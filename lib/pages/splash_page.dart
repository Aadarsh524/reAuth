import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reauth/pages/auth/login_page.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:reauth/pages/dashboard/dashboard_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();

    if (user != null) {
      Timer(const Duration(seconds: 3), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const DashboardPage(),
          ),
        );
      });
    } else {
      Timer(const Duration(seconds: 3), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                  style: Theme.of(context).textTheme.labelLarge,
                ).animate(delay: 1000.ms).fade(duration: 1000.ms),
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
