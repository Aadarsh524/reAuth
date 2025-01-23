import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reauth/components/custom_textfield.dart';

class SocialMediaFieldsWidget extends StatelessWidget {
  final TextEditingController authNameController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController noteController;

  const SocialMediaFieldsWidget({
    Key? key,
    required this.authNameController,
    required this.usernameController,
    required this.passwordController,
    required this.noteController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          isRequired: true,
          controller: authNameController,
          labelText: "Auth Name",
          hintText: "Enter Auth Name",
          keyboardType: TextInputType.text,
          textInputFormatter: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))
          ],
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
          isRequired: false,
          controller: noteController,
          labelText: "Note",
          hintText: "Enter Note",
          keyboardType: TextInputType.text,
          textInputFormatter: [FilteringTextInputFormatter.singleLineFormatter],
        ),
      ],
    );
  }
}
