import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reauth/bloc/cubit/user_auth_cubit.dart';
import 'package:reauth/bloc/states/user_auth_state.dart';
import 'package:reauth/components/custom_snackbar.dart';
import 'package:reauth/components/custom_textfield.dart';
import 'package:reauth/components/formatter.dart';
import 'package:reauth/constants/auth_category.dart';
import 'package:reauth/models/popular_auth_model.dart';
import 'package:reauth/models/user_auth_model.dart';
import 'package:reauth/pages/dashboard/dashboard_page.dart';

class AddAuthPage extends StatefulWidget {
  final PopularAuthModel? popularAuthModel;

  const AddAuthPage({Key? key, this.popularAuthModel}) : super(key: key);

  @override
  State<AddAuthPage> createState() => _AddAuthPageState();
}

class _AddAuthPageState extends State<AddAuthPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController authLinkController = TextEditingController();
  final TextEditingController authCategoryController = TextEditingController();
  final TextEditingController authNameController = TextEditingController();
  final TextEditingController transactionPasswordController =
      TextEditingController();

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  String? dropdownvalue = AuthCategory.socialMedia.toString();
  bool popularAuth = false;
  bool hasTransactionPass = false;

  // Field associations with AuthCategory
  final Map<AuthCategory, List<String>> categorySpecificFields = {
    AuthCategory.financial: ['Account Number', 'Transaction Password'],
    AuthCategory.socialMedia: ['Profile Link'],
    AuthCategory.others: [],
  };

  @override
  void initState() {
    super.initState();

    if (widget.popularAuthModel != null) {
      dropdownvalue = widget.popularAuthModel!.authCategory.toString();
      authNameController.text = widget.popularAuthModel!.authName;
      authLinkController.text = widget.popularAuthModel!.authLink;
      popularAuth = true;
    }

    authCategoryController.text = dropdownvalue!;
  }

  Widget buildDynamicFields() {
    // Get selected category fields
    AuthCategory selectedCategory =
        AuthCategory.values.firstWhere((e) => e.toString() == dropdownvalue);
    List<String> fields = categorySpecificFields[selectedCategory] ?? [];

    return Column(
      children: fields.map((field) {
        if (field == 'Transaction Password' && !hasTransactionPass) {
          return Container(); // Skip if transaction password is not required
        }
        return CustomTextField(
          keyboardType: TextInputType.text,
          controller: TextEditingController(),
          hintText: 'Enter $field',
          labelText: field,
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProviderCubit = BlocProvider.of<UserAuthCubit>(context);

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
                widget.popularAuthModel != null
                    ? authLinkController.text =
                        widget.popularAuthModel!.authLink
                    : authLinkController.text =
                        "www.${authNameController.text.toLowerCase()}.com";
                userProviderCubit.submitProvider(
                  UserAuthModel(
                    authName: authNameController.text.toLowerCase(),
                    username: usernameController.text,
                    password: passwordController.text,
                    note: noteController.text,
                    authLink: authLinkController.text,
                    userAuthFavicon: authLinkController.text,
                    hasTransactionPassword: hasTransactionPass,
                    transactionPassword: hasTransactionPass
                        ? transactionPasswordController.text
                        : '',
                    authCategory: AuthCategory.values
                        .firstWhere((e) => e.toString() == dropdownvalue),
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                    isFavorite: false,
                  ),
                  popularAuth,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(
                    color: Color.fromARGB(255, 111, 163, 219),
                  ),
                ),
              ),
              child: Text(
                "Save",
                style: GoogleFonts.karla(
                  color: const Color.fromARGB(255, 111, 163, 219),
                  fontSize: 16,
                  letterSpacing: .75,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 53, 64, 79),
              Color.fromARGB(255, 43, 51, 63),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 20.0,
                  ),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        widget.popularAuthModel != null
                            ? CachedNetworkImage(
                                imageUrl: widget.popularAuthModel!.authFavicon,
                                height: 30,
                                fit: BoxFit.contain,
                              )
                            : const Icon(
                                Icons.add_circle,
                                size: 24,
                                color: Color.fromARGB(255, 111, 163, 219),
                              ),
                        const SizedBox(height: 10),
                        Text(
                          widget.popularAuthModel != null
                              ? 'Add ${widget.popularAuthModel!.authName}'
                              : "Add Auth",
                          style: GoogleFonts.karla(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontSize: 20,
                            letterSpacing: .75,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10.0),
                  child: BlocConsumer<UserAuthCubit, UserAuthState>(
                    listener: (context, state) {
                      if (state is UserAuthSubmissionSuccess) {
                        CustomSnackbar customSnackbar =
                            CustomSnackbar("Submission Completed");

                        customSnackbar.showCustomSnackbar(context);

                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const DashboardPage(),
                          ),
                        );
                      } else if (state is UserAuthSubmissionFailure) {
                        CustomSnackbar customSnackbar =
                            CustomSnackbar("Submission Error: ${state.error}");
                        customSnackbar.showCustomSnackbar(context);
                      }
                    },
                    builder: (context, state) {
                      if (state is UserAuthLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color.fromARGB(255, 106, 172, 191),
                          ),
                        );
                      }
                      return Form(
                        child: Column(
                          children: [
                            DropdownButton<String>(
                              value: dropdownvalue,
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownvalue = newValue!;
                                  authCategoryController.text = dropdownvalue!;
                                });
                              },
                              items: AuthCategory.values
                                  .map((AuthCategory category) =>
                                      DropdownMenuItem<String>(
                                        value: category.toString(),
                                        child: Text(
                                          category.name,
                                          style: GoogleFonts.karla(
                                              color: Colors.white),
                                        ),
                                      ))
                                  .toList(),
                            ),
                            widget.popularAuthModel != null
                                ? CustomTextField(
                                    textInputFormatter: [
                                      NoUppercaseInputFormatter()
                                    ],
                                    keyboardType: TextInputType.text,
                                    controller: authLinkController,
                                    hintText: 'Enter Auth Link',
                                    labelText: 'Auth Link',
                                  )
                                : CustomTextField(
                                    keyboardType: TextInputType.text,
                                    controller: authNameController,
                                    hintText: 'Enter Auth Name',
                                    labelText: 'Auth Name',
                                  ),
                            CustomTextField(
                              keyboardType: TextInputType.text,
                              controller: usernameController,
                              hintText: 'Enter Auth Username',
                              labelText: 'Username',
                            ),
                            CustomTextField(
                              keyboardType: TextInputType.visiblePassword,
                              controller: passwordController,
                              hintText: 'Enter Auth Password',
                              labelText: 'Password',
                            ),
                            buildDynamicFields(),
                            CustomTextField(
                              keyboardType: TextInputType.text,
                              controller: noteController,
                              hintText: 'Write some notes',
                              labelText: 'Notes',
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
      ),
    );
  }
}
