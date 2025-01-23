import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reauth/components/custom_textfield.dart';

class FinancialFieldsWidget extends StatelessWidget {
  final TextEditingController authNameController;
  final TextEditingController accountNumberController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController transactionPasswordController;
  final TextEditingController noteController;
  final TextEditingController tagsController;

  const FinancialFieldsWidget({
    Key? key,
    required this.authNameController,
    required this.accountNumberController,
    required this.usernameController,
    required this.passwordController,
    required this.transactionPasswordController,
    required this.noteController,
    required this.tagsController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: authNameController,
          labelText: "Auth Name",
          hintText: "Enter Auth Name",
          keyboardType: TextInputType.text,
          textInputFormatter: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))
          ],
          isRequired: true,
        ),
        CustomTextField(
          controller: accountNumberController,
          labelText: "Account Number",
          hintText: "Enter Account Number",
          keyboardType: TextInputType.number,
          textInputFormatter: [FilteringTextInputFormatter.digitsOnly],
          isRequired: false,
        ),
        CustomTextField(
          isRequired: true,
          controller: usernameController,
          labelText: "User Name",
          hintText: "Enter User Name",
          keyboardType: TextInputType.text,
          textInputFormatter: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
        ),
        CustomTextField(
          isRequired: true,
          controller: passwordController,
          labelText: "Password",
          hintText: "Enter Password",
          obscureText: true,
          textInputFormatter: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
        ),
        CustomTextField(
          controller: transactionPasswordController,
          labelText: "Transaction Password",
          hintText: "Enter Transaction Password",
          obscureText: true,
          textInputFormatter: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
          isRequired: false,
        ),
        CustomTextField(
          controller: noteController,
          labelText: "Note",
          hintText: "Enter Note",
          keyboardType: TextInputType.text,
          textInputFormatter: [FilteringTextInputFormatter.singleLineFormatter],
          isRequired: false,
        ),
      ],
    );
  }
}
