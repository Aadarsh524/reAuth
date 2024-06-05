import 'package:flutter/material.dart';

Widget _buildPasswordSuggestions() {
  List<Map<String, dynamic>> suggestions = [
    {"text": "Use at least 12 characters.", "icon": Icons.security},
    {
      "text": "Include both upper and lower case characters.",
      "icon": Icons.text_fields
    },
    {"text": "Include at least one number.", "icon": Icons.looks_one},
    {"text": "Include at least one special character.", "icon": Icons.star},
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
              Icon(Icons.lightbulb, color: Colors.yellow, size: 24),
              SizedBox(width: 10),
              Text(
                "Password Suggestions",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...suggestions.map((suggestion) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Icon(suggestion["icon"], color: Colors.white, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        suggestion["text"],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
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
