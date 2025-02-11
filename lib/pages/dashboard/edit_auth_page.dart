import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../bloc/cubit/user_auth_cubit.dart';
import '../../bloc/states/user_auth_state.dart';
import '../../components/AuthCategory/entertainment_fields_widget.dart';
import '../../components/AuthCategory/financial_fields_widget.dart';
import '../../components/AuthCategory/network_fields_widget.dart';
import '../../components/AuthCategory/other_fields_widget.dart';
import '../../components/AuthCategory/social_media_fields_widget.dart';
import '../../components/custom_snackbar.dart';
import '../../components/constants/auth_category.dart';
import '../../models/user_auth_model.dart';
import '../../validator/auth_category_field_validator/entertainment_fields_validator.dart';
import '../../validator/auth_category_field_validator/financial_fields_validator.dart';
import '../../validator/auth_category_field_validator/network_fields_validator.dart';
import '../../validator/auth_category_field_validator/other_fields_validator.dart';
import '../../validator/auth_category_field_validator/socialmedia_fields_validator.dart';

class EditAuthPage extends StatefulWidget {
  final UserAuthModel userAuthModel;

  const EditAuthPage({Key? key, required this.userAuthModel}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EditAuthPageState createState() => _EditAuthPageState();
}

class _EditAuthPageState extends State<EditAuthPage> {
  late TextEditingController authNameController;
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late TextEditingController noteController;
  late TextEditingController transactionPasswordController;
  late TextEditingController accountNumberController;
  late TextEditingController tagsController;

  List<String> selectedTags = [];
  bool hasTransactionPass = false;
  late AuthCategory selectedCategory;

  @override
  void initState() {
    super.initState();
    authNameController =
        TextEditingController(text: widget.userAuthModel.authName);
    accountNumberController =
        TextEditingController(text: widget.userAuthModel.accountNumber);
    usernameController =
        TextEditingController(text: widget.userAuthModel.username);
    passwordController =
        TextEditingController(text: widget.userAuthModel.password);
    noteController = TextEditingController(text: widget.userAuthModel.note);
    transactionPasswordController = TextEditingController(
        text: widget.userAuthModel.transactionPassword ?? '');
    tagsController = TextEditingController(
        text: widget.userAuthModel.tags?.join(', ') ?? '');
    selectedTags = widget.userAuthModel.tags ?? [];
    hasTransactionPass = widget.userAuthModel.hasTransactionPassword;
    selectedCategory = widget.userAuthModel.authCategory;
  }

  @override
  void dispose() {
    authNameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    noteController.dispose();
    transactionPasswordController.dispose();
    accountNumberController.dispose();
    tagsController.dispose();
    super.dispose();
  }

  Widget buildFieldsByCategory(AuthCategory category) {
    final availableTags = authCategoryTags[category] ?? [];

    switch (category) {
      case AuthCategory.financial:
        return FinancialFieldsWidget(
          authNameController: authNameController,
          usernameController: usernameController,
          passwordController: passwordController,
          transactionPasswordController: transactionPasswordController,
          noteController: noteController,
          tagsController: tagsController,
          availableTags: availableTags,
          selectedTags: selectedTags,
          onTagsUpdated: (tags) => setState(() => selectedTags = tags),
          onTransactionPasswordToggle: (hasPassword) {
            setState(() => hasTransactionPass = hasPassword);
          },
          accountNumberController: accountNumberController,
          isUpdating: true,
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
          isUpdating: true,
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
          isUpdating: true,
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
          isUpdating: true,
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
          isUpdating: true,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void handleUpdate() {
    final userAuthCubit = BlocProvider.of<UserAuthCubit>(context);
    final authLink = widget.userAuthModel.authLink.isNotEmpty
        ? widget.userAuthModel.authLink
        : "www.${authNameController.text.toLowerCase().replaceAll(' ', '')}.com";

    bool isValid = false;

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
          authNameController: authNameController,
          usernameController: usernameController,
          passwordController: passwordController,
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
      final updatedModel = UserAuthModel(
        authName: authNameController.text.trim().toLowerCase(),
        username: usernameController.text.trim(),
        password: passwordController.text,
        note: noteController.text,
        authLink: authLink,
        userAuthFavicon: widget.userAuthModel.userAuthFavicon,
        hasTransactionPassword: hasTransactionPass,
        transactionPassword:
            hasTransactionPass ? transactionPasswordController.text : '',
        authCategory: selectedCategory,
        createdAt: widget.userAuthModel.createdAt,
        updatedAt: DateTime.now(),
        isFavorite: widget.userAuthModel.isFavorite,
        tags: selectedTags,
        lastAccessed: widget.userAuthModel.lastAccessed,
        mfaOptions: widget.userAuthModel.mfaOptions,
      );

      userAuthCubit.editAuth(updatedModel).then((_) {
        CustomSnackbar.show(context, message: "Update Success");
        Navigator.of(context).pop(updatedModel);
      }).catchError((error) {
        CustomSnackbar.show(context,
            message: "Please enter required fields.", isError: true);
      });
    } else {
      CustomSnackbar.show(context,
          message: "Please enter all required fields.", isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final faviconUrl = widget.userAuthModel.userAuthFavicon;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Edit Auth'),
        actions: [
          BlocBuilder<UserAuthCubit, UserAuthState>(
            builder: (context, state) {
              final isSubmitting = state is UserAuthUpdateInProgress;
              return Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: TextButton(
                  onPressed: handleUpdate,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(
                        color: Color.fromARGB(255, 111, 163, 219),
                      ),
                    ),
                  ),
                  child: isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            backgroundColor: Colors.transparent,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          "Update",
                          style: GoogleFonts.karla(
                            color: const Color.fromARGB(255, 111, 163, 219),
                            fontSize: 16,
                            letterSpacing: .75,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            faviconUrl == null || faviconUrl.isEmpty
                ? Image.asset(
                    'assets/error.png',
                    height: 60,
                    fit: BoxFit.contain,
                  )
                : CachedNetworkImage(
                    imageUrl: faviconUrl,
                    height: 60,
                    fit: BoxFit.contain,
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/error.png',
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                  ),
            const SizedBox(height: 10),
            Text(
              widget.userAuthModel.authName.toUpperCase(),
              style: GoogleFonts.karla(
                color: const Color.fromARGB(255, 255, 255, 255),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              widget.userAuthModel.authLink,
              style: GoogleFonts.karla(
                color: Colors.grey[600],
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            buildFieldsByCategory(selectedCategory),
          ],
        ),
      ),
    );
  }
}
