# Campus Connect — Architecture Decision Records & Engineering Handbook

A comprehensive record of system architecture, design patterns, engineering principles, and production lessons established during the development of Campus Connect.

---

## Table of Contents

1. [Core Architectural Philosophy](#1-core-architectural-philosophy)
2. [Clean Architecture & Strict Boundary Rules](#1-clean-architecture--strict-boundary-rules)
   - [ADR-001: Single Source of Truth (SSOT) — Why a Unified AuthBloc Wins](#13-adr-001-the-single-source-of-truth-ssot--why-a-unified-authbloc-wins)
   - [ADR-002: BLoC Dependency Injection — Strict Private Encapsulation vs. Public Initializing Formals](#14-adr-002-bloc-dependency-injection--strict-private-encapsulation--field--param-vs-public-initializing-formals-thisfield)
   - [ADR-003: App Bootloader vs. Feature Boundaries — Why Splash is a Dedicated Feature](#15-adr-003-app-bootloader-vs-feature-boundaries--why-splash-is-a-dedicated-feature-featuressplash)
3. [Domain Layer Standards](#2-domain-layer-standards)
4. [Data Layer Standards & Patterns](#3-data-layer-standards--patterns)
5. [SOLID & DRY Principles in Practice](#4-solid--dry-principles-in-practice)
6. [Critical Production Gotchas & Debugging Lessons](#5-the-deletion-order-constraint-security-rules)
7. [Store Policies, Security & Regulatory Compliance](#6-store-policies-security--regulatory-compliance)

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

### 1.4 ADR-002: BLoC Dependency Injection — Private Initializing Formals (`required this._field`) vs. Initializer Lists

#### Context & The Evolution of Dart Constructor Injection

When injecting dependencies (such as use cases) into a BLoC or Cubit, Dart developers traditionally encountered a dilemma:

1. **Option A: Public `final` fields with Initializing Formals (`required this.field`)**
   ```dart
   class AuthBloc extends Bloc<AuthEvent, AuthState> {
     final LogInUsecase logInUsecase; // ❌ Leaked to outside world
     AuthBloc({required this.logInUsecase});
   }
   ```
   - *Problem*: Domain use cases leak onto `AuthBloc`'s public API. Anyone can call `context.read<AuthBloc>().logInUsecase(...)` bypassing BLoC events and `bloc_concurrency`.

2. **Option B: Legacy Initializer Lists (`: _field = param`)**
   ```dart
   class AuthBloc extends Bloc<AuthEvent, AuthState> {
     final LogInUsecase _logInUsecase;
     AuthBloc({required LogInUsecase logInUsecase}) : _logInUsecase = logInUsecase;
   }
   ```
   - *Problem*: Pure boilerplate repetition (~30 lines when managing 10 use cases). Triggers the Dart linter warning: `prefer_initializing_formals`.

3. **The Modern Production Solution (Dart 2.17+): Private Initializing Formals (`required this._field`)**
   ```dart
   class AuthBloc extends Bloc<AuthEvent, AuthState> {
     final LogInUsecase _logInUsecase;

     AuthBloc({
       required this._logInUsecase, // ✅ 100% private inside, public named arg outside!
     }) : super(const AuthState.initial());
   }
   ```

#### How Modern Dart Resolves the Encapsulation Dilemma

In Dart 2.17+, Dart introduced **Private Initializing Formals for Named Parameters**:
- Inside the class, `_logInUsecase` remains **100% library-private** (encapsulation preserved, inaccessible to UI widgets or external classes).
- For callers (e.g. in `injection.dart`), Dart automatically **strips the leading underscore** at the callsite:
  ```dart
  // At the callsite (injection.dart):
  AuthBloc(
    logInUsecase: sl(), // Caller uses clean public name!
  );
  ```
- **Why `required LogInUsecase _logInUsecase` failed**: If you omit `this.` and write `required LogInUsecase _logInUsecase`, Dart rejects it with *"Named parameters can't start with an underscore."* Dart only permits the leading underscore when paired with `this._` because it knows to generate the public name for the caller.

---

#### Evaluation Metric Comparison

| Evaluation Metric | Option A: Public `final` (`this.field`) | Option B: Verbose List (`: _field = param`) | Modern Dart: Private Formal (`this._field`) |
| :--- | :--- | :--- | :--- |
| **Boilerplate / LOC** | Low (1 line) | High (3 mentions/dependency) | **Zero (1 line per dependency)** |
| **Encapsulation (OOP)** | ❌ Violated | ✅ Preserved | ✅ **100% Preserved (Private `_`)** |
| **Clean Architecture** | ❌ Leaks Domain to UI | ✅ BLoC isolates Domain | ✅ **BLoC isolates Domain** |
| **API Surface & Autocomplete**| ❌ Polluted with use cases | ✅ Clean (`add`, `state`, `stream`) | ✅ **Clean (`add`, `state`, `stream`)** |
| **Dart Linter (`prefer_initializing_formals`)** | ✅ Satisfied | ⚠️ Triggers 10 warnings | ✅ **0 warnings (100% compliant)** |

---

#### Conclusion & Production Standard

Campus Connect adopts **Modern Private Initializing Formals (`required this._field`)**:
It delivers the **best of both worlds**: strict OOP library encapsulation with zero repetitive boilerplate.

---

#### Interview Guide: The "Why, How, and So What" Framework

When asked in a Senior/Staff Flutter engineering interview to justify your constructor dependency injection style or how you structure BLoCs, use this three-part framework:

##### 1. The Architectural "Why" (Clean Architecture & Information Hiding)
> *"A BLoC is an **Event-Driven State Machine**. Its public contract with the outside world must strictly consist of two things: inputs (`add(Event)`) and outputs (`state`).*
>
> *If we inject use cases as **public fields** (e.g. `final LogInUsecase logInUsecase`), we violate **Information Hiding (OOP)** and leak the Domain layer directly into the Presentation layer. Any developer in the UI could accidentally call `context.read<AuthBloc>().logInUsecase(...)` directly. This completely bypasses the BLoC event pipeline—skipping `AuthLoading` emissions, centralized exception mapping, and `bloc_concurrency` debounce guards like `droppable()`."*

##### 2. The Language "How" (Dart 2.17+ Compiler Mechanism)
> *"In Dart, named arguments define the public API for the caller, so the language strictly forbids normal named parameters from beginning with an underscore (`required LogInUsecase _logInUsecase` fails to compile).*
>
> *Traditionally, this forced developers to write verbose initializer lists (`: _logInUsecase = logInUsecase`), which triggered the `prefer_initializing_formals` linter warning.*
>
> *In **Dart 2.17+**, the language introduced **Private Initializing Formals for Named Parameters** (`required this._logInUsecase`). The Dart compiler does something very elegant: it strips the leading underscore at the call site so callers use clean public names (`AuthBloc(logInUsecase: sl())`), while keeping the internal field strictly library-private (`_logInUsecase`)."*

##### 3. The Production "So What?" (Impact & Trade-offs)
> *"By leveraging `required this._field`, we achieve four concrete production benefits:*
> 1. *Strict OOP Encapsulation*: UI widgets physically cannot access domain use cases through the BLoC.
> 2. *Zero Boilerplate*: Completely eliminates dozens of lines of redundant initializer-list assignments.
> 3. *Clean Autocomplete*: IDE autocomplete on `AuthBloc` shows only `add()`, `state`, `stream`, and `close()`.
> 4. *100% Linter Compliance*: Fully satisfies Dart’s `prefer_initializing_formals` rule with zero warnings.*

##### Bonus Follow-up: *"Doesn't a BLoC with 10 use cases violate the Single Responsibility Principle?"*
> *"In Campus Connect, we deliberately chose a **Unified Single Source of Truth (SSOT)** over splitting authentication into multiple disconnected stores (e.g., a separate `SessionCubit`, `LoginBloc`, and `SignUpBloc`). Fragmenting authentication across stores leads to state-synchronization race conditions and split-brain states during backgrounding or token revocation. The 10 use cases represent the atomic capabilities of the authentication bounded context, while `AuthBloc` guarantees there is exactly one authoritative user state for the entire application."*

---

### 1.5 ADR-003: App Bootloader vs. Feature Boundaries — Why Splash is a Dedicated Feature (`features/splash/`)

#### Context & The Dilemma

When organizing a Feature-First Flutter project, developers frequently ask:
> *"Where should `SplashPage` live? Should it be placed inside `features/auth/presentation/pages/` or as a standalone feature `features/splash/`?"*

A common naive pattern in small prototypes is to place `splash_page.dart` inside `features/auth/` because the immediate concern on startup is checking whether a user is authenticated.

#### Why Placing Splash Inside `features/auth/` is an Architectural Anti-Pattern

1. **Violation of the Single Responsibility Principle (SRP)**:
   A Splash screen is **not an authentication screen**. A Splash screen is the **Application Bootloader & Lifecycle Gateway**.
   In production enterprise applications, the startup sequence is responsible for orchestrating multiple cross-cutting app initialization tasks:
   - **Session Verification**: Checking authentication state (`AuthBloc`).
   - **App Version & Force-Update**: Calling Firebase Remote Config to verify whether the client version is supported or force an update.
   - **Maintenance Mode Verification**: Checking if backend services are currently undergoing maintenance.
   - **Push Notification Registration**: Fetching and registering APNs / FCM tokens.
   - **Offline Database Hydration & Migrations**: Migrating local SQLite / Hive caches before UI rendering.
   - **Deep Link & Universal Link Resolution**: Parsing incoming route payloads before landing the user.

2. **Polluting the Authentication Bounded Context**:
   If `SplashPage` lives inside `features/auth/`:
   - `features/auth/` becomes artificially responsible for the entire application boot lifecycle.
   - When maintenance checks, remote config, or local DB migrations are added, `features/auth/` would be forced to import external non-auth services. This corrupts Domain-Driven Design (DDD) bounded contexts and introduces circular dependencies.

3. **Ownership of the Root Route (`/`)**:
   In `auto_route`, the initial route (`/`) represents the application's root entry point. The root entry point of an entire multi-feature application (Campus Connect) should never be owned by a single domain feature (Auth).

---

#### The Production Standard: `features/splash/` as an Isolated Gateway

Campus Connect isolates the application bootloader into a dedicated feature:

```
lib/
├── features/
│   ├── splash/                               <-- Dedicated Application Bootloader
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── splash_page.dart          <-- Root Initial Route ('/')
│   │       └── widgets/
│   │           └── animated_logo.dart        <-- 2-second Text Reveal Animation
│   ├── auth/                                 <-- Pure Authentication Bounded Context
│   │   ├── domain/
│   │   ├── data/
│   │   └── presentation/
│   │       └── pages/
│   │           ├── onboarding_page.dart
│   │           ├── login_page.dart
│   │           ├── signup_page.dart
│   │           ├── verify_email_page.dart
│   │           ├── account_ready_page.dart
│   │           └── forgot_password_page.dart
│   └── home/                                 <-- Authenticated Dashboard Feature
│       └── presentation/
│           └── pages/
│               └── home_page.dart
```

#### How `features/splash/` Coordinates with `features/auth/`

- **Global Availability**: `AuthBloc` is provided at the root of the application widget tree (`main.dart`).
- **Reactive Observation**: `SplashPage` simply observes `context.watch<AuthBloc>().state` or registers a `BlocListener<AuthBloc, AuthState>`.
- **Parallel Animation & Cold-Start Synchronization**:
  ```dart
  // Wait for both the minimum visual animation (2s) AND the backend check to complete
  await Future.wait([
    minimumAnimationTimerFuture,
    authCheckFuture,
  ]);
  ```
- **Type-Safe Routing Delegation**:
  Once the animation finishes and state is resolved, `SplashPage` uses `AutoRoute` to cleanly transition to the appropriate feature route:
  - `Authenticated` ➔ `context.router.replace(const HomeRoute());`
  - `Unverified` ➔ `context.router.replace(const VerifyEmailRoute());`
  - `Unauthenticated` ➔ `context.router.replace(const OnboardingRoute());`

#### Conclusion & Decision

Campus Connect mandates that the splash screen resides in **`lib/features/splash/`** as an independent bootloader feature, keeping `features/auth/` strictly focused on user authentication journeys.

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
