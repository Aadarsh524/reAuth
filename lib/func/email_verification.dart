import 'package:firebase_auth/firebase_auth.dart';

void verifyEmail(String email) {
  User? user = FirebaseAuth.instance.currentUser;
  try {
    user?.sendEmailVerification();
  } catch (e) {
    rethrow;
  }
}
