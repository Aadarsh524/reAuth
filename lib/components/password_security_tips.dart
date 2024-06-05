import 'package:flutter/material.dart';

Widget _buildSecurityTips() {
  List<Map<String, dynamic>> tips = [
    {
      "text": "Enable two-factor authentication (2FA).",
      "icon": Icons.phonelink_lock
    },
    {"text": "Regularly update your passwords.", "icon": Icons.update},
    {
      "text": "Avoid using the same password across multiple sites.",
      "icon": Icons.repeat
    },
    {"text": "Be cautious of phishing scams.", "icon": Icons.warning},
    {"text": "Use a password manager.", "icon": Icons.vpn_key},
  ];

  return Card(
    color: const Color.fromARGB(255, 40, 50, 65),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.security, color: Colors.yellow, size: 24),
              SizedBox(width: 10),
              Text(
                "Security Tips",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16, // Reduced font size
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20), // Spacer between title and tips
          ...tips.map((tip) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Icon(tip["icon"], color: Colors.white, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        tip["text"],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14, // Reduced font size for tips
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    ),
  );
}
