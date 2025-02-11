import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../bloc/cubit/authentication_cubit.dart';
import '../../bloc/states/authentication_state.dart';
import '../../components/custom_snackbar.dart';
import '../../components/custom_textfield.dart';
import 'register_page.dart';
import '../dashboard/dashboard_page.dart';

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
  void dispose() {
    super.dispose();
    emailController;
    passwordController;
    isPasswordVisible;
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthenticationCubit>(context);

    return Scaffold(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor, // Change background color
      body: SafeArea(
        child: BlocListener<AuthenticationCubit, AuthenticationState>(
          listenWhen: (previous, current) =>
              current is Authenticated ||
              current is AuthenticationError ||
              current is ValidationError ||
              current is PasswordResetSent,
          listener: (context, state) {
            if (state is Authenticated) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const DashboardPage()),
                (route) => false,
              );
              CustomSnackbar.show(context, message: "Login Success");
            }
            if (state is PasswordResetSent) {
              CustomSnackbar.show(context,
                  message: "Password reset link is send to you email.");
            } else if (state is AuthenticationError) {
              CustomSnackbar.show(context, message: state.error, isError: true);
            } else if (state is ValidationError) {
              CustomSnackbar.show(context, message: state.error, isError: true);
            } else if (state is PasswordResetSent) {
              CustomSnackbar.show(context,
                  message: "Password reset email sent");
            }
          },
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
                              .resetPassword(email: emailController.text);
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
                  BlocBuilder<AuthenticationCubit, AuthenticationState>(
                    builder: (context, state) {
                      bool isLoading = state is AuthenticationLoading;

                      return SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 106, 172, 191),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: isLoading
                              ? () {} // Keep button enabled but do nothing
                              : () {
                                  authCubit.login(
                                    emailController.text.trim(),
                                    passwordController.text.trim(),
                                  );
                                },
                          child: isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
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
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const RegisterPage()),
                              (route) => false,
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
      ),
    );
  }
}
