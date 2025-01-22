import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GeneralSettingsCard extends StatefulWidget {
  const GeneralSettingsCard({Key? key}) : super(key: key);

  @override
  State<GeneralSettingsCard> createState() => _GeneralSettingsCardState();
}

class _GeneralSettingsCardState extends State<GeneralSettingsCard> {
  bool _isGeneralExpanded = false;

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
            _isGeneralExpanded = !_isGeneralExpanded;
          });
        },
        children: [
          ExpansionPanel(
            backgroundColor: const Color.fromARGB(255, 50, 60, 75),
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(
                  "General Settings",
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
                  const Divider(),
                  _buildSettingItem(
                    icon: Icons.info,
                    title: 'Password Generator',
                    onTap: () {
                      // Implement About functionality
                    },
                  ),
                  _buildSettingItem(
                    icon: Icons.feedback,
                    title: 'Appearance Settings',
                    onTap: () {
                      // Implement Send Feedback functionality
                    },
                  ),
                  _buildSettingItem(
                    icon: Icons.help,
                    title: 'Notifications Settings',
                    onTap: () {
                      // Implement Help functionality
                    },
                  ),
                ],
              ),
            ),
            isExpanded: _isGeneralExpanded,
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
