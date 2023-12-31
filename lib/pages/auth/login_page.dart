import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reauth/bloc/cubit/auth_cubit.dart';
import 'package:reauth/bloc/states/auth_state.dart';
import 'package:reauth/components/custom_snackbar.dart';

import 'package:reauth/components/custom_textfield.dart';
import 'package:reauth/pages/auth/register_page.dart';
import '../dashboard/dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordVisible = true;
  CustomSnackbar customSnackbar = CustomSnackbar('');

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      top: 100,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "ReAuth",
                              style: GoogleFonts.karla(
                                  color:
                                      const Color.fromARGB(255, 125, 125, 125),
                                  fontSize: 25,
                                  letterSpacing: .75,
                                  fontWeight: FontWeight.w600),
                            ),
                            // .animate().slideX(duration: 1000.ms, begin: -1.5),
                            const SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Welcome Back",
                                  style: GoogleFonts.karla(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      fontSize: 18,
                                      letterSpacing: .75,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 50,
                                ),
                                CustomTextField(
                                  keyboardType: TextInputType.text,
                                  controller: emailController,
                                  hintText: 'enter email ',
                                  labelText: 'Email',
                                ),
                                CustomTextField(
                                    isFormTypePassword: true,
                                    keyboardType: TextInputType.text,
                                    controller: passwordController,
                                    hintText: 'enter password',
                                    labelText: 'Password',
                                    obscureText: isPasswordVisible,
                                    passwordVisibility: (e) {
                                      setState(() {
                                        isPasswordVisible = !isPasswordVisible;
                                      });
                                    }),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: Text(
                                        "Forgot Password?",
                                        style: GoogleFonts.karla(
                                            color: const Color.fromARGB(
                                                255, 255, 255, 255),
                                            fontSize: 14,
                                            letterSpacing: .5,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 50),
                                BlocConsumer<AuthCubit, AuthState>(
                                    listener: (context, state) {
                                  if (state is LoginSuccess) {
                                    customSnackbar =
                                        CustomSnackbar("Login Success");
                                    customSnackbar.showCustomSnackbar(context);

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const DashboardPage()),
                                    );
                                  }
                                  if (state is RegisterSubmissionFailure) {
                                    customSnackbar =
                                        CustomSnackbar(state.error);
                                    customSnackbar.showCustomSnackbar(context);
                                  }
                                  if (state is LoginFailure) {
                                    customSnackbar =
                                        CustomSnackbar(state.error);
                                    customSnackbar.showCustomSnackbar(context);
                                  }
                                }, builder: (context, state) {
                                  if (state is AuthLoading) {
                                    return const SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: CircularProgressIndicator(
                                            color: Color.fromARGB(
                                                255, 106, 172, 191)));
                                  }
                                  return SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 106, 172, 191),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          )),
                                      onPressed: () async {
                                        authCubit.initiateLogin(
                                            emailController.text,
                                            passwordController.text);
                                      },
                                      child: const Text(
                                        'Login',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  );
                                })
                              ],
                            ),
                            const SizedBox(height: 50),
                          ],
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Create Account?",
                        style: GoogleFonts.karla(
                            color: const Color.fromARGB(255, 125, 125, 125),
                            fontSize: 14,
                            letterSpacing: .5,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const RegisterPage(),
                            ),
                          );
                        },
                        child: Text(
                          "Register",
                          style: GoogleFonts.karla(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              fontSize: 14,
                              letterSpacing: .75,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
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
