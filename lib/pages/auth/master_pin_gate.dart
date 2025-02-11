import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../bloc/cubit/authentication_cubit.dart';
import '../../bloc/cubit/profile_cubit.dart';
import '../../bloc/states/authentication_state.dart';
import '../../bloc/states/profile_state.dart';
import '../../components/custom_snackbar.dart';
import '../../components/custom_textfield.dart';
import 'login_page.dart';
import '../dashboard/dashboard_page.dart';
import '../../services/biometric_services.dart';
import '../../services/encryption_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MasterPinGate extends StatefulWidget {
  const MasterPinGate({Key? key}) : super(key: key);

  @override
  State<MasterPinGate> createState() => _MasterPinGateState();
}

class _MasterPinGateState extends State<MasterPinGate> {
  final TextEditingController _pinController = TextEditingController();
  bool _isSubmitting = false;

  /// Triggers profile load and lets the bloc listener handle verification.
  void _submitPin() {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);
    // This will trigger the ProfileCubit to load the profile.
    context.read<ProfileCubit>().fetchProfile();
  }

  /// Handles biometric unlock. In this case, we simply verify biometric and
  /// navigate if the profile is loaded.
  Future<void> _handleBiometricUnlock() async {
    final authenticated = await BiometricService().authenticate();
    if (!authenticated) {
      CustomSnackbar.show(
        context,
        message: 'Biometric authentication failed',
        isError: true,
      );
      return;
    }

    final profileState = context.read<ProfileCubit>().state;
    if (profileState is ProfileLoaded) {
      final masterPin = await EncryptionService.decryptData(
        profileState.profile.masterPin,
      );
      if (masterPin.isNotEmpty) {
        _navigateToDashboard();
      } else {
        CustomSnackbar.show(
          context,
          message: "Master PIN not found!",
          isError: true,
        );
      }
    } else {
      CustomSnackbar.show(
        context,
        message: "Profile not loaded",
        isError: true,
      );
    }
  }

  Future<void> _updateBiometricStatus(bool status) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await FirebaseFirestore.instance
        .collection('profiles')
        .doc(user.uid)
        .update({
      'isBiometricSet': status,
    });
  }

  Future<bool> _validatePassword(String password) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email == null) return false;
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);
      return true;
    } catch (_) {
      return false;
    }
  }

  void _navigateToDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DashboardPage()),
    );
  }

  /// Opens a dialog to prompt the user for biometric activation.
  void _promptSetBiometric() {
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController masterPinController = TextEditingController();
    String? errorText;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                backgroundColor: const Color.fromARGB(255, 72, 80, 93),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Text(
                  "Enable Biometric Authentication",
                  style: GoogleFonts.karla(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
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
                        onChanged: (_) {},
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
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
                    onPressed: () async {
                      setDialogState(() => errorText = null);

                      if (passwordController.text.trim().isEmpty ||
                          masterPinController.text.trim().length != 4) {
                        setDialogState(() =>
                            errorText = "Please enter both fields correctly.");
                        return;
                      }

                      final isValidPassword = await _validatePassword(
                          passwordController.text.trim());
                      if (!isValidPassword) {
                        setDialogState(() => errorText = "Incorrect password.");
                        return;
                      }

                      final profileState = context.read<ProfileCubit>().state;
                      if (profileState is! ProfileLoaded) {
                        setDialogState(() => errorText = "Profile not loaded.");
                        return;
                      }

                      final decryptedPin = await EncryptionService.decryptData(
                          profileState.profile.masterPin);
                      if (masterPinController.text.trim() != decryptedPin) {
                        setDialogState(
                            () => errorText = "Incorrect Master PIN.");
                        return;
                      }

                      final authenticated =
                          await BiometricService().authenticate();
                      if (!authenticated) {
                        setDialogState(() =>
                            errorText = "Biometric authentication failed.");
                        return;
                      }

                      await _updateBiometricStatus(true);
                      Navigator.pop(context);
                      CustomSnackbar.show(
                        context,
                        message: "Biometric access added",
                      );
                      _navigateToDashboard();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 111, 163, 219),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
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
      body: BlocListener<AuthenticationCubit, AuthenticationState>(
        listener: (context, state) {
          if (state is LogoutSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (route) => false,
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: BlocConsumer<ProfileCubit, ProfileState>(
            listener: (context, state) async {
              if (state is ProfileLoaded) {
                final decryptedPin = await EncryptionService.decryptData(
                  state.profile.masterPin,
                );
                if (_pinController.text.trim() == decryptedPin) {
                  _navigateToDashboard();
                } else {
                  CustomSnackbar.show(
                    context,
                    message: 'Incorrect PIN. Please try again.',
                    isError: true,
                  );
                }
                setState(() => _isSubmitting = false);
              } else if (state is ProfileLoadingError) {
                CustomSnackbar.show(
                  context,
                  message: 'Profile load failed',
                  isError: true,
                );
                setState(() => _isSubmitting = false);
              }
            },
            builder: (context, state) {
              // Optionally, use state is ProfileLoading to show a loader.
              return Column(
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        // Clear stored PIN and trigger logout/reset flow.
                        context.read<ProfileCubit>().clearMasterPin();
                        context.read<AuthenticationCubit>().logout();
                        CustomSnackbar.show(
                          context,
                          message: 'Please login to reset.',
                          isError: true,
                        );
                      },
                      child: Text(
                        "Forgot Pin?",
                        style: GoogleFonts.karla(
                          color: const Color.fromARGB(255, 106, 172, 191),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (state is ProfileLoaded) _buildBiometricSection(state),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPinInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: PinCodeTextField(
        appContext: context,
        length: 4,
        controller: _pinController,
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
        onChanged: (_) {},
      ),
    );
  }

  Widget _buildSubmitButton() {
    return TextButton(
      onPressed: _isSubmitting
          ? null
          : () {
              if (_pinController.text.isEmpty) {
                CustomSnackbar.show(
                  context,
                  message: 'Please enter the pin.',
                  isError: true,
                );
              } else {
                _submitPin();
              }
            },
      style: TextButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 111, 163, 219),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: _isSubmitting
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
            ),
    );
  }

  Widget _buildBiometricSection(ProfileLoaded state) {
    return Column(
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
              state.profile.isBiometricSet ? _handleBiometricUnlock : null,
        ),
        if (!state.profile.isBiometricSet)
          TextButton(
            onPressed: _promptSetBiometric,
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
    );
  }
}
