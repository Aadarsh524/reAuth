import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:reauth/bloc/cubit/auth_cubit.dart';
import 'package:reauth/bloc/states/auth_state.dart';
import 'package:reauth/components/custom_snackbar.dart';
import 'package:reauth/pages/dashboard/dashboard_page.dart';

class AddPinPage extends StatefulWidget {
  const AddPinPage({Key? key}) : super(key: key);

  @override
  State<AddPinPage> createState() => _AddPinPageState();
}

class _AddPinPageState extends State<AddPinPage> {
  TextEditingController pinController = TextEditingController();
  TextEditingController pin2Controller = TextEditingController();
  CustomSnackbar customSnackbar = CustomSnackbar('');

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    return Scaffold(
      backgroundColor: Colors.black, // Change background color
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Set Pin", // Update title
                style: GoogleFonts.karla(
                  color: Colors.white,
                  fontSize: 28, // Increase font size
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              _buildEmailRow(), // New widget for email row
              const SizedBox(height: 40),
              _buildPinTextField(
                  "Enter Pin", pinController), // Updated hint text
              const SizedBox(height: 20),
              _buildPinTextField(
                  "Confirm Pin", pin2Controller), // Updated hint text
              const SizedBox(height: 20),
              _buildDescription(), // New widget for description
              const Spacer(),
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is PinSetSuccess) {
                    customSnackbar = CustomSnackbar(
                        "Pin Saved Successfully"); // Updated snackbar message
                    customSnackbar.showCustomSnackbar(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DashboardPage(),
                      ),
                    );
                  }
                  if (state is PinError) {
                    customSnackbar = CustomSnackbar(state.error);
                    customSnackbar.showCustomSnackbar(context);
                  }
                },
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white, // Change color to match theme
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        authCubit.setPin(
                            pinController.text, pin2Controller.text);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Change button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: Text(
                        'Save',
                        style: GoogleFonts.karla(
                          color: Colors.white,
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
        color: Colors.grey[800], // Update color
        border: const Border(
          bottom: BorderSide(
            color: Colors.blue, // Update color
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
              color: Colors.white,
              fontSize: 16,
              letterSpacing: .5,
              fontWeight: FontWeight.w400,
            ),
          ),
          Icon(
            Icons.arrow_drop_down_outlined,
            color: Colors.white,
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
        "Your pin will be used to secure your account and view saved passwords.",
        textAlign: TextAlign.center,
        style: GoogleFonts.karla(
          color: Colors.grey[400], // Update color
          fontSize: 14,
          letterSpacing: .75,
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
        backgroundColor: Colors.transparent,
        length: 6,
        textStyle: GoogleFonts.karla(
          color: Colors.white,
          fontSize: 16,
          letterSpacing: .75,
          fontWeight: FontWeight.w600,
        ),
        obscureText: true,
        blinkWhenObscuring: true,
        animationType: AnimationType.fade,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.underline,
          fieldHeight: 40,
          fieldWidth: 35,
          activeFillColor: Colors.transparent,
          activeColor: Colors.grey[400], // Update color
          inactiveColor: Colors.grey[400], // Update color
          selectedColor: Colors.grey[400], // Update color
          inactiveFillColor: Colors.transparent,
          selectedFillColor: Colors.transparent,
        ),
        cursorColor: Colors.white,
        animationDuration: const Duration(milliseconds: 300),
        enableActiveFill: true,
        controller: controller,
        keyboardType: TextInputType.number,
        onChanged: (value) {},
      ),
    );
  }
}
