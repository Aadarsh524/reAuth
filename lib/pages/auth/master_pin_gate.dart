import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:reauth/components/AuthCategory/bloc/cubit/profile_cubit.dart';
import 'package:reauth/components/AuthCategory/bloc/states/profile_state.dart';
import 'package:reauth/components/custom_snackbar.dart';
import 'package:reauth/components/custom_textfield.dart';
import 'package:reauth/pages/dashboard/dashboard_page.dart';
import 'package:reauth/services/biometric_services.dart';
import 'package:reauth/services/encryption_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MasterPinGate extends StatefulWidget {
  const MasterPinGate({Key? key}) : super(key: key);

  @override
  State<MasterPinGate> createState() => _MasterPinGateState();
}

class _MasterPinGateState extends State<MasterPinGate> {
  final TextEditingController pinController = TextEditingController();
  bool isSubmitting = false;

  void verifyPin(BuildContext context) async {
    setState(() => isSubmitting = true);
    await context.read<ProfileCubit>().fetchProfile();

    final profileState = context.read<ProfileCubit>().state;
    if (profileState is ProfileLoaded) {
      final decryptedPin =
          await EncryptionService.decryptData(profileState.profile.masterPin);
      if (pinController.text.trim() == decryptedPin && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardPage()),
        );
      } else {
        CustomSnackbar.show(context,
            message: 'Incorrect PIN. Please try again.', isError: true);
      }
    } else {
      CustomSnackbar.show(context,
          message: 'Profile load failed', isError: true);
    }

    setState(() => isSubmitting = false);
  }

  Future<void> handleBiometricUnlock() async {
    final authenticated = await BiometricService().authenticate();

    if (!authenticated || !mounted) {
      CustomSnackbar.show(context,
          message: 'Biometric authentication failed', isError: true);
      return;
    }

    final profileState = context.read<ProfileCubit>().state;
    if (profileState is ProfileLoaded) {
      final masterPin =
          await EncryptionService.decryptData(profileState.profile.masterPin);

      if (masterPin.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardPage()),
        );
      } else {
        CustomSnackbar.show(context,
            message: "Master PIN not found!", isError: true);
      }
    } else {
      CustomSnackbar.show(context,
          message: "Profile not loaded", isError: true);
    }
  }

  Future<void> updateBiometricStatus(bool status) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('profiles')
        .doc(user.uid)
        .update({
      'isBiometricSet': status,
    });
  }

  Future<bool> validatePassword(String password) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      AuthCredential credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Master PIN Verification",
          style: GoogleFonts.karla(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) async {
            if (state is ProfileLoaded) {
              final decryptedPin =
                  await EncryptionService.decryptData(state.profile.masterPin);
              if (pinController.text.trim() == decryptedPin && mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const DashboardPage()),
                );
              } else if (mounted) {
                CustomSnackbar.show(
                  context,
                  message: 'Incorrect PIN. Please try again.',
                  isError: true,
                );
              }
              setState(() => isSubmitting = false);
            } else if (state is ProfileLoadingError && mounted) {
              CustomSnackbar.show(context,
                  message: 'Profile load failed', isError: true);
              setState(() => isSubmitting = false);
            }
          },
          builder: (context, state) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Enter your 4-digit Master PIN to continue",
                style: GoogleFonts.karla(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              _buildPinInput(),
              const SizedBox(height: 32),
              _buildSubmitButton(),
              const SizedBox(height: 24),
              if (state is ProfileLoaded) _buildBiometricSection(state),
            ],
          ),
        ),
      ),
    );
  }

  void _promptSetBiometric(BuildContext context) {
    final passwordController = TextEditingController();
    final masterPinController = TextEditingController();
    String? errorText;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54, // Dark overlay color
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                backgroundColor: const Color.fromARGB(255, 72, 80, 93),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Text(
                  "Enable Biometric Authentication",
                  style: GoogleFonts.karla(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (errorText != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          errorText!,
                          style: GoogleFonts.karla(
                              color: Colors.red, fontSize: 14),
                        ),
                      ),
                    CustomTextField(
                      isRequired: true,
                      keyboardType: TextInputType.text,
                      controller: passwordController,
                      hintText: 'Enter Password',
                      labelText: 'Password',
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: PinCodeTextField(
                        appContext: context,
                        length: 4,
                        controller: masterPinController,
                        obscureText: true,
                        keyboardType: TextInputType.number,
                        animationType: AnimationType.fade,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.circle,
                          fieldHeight: 40,
                          fieldWidth: 40,
                          activeColor: const Color(0xFF2A6FDB),
                          inactiveColor: Colors.grey[300]!,
                          selectedColor: const Color(0xFF2A6FDB),
                        ),
                        textStyle: GoogleFonts.karla(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                        onChanged: (value) {},
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed:
                        isSubmitting ? null : () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Colors.red),
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
                    onPressed: isSubmitting
                        ? null
                        : () async {
                            setState(() => errorText = null);

                            if (passwordController.text.trim().isEmpty ||
                                masterPinController.text.trim().length != 4) {
                              setState(() => errorText =
                                  "Please enter both fields correctly.");
                              return;
                            }

                            bool isValidPassword = await validatePassword(
                                passwordController.text.trim());
                            if (!isValidPassword) {
                              setState(() => errorText = "Incorrect password.");
                              return;
                            }

                            final profileState =
                                context.read<ProfileCubit>().state;
                            if (profileState is! ProfileLoaded) {
                              setState(() => errorText = "Profile not loaded.");
                              return;
                            }

                            final decryptedPin =
                                await EncryptionService.decryptData(
                                    profileState.profile.masterPin);
                            if (masterPinController.text.trim() !=
                                decryptedPin) {
                              setState(
                                  () => errorText = "Incorrect Master PIN.");
                              return;
                            }

                            final authenticated =
                                await BiometricService().authenticate();
                            if (!authenticated) {
                              setState(() => errorText =
                                  "Biometric authentication failed.");
                              return;
                            }

                            await updateBiometricStatus(true);
                            Navigator.pop(context);
                            CustomSnackbar.show(
                              context,
                              message: "Biometric access added",
                            );
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const DashboardPage()));
                          },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 111, 163, 219),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              backgroundColor: Colors.transparent,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            "Continue",
                            style: GoogleFonts.karla(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ],
              );
            },
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        if (animation.status == AnimationStatus.reverse) {
          return child;
        }
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack,
          ),
          child: child,
        );
      },
    );
  }

  Widget _buildPinInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: PinCodeTextField(
        appContext: context,
        length: 4,
        controller: pinController,
        obscureText: true,
        keyboardType: TextInputType.number,
        animationType: AnimationType.fade,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.circle,
          fieldHeight: 40,
          fieldWidth: 40,
          activeColor: const Color(0xFF2A6FDB),
          inactiveColor: Colors.grey[300]!,
          selectedColor: const Color(0xFF2A6FDB),
        ),
        textStyle: GoogleFonts.karla(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        onChanged: (value) {},
      ),
    );
  }

  Widget _buildSubmitButton() {
    return TextButton(
        onPressed: isSubmitting ? null : () => verifyPin(context),
        style: TextButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 111, 163, 219),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: isSubmitting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  backgroundColor: Colors.transparent,
                  color: Colors.white,
                ),
              )
            : Text(
                "Verify PIN",
                style: GoogleFonts.karla(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ));
  }

  Widget _buildBiometricSection(ProfileLoaded state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 16),
        Text(
          "or continue with",
          style: GoogleFonts.karla(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 16),
        IconButton(
          iconSize: 40,
          icon: const Icon(Icons.fingerprint),
          color: const Color(0xFF2A6FDB),
          onPressed:
              state.profile.isBiometricSet ? handleBiometricUnlock : null,
        ),
        if (!state.profile.isBiometricSet) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => _promptSetBiometric(context),
                child: Text(
                  "Enable Biometric Authentication",
                  style: GoogleFonts.karla(
                    fontSize: 16,
                    color: const Color(0xFF2A6FDB),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
