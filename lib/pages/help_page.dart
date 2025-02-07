import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Define a list of FAQs.
    final List<Map<String, String>> faqs = [
      {
        'question': 'Q: How do I use this app?',
        'answer':
            'A: Simply navigate through the app and follow the on-screen instructions to get started.'
      },
      {
        'question': 'Q: How do I enable biometric login?',
        'answer':
            'A: Go to the Settings page and enable biometric login for quick access.'
      },
      {
        'question': 'Q: How do I reset my password?',
        'answer':
            'A: Use the "Forgot Password" option on the login screen to securely reset your password.'
      },
      {
        'question': 'Q: How can I contact support?',
        'answer':
            'A: Reach out via the "Contact Us" section or email support@reauth.com for assistance.'
      },
      {
        'question': 'Q: Is my data secure?',
        'answer':
            'A: Yes, ReAuth uses AES-256 encryption along with biometric protection to keep your data safe.'
      },
    ];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 43, 51, 63),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 53, 64, 79),
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Help",
          style: GoogleFonts.karla(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.separated(
            itemCount: faqs.length,
            separatorBuilder: (context, index) => const Divider(
              color: Colors.grey,
              thickness: 1,
              height: 20,
            ),
            itemBuilder: (context, index) {
              final faq = faqs[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    faq['question']!,
                    style: GoogleFonts.karla(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    faq['answer']!,
                    style: GoogleFonts.karla(
                      fontSize: 14,
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
