import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSnackbar {
  static const _defaultDuration = Duration(milliseconds: 2500);
  static const _backgroundColor = Color.fromARGB(255, 53, 64, 79);
  static const _errorColor = Colors.red;
  static const _defaultColor = Colors.white;
  static const _padding = EdgeInsets.symmetric(vertical: 16, horizontal: 20);
  static const _borderRadius = BorderRadius.zero; // Keep rectangular shape
  static const _elevation = 4.0;

  static TextStyle get _textStyle => GoogleFonts.karla(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      );

  static void show(
    BuildContext context, {
    required String message,
    bool isError = false,
  }) {
    final textColor = isError ? _errorColor : _defaultColor;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: _padding,
        backgroundColor: _backgroundColor,
        duration: _defaultDuration,
        elevation: _elevation,
        shape: const RoundedRectangleBorder(borderRadius: _borderRadius),
        content: Text(
          message,
          style: _textStyle.copyWith(color: textColor),
        ),
      ),
    );
  }
}
