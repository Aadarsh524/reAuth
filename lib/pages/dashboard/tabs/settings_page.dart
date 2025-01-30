import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:reauth/bloc/cubit/authentication_cubit.dart';
import 'package:reauth/bloc/cubit/profile_cubit.dart';
import 'package:reauth/bloc/states/auth_state.dart';
import 'package:reauth/bloc/states/profile_state.dart';
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
  bool verifiedEmail = false;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _checkEmailVerification();
  }

  Future<void> _checkEmailVerification() async {
    bool verified = await BlocProvider.of<AuthenticationCubit>(context)
        .checkEmailVerification();
    setState(() {
      verifiedEmail = verified;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 40, 50, 65),
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            _buildPersonalInfoCard(context, verifiedEmail),
            const SecuritySettingsCard(),
            const GeneralSettingsCard(),
            const AboutSettingsCard(),
          ],
        ),
      ),
    );
  }
}

Widget _buildPersonalInfoCard(BuildContext context, bool verifiedEmail) {
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
            borderRadius: BorderRadius.circular(
                3), // Change this value to adjust corner roundness
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
                    state.profile.profileImage != ''
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
                              color: Colors.grey[400],
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
                              ? Icons.verified_user_outlined
                              : Icons.gpp_maybe_outlined,
                          color: verifiedEmail ? Colors.green : Colors.red,
                          size: 35,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            // Implement upgrade functionality
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 111, 163, 219),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(
                            Icons.arrow_upward,
                            size: 20,
                            color: Colors.white,
                          ),
                          label: Text(
                            "Upgrade",
                            style: GoogleFonts.karla(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        _showLogoutDialog(context);
                      },
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
      } else {
        return Container();
      }
    },
  );
}

void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BlocListener<AuthenticationCubit, AuthenticationState>(
        listener: (context, state) {
          if (state is LogoutInProgress) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is LogoutSuccess) {
            // Close all dialogs and navigate to LoginPage
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          }
        },
        child: AlertDialog(
          backgroundColor: const Color.fromARGB(255, 40, 50, 65),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Log Out',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(
              fontSize: 14,
              color: Color.fromARGB(255, 111, 163, 219),
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(
                    color: Color.fromARGB(255, 111, 163, 219),
                  ),
                ),
              ),
              child: const Text(
                "Cancel",
                style: TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 111, 163, 219),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // Trigger the logout process
                BlocProvider.of<AuthenticationCubit>(context).logout();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(
                    color: Colors.red,
                  ),
                ),
              ),
              child: const Text(
                "Logout",
                style: TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
