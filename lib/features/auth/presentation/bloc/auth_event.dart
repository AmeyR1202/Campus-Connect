import 'package:campus_connect/core/entities/user_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.freezed.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.authCheckRequested() = AuthCheckRequested;
  const factory AuthEvent.loginSubmitted({
    required String email,
    required String password,
  }) = LoginSubmitted;
  const factory AuthEvent.signUpSubmitted({
    required String username,
    required String email,
    required String password,
  }) = SignUpSubmitted;
  const factory AuthEvent.googleSignInSubmitted() = GoogleSignInSubmitted;
  const factory AuthEvent.appleSignInSubmitted() = AppleSignInSubmitted;
  const factory AuthEvent.sendEmailVerificationSubmitted() =
      SendEmailVerificationSubmitted;
  const factory AuthEvent.checkEmailVerifiedSubmitted() =
      CheckEmailVerifiedSubmitted;
  const factory AuthEvent.sendPasswordResetSubmitted({required String email}) =
      SendPasswordResetSubmitted;
  const factory AuthEvent.logoutSubmitted() = LogoutSubmitted;
  const factory AuthEvent.deleteAccountSubmitted() = DeleteAccountSubmitted;
  const factory AuthEvent.authStateChanged(UserEntity? user) = AuthStateChanged;
}
