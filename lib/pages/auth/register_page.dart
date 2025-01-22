import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reauth/bloc/cubit/authentication_cubit.dart';
import 'package:reauth/bloc/states/auth_state.dart';
import 'package:reauth/components/custom_snackbar.dart';
import 'package:reauth/components/custom_textfield.dart';
import 'package:reauth/pages/auth/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isPasswordVisible = false; // Initially set to false
  bool isConfirmPasswordVisible = false; // Initially set to false
  CustomSnackbar customSnackbar = CustomSnackbar('');

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthenticationCubit>(context);
    return Scaffold(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor, // Set background color
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    "ReAuth",
                    style: GoogleFonts.karla(
                      color: const Color.fromARGB(
                          255, 125, 125, 125), // Set text color
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Create an Account",
                        style: GoogleFonts.karla(
                          color: const Color.fromARGB(
                              255, 255, 255, 255), // Set text color
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 30),
                      CustomTextField(
                        keyboardType: TextInputType.text,
                        controller: fullNameController,
                        hintText: 'Enter your full name',
                        labelText: 'Full Name',
                      ),
                      CustomTextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        hintText: 'Enter your email',
                        labelText: 'Email',
                      ),
                      CustomTextField(
                        isFormTypePassword: true,
                        keyboardType: TextInputType.visiblePassword,
                        controller: passwordController,
                        hintText: 'Enter your password',
                        labelText: 'Password',
                        obscureText: !isPasswordVisible, // Inverted value
                        passwordVisibility: (e) {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                      CustomTextField(
                        isFormTypePassword: true,
                        keyboardType: TextInputType.visiblePassword,
                        controller: confirmPasswordController,
                        hintText: 'Confirm your password',
                        labelText: 'Confirm Password',
                        obscureText:
                            !isConfirmPasswordVisible, // Inverted value
                        passwordVisibility: (e) {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                      const SizedBox(height: 40),
                      BlocConsumer<AuthenticationCubit, AuthenticationState>(
                        listener: (context, state) {
                          if (state is RegisterSuccess) {
                            customSnackbar =
                                CustomSnackbar("Registration Success");
                            customSnackbar.showCustomSnackbar(context);

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          }
                          if (state is RegisterSubmissionFailure) {
                            customSnackbar = CustomSnackbar(state.error);
                            customSnackbar.showCustomSnackbar(context);
                          }
                          if (state is RegisterFailure) {
                            customSnackbar = CustomSnackbar(state.error);
                            customSnackbar.showCustomSnackbar(context);
                          }
                        },
                        builder: (context, state) {
                          if (state is AuthenticationLoading) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Color.fromARGB(
                                    255, 106, 172, 191), // Set color
                              ),
                            );
                          }
                          return SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                    255, 106, 172, 191), // Set button color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                authCubit.initiateRegister(
                                  fullNameController.text,
                                  emailController.text,
                                  passwordController.text,
                                  confirmPasswordController.text,
                                );
                              },
                              child: const Text(
                                'Register',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: GoogleFonts.karla(
                          color: Colors.black, // Set text color
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        child: Text(
                          "Login",
                          style: GoogleFonts.karla(
                            color: const Color.fromARGB(
                                255, 255, 255, 255), // Set text color
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
