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
import 'package:reauth/constants/auth_category.dart';
import 'package:reauth/models/popular_auth_model.dart';
import 'package:reauth/models/user_auth_model.dart';
import 'package:reauth/pages/dashboard/dashboard_page.dart';
import 'package:reauth/validator/auth_category_field_validator/entertainment_fields_validator.dart';
import 'package:reauth/validator/auth_category_field_validator/financial_fields_validator.dart';
import 'package:reauth/validator/auth_category_field_validator/network_fields_validator.dart';
import 'package:reauth/validator/auth_category_field_validator/other_fields_validator.dart';
import 'package:reauth/validator/auth_category_field_validator/socialmedia_fields_validator.dart';

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
  final TextEditingController accountNumberController = TextEditingController();

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  List<String> selectedTags = [];

  String? dropdownValue;
  bool popularAuth = false;
  bool hasTransactionPass = false;
  bool isDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    if (widget.popularAuthModel != null) {
      dropdownValue = widget.popularAuthModel!.authCategory.toString();
      authNameController.text = widget.popularAuthModel!.authName;
      authLinkController.text = widget.popularAuthModel!.authLink;
      popularAuth = true;
    } else {
      dropdownValue = AuthCategory.financial.toString();
    }
    authCategoryController.text = dropdownValue!;
  }

  Widget buildFieldsByCategory(AuthCategory category) {
    final availableTags = authCategoryTags[category] ?? [];

    switch (category) {
      case AuthCategory.financial:
        return FinancialFieldsWidget(
          authNameController: authNameController,
          accountNumberController: accountNumberController,
          usernameController: usernameController,
          passwordController: passwordController,
          transactionPasswordController: transactionPasswordController,
          noteController: noteController,
          tagsController: TextEditingController(),
          availableTags: availableTags,
          selectedTags: selectedTags,
          onTagsUpdated: (tags) => setState(() => selectedTags = tags),
          onTransactionPasswordToggle: (hasPassword) {
            setState(() {
              hasTransactionPass = hasPassword; // Update the parent’s value
            });
          },
          isUpdating: popularAuth,
        );

      case AuthCategory.socialMedia:
        return SocialMediaFieldsWidget(
          authNameController: authNameController,
          usernameController: usernameController,
          passwordController: passwordController,
          noteController: noteController,
          availableTags: availableTags,
          selectedTags: selectedTags,
          onTagsUpdated: (tags) => setState(() => selectedTags = tags),
          isUpdating: popularAuth,
        );
      case AuthCategory.entertainment:
        return EntertainmentFieldsWidget(
          authNameController: authNameController,
          usernameController: usernameController,
          passwordController: passwordController,
          noteController: noteController,
          availableTags: availableTags,
          selectedTags: selectedTags,
          onTagsUpdated: (tags) => setState(() => selectedTags = tags),
          isUpdating: popularAuth,
        );
      case AuthCategory.network:
        return NetworkFieldsWidget(
          usernameController: usernameController,
          passwordController: passwordController,
          noteController: noteController,
          availableTags: availableTags,
          selectedTags: selectedTags,
          onTagsUpdated: (tags) => setState(() => selectedTags = tags),
          authNameController: authNameController,
          isUpdating: popularAuth,
        );
      case AuthCategory.others:
        return OtherFieldsWidget(
          authNameController: authNameController,
          usernameController: usernameController,
          passwordController: passwordController,
          noteController: noteController,
          availableTags: availableTags,
          selectedTags: selectedTags,
          onTagsUpdated: (tags) => setState(() => selectedTags = tags),
          isUpdating: popularAuth,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget buildDropdown() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * .60,
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
            value: dropdownValue,
            isExpanded: false, // Restrict full width
            iconSize: 24,
            style: const TextStyle(
              color: Colors.white, // White text style
              fontSize: 16,
            ),
            onChanged: widget.popularAuthModel != null
                ? null // Disable the dropdown when popularAuthModel is not null
                : (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
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
    );
  }

  void handleSave() {
    final userProviderCubit = BlocProvider.of<UserAuthCubit>(context);

    AuthCategory selectedCategory =
        AuthCategory.values.firstWhere((e) => e.toString() == dropdownValue);

    bool isValid = false;

    // Determine the appropriate validator based on the category
    switch (selectedCategory) {
      case AuthCategory.financial:
        isValid = FinancialFieldsValidator.validateFields(
          authNameController: authNameController,
          usernameController: usernameController,
          passwordController: passwordController,
          transactionPasswordController: transactionPasswordController,
          hasTransactionPassword: hasTransactionPass,
        );
        break;

      case AuthCategory.socialMedia:
        isValid = SocialMediaFieldsValidator.validateFields(
          authNameController: authNameController,
          usernameController: usernameController,
          passwordController: passwordController,
        );
        break;

      case AuthCategory.entertainment:
        isValid = EntertainmentFieldsValidator.validateFields(
          authNameController: authNameController,
          usernameController: usernameController,
          passwordController: passwordController,
        );
        break;
      case AuthCategory.network:
        isValid = NetworkFieldsValidator.validateFields(
          usernameController: usernameController,
          passwordController: passwordController,
          authNameController: authNameController,
        );
        break;
      case AuthCategory.others:
        isValid = OtherFieldsValidator.validateFields(
          authNameController: authNameController,
          usernameController: usernameController,
          passwordController: passwordController,
        );
        break;

      default:
        break;
    }

    if (isValid) {
      final userAuthModel = UserAuthModel(
        authName: authNameController.text.toLowerCase().trim(),
        username: usernameController.text.trim(),
        password: passwordController.text.trim(),
        note: noteController.text.trim(),
        authLink: widget.popularAuthModel?.authLink ??
            'www.${authNameController.text.trim().toLowerCase()}.com',
        authCategory: selectedCategory,
        hasTransactionPassword: hasTransactionPass,
        transactionPassword: transactionPasswordController.text.trim(),
        accountNumber: accountNumberController.text.trim(),
        tags: selectedTags,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        lastAccessed: DateTime.now(),
        isFavorite: false,
      );
      userProviderCubit.submitUserAuth(
        userAuthModel: userAuthModel,
        popularAuth: popularAuth,
      );
    } else {
      CustomSnackbar.show(context,
          message: "Please enter required fields.", isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Ensure space for keyboard
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 53, 64, 79),
        centerTitle: true,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: TextButton(
              onPressed: handleSave,
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
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
                const SizedBox(height: 20),
                BlocConsumer<UserAuthCubit, UserAuthState>(
                  listener: (context, state) {
                    if (state is UserAuthSubmissionSuccess) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (_) => const DashboardPage()),
                      );
                    } else if (state is UserAuthSubmissionFailure) {
                      CustomSnackbar.show(context,
                          message: state.error.toString(), isError: true);
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
                    return Column(
                      children: [
                        buildDropdown(),
                        buildFieldsByCategory(
                          AuthCategory.values
                              .firstWhere((e) => e.toString() == dropdownValue),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
