import 'package:formz/formz.dart';

enum InvalidName { empty, tooShort }

class NameInput extends FormzInput<String, InvalidName> {
  const NameInput.pure([super.value = '']) : super.pure();
  const NameInput.dirty([super.value = '']) : super.dirty();

  @override
  InvalidName? validator(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return InvalidName.empty;
    if (trimmed.length < 2) return InvalidName.tooShort;
    return null;
  }

  String? get errorMessage => switch (displayError) {
    InvalidName.empty => 'Name is required',
    InvalidName.tooShort => 'Name must be at least 2 characters',
    null => null,
  };
}
