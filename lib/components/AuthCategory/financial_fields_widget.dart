import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reauth/components/custom_tags_field.dart';
import 'package:reauth/components/custom_textfield.dart';

class FinancialFieldsWidget extends StatefulWidget {
  final TextEditingController authNameController;
  final TextEditingController accountNumberController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController transactionPasswordController;
  final TextEditingController noteController;
  final TextEditingController tagsController;
  final List<String> availableTags;
  final List<String> selectedTags;
  final Function(List<String>) onTagsUpdated;
  final Function(bool) onTransactionPasswordToggle;
  final bool isUpdating; // New field to check updating state

  const FinancialFieldsWidget({
    Key? key,
    required this.authNameController,
    required this.accountNumberController,
    required this.usernameController,
    required this.passwordController,
    required this.transactionPasswordController,
    required this.noteController,
    required this.tagsController,
    required this.availableTags,
    required this.selectedTags,
    required this.onTagsUpdated,
    required this.onTransactionPasswordToggle,
    required this.isUpdating, // Initialize this field
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FinancialFieldsWidgetState createState() => _FinancialFieldsWidgetState();
}

class _FinancialFieldsWidgetState extends State<FinancialFieldsWidget> {
  bool hasTransactionPassword = false;
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: widget.authNameController,
          labelText: "Auth Name",
          hintText: "Enter Auth Name",
          keyboardType: TextInputType.text,
          textInputFormatter: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))
          ],
          isRequired: true,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Has Transaction Password?",
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Checkbox(
              value: hasTransactionPassword,
              onChanged: (value) {
                setState(() {
                  hasTransactionPassword = value!;
                });
                widget.onTransactionPasswordToggle(
                    hasTransactionPassword); // Notify parent
              },
              activeColor: Colors.blue,
            ),
          ],
        ),
        if (hasTransactionPassword)
          CustomTextField(
            controller: widget.transactionPasswordController,
            labelText: "Transaction Password",
            hintText: "Enter Transaction Password",
            obscureText: true,
            textInputFormatter: [FilteringTextInputFormatter.digitsOnly],
            isRequired: true,
          ),
        CustomTextField(
          controller: widget.accountNumberController,
          labelText: "Account Number",
          hintText: "Enter Account Number",
          keyboardType: TextInputType.number,
          textInputFormatter: [FilteringTextInputFormatter.digitsOnly],
          isRequired: false,
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
          controller: widget.noteController,
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
