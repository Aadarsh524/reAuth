import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutSettingsCard extends StatefulWidget {
  const AboutSettingsCard({super.key});

  @override
  State<AboutSettingsCard> createState() => _AboutSettingsCardState();
}

class _AboutSettingsCardState extends State<AboutSettingsCard> {
  static const _panelBackgroundColor = Color.fromARGB(255, 50, 60, 75);
  static const _textColor = Colors.white;
  static const _iconSize = 20.0;
  static const _animationDuration = Duration(milliseconds: 300);
  static const _verticalPadding = EdgeInsets.symmetric(vertical: 5);
  static const _contentPadding =
      EdgeInsets.symmetric(horizontal: 20, vertical: 5);
  static const _itemPadding = EdgeInsets.symmetric(vertical: 12);
  static const _iconSpacing = SizedBox(width: 16);

  // Made styles static
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

  bool _isAboutExpanded = false;

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
            setState(() => _isAboutExpanded = !_isAboutExpanded),
        children: [_buildExpansionPanel()],
      ),
    );
  }

  ExpansionPanel _buildExpansionPanel() {
    return ExpansionPanel(
      backgroundColor: _panelBackgroundColor,
      headerBuilder: _buildHeader,
      body: _buildPanelBody(),
      isExpanded: _isAboutExpanded,
    );
  }

  Widget _buildHeader(BuildContext context, bool isExpanded) {
    return ListTile(title: Text("About Settings", style: _headerStyle));
  }

  Widget _buildPanelBody() {
    return Padding(
      padding: _contentPadding,
      child: Column(
        children: [
          const Divider(),
          SettingsItem(icon: Icons.info, title: 'About', onTap: () {}),
          SettingsItem(
              icon: Icons.feedback, title: 'Send Feedback', onTap: () {}),
          SettingsItem(icon: Icons.help, title: 'Help', onTap: () {}),
          SettingsItem(icon: Icons.star, title: 'Rate this App', onTap: () {}),
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
        padding: _AboutSettingsCardState._itemPadding,
        child: Row(
          children: [
            Icon(icon,
                color: _AboutSettingsCardState._textColor,
                size: _AboutSettingsCardState._iconSize),
            _AboutSettingsCardState._iconSpacing,
            Text(title, style: _AboutSettingsCardState._itemStyle),
          ],
        ),
      ),
    );
  }
}
