import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reauth/bloc/cubit/provider_cubit.dart';
import 'package:reauth/bloc/states/provider_state.dart';
import 'package:reauth/components/custom_snackbar.dart';
import 'package:reauth/components/custom_textfield.dart';
import 'package:reauth/models/provider_model.dart';

class AddProviderPage extends StatefulWidget {
  const AddProviderPage({Key? key}) : super(key: key);

  @override
  State<AddProviderPage> createState() => _AddProviderPageState();
}

class _AddProviderPageState extends State<AddProviderPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController authProviderLinkController =
      TextEditingController();
  final TextEditingController providerCategoryController =
      TextEditingController();

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final providerCubit = BlocProvider.of<ProviderCubit>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 53, 64, 79),
        centerTitle: true,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: TextButton(
              onPressed: () {
                providerCubit.submitProvider(
                  ProviderModel(
                    username: usernameController.text,
                    password: passwordController.text,
                    note: noteController.text,
                    providerCategory: providerCategoryController.text,
                    authproviderLink: authProviderLinkController.text,
                  ),
                );
              },
              child: Text(
                "Save",
                style: GoogleFonts.karla(
                    color: const Color.fromARGB(255, 111, 163, 219),
                    fontSize: 20,
                    letterSpacing: .75,
                    fontWeight: FontWeight.w600),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * .95,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: const Color.fromARGB(255, 53, 64, 79),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20.0,
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.add_box,
                          size: 24,
                          color: Color.fromARGB(255, 111, 163, 219),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Add Auth",
                          style: GoogleFonts.karla(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              fontSize: 20,
                              letterSpacing: .75,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 10.0),
                child: BlocConsumer<ProviderCubit, ProviderState>(
                  listener: (context, state) {
                    if (state is ProviderSubmissionSuccess) {
                      CustomSnackbar customSnackbar =
                          CustomSnackbar("Submission Completed");
                      customSnackbar.showCustomSnackbar(context);
                    } else if (state is ProviderSubmissionFailure) {
                      CustomSnackbar customSnackbar =
                          CustomSnackbar("Submission Error: ${state.error}");
                      customSnackbar.showCustomSnackbar(context);
                    }
                  },
                  builder: (context, state) {
                    return Form(
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: authProviderLinkController,
                            hintText: 'enter auth url',
                            labelText: 'Auth Url',
                          ),
                          CustomTextField(
                            controller: passwordController,
                            hintText: 'enter auth username',
                            labelText: 'Username ',
                          ),
                          CustomTextField(
                            controller: noteController,
                            hintText: 'enter auth passwrod',
                            labelText: 'Password',
                          ),
                          CustomTextField(
                            controller: providerCategoryController,
                            hintText: 'Enter App Category',
                            labelText: 'ProviderCategory',
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
