import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'package:flutter/services.dart';

class PasswordGeneratorPage extends StatefulWidget {
  @override
  _PasswordGeneratorPageState createState() => _PasswordGeneratorPageState();
}

class _PasswordGeneratorPageState extends State<PasswordGeneratorPage> {
  bool includeNumbers = true;
  bool includeUppercase = true;
  bool includeSpecialChars = true;
  String generatedPassword = "";

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

    setState(() {});
  }

  void copyToClipboard() {
    Clipboard.setData(ClipboardData(text: generatedPassword));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Password copied to clipboard!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Password Generator")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text("Include Uppercase"),
              value: includeUppercase,
              onChanged: (val) => setState(() => includeUppercase = val),
            ),
            SwitchListTile(
              title: const Text("Include Numbers"),
              value: includeNumbers,
              onChanged: (val) => setState(() => includeNumbers = val),
            ),
            SwitchListTile(
              title: const Text("Include Special Characters"),
              value: includeSpecialChars,
              onChanged: (val) => setState(() => includeSpecialChars = val),
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: generatePassword,
                    child: const Text("Generate Password"),
                  ),
                  const SizedBox(height: 10),
                  SelectableText(
                    generatedPassword,
                    style: GoogleFonts.karla(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed:
                        generatedPassword.isNotEmpty ? copyToClipboard : null,
                    child: const Text("Copy to Clipboard"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
