/// Centralized validation utilities for Campus Connect.
///
/// Follows DRY and SOLID principles: ensures validation logic (regexes, min lengths,
/// required checks) is unified across Login, Sign-Up, and Password Reset screens.
class AppValidators {
  const AppValidators._();

  // RFC 5322 compliant email regex
  static final RegExp _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  /// Validates that an email is present and properly formatted.
  static String? email(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return 'Email address is required';
    }
    if (!_emailRegExp.hasMatch(trimmed)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validates password presence and minimum length (default: 6 characters).
  static String? password(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }
    return null;
  }

  /// Validates generic required fields (e.g. Full Name on Sign-Up).
  static String? required(String? value, String fieldName) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
}
