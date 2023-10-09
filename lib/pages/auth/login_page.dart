import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../dashboard/dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleUser.authentication;

      final authCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      await auth.signInWithCredential(authCredential);

      GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut().then((value) => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const DashboardPage(),
            ),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * .75,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ReAuth",
                        style: GoogleFonts.karla(
                            color: const Color.fromARGB(255, 125, 125, 125),
                            fontSize: 25,
                            letterSpacing: .75,
                            fontWeight: FontWeight.w600),
                      ).animate().slideX(duration: 750.ms, begin: -1.5),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 2.0, vertical: 15.0),
                        child: Text(
                          "Welcome Back,",
                          style: GoogleFonts.oxygenMono(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              fontSize: 14,
                              letterSpacing: .5,
                              fontWeight: FontWeight.w400),
                        ).animate(delay: 750.ms).fade(duration: 750.ms),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Sign In",
                        style: GoogleFonts.karla(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontSize: 18,
                            letterSpacing: .75,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * .25,
                              height: 1.0,
                              color: const Color.fromARGB(255, 125, 125, 125),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                "With",
                                style: GoogleFonts.karla(
                                    color: const Color.fromARGB(
                                        255, 125, 125, 125),
                                    fontSize: 14,
                                    letterSpacing: .75,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * .25,
                              height: 1.0,
                              color: const Color.fromARGB(255, 125, 125, 125),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 75,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.all(8.0),
                                        side: const BorderSide(
                                            color: Color.fromARGB(
                                                255, 53, 64, 79)),
                                        backgroundColor: const Color.fromARGB(
                                            255, 36, 45, 58)),
                                    onPressed: () async {
                                      await signInWithGoogle();
                                    },
                                    child: Image.network(
                                      'http://pngimg.com/uploads/google/google_PNG19635.png',
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.all(8.0),
                                        side: const BorderSide(
                                            color: Color.fromARGB(
                                                255, 53, 64, 79)),
                                        backgroundColor: const Color.fromARGB(
                                            255, 36, 45, 58)),
                                    onPressed: () {},
                                    child: Image.network(
                                      'https://pngimg.com/uploads/facebook_logos/small/facebook_logos_PNG19753.png',
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ).animate(delay: 1500.ms).fade(duration: 1000.ms)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
