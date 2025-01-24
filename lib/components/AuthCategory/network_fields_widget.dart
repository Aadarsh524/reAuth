import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reauth/components/custom_tags_field.dart';
import 'package:reauth/components/custom_textfield.dart';

class NetworkFieldsWidget extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController noteController;
  final List<String> availableTags;
  final List<String> selectedTags;
  final Function(List<String>) onTagsUpdated;

  const NetworkFieldsWidget({
    Key? key,
    required this.usernameController,
    required this.passwordController,
    required this.noteController,
    required this.availableTags,
    required this.selectedTags,
    required this.onTagsUpdated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        CustomTagsField(
          availableTags: availableTags,
          selectedTags: selectedTags,
          hintText: "Enter Tags",
          labelText: "Tags",
          isRequired: false,
          onTagsUpdated: onTagsUpdated,
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
