import 'package:flutter/material.dart';

class OtherFieldsValidator {
  static bool validateFields({
    required TextEditingController authNameController,
    required TextEditingController usernameController,
    required TextEditingController passwordController,
  }) {
    if (authNameController.text.isEmpty ||
        usernameController.text.isEmpty ||
        passwordController.text.isEmpty) {
      return false;
    }
    return true;
  }
}
