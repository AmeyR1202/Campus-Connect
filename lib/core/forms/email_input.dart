import 'package:formz/formz.dart';

enum InvalidEmail { empty, invalid }

class EmailInput extends FormzInput<String, InvalidEmail> {
  const EmailInput.pure([super.value = '']) : super.pure();
  const EmailInput.dirty([super.value = '']) : super.dirty();

  static final RegExp _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  @override
  InvalidEmail? validator(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return InvalidEmail.empty;
    if (!_emailRegExp.hasMatch(trimmed)) return InvalidEmail.invalid;
    return null;
  }

  /// Return the error message only if the field has been interracted with displayError
  String? get errorMessage => switch (displayError) {
    InvalidEmail.empty => "Email address is required",
    InvalidEmail.invalid => "Please enter a valid email address",
    null => null,
  };
}
