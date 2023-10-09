import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final bool obscureText;
  final TextInputType keyboardType;
  final Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
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
          Card(
            elevation: 5,
            color: Colors.transparent,
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              onChanged: onChanged,
              cursorColor: Colors.white,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(16),
                hintText: hintText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: Color.fromARGB(255, 53, 64, 79)),
                ),
                filled: true,
                fillColor: const Color.fromARGB(255, 43, 51, 63),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(
                  fontFamily: 'oxygenMono',
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 12,
                  letterSpacing: .75,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}
