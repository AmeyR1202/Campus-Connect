import 'package:campus_connect/core/entities/user_entity.dart';
import 'package:campus_connect/features/auth/domain/failures/auth_failures.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  /// Real-time stream of user auth state changes (used by SessionCubit).
  Stream<UserEntity?> get authStateChanges;

  /// Fetches the currently authenticated user (for initial splash hydration).
  Future<Either<AuthFailures, UserEntity?>> getCurrentUser();

  Future<Either<AuthFailures, UserEntity>> signUpWithEmailAndPassword({
    required String username,
    required String email,
    required String password,
  });

  /// Logs in with email and password
  Future<Either<AuthFailures, UserEntity>> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// signs in with google OAuth
  Future<Either<AuthFailures, UserEntity>> signInWithGoogle();

  /// signs in using apple account (mandatory if i'm offering google in iOS)
  Future<Either<AuthFailures, UserEntity>> signInWithApple();

  /// LEARNED: why use Unit instead of void
  /// void does not represent an actual value or object you can pass around, it breaks composition. "
  /// Unit gives you an actual object (Unit) to pass down the pipeline when an operation succeeds but has no meaningful data to return.

  /// send verification email link to user's email
  Future<Either<AuthFailures, Unit>> sendEmailVerification();

  /// Reloads the user and checks if the email verification link was clicked.
  Future<Either<AuthFailures, bool>> checkEmailVerified();

  /// Sends a password reset email link to the given email.
  Future<Either<AuthFailures, Unit>> sendPasswordResetEmail({
    required String email,
  });

  /// Signs out of all active sessions.
  Future<Either<AuthFailures, Unit>> logout();

  /// Permanently deletes the user account (mandated by App Store).
  Future<Either<AuthFailures, Unit>> deleteAccount();
}
