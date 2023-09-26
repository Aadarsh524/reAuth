import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reauth/pages/auth/login_page.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    });
  }

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
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Image.asset(
                    "assets/splash.png",
                    colorBlendMode: BlendMode.colorBurn,
                    filterQuality: FilterQuality.high,
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
                Text(
                  "ReAuth",
                  style: GoogleFonts.karla(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontSize: 25,
                      letterSpacing: .75,
                      fontWeight: FontWeight.w600),
                ).animate().fade(delay: 1250.ms)
                // .scale(delay: 750.ms)
                // .slideY(
                //       delay: 250.ms,
                //       duration: 1000.ms,
                //       begin: -1.2,
                //     ),
                ,
                const SizedBox(
                  height: 75,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
