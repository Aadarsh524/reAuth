import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reauth/pages/notification_settings_page.dart';
import 'package:reauth/pages/password_generator_page.dart';
import 'package:reauth/pages/appearance_settings_page.dart';

class GeneralSettingsCard extends StatefulWidget {
  const GeneralSettingsCard({super.key});

  @override
  State<GeneralSettingsCard> createState() => _GeneralSettingsCardState();
}

class _GeneralSettingsCardState extends State<GeneralSettingsCard> {
  static const _panelBackgroundColor = Color.fromARGB(255, 50, 60, 75);
  static const _textColor = Colors.white;
  static const _iconSize = 20.0;
  static const _animationDuration = Duration(milliseconds: 300);
  static const _verticalPadding = EdgeInsets.symmetric(vertical: 5);
  static const _contentPadding =
      EdgeInsets.symmetric(horizontal: 20, vertical: 5);
  static const _itemPadding = EdgeInsets.symmetric(vertical: 12);
  static const _iconSpacing = SizedBox(width: 16);

  static TextStyle get _headerStyle => GoogleFonts.karla(
        color: _textColor,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get _itemStyle => GoogleFonts.karla(
        color: _textColor,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      );

  bool _isGeneralExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _verticalPadding,
      child: ExpansionPanelList(
        elevation: 0,
        expandedHeaderPadding: EdgeInsets.zero,
        dividerColor: Colors.transparent,
        animationDuration: _animationDuration,
        expansionCallback: (_, __) =>
            setState(() => _isGeneralExpanded = !_isGeneralExpanded),
        children: [_buildExpansionPanel()],
      ),
    );
  }

  ExpansionPanel _buildExpansionPanel() {
    return ExpansionPanel(
      backgroundColor: _panelBackgroundColor,
      headerBuilder: _buildHeader,
      body: _buildPanelBody(),
      isExpanded: _isGeneralExpanded,
    );
  }

  Widget _buildHeader(BuildContext context, bool isExpanded) {
    return ListTile(title: Text("General Settings", style: _headerStyle));
  }

  Widget _buildPanelBody() {
    return Padding(
      padding: _contentPadding,
      child: Column(
        children: [
          const Divider(),
          SettingsItem(
              icon: Icons.password,
              title: 'Password Generator',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PasswordGeneratorPage()),
                );
              }),
          SettingsItem(
              icon: Icons.palette,
              title: 'Appearance Settings',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AppearanceSettingsPage()),
                );
              }),
          SettingsItem(
              icon: Icons.notifications,
              title: 'Notifications Settings',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NotificationsSettingsPage()),
                );
              }),
        ],
      ),
    );
  }
}

class SettingsItem extends StatelessWidget {
  const SettingsItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: _GeneralSettingsCardState._itemPadding,
        child: Row(
          children: [
            Icon(
              icon,
              color: _GeneralSettingsCardState._textColor,
              size: _GeneralSettingsCardState._iconSize,
            ),
            _GeneralSettingsCardState._iconSpacing,
            Text(title, style: _GeneralSettingsCardState._itemStyle),
          ],
        ),
      ),
    );
  }
}
