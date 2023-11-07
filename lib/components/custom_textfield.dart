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
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              labelText,
              style: GoogleFonts.karla(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  fontSize: 14,
                  letterSpacing: .75,
                  fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 60,
            child: Card(
              elevation: 5,
              color: Colors.transparent,
              child: TextFormField(
                inputFormatters: textInputFormatter,
                controller: controller,
                obscureText: obscureText,
                keyboardType: keyboardType,
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  suffixIcon: isFormTypePassword
                      ? IconButton(
                          icon: Icon(
                            obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white,
                            size: 18,
                          ),
                          onPressed: () {
                            passwordVisibility?.call(!obscureText);
                          })
                      : null,
                  hintText: hintText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 53, 64, 79),
                    ),
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 43, 51, 63),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(
                  fontFamily: 'oxygenMono',
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 12,
                  letterSpacing: 0.75,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
