import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  bool obscureText;
  bool isFormTypePassword;

  final List<TextInputFormatter> textInputFormatter;
  final TextInputType keyboardType;
  Function(bool)? passwordVisibility;

  CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    this.passwordVisibility,
    this.isFormTypePassword = false,
    this.obscureText = false,
    this.textInputFormatter = const [],
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: GoogleFonts.karla(
              color: Colors.white,
              fontSize: 14,
              letterSpacing: 0.75,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 50,
            child: TextFormField(
              inputFormatters: textInputFormatter,
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              cursorColor: Colors.white,
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
                          color: Colors.white,
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
                fillColor: const Color.fromARGB(255, 53, 64, 79),
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
