import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:reauth/bloc/cubit/authentication_cubit.dart';
import 'package:reauth/bloc/states/auth_state.dart';
import 'package:reauth/components/custom_snackbar.dart';
import 'package:reauth/pages/dashboard/dashboard_page.dart';

class AddPinPage extends StatefulWidget {
  const AddPinPage({Key? key}) : super(key: key);

  @override
  State<AddPinPage> createState() => _AddPinPageState();
}

class _AddPinPageState extends State<AddPinPage> {
  final TextEditingController pinController = TextEditingController();
  final TextEditingController confirmPinController = TextEditingController();

  // Constants for colors and styles
  static const Color scaffoldBackgroundColor = Colors.black;
  static const Color textColor = Colors.white;
  static const Color primaryColor = Colors.blue;
  static const Color secondaryTextColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Set PIN",
                style: GoogleFonts.karla(
                  color: textColor,
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              _buildEmailRow(),
              const SizedBox(height: 40),
              _buildPinTextField("Enter PIN", pinController),
              const SizedBox(height: 20),
              _buildPinTextField("Confirm PIN", confirmPinController),
              const SizedBox(height: 20),
              _buildDescription(),
              const Spacer(),
              BlocConsumer<AuthenticationCubit, AuthenticationState>(
                listener: (context, state) {
                  if (state is PinUpdateSuccess) {
                    CustomSnackbar.show(
                      context,
                      message: "PIN saved successfuly",
                    );

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DashboardPage(),
                      ),
                    );
                  } else if (state is AuthenticationError) {
                    CustomSnackbar.show(context,
                        message: state.error, isError: true);
                  }
                },
                builder: (context, state) {
                  if (state is AuthenticationLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        // authCubit.setPin(
                        //   pinController.text,
                        //   confirmPinController.text,
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: Text(
                        'Save',
                        style: GoogleFonts.karla(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
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

  Widget _buildEmailRow() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[800],
        border: const Border(
          bottom: BorderSide(
            color: primaryColor,
            width: 2,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "aadarshghimire524@gmail.com",
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          Icon(
            Icons.arrow_drop_down_outlined,
            color: textColor,
            size: 20,
          ),
        ],
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

  Widget _buildPinTextField(String hintText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: PinCodeTextField(
        appContext: context,
        length: 6,
        obscureText: true,
        blinkWhenObscuring: true,
        animationType: AnimationType.fade,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.underline,
          fieldHeight: 40,
          fieldWidth: 35,
          activeColor: primaryColor,
          inactiveColor: secondaryTextColor,
          selectedColor: primaryColor,
        ),
        cursorColor: textColor,
        animationDuration: const Duration(milliseconds: 300),
        controller: controller,
        keyboardType: TextInputType.number,
        onChanged: (value) {},
      ),
    );
  }
}
