import 'package:flutter/material.dart';

class PasswordSuggestions extends StatefulWidget {
  const PasswordSuggestions({super.key});

  @override
  _PasswordSuggestionsState createState() => _PasswordSuggestionsState();
}

class _PasswordSuggestionsState extends State<PasswordSuggestions> {
  bool _isExpanded = false;

  List<Map<String, dynamic>> suggestions = [
    {"text": "Use at least 12 characters.", "icon": Icons.security},
    {
      "text": "Include both upper and lower case characters.",
      "icon": Icons.text_fields
    },
    {"text": "Include at least one number.", "icon": Icons.looks_one},
    {"text": "Include at least one special character.", "icon": Icons.star},
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 15),
      color: const Color.fromARGB(255, 40, 50, 65),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 40, 50, 65),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExpansionPanelList(
                expandedHeaderPadding: EdgeInsets.zero,
                elevation: 0,
                animationDuration: const Duration(milliseconds: 500),
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                children: [
                  ExpansionPanel(
                    backgroundColor: const Color.fromARGB(255, 40, 50, 65),
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return const ListTile(
                        leading: Icon(Icons.lightbulb,
                            color: Colors.yellow, size: 24),
                        title: Text(
                          "Password Suggestions",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                    body: Column(
                      children: suggestions.map((suggestion) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 50, 60, 75),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: Icon(suggestion["icon"],
                                color: Colors.white, size: 24),
                            title: Text(
                              suggestion["text"],
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    isExpanded: _isExpanded,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
