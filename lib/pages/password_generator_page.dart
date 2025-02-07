import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

/// State management for the password generator.
class PasswordGeneratorModel extends ChangeNotifier {
  bool includeNumbers = true;
  bool includeUppercase = true;
  bool includeSpecialChars = true;
  String generatedPassword = "";

  /// Generates a new password based on the selected options.
  void generatePassword() {
    const lowercase = "abcdefghijklmnopqrstuvwxyz";
    const uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    const numbers = "0123456789";
    const specialChars = "!@#\$%^&*()_+-=[]{}|;:'\",.<>?/";
    String chars = lowercase;
    if (includeUppercase) chars += uppercase;
    if (includeNumbers) chars += numbers;
    if (includeSpecialChars) chars += specialChars;

    Random random = Random();
    generatedPassword =
        List.generate(12, (index) => chars[random.nextInt(chars.length)])
            .join();
    notifyListeners();
  }

  /// Toggles the uppercase inclusion.
  void toggleUppercase(bool value) {
    includeUppercase = value;
    notifyListeners();
  }

  /// Toggles the numbers inclusion.
  void toggleNumbers(bool value) {
    includeNumbers = value;
    notifyListeners();
  }

  /// Toggles the special characters inclusion.
  void toggleSpecialChars(bool value) {
    includeSpecialChars = value;
    notifyListeners();
  }

  /// Copies the generated password to the clipboard.
  void copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: generatedPassword));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Password copied to clipboard!",
          style: GoogleFonts.karla(),
        ),
      ),
    );
  }
}

/// The main page that shows the password generator UI.
class PasswordGeneratorPage extends StatelessWidget {
  const PasswordGeneratorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define a refined color scheme.
    final Color backgroundColor = const Color(0xFF1F1F2E);
    final Color appBarColor = const Color(0xFF2C2C3D);
    final Color cardColor = const Color(0xFF2A2A3A);
    final Color accentColor = Colors.amber;
    final Color inactiveColor = Colors.grey;
    final Color copyButtonColor = Colors.teal;

    return ChangeNotifierProvider(
      create: (_) => PasswordGeneratorModel(),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text(
            "Password Generator",
            style: GoogleFonts.karla(),
          ),
          backgroundColor: appBarColor,
          centerTitle: true,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Consumer<PasswordGeneratorModel>(
                builder: (context, model, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Customize Your Password",
                        style: GoogleFonts.karla(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Switch options for password components.
                      SwitchListTile(
                        title: Text(
                          "Include Uppercase",
                          style: GoogleFonts.karla(
                            color: model.includeUppercase
                                ? accentColor
                                : inactiveColor,
                          ),
                        ),
                        value: model.includeUppercase,
                        onChanged: model.toggleUppercase,
                        activeColor: accentColor,
                      ),
                      SwitchListTile(
                        title: Text(
                          "Include Numbers",
                          style: GoogleFonts.karla(
                            color: model.includeNumbers
                                ? accentColor
                                : inactiveColor,
                          ),
                        ),
                        value: model.includeNumbers,
                        onChanged: model.toggleNumbers,
                        activeColor: accentColor,
                      ),
                      SwitchListTile(
                        title: Text(
                          "Include Special Characters",
                          style: GoogleFonts.karla(
                            color: model.includeSpecialChars
                                ? accentColor
                                : inactiveColor,
                          ),
                        ),
                        value: model.includeSpecialChars,
                        onChanged: model.toggleSpecialChars,
                        activeColor: accentColor,
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Column(
                          children: [
                            ElevatedButton(
                              onPressed: model.generatePassword,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accentColor,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                "Generate Password",
                                style: GoogleFonts.karla(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Display generated password in a styled card.
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: cardColor,
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: SelectableText(
                                  model.generatedPassword,
                                  style: GoogleFonts.karla(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: model.generatedPassword.isNotEmpty
                                  ? () => model.copyToClipboard(context)
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: copyButtonColor,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                "Copy to Clipboard",
                                style: GoogleFonts.karla(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
