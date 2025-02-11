import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LockScreen extends StatelessWidget {
  final VoidCallback onUnlock;

  const LockScreen({Key? key, required this.onUnlock}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "App Locked",
              style: GoogleFonts.karla(color: Colors.white, fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onUnlock,
              child: const Text("Unlock"),
            ),
          ],
        ),
      ),
    );
  }
}
