import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reauth/bloc/cubit/profile_cubit.dart';
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
            _buildPersonalInfoCard(context),
            SecuritySettingsCard(),
            GeneralSettingsCard(),
            AboutSettingsCard(),
          ],
        ),
      ),
    );
  }
}

Widget _buildPersonalInfoCard(BuildContext context) {
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
                            width: 40,
                            height: 40,
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
                            radius: 20,
                            backgroundImage:
                                AssetImage('assets/defaultAvatar.png'),
                          ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.profile.fullname,
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
                        const Icon(
                          Icons.badge,
                          color: Colors.white,
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
                          icon: const Icon(Icons.arrow_upward, size: 20),
                          label: Text(
                            "Upgrade",
                            style: GoogleFonts.karla(
                              color: Colors.black,
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
                      icon: const Icon(Icons.logout),
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
      return AlertDialog(
        backgroundColor: const Color.fromARGB(255, 40, 50, 65),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Log Out',
          style: TextStyle(
            fontSize: 18, // Smaller font size
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(
            fontSize: 14, // Smaller font size
            color: Color.fromARGB(255, 111, 163, 219),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
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
                fontSize: 14, // Smaller font size
                color: Color.fromARGB(255, 111, 163, 219),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
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
                fontSize: 14, // Smaller font size
                color: Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    },
  );
}
