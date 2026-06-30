/// Common input validators reused across auth and calculator forms.
class Validators {
  Validators._();

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    final regex = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$');
    if (!regex.hasMatch(value.trim())) return 'Enter a valid email address';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    if (value != original) return 'Passwords do not match';
    return null;
  }

  static String? notEmpty(String? value, {String field = 'This field'}) {
    if (value == null || value.trim().isEmpty) return '$field is required';
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) return 'Phone number is required';
    final regex = RegExp(r'^[6-9]\d{9}$');
    if (!regex.hasMatch(value.trim())) {
      return 'Enter a valid 10-digit Indian mobile number';
    }
    return null;
  }

  static String? numeric(String? value, {String field = 'Value'}) {
    if (value == null || value.trim().isEmpty) return '$field is required';
    if (double.tryParse(value.trim()) == null) {
      return '$field must be a number';
    }
    return null;
  }
}
