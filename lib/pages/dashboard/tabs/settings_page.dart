import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reauth/components/AuthCategory/bloc/cubit/authentication_cubit.dart';
import 'package:reauth/components/AuthCategory/bloc/cubit/profile_cubit.dart';
import 'package:reauth/components/AuthCategory/bloc/states/authentication_state.dart';
import 'package:reauth/components/AuthCategory/bloc/states/profile_state.dart';
import 'package:reauth/components/about_settings_card.dart';
import 'package:reauth/components/general_settings_card.dart';
import 'package:reauth/components/security_settings_card.dart';
import 'package:reauth/pages/auth/login_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Immediately initialize with the current user's email verification status.
  final User? user = FirebaseAuth.instance.currentUser;
  late bool verifiedEmail = user?.emailVerified ?? false;

  @override
  void initState() {
    super.initState();
    _checkEmailVerification();
  }

  Future<void> _checkEmailVerification() async {
    // Optionally re-check the status using your cubit if needed.
    bool verified = await BlocProvider.of<AuthenticationCubit>(context)
        .checkEmailVerification();
    if (mounted) {
      setState(() {
        verifiedEmail = verified;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 40, 50, 65),
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            PersonalInfoCard(
              verifiedEmail: verifiedEmail,
              screenWidth: screenWidth,
              onLogout: () => _showLogoutDialog(context),
            ),
            const SecuritySettingsCard(),
            const GeneralSettingsCard(),
            const AboutSettingsCard(),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    Navigator.of(context).push(PageRouteBuilder(
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54, // Dark overlay color
      transitionDuration:
          const Duration(milliseconds: 300), // Opening animation duration
      pageBuilder: (context, animation, secondaryAnimation) {
        // Wrap your dialog widget inside a BlocListener if needed.
        return BlocListener<AuthenticationCubit, AuthenticationState>(
          listener: (context, state) {
            if (state is LogoutInProgress) {
              // Optionally show a loading indicator if needed.
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (state is LogoutSuccess) {
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            }
          },
          child: Center(
            child: _buildLogoutDialog(context),
          ),
        );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        if (animation.status == AnimationStatus.reverse) {
          return child; // Close instantly
        }
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack, // Nice bounce effect on open
          ),
          child: child,
        );
      },
    ));
  }

  Widget _buildLogoutDialog(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 72, 80, 93),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        "Log Out",
        style: GoogleFonts.karla(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: SingleChildScrollView(
        child: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.karla(
            color: const Color.fromARGB(255, 111, 163, 219),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog instantly
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.red,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(
                color: Colors.red,
              ),
            ),
          ),
          child: Text(
            "Cancel",
            style: GoogleFonts.karla(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            // Trigger the logout process via your cubit
            BlocProvider.of<AuthenticationCubit>(context).logout();
          },
          style: TextButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 111, 163, 219),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(
                color: Color.fromARGB(255, 111, 163, 219),
              ),
            ),
          ),
          child: Text(
            "Logout",
            style: GoogleFonts.karla(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class PersonalInfoCard extends StatelessWidget {
  final bool verifiedEmail;
  final double screenWidth;
  final VoidCallback onLogout;

  const PersonalInfoCard({
    Key? key,
    required this.verifiedEmail,
    required this.screenWidth,
    required this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 106, 172, 191),
            ),
          );
        }
        if (state is ProfileLoaded) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            color: const Color.fromARGB(255, 50, 60, 75),
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      state.profile.profileImage.isNotEmpty
                          ? Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      state.profile.profileImage),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : const CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/defaultAvatar.png'),
                            ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.profile.fullName,
                              style: GoogleFonts.karla(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              state.profile.email,
                              style: GoogleFonts.karla(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            verifiedEmail
                                ? Icons.verified_outlined
                                : Icons.error_outline,
                            color: verifiedEmail
                                ? Colors.greenAccent
                                : Colors.redAccent,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            verifiedEmail ? "Verified" : "Not Verified",
                            style: GoogleFonts.karla(
                              color: verifiedEmail
                                  ? Colors.greenAccent
                                  : Colors.redAccent,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton.icon(
                            onPressed: () {
                              // Implement upgrade functionality if needed.
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFCC00),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            icon: const Icon(
                              Icons.arrow_upward,
                              size: 20,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                            label: Text(
                              "Upgrade",
                              style: GoogleFonts.karla(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: onLogout,
                        icon: const Icon(
                          Icons.logout,
                          size: 32,
                        ),
                        color: Colors.redAccent,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
