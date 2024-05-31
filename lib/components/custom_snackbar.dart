import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSnackbar {
  late String message;

  CustomSnackbar(this.message);

  void showCustomSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: const EdgeInsets.all(20),
        backgroundColor: const Color.fromARGB(255, 111, 163, 219),
        duration: const Duration(milliseconds: 2500),
        content: Text(
          message,
          style: GoogleFonts.montserrat(
            height: 1.0, // Adjusted height value
            letterSpacing: 0.5,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
