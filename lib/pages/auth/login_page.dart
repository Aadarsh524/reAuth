import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 36, 45, 58),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * .95,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 100,
                ),
                Text(
                  "ReAuth",
                  style: GoogleFonts.karla(
                      color: const Color.fromARGB(255, 125, 125, 125),
                      fontSize: 25,
                      letterSpacing: .75,
                      fontWeight: FontWeight.w600),
                )
                    .animate()
                    .fade(duration: 750.ms)
                    .slideY(duration: 750.ms, begin: -1.5),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome Back,",
                        style: GoogleFonts.oxygenMono(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontSize: 14,
                            letterSpacing: .5,
                            fontWeight: FontWeight.w400),
                      ).animate(delay: 1500.ms),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        "Sign In",
                        style: GoogleFonts.karla(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontSize: 18,
                            letterSpacing: .75,
                            fontWeight: FontWeight.w600),
                      )
                          .animate()
                          .fade(duration: 750.ms)
                          .slideY(duration: 750.ms, begin: -1.5),
                    ],
                  ),
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
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          "With",
                          style: GoogleFonts.karla(
                              color: const Color.fromARGB(255, 125, 125, 125),
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
                  height: 60,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: SizedBox(
                            height: 50,
                            width: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(8.0),
                                  side: const BorderSide(
                                      color: Color.fromARGB(255, 53, 64, 79)),
                                  backgroundColor:
                                      const Color.fromARGB(255, 36, 45, 58)),
                              onPressed: () {},
                              child: Image.network(
                                'http://pngimg.com/uploads/google/google_PNG19635.png',
                                fit: BoxFit.cover,
                              ),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: SizedBox(
                            height: 50,
                            width: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(8.0),
                                  side: const BorderSide(
                                      color: Color.fromARGB(255, 53, 64, 79)),
                                  backgroundColor:
                                      const Color.fromARGB(255, 36, 45, 58)),
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
            ),
          ),
        ),
      ),
    );
  }
}
