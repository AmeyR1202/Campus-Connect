import 'package:campus_connect/core/error/failures.dart';

sealed class AuthFailures extends Failures {
  const AuthFailures([super.message]);
}

class InvalidCredentialsFailure extends AuthFailures {
  const InvalidCredentialsFailure([
    super.message = 'Invalid email or password combination.',
  ]);
}

class EmailAlreadyInUseFailure extends AuthFailures {
  const EmailAlreadyInUseFailure([
    super.message = 'An account already exists for this email.',
  ]);
}

class WeakPasswordFailure extends AuthFailures {
  const WeakPasswordFailure([
    super.message = 'Password must be at least 8 characters.',
  ]);
}

class UserNotFoundFailure extends AuthFailures {
  const UserNotFoundFailure([
    super.message = 'No user found for this email address.',
  ]);
}

class EmailNotVerifiedFailure extends AuthFailures {
  const EmailNotVerifiedFailure([
    super.message = 'Please verify your email address first.',
  ]);
}

class AuthServerFailure extends AuthFailures {
  const AuthServerFailure([
    super.message = 'An unexpected error occurred. Please try again.',
  ]);
}

class AuthNetworkFailure extends AuthFailures {
  const AuthNetworkFailure([
    super.message = 'Please check your internet connection.',
  ]);
}

class SocialSignInCancelledFailure extends AuthFailures {
  const SocialSignInCancelledFailure([
    super.message = 'Sign-in was cancelled by user.',
  ]);
}
