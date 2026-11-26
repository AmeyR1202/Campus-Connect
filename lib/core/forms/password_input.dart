import 'package:formz/formz.dart';

enum InvalidPassword { empty, tooShort }

class PasswordInput extends FormzInput<String, InvalidPassword> {
  const PasswordInput.pure([super.value = '']) : super.pure();
  const PasswordInput.dirty([super.value = '']) : super.dirty();

  @override
  InvalidPassword? validator(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return InvalidPassword.empty;
    if (trimmed.length < 6) return InvalidPassword.tooShort;
    return null;
  }

  String? get errorMessage => switch (displayError) {
    InvalidPassword.empty => 'Password cannot be empty',
    InvalidPassword.tooShort => 'Password must be at least 6 characters long',
    null => null,
  };
}
