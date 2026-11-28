import 'package:campus_connect/core/forms/email_input.dart';
import 'package:campus_connect/core/forms/name_input.dart';
import 'package:campus_connect/core/forms/password_input.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_form_state.freezed.dart';

@freezed
abstract class SignUpFormState with _$SignUpFormState, FormzMixin {
  const SignUpFormState._();

  const factory SignUpFormState({
    @Default(NameInput.pure()) NameInput name,
    @Default(EmailInput.pure()) EmailInput email,
    @Default(PasswordInput.pure()) PasswordInput password,
  }) = _SignUpFormState;

  @override
  List<FormzInput<dynamic, dynamic>> get inputs => [name, email, password];
}
