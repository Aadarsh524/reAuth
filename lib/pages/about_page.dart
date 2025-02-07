import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsiveness
    final size = MediaQuery.of(context).size;
    final horizontalPadding = size.width * 0.05;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 43, 51, 63),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 53, 64, 79),
        centerTitle: true,
        elevation: 0,
        title: Text(
          "About ReAuth",
          style: GoogleFonts.karla(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Optional: A centered logo image
              Center(
                child: Container(
                  width: size.width * 0.10,
                  height: size.width * 0.10,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/favicon.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "ReAuth is a powerful and secure password manager designed to protect your digital identity with cutting-edge encryption and seamless access. With AES-256 encryption, biometric authentication, and cross-platform syncing, ReAuth ensures that your passwords, sensitive notes, and personal data remain safe while being easily accessible whenever you need them. Features like auto-fill, a built-in password generator, two-factor authentication (2FA) integration, and dark web monitoring provide an extra layer of security against cyber threats. Whether you’re managing personal accounts or business credentials, ReAuth simplifies password management while keeping you in complete control of your online security.",
                style: GoogleFonts.karla(
                  fontSize: 16,
                  color: Colors.grey[300],
                  height: 1.25,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 20),
              // Add additional responsive UI elements here if needed
            ],
          ),
        ),
      ),
    );
  }
}
