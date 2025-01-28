import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reauth/bloc/cubit/authentication_cubit.dart';
import 'package:reauth/bloc/states/auth_state.dart';
import 'package:reauth/components/custom_snackbar.dart';
import 'package:reauth/components/custom_textfield.dart';
import 'package:reauth/pages/auth/register_page.dart';
import 'package:reauth/pages/dashboard/dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;

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
                const SizedBox(height: 50),
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
                  child: Text(
                    "Welcome Back",
                    style: GoogleFonts.karla(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
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
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        BlocProvider.of<AuthenticationCubit>(context)
                            .resetPassword(emailController.text);
                      },
                      child: Text(
                        "Forgot Password?",
                        style: GoogleFonts.karla(
                          color: primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                BlocConsumer<AuthenticationCubit, AuthenticationState>(
                  listener: (context, state) {
                    // When login is successful, show success snackbar and navigate
                    if (state is LoginSuccess) {
                      CustomSnackbar.show(
                        context,
                        message: "Login Success",
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DashboardPage(),
                        ),
                      );
                    }

                    // Handle login error state
                    else if (state is AuthError) {
                      String errorMessage = state.message;

                      // Handle specific error types for login
                      if (state.errorType == AuthErrorType.login) {
                        CustomSnackbar.show(
                          context,
                          message: errorMessage,
                          isError: true,
                        );
                      }
                    }

                    // Handle validation error state for registration
                    else if (state is ValidationError) {
                      CustomSnackbar.show(
                        context,
                        message: state.error,
                        isError: true,
                      );
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
                          onPressed: null, // Disable button during loading
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    }

                    // Normal login button when no loading is happening
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
                          authCubit.login(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                          );
                        },
                        child: Text(
                          'Login',
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
                const SizedBox(height: 20),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Create Account?",
                        style: GoogleFonts.karla(
                          color: secondaryTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const RegisterPage(),
                            ),
                          );
                        },
                        child: Text(
                          "Register",
                          style: GoogleFonts.karla(
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
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
