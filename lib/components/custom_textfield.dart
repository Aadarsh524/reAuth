import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final bool obscureText;
  final bool isFormTypePassword;
  final List<TextInputFormatter> textInputFormatter;
  final TextInputType keyboardType;
  final Function(bool)? passwordVisibility;
  final Function(String)? onChanged;
  final bool isRequired;
  final bool enabled;
  final FocusNode? focusNode;
  final int maxLines; // Added maxLines parameter

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    this.passwordVisibility,
    this.isFormTypePassword = false,
    this.obscureText = false,
    this.textInputFormatter = const [],
    this.keyboardType = TextInputType.text,
    this.onChanged,
    required this.isRequired,
    this.enabled = true,
    this.focusNode,
    this.maxLines = 1, // Default value set to 1
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                labelText,
                style: GoogleFonts.karla(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  fontSize: 14,
                  letterSpacing: 0.75,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (isRequired)
                const Text(
                  ' *',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: maxLines > 1 ? null : 50, // Adjust height dynamically
            child: TextFormField(
              focusNode: focusNode,
              inputFormatters: textInputFormatter,
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              cursorColor: Colors.white,
              onChanged: onChanged,
              enabled: enabled,
              maxLines: maxLines, // Set maxLines property
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: Color.fromARGB(255, 125, 125, 125),
                  fontSize: 14,
                  letterSpacing: 0.75,
                  fontWeight: FontWeight.w400,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                suffixIcon: isFormTypePassword
                    ? IconButton(
                        icon: Icon(
                          obscureText ? Icons.visibility_off : Icons.visibility,
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                        onPressed: () {
                          passwordVisibility?.call(!obscureText);
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color.fromARGB(255, 43, 51, 63),
              ),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                letterSpacing: 0.75,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
