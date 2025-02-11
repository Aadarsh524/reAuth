import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'custom_snackbar.dart';
import '../pages/about_page.dart';
import '../pages/feedback_page.dart';
import '../pages/help_page.dart';
import '../services/rating_services.dart';

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

void showRateDialog(BuildContext context) {
  int selectedStars = 0;
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: const Color(0xFF242D3A),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return StatefulBuilder(
              builder: (context, setDialogState) {
                return AlertDialog(
                  backgroundColor: const Color.fromARGB(255, 72, 80, 93),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  title: Text(
                    "Rate this App",
                    style: GoogleFonts.karla(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(5, (index) {
                          return IconButton(
                            // Reduce spacing between icons:
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            constraints: const BoxConstraints(),
                            icon: Icon(
                              index < selectedStars
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 28, // Adjust star size as needed
                            ),
                            onPressed: () {
                              setDialogState(() {
                                selectedStars = index + 1;
                              });
                            },
                          );
                        }),
                      ),
                      if (selectedStars > 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "$selectedStars Star${selectedStars > 1 ? 's' : ''}",
                            style: GoogleFonts.karla(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.karla(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: selectedStars > 0
                          ? () {
                              submitRating(selectedStars);
                              Navigator.pop(context);
                              CustomSnackbar.show(
                                context,
                                message: "Thank you for rating!",
                              );
                            }
                          : null,
                      child: Text(
                        "Submit",
                        style: GoogleFonts.karla(
                          color: selectedStars > 0 ? Colors.amber : Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        ),
        child: child,
      );
    },
  );
}
