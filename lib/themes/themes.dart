// app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const Color primaryDark = Color(0xFF242D3A);
  static const Color secondaryDark = Color.fromARGB(255, 43, 51, 63);
  static const Color tertiaryDark = Color.fromARGB(255, 53, 64, 79);

  static const Color primaryCardDark = Color(0xFF6AACBF);

  static const Color primaryText = Color.fromARGB(255, 255, 255, 255);
  static const Color secondaryText = Color.fromARGB(255, 125, 125, 125);

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: primaryDark,
    appBarTheme: const AppBarTheme(
      color: tertiaryDark,
      iconTheme: IconThemeData(color: secondaryText),
    ),
    colorScheme: const ColorScheme.dark(
      primary: primaryDark,
      secondary: secondaryDark,
      tertiary: tertiaryDark,
    ),
    iconTheme: const IconThemeData(
      color: secondaryText,
    ),
    textTheme: TextTheme(
      labelLarge: GoogleFonts.karla(
        letterSpacing: .75,
        color: primaryText,
        fontSize: 25,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: GoogleFonts.karla(
        letterSpacing: .75,
        color: secondaryText,
        fontSize: 25,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: GoogleFonts.karla(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: .75,
        color: primaryText,
      ),
      titleMedium: GoogleFonts.karla(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: .75,
        color: secondaryText,
      ),
      labelSmall: GoogleFonts.karla(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: .5,
        color: primaryText,
      ),
      titleSmall: GoogleFonts.karla(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: .5,
        color: secondaryText,
      ),
      bodyMedium: GoogleFonts.karla(
        letterSpacing: .5,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: primaryText,
      ),
    ),
    dividerTheme: const DividerThemeData(color: secondaryText),
  );

  // Helper method for custom text styles with specific sizes
  static TextStyle customTextStyle(double fontSize,
      {Color? color, FontWeight fontWeight = FontWeight.normal}) {
    return GoogleFonts.karla(
      fontSize: fontSize,
      color: color ?? primaryText,
      fontWeight: fontWeight,
    );
  }
}
