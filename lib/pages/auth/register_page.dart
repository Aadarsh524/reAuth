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

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  // Constants for colors and styles
  static const Color textColor = Color.fromARGB(255, 255, 255, 255);
  static const Color primaryColor = Color.fromARGB(255, 106, 172, 191);
  static const Color secondaryTextColor = Color.fromARGB(255, 125, 125, 125);

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthenticationCubit>(context);

    return Scaffold(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor, // Change background color
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
                      color: secondaryTextColor,
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
                          color: textColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 30),
                      CustomTextField(
                        isRequired: true,
                        keyboardType: TextInputType.text,
                        controller: fullNameController,
                        hintText: 'Enter your full name',
                        labelText: 'Full Name',
                      ),
                      CustomTextField(
                        isRequired: true,
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        hintText: 'Enter your email',
                        labelText: 'Email',
                      ),
                      CustomTextField(
                        isRequired: true,
                        isFormTypePassword: true,
                        keyboardType: TextInputType.visiblePassword,
                        controller: passwordController,
                        hintText: 'Enter your password',
                        labelText: 'Password',
                        obscureText: !isPasswordVisible,
                        passwordVisibility: (e) {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                      CustomTextField(
                        isRequired: true,
                        isFormTypePassword: true,
                        keyboardType: TextInputType.visiblePassword,
                        controller: confirmPasswordController,
                        hintText: 'Confirm your password',
                        labelText: 'Confirm Password',
                        obscureText: !isConfirmPasswordVisible,
                        passwordVisibility: (e) {
                          setState(() {
                            isConfirmPasswordVisible =
                                !isConfirmPasswordVisible;
                          });
                        },
                      ),
                      const SizedBox(height: 40),
                      BlocConsumer<AuthenticationCubit, AuthenticationState>(
                        listener: (context, state) {
                          if (state is RegistrationSuccess) {
                            CustomSnackbar.show(
                              context,
                              message: "Registration Success",
                            );

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          } else if (state is AuthError) {
                            String errorMessage = state.message;

                            // Handle specific error types
                            if (state.errorType == AuthErrorType.login) {
                              CustomSnackbar.show(
                                context,
                                message: errorMessage,
                                isError: true,
                              );
                            }
                          } else if (state is ValidationError) {
                            CustomSnackbar.show(
                              context,
                              message: state.error,
                              isError: true,
                            );
                            // }
                          }
                        },
                        builder: (context, state) {
                          if (state is LoginInProgress ||
                              state is AuthenticationLoading) {
                            return SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed:
                                    null, // Disable button during loading
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          }

                          return SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                authCubit.register(
                                  fullName: fullNameController.text.trim(),
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                  confirmPassword:
                                      confirmPasswordController.text.trim(),
                                );
                              },
                              child: Text(
                                'Register',
                                style: GoogleFonts.karla(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
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
                          color: secondaryTextColor,
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
                            color: textColor,
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
