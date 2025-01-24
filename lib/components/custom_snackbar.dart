import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSnackbar {
  final String message;
  final bool isError; // Flag to indicate if the message is an error

  CustomSnackbar(this.message, {this.isError = false});

  void showCustomSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        backgroundColor: const Color.fromARGB(255, 53, 64, 79),
        duration: const Duration(milliseconds: 2500),
        elevation: 4, // Added elevation for a card-like appearance
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        content: Text(
          message,
          style: GoogleFonts.karla(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isError
                ? Colors.red
                : Colors.white, // Change color based on isError
          ),
        ),
      ),
    );
  }
}
