import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../bloc/cubit/authentication_cubit.dart';
import '../../bloc/states/authentication_state.dart';
import '../../components/custom_snackbar.dart';
import '../dashboard/dashboard_page.dart';

class AddPinPage extends StatefulWidget {
  const AddPinPage({Key? key}) : super(key: key);

  @override
  State<AddPinPage> createState() => _AddPinPageState();
}

class _AddPinPageState extends State<AddPinPage> {
  final TextEditingController pinController = TextEditingController();
  final TextEditingController confirmPinController = TextEditingController();

  static const Color scaffoldBackgroundColor = Color.fromARGB(255, 43, 51, 63);
  static const Color textColor = Colors.white;
  static const Color primaryColor = Color.fromARGB(255, 111, 163, 219);
  static const Color secondaryTextColor = Colors.grey;

  @override
  void dispose() {
    pinController.dispose();
    confirmPinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 53, 64, 79),
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Set Master Pin",
          style: GoogleFonts.karla(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              _buildPinTextField("Add Master PIN", pinController),
              const SizedBox(height: 20),
              _buildPinTextField(
                  "Add Confirm Master PIN", confirmPinController),
              const SizedBox(height: 20),
              _buildDescription(),
              const Spacer(),
              BlocConsumer<AuthenticationCubit, AuthenticationState>(
                listener: (context, state) {
                  if (state is SettingPinInSuccess) {
                    CustomSnackbar.show(
                      context,
                      message: "PIN saved successfully",
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DashboardPage(),
                      ),
                    );
                  } else if (state is AuthenticationError ||
                      state is ValidationError) {
                    CustomSnackbar.show(context,
                        message: state is AuthenticationError
                            ? state.error
                            : (state as ValidationError).error,
                        isError: true);
                  }
                },
                builder: (context, state) {
                  final isSubmitting = state is SettingPinInProgress;
                  return TextButton(
                    onPressed: isSubmitting
                        ? null
                        : () {
                            BlocProvider.of<AuthenticationCubit>(context)
                                .setMasterPin(
                              pin: pinController.text.trim(),
                              confirmPin: confirmPinController.text.trim(),
                            );
                          },
                    style: TextButton.styleFrom(
                      backgroundColor: primaryColor,
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
                            "Save",
                            style: GoogleFonts.karla(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        "Your PIN will be used to secure your account and view saved passwords.",
        textAlign: TextAlign.center,
        style: GoogleFonts.karla(
          color: secondaryTextColor,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Wraps a PinCodeTextField with a label above it.
  Widget _buildPinTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.karla(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          PinCodeTextField(
            appContext: context,
            length: 4, // 4 digits PIN
            obscureText: true,
            blinkWhenObscuring: true,
            animationType: AnimationType.fade,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              fieldHeight: 40, // Reduced from 50 to 40
              fieldWidth: 35, // Reduced from 45 to 35
              borderRadius: BorderRadius.circular(8),
              activeColor: primaryColor,
              inactiveColor: secondaryTextColor,
              selectedColor: primaryColor,
              activeFillColor: scaffoldBackgroundColor,
            ),
            cursorColor: textColor,
            animationDuration: const Duration(milliseconds: 300),
            controller: controller,
            keyboardType: TextInputType.number,
            onChanged: (value) {},
          ),
        ],
      ),
    );
  }
}
