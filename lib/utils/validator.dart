String? validateRegister(
    String email, String password, String confirmPassword) {
  if (email.isEmpty) {
    return 'Email is required';
  }
  if (email.isNotEmpty) {
    final RegExp emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)*(\.[a-z]{2,})$',
      caseSensitive: false,
    );
    if (!emailRegex.hasMatch(email)) {
      return 'Email format is not matched';
    }
  }
  if (password.isEmpty) {
    return 'Password is required';
  }
  if (confirmPassword.isEmpty) {
    return 'Confirm Password is required';
  }
  if (password.isNotEmpty && confirmPassword.isNotEmpty) {
    if (password != confirmPassword) {
      return 'Password donot matches';
    }
  }

  return null;
}

String? validateLogin(String email, String password) {
  if (email.isEmpty) {
    return 'Email is required';
  }
  if (email.isNotEmpty) {
    final RegExp emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)*(\.[a-z]{2,})$',
      caseSensitive: false,
    );
    if (!emailRegex.hasMatch(email)) {
      return 'Email format is not matched';
    }
  }
  if (password.isEmpty) {
    return 'Password is required';
  }

  return null;
}

String? validateSetPin(String pin1, String pin2) {
  if (pin1.isEmpty && pin2.isEmpty) {
    return 'Pin Cannot be Empty';
  }
  if (pin1.isNotEmpty && pin2.isNotEmpty) {
    if (pin1 != pin2) {
      return 'Pin donot matches';
    }
  }

  return null;
}
