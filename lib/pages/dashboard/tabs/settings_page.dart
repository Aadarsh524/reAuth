import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reauth/pages/auth/login_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * .95,
          width: MediaQuery.of(context).size.width * .95,
          child: Column(
            children: [
              const Text("Settings"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: SizedBox(
                    child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(8.0),
                      side: const BorderSide(
                          color: Color.fromARGB(255, 53, 64, 79)),
                      backgroundColor: const Color.fromARGB(255, 36, 45, 58)),
                  onPressed: () async {
                    GoogleSignIn googleSignIn = GoogleSignIn();
                    await googleSignIn.signOut();
                    await firebaseAuth
                        .signOut()
                        .then((value) => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            ));
                  },
                  child: const Text("Sign Out"),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
