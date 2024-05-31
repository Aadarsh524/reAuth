import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reauth/bloc/cubit/profile_cubit.dart';
import 'package:reauth/bloc/states/profile_state.dart';
import 'package:reauth/pages/auth/login_page.dart';
import 'package:reauth/pages/dashboard/editprofile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEmailVerified = false;

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ProfileCubit>(context).fetchProfile();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 36, 45, 58),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 36, 45, 58),
        centerTitle: true,
        title: Text(
          "Profile",
          style: GoogleFonts.karla(
            color: const Color.fromARGB(255, 255, 255, 255),
            fontSize: 25,
            letterSpacing: .75,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              splashRadius: 25,
              icon: const Icon(
                Icons.edit,
                size: 24,
                color: Color.fromARGB(255, 111, 163, 219),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const EditProfilePage(),
                  ),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: TextButton(
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
          backgroundColor: const Color.fromARGB(255, 111, 163, 219),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
        child: Text(
          'Sign out',
          style: GoogleFonts.karla(
            color: Colors.white,
            fontSize: 16,
            letterSpacing: .5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoaded) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/defaultAvatar.png'),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      state.profile.fullname,
                      style: GoogleFonts.karla(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      state.profile.email,
                      style: GoogleFonts.karla(
                        color: Colors.grey[400],
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    isEmailVerified
                        ? _buildVerificationStatus(
                            "Verified",
                            Colors.green,
                            Icons.check_circle,
                          )
                        : _buildVerificationStatus(
                            "Not Verified",
                            Colors.red,
                            Icons.cancel,
                          ),
                    const SizedBox(height: 30),
                    _buildProfileCard(
                      "4",
                      "Saved Passwords",
                      Icons.lock,
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildProfileCard("1", "Strong", Icons.security),
                        _buildProfileCard("3", "Weak", Icons.warning),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 106, 172, 191),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVerificationStatus(String status, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 5),
          Text(
            status,
            style: GoogleFonts.karla(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(String count, String label, IconData icon) {
    return Card(
      color: const Color.fromARGB(255, 40, 50, 65),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          children: [
            Icon(icon,
                color: const Color.fromARGB(255, 106, 172, 191), size: 30),
            const SizedBox(height: 10),
            Text(
              count,
              style: GoogleFonts.karla(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: GoogleFonts.karla(
                color: Colors.grey[400],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
