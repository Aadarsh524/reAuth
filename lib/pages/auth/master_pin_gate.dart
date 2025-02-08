import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:reauth/bloc/cubit/profile_cubit.dart';
import 'package:reauth/bloc/states/profile_state.dart';
import 'package:reauth/components/custom_snackbar.dart';
import 'package:reauth/pages/dashboard/dashboard_page.dart';
import 'package:reauth/services/biometric_services.dart';
import 'package:reauth/services/encryption_service.dart';

class MasterPinGate extends StatefulWidget {
  const MasterPinGate({Key? key}) : super(key: key);

  @override
  State<MasterPinGate> createState() => _MasterPinGateState();
}

class _MasterPinGateState extends State<MasterPinGate> {
  final TextEditingController pinController = TextEditingController();
  bool isSubmitting = false;

  void _verifyPin(BuildContext context) async {
    setState(() => isSubmitting = true);
    context.read<ProfileCubit>().fetchProfile();
  }

  Future<void> _handleBiometricUnlock() async {
    final authenticated = await BiometricService().authenticate();
    if (authenticated && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardPage()),
      );
    } else if (mounted) {
      CustomSnackbar.show(
        context,
        message: 'Biometric authentication failed',
        isError: true,
      );
    }
  }

  void _promptSetBiometric(BuildContext context) {
    final passwordController = TextEditingController();
    final masterPinController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color(0xFF2A6FDB),
            secondary: const Color(0xFF2A6FDB),
          ),
        ),
        child: AlertDialog(
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
              Text(
                "Verify your identity to enable biometric login",
                style: GoogleFonts.karla(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: GoogleFonts.karla(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              PinCodeTextField(
                appContext: context,
                length: 4,
                controller: masterPinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.underline,
                  fieldHeight: 40,
                  fieldWidth: 35,
                  activeColor: const Color(0xFF2A6FDB),
                  inactiveColor: Colors.grey[400]!,
                  selectedColor: const Color(0xFF2A6FDB),
                ),
                textStyle: GoogleFonts.karla(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                onChanged: (value) {},
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: GoogleFonts.karla(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2A6FDB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async => _validateBiometricCredentials(
                passwordController.text.trim(),
                masterPinController.text.trim(),
              ),
              child: Text(
                "Continue",
                style: GoogleFonts.karla(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _validateBiometricCredentials(
    String password,
    String masterPin,
  ) async {
    if (password.isEmpty || masterPin.length != 4) {
      CustomSnackbar.show(context,
          message: "Please fill all fields", isError: true);
      return;
    }

    // Replace with actual password validation from secure storage
    if (password != "securePassword123") {
      CustomSnackbar.show(context,
          message: "Incorrect password", isError: true);
      return;
    }

    final profileState = context.read<ProfileCubit>().state;
    if (profileState is! ProfileLoaded) {
      CustomSnackbar.show(context,
          message: "Profile not loaded", isError: true);
      return;
    }

    final decryptedPin =
        await EncryptionService.decryptData(profileState.profile.masterPin);
    if (masterPin != decryptedPin) {
      CustomSnackbar.show(context,
          message: "Incorrect master PIN", isError: true);
      return;
    }

    final authenticated = await BiometricService().authenticate();
    if (authenticated && mounted) {
      // TODO: Update profile biometric setting in backend
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardPage()),
      );
    }
  }

  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isSubmitting ? null : () => _verifyPin(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2A6FDB),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isSubmitting
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                "Verify PIN",
                style: GoogleFonts.karla(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
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
              state.profile.isBiometricSet ? _handleBiometricUnlock : null,
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
