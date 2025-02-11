import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/custom_snackbar.dart';
import '../components/custom_textfield.dart';
import '../services/feedback_services.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController feedbackController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 53, 64, 79),
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Send Feedback",
          style: GoogleFonts.karla(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              keyboardType: TextInputType.text,
              controller: feedbackController,
              maxLines: 5,
              hintText: 'Enter your feedback here...',
              labelText: 'Your Feedback',
              isRequired: true,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 111, 163, 219),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    if (feedbackController.text.trim().isEmpty) {
                      CustomSnackbar.show(context,
                          message: "Feedback cannot be empty", isError: true);
                      return;
                    }
                    submitFeedback(feedbackController.text.trim());
                    CustomSnackbar.show(
                      context,
                      message: "Feedback Submitted",
                    );
                  },
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Karla',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
