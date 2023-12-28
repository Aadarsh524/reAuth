import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:reauth/bloc/cubit/auth_cubit.dart';
import 'package:reauth/bloc/states/auth_state.dart';
import 'package:reauth/components/custom_snackbar.dart';
import 'package:reauth/pages/dashboard/dashboard_page.dart';

class AddPinPage extends StatefulWidget {
  const AddPinPage({super.key});

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Enter Pin",
                style: GoogleFonts.karla(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontSize: 22,
                    letterSpacing: .75,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(
                      255, 53, 64, 79), // Set your desired background color
                  border: Border(
                    bottom: BorderSide(
                      color: Color.fromARGB(255, 106, 172, 191),
                      width: 2, // Adjust the width of the bottom border
                    ),
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "aadarshghimire524@gmail.com",
                      style: GoogleFonts.karla(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontSize: 16,
                        letterSpacing: .5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_drop_down_outlined,
                      color: Color.fromARGB(255, 255, 255, 255),
                      size: 20,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Text(
                "Enter Account Pin",
                style: GoogleFonts.karla(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontSize: 14,
                    letterSpacing: .75,
                    fontWeight: FontWeight.w600),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 30,
                ),
                child: PinCodeTextField(
                  appContext: context,
                  backgroundColor: Colors.transparent,
                  length: 6,
                  textStyle: GoogleFonts.karla(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                      letterSpacing: .75,
                      fontWeight: FontWeight.w600),
                  obscureText: true,
                  blinkWhenObscuring: true,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.underline,
                    fieldHeight: 40,
                    fieldWidth: 35,
                    activeFillColor: Colors.transparent,
                    activeColor: const Color.fromARGB(255, 125, 125, 125),
                    inactiveColor: const Color.fromARGB(255, 125, 125, 125),
                    selectedColor: const Color.fromARGB(255, 125, 125, 125),
                    inactiveFillColor: Colors.transparent,
                    selectedFillColor: Colors.transparent,
                  ),
                  cursorColor: Colors.white,
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  controller: pinController,
                  keyboardType: TextInputType.number,
                  onCompleted: (v) {
                    debugPrint("Completed");
                  },
                  onChanged: (value) {},
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Text(
                "Re-enter Account Pin",
                style: GoogleFonts.karla(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontSize: 14,
                    letterSpacing: .75,
                    fontWeight: FontWeight.w600),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 30,
                ),
                child: PinCodeTextField(
                  appContext: context,
                  backgroundColor: Colors.transparent,
                  length: 6,
                  textStyle: GoogleFonts.karla(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                      letterSpacing: .75,
                      fontWeight: FontWeight.w600),
                  obscureText: true,
                  blinkWhenObscuring: true,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.underline,
                    fieldHeight: 40,
                    fieldWidth: 35,
                    activeFillColor: Colors.transparent,
                    activeColor: const Color.fromARGB(255, 125, 125, 125),
                    inactiveColor: const Color.fromARGB(255, 125, 125, 125),
                    selectedColor: const Color.fromARGB(255, 125, 125, 125),
                    inactiveFillColor: Colors.transparent,
                    selectedFillColor: Colors.transparent,
                  ),
                  cursorColor: Colors.white,
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  controller: pin2Controller,
                  keyboardType: TextInputType.number,
                  onCompleted: (v) {
                    debugPrint("Completed");
                  },
                  onChanged: (value) {},
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  textAlign: TextAlign.center,
                  "This pin will be used to login your profile and view saved passwords",
                  style: GoogleFonts.karla(
                      color: const Color.fromARGB(255, 125, 125, 125),
                      fontSize: 14,
                      letterSpacing: .75,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is PinSetSuccess) {
            customSnackbar = CustomSnackbar("Pin Saved Success");
            customSnackbar.showCustomSnackbar(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DashboardPage()),
            );
          }
          if (state is PinError) {
            customSnackbar = CustomSnackbar(state.error);
            customSnackbar.showCustomSnackbar(context);
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 106, 172, 191)));
          }
          return TextButton(
            onPressed: () async {
              authCubit.setPin(pinController.text, pin2Controller.text);
            },
            style: TextButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 111, 163, 219),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(30), // Adjust the radius here
              ),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
            ),
            child: Text(
              'Save',
              style: GoogleFonts.karla(
                color: const Color.fromARGB(249, 255, 255, 255),
                fontSize: 16,
                letterSpacing: .5,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
