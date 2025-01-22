import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reauth/bloc/cubit/authentication_cubit.dart';
import 'package:reauth/bloc/states/auth_state.dart';
import 'package:reauth/components/custom_snackbar.dart';
import 'package:reauth/pages/dashboard/dashboard_page.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EmailVerificationPageState createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final User? user = FirebaseAuth.instance.currentUser;

  bool _isEmailVerified = false;
  bool _isVerificationEmailSent = false;
  bool _isCheckingVerification = false;
  bool _didnotReceived = true;
  CustomSnackbar customSnackbar = CustomSnackbar('');

  @override
  void initState() {
    super.initState();

    _checkEmailVerified();
  }

  void _sendVerificationEmail() async {
    try {
      setState(() {
        _isVerificationEmailSent = true;
        _didnotReceived = false;
        _isCheckingVerification = true;
      });

      await user!.sendEmailVerification();

      Future.delayed(const Duration(seconds: 30), () {
        setState(() {
          _didnotReceived = true;
        });
      });

      _checkEmailVerified();
    } catch (e) {
      setState(() {
        _isCheckingVerification = false;
      });
    }
  }

  void _checkEmailVerified() async {
    while (!_isEmailVerified) {
      await Future.delayed(const Duration(seconds: 3));
      await user!.reload();
      setState(() {
        _isEmailVerified = user!.emailVerified;
        _isCheckingVerification = false;
      });
    }
    if (_isEmailVerified == true) {
      // ignore: use_build_context_synchronously
      BlocProvider.of<AuthenticationCubit>(context)
          .changeEmailVerificationStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Email Verification')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<AuthenticationCubit, AuthenticationState>(
            listener: (BuildContext context, AuthenticationState state) {
          if (state is RegisterSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const DashboardPage(),
              ),
            );
          }
        }, builder: (context, state) {
          if (state is AuthenticationLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 106, 172, 191), // Change color
              ),
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "User email: ${user!.email}",
                style: GoogleFonts.karla(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              _isEmailVerified
                  ? Center(
                      child: Text(
                        "Your Email is Verified",
                        style: GoogleFonts.karla(
                          color: Colors.green,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _isVerificationEmailSent
                              ? null
                              : _sendVerificationEmail,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 32),
                          ),
                          child: _isCheckingVerification
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : Text(
                                  _isVerificationEmailSent
                                      ? 'Verifying...'
                                      : 'Verify',
                                  style: GoogleFonts.karla(
                                    color: const Color.fromARGB(
                                        255, 106, 172, 191),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 10),
                        _isVerificationEmailSent && !_didnotReceived
                            ? const Text(
                                "Didn't receive email? Wait 30 seconds to resend.",
                                style: TextStyle(color: Colors.white),
                              )
                            : Container(),
                      ],
                    ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 106, 172, 191),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 32),
                  ),
                  onPressed: () {
                    // Navigate to another page or perform any action for verify later
                  },
                  child: Text(
                    'Verify Later',
                    style: GoogleFonts.karla(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          );
        }),
      ),
    );
  }
}
