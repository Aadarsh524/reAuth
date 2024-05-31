import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reauth/bloc/cubit/auth_cubit.dart';
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

  bool isPasswordVisible = true;
  bool isConfirmPasswordVisible = true;
  CustomSnackbar customSnackbar = CustomSnackbar('');

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  "ReAuth",
                  style: GoogleFonts.karla(
                    color: const Color.fromARGB(255, 125, 125, 125),
                    fontSize: 25,
                    letterSpacing: .75,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Hello there!",
                        style: GoogleFonts.karla(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontSize: 18,
                          letterSpacing: .75,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 30),
                      CustomTextField(
                        keyboardType: TextInputType.text,
                        controller: fullNameController,
                        hintText: 'enter full name',
                        labelText: 'Full Name',
                      ),
                      CustomTextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        hintText: 'enter email',
                        labelText: 'Email',
                      ),
                      CustomTextField(
                        isFormTypePassword: true,
                        keyboardType: TextInputType.visiblePassword,
                        controller: passwordController,
                        hintText: 'enter password',
                        labelText: 'Password',
                        obscureText: isPasswordVisible,
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
                        hintText: 'confirm password',
                        labelText: 'Confirm Password',
                        obscureText: isConfirmPasswordVisible,
                        passwordVisibility: (e) {
                          setState(() {
                            isConfirmPasswordVisible =
                                !isConfirmPasswordVisible;
                          });
                        },
                      ),
                      const SizedBox(height: 50),
                      BlocConsumer<AuthCubit, AuthState>(
                        listener: (context, state) {
                          if (state is RegisterSuccess) {
                            customSnackbar =
                                CustomSnackbar("Registeration Success");
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
                          if (state is AuthLoading) {
                            return const CircularProgressIndicator(
                              color: Color.fromARGB(255, 106, 172, 191),
                            );
                          }
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
                        "Have Account?",
                        style: GoogleFonts.karla(
                          color: const Color.fromARGB(255, 125, 125, 125),
                          fontSize: 14,
                          letterSpacing: .5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 5),
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
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontSize: 14,
                            letterSpacing: .75,
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
