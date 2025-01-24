import 'package:flutter/material.dart';

class FinancialFieldsValidator {
  static bool validateFields({
    required TextEditingController authNameController,
    required TextEditingController usernameController,
    required TextEditingController passwordController,
    required TextEditingController transactionPasswordController,
    bool hasTransactionPassword = false,
  }) {
    if (authNameController.text.isEmpty ||
        usernameController.text.isEmpty ||
        passwordController.text.isEmpty) {
      return false;
    }
    if (hasTransactionPassword && transactionPasswordController.text.isEmpty) {
      return false;
    }
    return true;
  }
}
