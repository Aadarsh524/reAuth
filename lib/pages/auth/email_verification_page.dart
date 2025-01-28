import 'dart:async';
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
  bool _canResendEmail = true;
  int _remainingTime = 0;
  late Timer _timer;

  // Constants
  static const _resendCooldown = 30;
  static const _primaryColor = Color.fromARGB(255, 106, 172, 191);
  static const _textColor = Colors.white;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startPeriodicVerificationCheck() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      await _checkEmailVerified();
      if (_isEmailVerified) {
        timer.cancel();
      }
    });
  }

  Future<void> _checkEmailVerified() async {
    final authCubit = context.read<AuthenticationCubit>();
    await authCubit
        .checkEmailVerification(user!); // Dispatch verification check
  }

  Future<void> _sendVerificationEmail() async {
    try {
      setState(() {
        _canResendEmail = false;
        _remainingTime = _resendCooldown;
      });
      final authCubit = context.read<AuthenticationCubit>();
      await authCubit.verifyEmail(); // Dispatch verification check
      _startPeriodicVerificationCheck();
      // Start countdown timer
      Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingTime > 0) {
          setState(() => _remainingTime--);
        } else {
          timer.cancel();
          setState(() => _canResendEmail = true);
        }
      });
    } catch (e) {
      if (mounted) {
        CustomSnackbar.show(
          context,
          message: "Error Occurred",
          isError: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Email Verification",
            style: GoogleFonts.karla(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.75,
            ),
          )),
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor, // Change background color
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<AuthenticationCubit, AuthenticationState>(
          listener: (context, state) {
            if (state is AuthError &&
                state.errorType == AuthErrorType.emailVerification) {
              CustomSnackbar.show(
                context,
                message: state.message,
                isError: true,
              );
            }
            if (state is EmailVerificationSent) {
              CustomSnackbar.show(
                context,
                message: "Verification Email Sent",
              );
            }

            if (state is EmailVerificationSuccess) {
              setState(() {
                _isEmailVerified = true;
              });
              CustomSnackbar.show(
                context,
                message: "Your email is verified.",
              );
            }
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserEmail(),
                const SizedBox(height: 20),
                _isEmailVerified ? _verifiedUI() : _verificationUI(state),
                const Spacer(),
                _buildVerifyLaterButton(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildUserEmail() {
    return Text(
      "User email: ${user?.email ?? 'N/A'}",
      style: GoogleFonts.karla(
        color: _textColor,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _verifiedUI() {
    return Center(
      child: Text(
        "Your Email is Verified",
        style: GoogleFonts.karla(
          color: Colors.green,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _verificationUI(AuthenticationState state) {
    return Center(
      child: ElevatedButton(
        onPressed: _canResendEmail ? _sendVerificationEmail : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        ),
        child: Text(
          _canResendEmail
              ? 'Send Verification Email'
              : 'Resend in $_remainingTime seconds',
          style: GoogleFonts.karla(
            color: _textColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildVerifyLaterButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DashboardPage()),
          );
        },
        child: Text(
          'Verify Later',
          style: GoogleFonts.karla(
            color: _primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
