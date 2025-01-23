import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reauth/bloc/cubit/user_auth_cubit.dart';
import 'package:reauth/bloc/states/user_auth_state.dart';
import 'package:reauth/components/AuthCategory/entertainment_fields_widget.dart';
import 'package:reauth/components/AuthCategory/financial_fields_widget.dart';
import 'package:reauth/components/AuthCategory/network_fields_widget.dart';
import 'package:reauth/components/AuthCategory/other_fields_widget.dart';
import 'package:reauth/components/AuthCategory/social_media_fields_widget.dart';
import 'package:reauth/components/custom_snackbar.dart';
import 'package:reauth/components/custom_tags_field.dart';
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

  String? dropdownvalue = AuthCategory.financial.toString();
  bool popularAuth = false;
  bool hasTransactionPass = false;
  bool isDropdownOpen = false;

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
    final List<String> availableTags = authCategoryTags[selectedCategory] ?? [];
    List<String> selectedTags = [];

    if (popularAuth) {
      print(widget.popularAuthModel!.authCategory);

      switch (widget.popularAuthModel!.authCategory) {
        case AuthCategory.financial:
          return Expanded(
            child: Column(
              children: [
                FinancialFieldsWidget(
                  authNameController: TextEditingController(
                      text: widget.popularAuthModel!.authName.toString()),
                  accountNumberController: TextEditingController(),
                  usernameController: TextEditingController(),
                  passwordController: TextEditingController(),
                  transactionPasswordController: TextEditingController(),
                  noteController: TextEditingController(),
                  tagsController: TextEditingController(),
                ),
                CustomTagsField(
                  availableTags: availableTags,
                  selectedTags: selectedTags,
                  hintText: "Enter Tags",
                  labelText: "Tags",
                  isRequired: false,
                  onTagsUpdated: (tags) {
                    setState(() {
                      selectedTags = tags;
                    });
                  },
                ),
              ],
            ),
          );
        case AuthCategory.socialMedia:
          return Expanded(
            child: Column(
              children: [
                SocialMediaFieldsWidget(
                  authNameController: TextEditingController(
                      text: widget.popularAuthModel!.authName.toString()),
                  usernameController: TextEditingController(),
                  passwordController: TextEditingController(),
                  noteController: TextEditingController(),
                ),
                CustomTagsField(
                  availableTags: availableTags,
                  selectedTags: selectedTags,
                  hintText: "Enter Tags",
                  labelText: "Tags",
                  isRequired: false,
                  onTagsUpdated: (tags) {
                    setState(() {
                      selectedTags = tags;
                    });
                  },
                ),
              ],
            ),
          );

        case AuthCategory.entertainment:
          return Expanded(
            child: Column(
              children: [
                EntertainmentFieldsWidget(
                  authNameController: TextEditingController(
                      text: widget.popularAuthModel!.authName.toString()),
                  usernameController: TextEditingController(),
                  passwordController: TextEditingController(),
                  noteController: TextEditingController(),
                ),
                CustomTagsField(
                  availableTags: availableTags,
                  selectedTags: selectedTags,
                  hintText: "Enter Tags",
                  labelText: "Tags",
                  isRequired: false,
                  onTagsUpdated: (tags) {
                    setState(() {
                      selectedTags = tags;
                    });
                  },
                ),
              ],
            ),
          );
        case AuthCategory.network:
          return Expanded(
            child: Column(
              children: [
                NetworkFieldsWidget(
                  usernameController: TextEditingController(),
                  passwordController: TextEditingController(),
                  noteController: TextEditingController(),
                ),
                CustomTagsField(
                  availableTags: availableTags,
                  selectedTags: selectedTags,
                  hintText: "Enter Tags",
                  labelText: "Tags",
                  isRequired: false,
                  onTagsUpdated: (tags) {
                    setState(() {
                      selectedTags = tags;
                    });
                  },
                ),
              ],
            ),
          );
        case AuthCategory.others:
          return Expanded(
            child: Column(
              children: [
                OtherFieldsWidget(
                  usernameController: TextEditingController(),
                  passwordController: TextEditingController(),
                  noteController: TextEditingController(),
                  authNameController: TextEditingController(
                      text: widget.popularAuthModel!.authName.toString()),
                ),
                CustomTagsField(
                  availableTags: availableTags,
                  selectedTags: selectedTags,
                  hintText: "Enter Tags",
                  labelText: "Tags",
                  isRequired: false,
                  onTagsUpdated: (tags) {
                    setState(() {
                      selectedTags = tags;
                    });
                  },
                ),
              ],
            ),
          );
        default:
          return Container();
      }
    } else {
      switch (selectedCategory) {
        case AuthCategory.financial:
          return Expanded(
            child: Column(
              children: [
                FinancialFieldsWidget(
                  authNameController: TextEditingController(),
                  accountNumberController: TextEditingController(),
                  usernameController: TextEditingController(),
                  passwordController: TextEditingController(),
                  transactionPasswordController: TextEditingController(),
                  noteController: TextEditingController(),
                  tagsController: TextEditingController(),
                ),
                CustomTagsField(
                  availableTags: availableTags,
                  selectedTags: selectedTags,
                  hintText: "Enter Tags",
                  labelText: "Tags",
                  isRequired: false,
                  onTagsUpdated: (tags) {
                    setState(() {
                      selectedTags = tags;
                    });
                  },
                ),
              ],
            ),
          );
        case AuthCategory.socialMedia:
          return Expanded(
            child: Column(
              children: [
                SocialMediaFieldsWidget(
                  authNameController: TextEditingController(),
                  usernameController: TextEditingController(),
                  passwordController: TextEditingController(),
                  noteController: TextEditingController(),
                ),
                CustomTagsField(
                  availableTags: availableTags,
                  selectedTags: selectedTags,
                  hintText: "Enter Tags",
                  labelText: "Tags",
                  isRequired: false,
                  onTagsUpdated: (tags) {
                    setState(() {
                      selectedTags = tags;
                    });
                  },
                ),
              ],
            ),
          );

        case AuthCategory.entertainment:
          return Expanded(
            child: Column(
              children: [
                EntertainmentFieldsWidget(
                  authNameController: TextEditingController(),
                  usernameController: TextEditingController(),
                  passwordController: TextEditingController(),
                  noteController: TextEditingController(),
                ),
                CustomTagsField(
                  availableTags: availableTags,
                  selectedTags: selectedTags,
                  hintText: "Enter Tags",
                  labelText: "Tags",
                  isRequired: false,
                  onTagsUpdated: (tags) {
                    setState(() {
                      selectedTags = tags;
                    });
                  },
                ),
              ],
            ),
          );
        case AuthCategory.network:
          return Expanded(
            child: Column(
              children: [
                NetworkFieldsWidget(
                  usernameController: TextEditingController(),
                  passwordController: TextEditingController(),
                  noteController: TextEditingController(),
                ),
                CustomTagsField(
                  availableTags: availableTags,
                  selectedTags: selectedTags,
                  hintText: "Enter Tags",
                  labelText: "Tags",
                  isRequired: false,
                  onTagsUpdated: (tags) {
                    setState(() {
                      selectedTags = tags;
                    });
                  },
                ),
              ],
            ),
          );
        case AuthCategory.others:
          return Expanded(
            child: Column(
              children: [
                OtherFieldsWidget(
                  usernameController: TextEditingController(),
                  passwordController: TextEditingController(),
                  noteController: TextEditingController(),
                  authNameController: TextEditingController(),
                ),
                CustomTagsField(
                  availableTags: availableTags,
                  selectedTags: selectedTags,
                  hintText: "Enter Tags",
                  labelText: "Tags",
                  isRequired: false,
                  onTagsUpdated: (tags) {
                    setState(() {
                      selectedTags = tags;
                    });
                  },
                ),
              ],
            ),
          );
        default:
          return Container();
      }
    }
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
              Color.fromARGB(255, 53, 64, 79),
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
                    vertical: 15.0,
                  ),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        widget.popularAuthModel != null
                            ? CachedNetworkImage(
                                imageUrl: widget.popularAuthModel!.authFavicon,
                                height: 45,
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
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * .85,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color.fromARGB(255, 43, 51, 63),
                        width: 1.5,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        dropdownColor: const Color.fromARGB(255, 43, 51, 63),
                        menuMaxHeight: 300,
                        icon: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: isDropdownOpen
                              ? const Icon(
                                  Icons.arrow_drop_up,
                                  color: Color.fromARGB(255, 125, 125, 125),
                                  size: 28,
                                )
                              : const Icon(
                                  Icons.arrow_drop_down,
                                  color: Color.fromARGB(255, 125, 125, 125),
                                  size: 28,
                                ),
                        ),
                        value: dropdownvalue,
                        isExpanded: false, // Restrict full width
                        iconSize: 24,
                        style: const TextStyle(
                          color: Colors.white, // White text style
                          fontSize: 16,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownvalue = newValue!;
                            isDropdownOpen = !isDropdownOpen;
                          });
                        },
                        items: authCategoryStrings.entries.map((entry) {
                          return DropdownMenuItem<String>(
                            value: entry.key.toString(),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 16.0,
                              ),
                              child: Text(
                                entry.value,
                                style: const TextStyle(
                                  color: Colors.white, // White text for items
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
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
                      return buildDynamicFields();
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
