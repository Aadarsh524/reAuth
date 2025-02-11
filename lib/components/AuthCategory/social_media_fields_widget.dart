import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../custom_tags_field.dart';
import '../custom_textfield.dart';

class SocialMediaFieldsWidget extends StatefulWidget {
  final TextEditingController authNameController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController noteController;
  final List<String> availableTags;
  final List<String> selectedTags;
  final Function(List<String>) onTagsUpdated;
  final bool isUpdating;

  const SocialMediaFieldsWidget({
    Key? key,
    required this.authNameController,
    required this.usernameController,
    required this.passwordController,
    required this.noteController,
    required this.availableTags,
    required this.selectedTags,
    required this.onTagsUpdated,
    required this.isUpdating,
  }) : super(key: key);

  @override
  _SocialMediaFieldsWidgetState createState() =>
      _SocialMediaFieldsWidgetState();
}

class _SocialMediaFieldsWidgetState extends State<SocialMediaFieldsWidget> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          isRequired: true,
          controller: widget.authNameController,
          labelText: "Auth Name",
          hintText: "Enter Auth Name",
          keyboardType: TextInputType.text,
          textInputFormatter: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))
          ],
          enabled: !widget.isUpdating, // Disable if updating
        ),
        CustomTextField(
          isRequired: true,
          controller: widget.usernameController,
          labelText: "User Name",
          hintText: "Enter User Name",
          keyboardType: TextInputType.text,
          textInputFormatter: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
        ),
        CustomTextField(
          isRequired: true,
          controller: widget.passwordController,
          labelText: "Password",
          hintText: "Enter Password",
          obscureText: !isPasswordVisible,
          isFormTypePassword: true,
          passwordVisibility: (e) {
            setState(() {
              isPasswordVisible = !isPasswordVisible;
            });
          },
          textInputFormatter: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
        ),
        CustomTagsField(
          availableTags: widget.availableTags,
          selectedTags: widget.selectedTags,
          hintText: "Enter Tags",
          labelText: "Tags",
          isRequired: false,
          onTagsUpdated: widget.onTagsUpdated,
        ),
        CustomTextField(
          isRequired: false,
          controller: widget.noteController,
          labelText: "Note",
          hintText: "Enter Note",
          keyboardType: TextInputType.text,
          textInputFormatter: [FilteringTextInputFormatter.singleLineFormatter],
        ),
      ],
    );
  }
}
