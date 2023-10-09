import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const Color primaryDark = Color.fromARGB(255, 36, 45, 58);
  static const Color secondaryDark = Color.fromARGB(255, 43, 51, 63);
  static const Color tertiaryDark = Color.fromARGB(255, 53, 64, 79);

  static const Color primaryCardDark = Color.fromARGB(255, 106, 172, 191);
  static const Color secondaryCardDark = Color.fromARGB(255, 111, 163, 219);

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
            fontWeight: FontWeight.w600),
        titleLarge: GoogleFonts.karla(
            letterSpacing: .75,
            color: secondaryText,
            fontSize: 25,
            fontWeight: FontWeight.w600),
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
        bodyMedium: GoogleFonts.oxygenMono(
          letterSpacing: .5,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: const Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      dividerTheme: const DividerThemeData(color: secondaryText));
}
