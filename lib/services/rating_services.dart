import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> submitRating(int count) async {
  // Get an instance of Firestore.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Retrieve the currently authenticated user.
  final User? user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    throw Exception('User is not logged in.');
  }

  try {
    // Save the feedback message to the 'feedbacks' collection
    // using the user's UID as the document ID.
    await _firestore.collection('ratings').doc(user.uid).set({
      'count': count,
      'timestamp': FieldValue.serverTimestamp(),
    });

    print("Feedback submitted successfully.");
  } catch (e) {
    print("Error submitting feedback: $e");
    rethrow;
  }
}
