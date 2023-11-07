import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reauth/components/custom_textfield.dart';

class AddProfilePage extends StatefulWidget {
  const AddProfilePage({Key? key}) : super(key: key);

  @override
  State<AddProfilePage> createState() => _AddProfilePageState();
}

class _AddProfilePageState extends State<AddProfilePage> {
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();

  Future<void> firebaseRegistration() async {
    // if (passwordController.text == confirmPasswordController.text) {
    //   print('Matches');
    //   try {
    //     CustomSnackbar customSnackbar =
    //         CustomSnackbar("Successful Registration");
    //     await FirebaseAuth.instance
    //         .createUserWithEmailAndPassword(
    //           email: emailController.text,
    //           password: passwordController.text,
    //         )
    //         .then((value) => Navigator.pushReplacement(context,
    //             MaterialPageRoute(builder: (context) => const LoginPage())))
    //         .then((value) => customSnackbar.showCustomSnackbar(context));
    //   } on FirebaseAuthException catch (e) {
    //     if (e.code == 'weak-password') {
    //       print('The password provided is too weak.');
    //     } else if (e.code == 'email-already-in-use') {
    //       print('The account already exists for that email.');
    //     }
    //   } catch (e) {
    //     print(e);
    //   }
    // } else {
    //   print('doesnt match');
    // }
  }

  @override
  Widget build(BuildContext context) {
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
                      top: 75,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Column(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Text(
                        //       "Add Info",
                        //       style: GoogleFonts.karla(
                        //           color:
                        //               const Color.fromARGB(255, 125, 125, 125),
                        //           fontSize: 25,
                        //           letterSpacing: .75,
                        //           fontWeight: FontWeight.w600),
                        //     ),
                        //     // .animate().slideX(duration: 1000.ms, begin: -1.5),
                        //     const SizedBox(
                        //       height: 30,
                        //     ),
                        //   ],
                        // ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Add Info",
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
                                  controller: firstName,
                                  hintText: 'enter first name ',
                                  labelText: 'First Name',
                                ),
                                CustomTextField(
                                  isFormTypePassword: true,
                                  keyboardType: TextInputType.text,
                                  controller: lastName,
                                  hintText: 'enter last name',
                                  labelText: 'LastName',
                                ),
                                SizedBox(
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
                                      onPressed: firebaseRegistration,
                                      child: const Text(
                                        'Save & OnBoard',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                            // .animate(delay: 1500.ms).fade(duration: 1000.ms),
                            const SizedBox(height: 50),
                          ],
                        )
                        // .animate(delay: 1500.ms).fade(duration: 1000.ms),
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
