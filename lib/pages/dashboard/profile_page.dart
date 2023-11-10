import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reauth/pages/auth/login_page.dart';
import 'package:reauth/pages/dashboard/editprofile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEmailVerified = true;
  @override
  Widget build(BuildContext context) {
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
              fontWeight: FontWeight.w600),
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
              ), // You can replace 'add' with any other icon
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
            borderRadius: BorderRadius.circular(30), // Adjust the radius here
          ),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
        child: Text(
          'Sign out',
          style: GoogleFonts.karla(
            color: const Color.fromARGB(250, 150, 0, 0),
            fontSize: 16,
            letterSpacing: .5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * .90,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(top: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/defaultAvatar.png'),
              ),
              const SizedBox(height: 20),
              Text(
                "Aadarsh Ghimire",
                style: GoogleFonts.karla(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontSize: 20,
                    letterSpacing: .75,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Text(
                "aadarshghimire524@gmail.com",
                style: GoogleFonts.karla(
                    color: const Color.fromARGB(255, 125, 125, 125),
                    fontSize: 18,
                    letterSpacing: .5,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              isEmailVerified
                  ? Container(
                      width: 85,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 106, 172, 191),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color.fromARGB(255, 106, 172, 191),
                              border: Border.all(
                                color: const Color.fromARGB(255, 106, 172, 191),
                                width: 1,
                              ),
                            ),
                            width: 16,
                            height: 16,
                            child: const Icon(
                              Icons.check,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            "Verified",
                            style: GoogleFonts.karla(
                              color: const Color.fromARGB(255, 106, 172, 191),
                              fontSize: 14,
                              letterSpacing: .5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      width: 115,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 106, 172, 191),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromARGB(250, 150, 0, 0),
                              border: Border.all(
                                color: Color.fromARGB(250, 150, 0, 0),
                                width: 1,
                              ),
                            ),
                            width: 16,
                            height: 16,
                            child: const Icon(
                              Icons.cancel_rounded,
                              size: 14,
                              color: Color.fromARGB(249, 255, 255, 255),
                            ),
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          Text(
                            "Not Verified",
                            style: GoogleFonts.karla(
                              color: const Color.fromARGB(255, 106, 172, 191),
                              fontSize: 14,
                              letterSpacing: .5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
              const SizedBox(height: 30),
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color.fromARGB(255, 106, 172, 191),
                      width: 1, // Adjust the width of the bottom border
                    ),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  children: [
                    Text(
                      "4",
                      style: GoogleFonts.karla(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontSize: 20,
                        letterSpacing: .75,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Saved Passwords",
                      style: GoogleFonts.karla(
                        color: const Color.fromARGB(255, 125, 125, 125),
                        fontSize: 16,
                        letterSpacing: .5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color.fromARGB(255, 106, 172, 191),
                          width: 1, // Adjust the width of the bottom border
                        ),
                      ),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: Column(
                      children: [
                        Text(
                          "1",
                          style: GoogleFonts.karla(
                              color: const Color.fromARGB(255, 111, 163, 219),
                              fontSize: 20,
                              letterSpacing: .75,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Strong",
                          style: GoogleFonts.karla(
                              color: const Color.fromARGB(255, 125, 125, 125),
                              fontSize: 16,
                              letterSpacing: .5,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color.fromARGB(255, 106, 172, 191),
                            width: 1, // Adjust the width of the bottom border
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 10),
                      child: Column(
                        children: [
                          Text(
                            "3",
                            style: GoogleFonts.karla(
                                color: const Color.fromARGB(250, 150, 0, 0),
                                fontSize: 20,
                                letterSpacing: .75,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Weak",
                            style: GoogleFonts.karla(
                                color: const Color.fromARGB(255, 125, 125, 125),
                                fontSize: 16,
                                letterSpacing: .5,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
