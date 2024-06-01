import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reauth/bloc/cubit/user_provider_cubit.dart';
import 'package:reauth/bloc/states/user_provider_state.dart';
import 'package:reauth/components/custom_snackbar.dart';
import 'package:reauth/components/custom_textfield.dart';
import 'package:reauth/components/formatter.dart';
import 'package:reauth/models/popularprovider_model.dart';
import 'package:reauth/models/userprovider_model.dart';
import 'package:reauth/pages/dashboard/dashboard_page.dart';

class AddProviderPage extends StatefulWidget {
  final PopularProviderModel? popularProviderModel;
  const AddProviderPage({Key? key, this.popularProviderModel})
      : super(key: key);

  @override
  State<AddProviderPage> createState() => _AddProviderPageState();
}

class _AddProviderPageState extends State<AddProviderPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  TextEditingController authProviderLinkController = TextEditingController();
  final TextEditingController providerCategoryController =
      TextEditingController();
  final TextEditingController authProviderNameController =
      TextEditingController();
  final TextEditingController transactionPasswordController =
      TextEditingController();

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  var authCategories = [
    'Social Media',
    'Ecommerce',
    'Educational',
    'Lifestyle',
    'Productivity',
    'Entertainment',
    'Game',
  ];
  String? dropdownvalue = 'Social Media';
  RegExp noUpperCase = RegExp(r'[A-Z]');
  bool popularProvider = false;
  bool hasTransactionPass = false;

  @override
  void initState() {
    super.initState();

    if (widget.popularProviderModel != null) {
      dropdownvalue = widget.popularProviderModel?.authCategory;
      authProviderNameController.text = widget.popularProviderModel!.authName;
      authProviderLinkController.text = widget.popularProviderModel!.authLink;
      popularProvider = true;
    }

    providerCategoryController.text = dropdownvalue!;
  }

  @override
  Widget build(BuildContext context) {
    final userProviderCubit = BlocProvider.of<UserProviderCubit>(context);

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
                      widget.popularProviderModel != null
                          ? authProviderLinkController.text =
                              widget.popularProviderModel!.authLink
                          : authProviderLinkController.text =
                              "www.${authProviderNameController.text.toLowerCase()}.com";
                      userProviderCubit.submitProvider(
                          UserProviderModel(
                            authName:
                                authProviderNameController.text.toLowerCase(),
                            username: usernameController.text,
                            password: passwordController.text,
                            note: noteController.text,
                            providerCategory: providerCategoryController.text,
                            authProviderLink: authProviderLinkController.text,
                            faviconUrl: authProviderLinkController.text,
                            hasTransactionPassword: hasTransactionPass,
                            transactionPassword: hasTransactionPass
                                ? transactionPasswordController.text
                                : '',
                          ),
                          popularProvider);
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
                    )))
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
                          widget.popularProviderModel != null
                              ? CachedNetworkImage(
                                  imageUrl:
                                      widget.popularProviderModel!.faviconUrl,
                                  height: 30,
                                  fit: BoxFit.contain,
                                )
                              : const Icon(
                                  Icons.add_circle,
                                  size: 24,
                                  color: Color.fromARGB(255, 111, 163, 219),
                                ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            widget.popularProviderModel != null
                                ? 'Add ${widget.popularProviderModel!.authName}'
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
                  const SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 10.0),
                    child: BlocConsumer<UserProviderCubit, UserProviderState>(
                      listener: (context, state) {
                        if (state is UserProviderSubmissionSuccess) {
                          CustomSnackbar customSnackbar =
                              CustomSnackbar("Submission Completed");

                          customSnackbar.showCustomSnackbar(context);

                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const DashboardPage(),
                            ),
                          );
                        } else if (state is UserProviderSubmissionFailure) {
                          CustomSnackbar customSnackbar = CustomSnackbar(
                              "Submission Error: ${state.error}");
                          customSnackbar.showCustomSnackbar(context);
                        }
                      },
                      builder: (context, state) {
                        if (state is UserProviderLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Color.fromARGB(255, 106, 172, 191),
                            ),
                          );
                        }
                        return Form(
                          child: Column(
                            children: [
                              widget.popularProviderModel != null
                                  ? CustomTextField(
                                      textInputFormatter: [
                                        NoUppercaseInputFormatter()
                                      ],
                                      keyboardType: TextInputType.text,
                                      controller: authProviderLinkController,
                                      hintText: 'Enter Auth Link',
                                      labelText: 'Auth Link',
                                    )
                                  : CustomTextField(
                                      keyboardType: TextInputType.text,
                                      controller: authProviderNameController,
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: hasTransactionPass,
                                        onChanged: (value) {
                                          setState(() {
                                            hasTransactionPass = value!;
                                          });
                                        },
                                      ),
                                      Text(
                                        'Transaction Password Exists',
                                        style: GoogleFonts.karla(
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontSize: 16,
                                          letterSpacing: .75,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (hasTransactionPass) ...[
                                    CustomTextField(
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      controller: transactionPasswordController,
                                      hintText: 'Enter Transaction Password',
                                      labelText: 'Transaction Password',
                                    ),
                                  ],
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 10),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 53, 64, 79),
                                        width: 2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: DropdownButton<String>(
                                    // Initial Value
                                    value: dropdownvalue,
                                    dropdownColor:
                                        const Color.fromARGB(255, 53, 64, 79),
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    isExpanded: true,
                                    // Array list of items
                                    items: authCategories.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(items,
                                            // Customize the style of each item
                                            style: GoogleFonts.karla(
                                                color: const Color.fromARGB(
                                                    255, 255, 255, 255),
                                                fontSize: 14,
                                                letterSpacing: .75,
                                                fontWeight: FontWeight.w600)),
                                      );
                                    }).toList(),
                                    style: GoogleFonts.karla(
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        fontSize: 14,
                                        letterSpacing: .75,
                                        fontWeight: FontWeight.w600),
                                    underline: Container(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownvalue = newValue!;
                                        providerCategoryController.text =
                                            dropdownvalue!;
                                      });
                                    },
                                  ),
                                ),
                              ),
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
        ));
  }
}
