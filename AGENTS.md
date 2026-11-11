# Campus Connect — Project Architecture & Engineering Standards

These rules apply across all sessions for this repository.

## 1. Pairing & Mentorship Style
- **Guide, don't dump**: Do not write entire features blindly. Explain the architectural "why", provide blueprints/patterns or single reference functions, let the user write the code, and review it thoroughly.
- **Proactive Optimization**: Always point out when something can be done in a cleaner, faster, or more idiomatic/optimized way—even if the user didn't explicitly ask.

## 2. Architecture & Engineering Principles
- **Clean Architecture (Strict Boundaries)**:
  - **Domain (`domain/`)**: 100% pure Dart. Zero imports from Flutter, Firebase, or third-party SDKs. Contains Entities (shared cross-cutting entities live in `core/entities/`), Failures (`sealed class` extending `core/error/failures.dart`), Repository interfaces (`abstract interface class`), and single-responsibility Use Cases.
  - **Data (`data/`)**: Implements Domain contracts. DataSources perform raw SDK calls and let exceptions bubble up; Repositories catch exceptions, wrap logic with shared guards, and map results to `fpdart` `Either<Failure, T>`. Models extend Entities (`UserModel extends UserEntity`) for clean polymorphism and Firestore `Timestamp` handling.
  - **Presentation (`presentation/`)**: Never talks directly to Firebase or Repositories. Calls Use Cases via BLoCs/Cubits.
- **SOLID Principles**:
  - **S**ingle Responsibility: Split DataSources per SDK (e.g., Auth vs Firestore), 1 Use Case per action, separate global `SessionCubit` from feature UI `AuthBloc`.
  - **O**pen/Closed & **L**iskov Substitution: Use Dart 3 `sealed class` hierarchies for exhaustive pattern matching and polymorphic Model-Entity inheritance.
  - **I**nterface Segregation & **D**ependency Inversion: Always code against `abstract interface class` contracts and inject dependencies via constructor (`get_it` / `injectable`).
- **DRY Principle**:
  - Never duplicate `try-catch` blocks, exception-to-failure mappings, or UI widgets. Extract reusable helpers (e.g., `_guard<T>`, `_mapFirebaseAuthException`, shared atomic UI components).

## 3. Standard Tech Stack
- **State Management**: `flutter_bloc`, `bloc_concurrency` (use `droppable()`, `restartable()`, etc. to prevent race conditions and double-taps).
- **Immutability & Code-Gen**: `equatable` for Entities/Failures; `freezed` for BLoC States & Events; `json_serializable` where pure JSON APIs require it.
- **Functional Error Handling**: `fpdart` (`Either`, `Unit`).
- **Routing**: `auto_route` (type-safe navigation & declarative route guards).
- **Dependency Injection**: `get_it` + `injectable`.
- **Localization**: `intl`.
- **Backend**: Firebase (`firebase_core`, `firebase_auth`, `cloud_firestore`).

