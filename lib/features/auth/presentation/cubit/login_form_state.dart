import 'package:campus_connect/core/forms/email_input.dart';
import 'package:campus_connect/core/forms/password_input.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_form_state.freezed.dart';

@freezed
abstract class LoginFormState with _$LoginFormState, FormzMixin {
  const LoginFormState._();

  const factory LoginFormState({
    @Default(EmailInput.pure()) EmailInput email,
    @Default(PasswordInput.pure()) PasswordInput password,
  }) = _LoginFormState;
  @override
  List<FormzInput<dynamic, dynamic>> get inputs => [email, password];
}

/// Learned
/// Why const LoginFormState._();? Freezed requires a private empty
/// constructor whenever you add a custom getter/method (like inputs) or mix in FormzMixin.
