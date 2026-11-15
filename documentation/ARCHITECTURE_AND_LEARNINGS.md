# Campus Connect — Architecture Decision Records & Engineering Handbook

A comprehensive record of system architecture, design patterns, engineering principles, and production lessons established during the development of Campus Connect.

---

## Table of Contents

1. [Core Architectural Philosophy](#1-core-architectural-philosophy)
2. [Clean Architecture & Strict Boundary Rules](#2-clean-architecture--strict-boundary-rules)
3. [Domain Layer Standards](#3-domain-layer-standards)
4. [Data Layer Standards & Patterns](#4-data-layer-standards--patterns)
5. [SOLID & DRY Principles in Practice](#5-solid--dry-principles-in-practice)
6. [Critical Production Gotchas & Debugging Lessons](#6-critical-production-gotchas--debugging-lessons)
7. [Store Policies, Security & Regulatory Compliance](#7-store-policies-security--regulatory-compliance)

---

## 1. Clean Architecture & Strict Boundary Rules

Campus Connect follows Uncle Bob's Clean Architecture organized with a **Feature-First** approach:

```
lib/
├── core/                       # Shared app-wide cross-cutting concerns
│   ├── entities/               # Entities shared across multiple features (e.g., UserEntity)
│   ├── error/                  # Base Failure contracts
│   ├── session/                # Global session lifecycle management
│   └── theme/                  # Design system tokens and helpers
└── features/
    └── auth/                   # Bounded Context: Authentication
        ├── domain/             # 100% pure Dart (no Flutter, no Firebase)
        │   ├── failures/       # Feature-specific domain failures
        │   ├── repositories/   # Abstract contracts
        │   └── usecases/       # Single-responsibility business actions
        ├── data/               # Infrastructure implementation
        │   ├── datasources/    # Raw SDK communication & network calls
        │   ├── models/         # Serialization & database persistence
        │   └── repositories/   # Fulfills domain contracts; maps exceptions
        └── presentation/       # User Interface & state management
            ├── bloc/           # BLoC with bloc_concurrency transformers
            ├── pages/          # Full-screen route views
            └── widgets/        # Reusable feature-level UI components
```

### The Strict Dependency Rules:

1. **Features can ALWAYS import from `core/`**. (`features/auth` -> `core`).
2. **`core/` NEVER imports from a feature**. (Prevents circular dependencies).
3. **Features NEVER import from other features**. (If `features/events` needs user details, it accesses them via `core/session/`, never by importing `features/auth`).
4. **Domain Layer has ZERO external dependencies**. No Flutter, no Firebase, no HTTP. Pure Dart only.

### 1.3 ADR-001: The Single Source of Truth (SSOT) — Why a Unified AuthBloc Wins

#### The Problem: Why Having Both `AuthBloc` and `SessionCubit` and "Syncing" Them is Bad Architecture

We initially explored splitting authentication into:

1. `AuthBloc` in `features/auth/` (handling forms/actions)
2. `SessionCubit` in `core/` or `app/` (holding session state)
3. Synchronizing them when login/logout occurs.

**Why this is dangerous in production:**

- **Race Conditions**: What happens if `AuthBloc` emits `AuthSuccess`, but before `SessionCubit` receives it, the user minimizes the app or a network glitch occurs? Store A says logged in, Store B says logged out.
- **Cognitive Overhead**: In 6 months, when you or a teammate want to know _"Who is the current user?"_, you will hesitate: _"Wait, do I read `context.read<AuthBloc>().state` or `context.read<SessionCubit>().state`?"_
- **Two BLoCs Doing One Job**: Why have two separate state managers for the single concept of _"Who is authenticated?"_

#### The Reality: Look Back at Your Original Architecture Plan (Image 3)

In the initial project structure planned for Campus Connect, there was **only ONE `AuthBloc`**:

```
auth/
  presentation/
    bloc/
      auth_bloc.dart
      auth_event.dart
      auth_state.dart
```

In the original diagram, there was **no `SessionCubit`**! A `SessionCubit` was only introduced because an old prototype snippet happened to import one. Attempting to keep both alive and "sync" them was textbook over-engineering.

---

#### The Real Production Truth: You Only Need ONE Single Source of Truth

In production apps, there are two clean, un-synced options:

##### Pattern 1: The Unified `AuthBloc` (Adopted — Matches Image 3)

You do **NOT** need a `SessionCubit`. You only need **`AuthBloc`** in `features/auth/presentation/bloc/`:

```
features/auth/presentation/bloc/
├── auth_bloc.dart
├── auth_event.dart
└── auth_state.dart
```

**How it works (Zero Syncing Needed):**

1. **`AuthState` (Sealed Class)**:
   - `AuthInitial`
   - `AuthLoading`
   - `Authenticated(UserEntity user)`
   - `Unverified(UserEntity user)`
   - `Unauthenticated`
   - `AuthFailureState(AuthFailures failure)`

2. **`AuthEvent` (Sealed Class)**:
   - `AuthCheckRequested` (called on Splash)
   - `LoginSubmitted(email, password)`
   - `SignUpSubmitted(username, email, password)`
   - `GoogleSignInSubmitted`
   - `AppleSignInSubmitted`
   - `LogoutSubmitted`
   - `_AuthStateChanged(UserEntity? user)` (internal stream listener)

**Why this is 100% Production Grade:**

- **One Source of Truth**: There is only one place in the entire app that knows about the user.
- **Zero "Syncing" code**: You don't sync anything. When `LoginSubmitted` succeeds, `AuthBloc` directly emits `Authenticated(user)`.
- **Accessible Everywhere**: Provided at the root of `main.dart`. The `SplashPage`, `EventsPage`, `TimetablePage`, and `ProfilePage` all read the exact same `context.watch<AuthBloc>().state`.
- **Uses `bloc_concurrency`**: We can use `droppable()` on `LoginSubmitted` so button spamming is impossible.

##### Pattern 2: The Scoped Form Cubit (Very Good Ventures Style)

A global `AppBloc` that only knows `Authenticated` vs `Unauthenticated`, paired with a local `LoginCubit` scoped strictly to the login bottom sheet. Neither manually syncs to the other; both react to Firebase Auth's underlying stream.

#### The Architectural Decision

Campus Connect adopts **Pattern 1: The Unified `AuthBloc`** as the application's Single Source of Truth. No secondary session stores, no imperative synchronization middleware.

---

## 2. Domain Layer Standards

### 2.1 Entities vs Models

- **`UserEntity` (Domain)**: Pure business concept. Holds properties (`userId`, `username`, `email`, `isEmailVerified`, `createdAt`). Uses `Equatable` for value equality and includes `copyWith()` for immutable mutations.
- **`UserModel` (Data)**: Persistence-aware representation. Extends `UserEntity` to handle serialization (`toFirestore`, `fromFirestore`, `fromFirebaseUser`).

### 2.2 Monadic Functional Error Handling (`fpdart`)

Instead of throwing arbitrary exceptions that bubble up and crash the UI, all repository methods and use cases return `Future<Either<Failure, T>>`.

- **`Left(Failure)`**: Represents expected domain failure states.
- **`Right(T)`**: Represents successful execution returning data.

### 2.3 Why `Unit` instead of `void`?

In Dart, `void` is not an object or a type argument (`Either<Failure, void>` is invalid). Functional programming uses `Unit` (exported by `fpdart`) to represent a successful operation that produces no meaningful value (e.g., logging out, deleting an account, sending verification email).

### 2.4 Compile-Time Exhaustive Pattern Matching (`sealed class`)

Domain failures are modeled using Dart 3 `sealed class`:

```dart
sealed class AuthFailures extends Failures {
  const AuthFailures([super.message]);
}

class InvalidCredentialsFailure extends AuthFailures { ... }
class EmailAlreadyInUseFailure extends AuthFailures { ... }
class WeakPasswordFailure extends AuthFailures { ... }
```

**Why?** In the BLoC or UI, a `switch (failure)` statement is verified by the compiler. If a developer adds a new failure type in the future and forgets to handle it in the UI, the app will not compile.

### 2.5 Single Responsibility Use Cases

Every use case is a single class with a `call()` method:

- `LogInUsecase`
- `SignUpUsecase`
- `GoogleSignInUsecase`
- `SendEmailVerificationUsecase`
- `CheckEmailVerifiedUsecase`

**Why?**

- In unit testing, you mock only the 1 method you care about, not an 11-method repository.
- Avoids bloated "God" classes.

---

## 3. Data Layer Standards & Patterns

### 3.1 Polymorphic Inheritance (Liskov Substitution Principle - SOLID)

#### 1. Breaking Down the Words

- **Poly** = Many
- **Morph** = Forms or Shapes
- **Inheritance** = A child class inherits from a parent class (`class Child extends Parent`).
- **Polymorphic Inheritance** means: A child object can take the shape of its parent class, and be used anywhere the parent is expected, without needing any conversion or type casting.

#### 2. How it is used in Campus Connect:

```dart
// 1. In Domain (The Parent):
class UserEntity { ... }

// 2. In Data (The Child):
class UserModel extends UserEntity { ... }
```

In the Domain contract (`AuthRepository`):

```dart
// The Domain says: "I only care about UserEntity. I know nothing about UserModel!"
Future<Either<AuthFailures, UserEntity>> loginWithEmailAndPassword(...);
```

In `AuthRepositoryImpl`:

```dart
final userModel = UserModel(userId: '123', ...);
return userModel; // Works seamlessly!
```

The Dart compiler accepts this because through **Polymorphic Inheritance**, `UserModel` **IS-A** `UserEntity`. It morphs into its parent type seamlessly.

#### 3. The Junior Way vs. The Senior Way

- **The Junior Way (No Polymorphism)**: If `UserModel` did not extend `UserEntity`, they would be two disconnected classes. You would be forced to write manual mapping boilerplate on every single call (`return userModel.toEntity()`), allocating duplicate objects in memory across 40 features.
- **The Senior Way (Polymorphic Inheritance)**: Because `UserModel extends UserEntity`, `UserModel` holds all serialization logic (`toFirestore`, `fromFirestore`), but can be returned directly anywhere a pure `UserEntity` is expected with zero boilerplate and zero memory overhead.

#### 4. The Interview Connection (Liskov Substitution Principle - LSP)

When interviewers ask about the **L in SOLID principles**:

> _"If Class B extends Class A, any function that accepts Class A must be able to accept Class B without breaking the application or needing type-casting."_

### 3.2 Handling Cloud Firestore `Timestamp`

Firestore documents do not store dates as ISO-8601 strings; they store binary `Timestamp` objects.

- `createdAt` in `UserEntity` must be `DateTime?` (nullable) because a user exists in memory before Firestore generates the server timestamp.
- Serialization reads `(doc['createdAt'] as Timestamp?)?.toDate()`.
- Deserialization writes `FieldValue.serverTimestamp()`.

### 3.3 DataSources vs Repositories

- **DataSources**:
  - `FirebaseAuthDataSource`: Only talks to `firebase_auth`.
  - `FirestoreUserDataSource`: Only talks to `cloud_firestore`.
  - **DataSources NEVER throw Domain Failures**. They execute raw SDK calls and let raw exceptions (`FirebaseAuthException`) bubble up.
- **Repositories**:
  - `AuthRepositoryImpl`: Coordinates the DataSources, catches raw exceptions, and maps them into domain `Either<AuthFailures, T>`.

---

## 4. SOLID & DRY Principles in Practice

### 4.1 The DRY `_guard` Pattern

Instead of copy-pasting `try-catch` blocks across 11 different repository methods, `AuthRepositoryImpl` uses a centralized functional wrapper:

```dart
Future<Either<AuthFailures, T>> _guard<T>(Future<T> Function() action) async {
  try {
    final result = await action();
    return Right(result);
  } on AuthFailures catch (failure) {
    return Left(failure);
  } on FirebaseAuthException catch (e) {
    return Left(_mapFirebaseAuthException(e));
  } on FirebaseException catch (e) {
    return Left(AuthServerFailure(e.message ?? 'A database error occurred.'));
  } catch (e) {
    return Left(AuthServerFailure(e.toString()));
  }
}
```

Every repository method becomes a clean 3-liner:

```dart
@override
Future<Either<AuthFailures, Unit>> logout() {
  return _guard(() async {
    await _authDataSource.logOut();
    return unit;
  });
}
```

---

### 5 The Deletion Order Constraint (Security Rules)

When deleting an account:

1. **Step 1**: Delete Firestore user document (`_userDataSource.deleteUserProfile(uid)`).
2. **Step 2**: Delete Firebase Auth record (`_authDataSource.deleteAccount()`).

**Why?** If you delete the Firebase Auth user first, the client immediately becomes unauthenticated (`request.auth == null`). Subsequent Firestore delete requests will fail with `PERMISSION_DENIED`!

## 6. Store Policies, Security & Regulatory Compliance

### 6.1 Apple App Store Rule 5.1.1 (Account Deletion)

Any app published on the Apple App Store that supports user account creation **must** provide an in-app mechanism for users to initiate complete deletion of their account and associated personal data.

### 6.2 Apple App Store Rule 4.8 (Social Sign-In Parity)

If an app offers any third-party social sign-in service (such as Google Sign-In) on iOS, Apple mandates that the app **must also offer Sign in with Apple** with equivalent prominence.
