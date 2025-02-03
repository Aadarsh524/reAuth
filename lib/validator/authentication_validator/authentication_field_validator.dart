String? validateLoginFields(String email, String password) {
  if (email.isEmpty && password.isEmpty) return 'Multiple empty fields';
  if (email.isEmpty) return 'Email cannot be empty';
  if (password.isEmpty) return 'Password cannot be empty';
  if (!email.isValidEmail) return 'Invalid email address';
  return null;
}

String? validateRegisterFields(
  String fullName,
  String email,
  String password,
  String confirmPassword,
) {
  final missingFields = [
    if (fullName.isEmpty) 'Full Name',
    if (email.isEmpty) 'Email',
    if (password.isEmpty) 'Password',
    if (confirmPassword.isEmpty) 'Confirm Password',
  ];

  if (missingFields.length > 1) return 'Multiple empty fields';
  if (missingFields.isNotEmpty) {
    return '${missingFields.first} cannot be empty';
  }
  if (!email.isValidEmail) return 'Invalid email address';
  if (!password.isValidPassword) {
    return 'Password must be at least 6 characters';
  }
  if (password != confirmPassword) return 'Passwords do not match';
  if (!fullName.isValidName) return 'Invalid full name';
  return null;
}

extension _ValidationExtensions on String {
  bool get isValidEmail =>
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  bool get isValidPassword => length >= 6;
  bool get isValidName => length >= 3;
}
