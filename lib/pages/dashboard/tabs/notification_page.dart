import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: const Color.fromARGB(255, 40, 50, 65),
        elevation: 4, // Add a subtle shadow
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    _buildNotificationItem(
                      title: "Reminder",
                      description: "Don't forget to update passwords.",
                      date: "Feb 9, 2025",
                    ),
                    // Add more notification items as needed
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required String description,
    required String date,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF37474F), // Darker background for notifications
        borderRadius:
            BorderRadius.circular(16), // Rounded corners for modern style
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.karla(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 12,
                    color: Colors.white54,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    date,
                    style: GoogleFonts.karla(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: GoogleFonts.karla(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }
}
