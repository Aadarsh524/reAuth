int checkPasswordStrength(String password) {
  int score = 0;

  // Check password length
  if (password.length >= 8) {
    score++;
  }

  // Check for uppercase letters
  if (password.contains(RegExp(r'[A-Z]'))) {
    score++;
  }

  // Check for lowercase letters
  if (password.contains(RegExp(r'[a-z]'))) {
    score++;
  }

  // Check for digits
  if (password.contains(RegExp(r'[0-9]'))) {
    score++;
  }

  // Check for special characters
  if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
    score++;
  }

  return score;
}

Map<String, int> classifyPasswordStrengths(List<String> passwords) {
  int weak = 0;
  int strong = 0;

  for (String password in passwords) {
    int score = checkPasswordStrength(password);

    if (score <= 3) {
      weak++;
    } else {
      strong++;
    }
  }

  return {
    "Weak": weak,
    "Strong": strong,
  };
}
