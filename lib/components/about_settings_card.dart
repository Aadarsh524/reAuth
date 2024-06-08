import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutSettingsCard extends StatefulWidget {
  AboutSettingsCard({Key? key}) : super(key: key);

  @override
  State<AboutSettingsCard> createState() => _AboutSettingsCardState();
}

class _AboutSettingsCardState extends State<AboutSettingsCard> {
  bool _isAboutExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: ExpansionPanelList(
        elevation: 0,
        expandedHeaderPadding: EdgeInsets.zero,
        dividerColor: Colors.transparent,
        animationDuration: const Duration(milliseconds: 300),
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _isAboutExpanded = !_isAboutExpanded;
          });
        },
        children: [
          ExpansionPanel(
            backgroundColor: const Color.fromARGB(255, 50, 60, 75),
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(
                  "About Settings",
                  style: GoogleFonts.karla(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            },
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Column(
                children: [
                  Divider(),
                  _buildSettingItem(
                    icon: Icons.info,
                    title: 'About',
                    onTap: () {
                      // Implement About functionality
                    },
                  ),
                  _buildSettingItem(
                    icon: Icons.feedback,
                    title: 'Send Feedback',
                    onTap: () {
                      // Implement Send Feedback functionality
                    },
                  ),
                  _buildSettingItem(
                    icon: Icons.help,
                    title: 'Help',
                    onTap: () {
                      // Implement Help functionality
                    },
                  ),
                  _buildSettingItem(
                    icon: Icons.star,
                    title: 'Rate this App',
                    onTap: () {
                      // Implement Rate this App functionality
                    },
                  ),
                ],
              ),
            ),
            isExpanded: _isAboutExpanded,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'Karla',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
