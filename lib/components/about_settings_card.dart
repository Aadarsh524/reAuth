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
  static const _animationDuration = Duration(milliseconds: 300);
  static const _verticalPadding = EdgeInsets.symmetric(vertical: 5);
  static const _contentPadding =
      EdgeInsets.symmetric(horizontal: 20, vertical: 5);

  // Made styles static
  static TextStyle get _headerStyle => GoogleFonts.karla(
        color: _textColor,
        fontSize: 16,
        fontWeight: FontWeight.w700,
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
          _buildSettingsItem(context, Icons.info, "About", () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AboutPage()));
          }),
          _buildSettingsItem(context, Icons.feedback, "Send Feedback", () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const FeedbackPage()));
          }),
          _buildSettingsItem(context, Icons.help, "Help", () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HelpPage()));
          }),
          _buildSettingsItem(context, Icons.star, "Rate this App", () {
            showRateDialog(context);
          }),
        ],
      ),
    );
  }
}

Widget _buildSettingsItem(
    BuildContext context, IconData icon, String title, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 16),
          Text(title,
              style: GoogleFonts.karla(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    ),
  );
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "This is an app to manage your settings efficiently.",
            style: GoogleFonts.karla(fontSize: 16),
          ),
        ),
      ),
    );
  }
}

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController feedbackController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Send Feedback")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Your Feedback", style: GoogleFonts.karla(fontSize: 18)),
            const SizedBox(height: 10),
            TextField(
              controller: feedbackController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter your feedback here...",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Feedback Submitted")),
                );
              },
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Help")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("FAQs",
                style: GoogleFonts.karla(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(
                "Q: How to use this app?\nA: Simply navigate through the settings and configure as needed.",
                style: GoogleFonts.karla(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

void showRateDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Rate this App"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Please rate this app"),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: const Icon(Icons.star_border),
                  onPressed: () {},
                );
              }),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Thank you for rating!")),
              );
            },
            child: const Text("Submit"),
          ),
        ],
      );
    },
  );
}
