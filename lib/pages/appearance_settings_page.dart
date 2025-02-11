import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppearanceSettingsPage extends StatelessWidget {
  static const _panelBackgroundColor = Color.fromARGB(255, 50, 60, 75);
  static const _textColor = Colors.white;
  static const _contentPadding =
      EdgeInsets.symmetric(horizontal: 20, vertical: 10);

  const AppearanceSettingsPage({super.key});

  static TextStyle get _headerStyle => GoogleFonts.karla(
        color: _textColor,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Appearance Settings", style: _headerStyle)),
      backgroundColor: _panelBackgroundColor,
      body: Padding(
        padding: _contentPadding,
        child: Column(
          children: [
            _buildSettingItem(Icons.format_size, "Font Size", () {}),
            _buildSettingItem(Icons.color_lens, "Theme Color", () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: _textColor),
      title: Text(title, style: GoogleFonts.karla(color: _textColor)),
      onTap: onTap,
    );
  }
}
