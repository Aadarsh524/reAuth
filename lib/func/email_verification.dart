import 'package:firebase_auth/firebase_auth.dart';

Future<void> sendVerificationEmail(User? user) async {
  if (user != null && !user.emailVerified) {
    await user.sendEmailVerification();
  }
}

Future<bool> isEmailVerified() async {
  User? user = FirebaseAuth.instance.currentUser;
  await user?.reload(); // Refresh user to get updated info
  return user?.emailVerified ?? false;
}
