import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reauth/bloc/cubit/user_auth_cubit.dart';
import 'package:reauth/bloc/states/user_auth_state.dart';

import 'package:reauth/components/custom_snackbar.dart';
import 'package:reauth/components/custom_textfield.dart';
import 'package:reauth/constants/auth_category.dart';
import 'package:reauth/models/user_auth_model.dart';

import 'package:reauth/pages/dashboard/dashboard_page.dart';

class EditAuthPage extends StatefulWidget {
  final UserAuthModel userAuthModel;

  const EditAuthPage({Key? key, required this.userAuthModel}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EditProviderPageState createState() => _EditProviderPageState();
}

class _EditProviderPageState extends State<EditAuthPage> {
  late TextEditingController _authLinkController;
  late TextEditingController _passwordController;
  late TextEditingController _usernameController;
  late TextEditingController _noteController;
  late TextEditingController _transactionPasswordController;
  late TextEditingController _tagsController;
  late TextEditingController _authCategoryController;

  late bool hasTransactionPass;
  late String dropdownValue;

  @override
  void initState() {
    super.initState();
    _authLinkController =
        TextEditingController(text: widget.userAuthModel.authLink);
    _passwordController =
        TextEditingController(text: widget.userAuthModel.password);
    _usernameController =
        TextEditingController(text: widget.userAuthModel.username);
    _noteController = TextEditingController(text: widget.userAuthModel.note);
    _transactionPasswordController = TextEditingController(
        text: widget.userAuthModel.transactionPassword ?? '');
    _tagsController = TextEditingController(
        text: widget.userAuthModel.tags?.join(', ') ?? '');
    dropdownValue = widget.userAuthModel.authCategory.name;

    hasTransactionPass = widget.userAuthModel.hasTransactionPassword;
    _authCategoryController =
        widget.userAuthModel.authCategory.toString() as TextEditingController;
  }

  @override
  void dispose() {
    _authLinkController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _noteController.dispose();
    _transactionPasswordController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProviderCubit = BlocProvider.of<UserAuthCubit>(context);

    return Scaffold(
      appBar: AppBar(
          title: const Text('Edit Provider'),
          centerTitle: false,
          elevation: 0,
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: TextButton(
                    onPressed: () {
                      userProviderCubit.editProvider(
                        UserAuthModel(
                          authName: widget.userAuthModel.authName,
                          username: _usernameController.text,
                          password: _passwordController.text,
                          note: _noteController.text,
                          authLink: _authLinkController.text,
                          userAuthFavicon: widget.userAuthModel.userAuthFavicon,
                          hasTransactionPassword: hasTransactionPass,
                          transactionPassword: hasTransactionPass
                              ? _transactionPasswordController.text
                              : null,
                          authCategory: AuthCategory.values.firstWhere(
                              (e) => e.name == dropdownValue,
                              orElse: () => AuthCategory.others),
                          createdAt: widget.userAuthModel.createdAt,
                          updatedAt: DateTime.now(),
                          tags: _tagsController.text
                              .split(',')
                              .map((tag) => tag.trim())
                              .toList(),
                          isFavorite: widget.userAuthModel.isFavorite,
                          lastAccessed: widget.userAuthModel.lastAccessed,
                          mfaOptions: widget.userAuthModel.mfaOptions,
                        ),
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
                      "Update",
                      style: GoogleFonts.karla(
                        color: const Color.fromARGB(255, 111, 163, 219),
                        fontSize: 16,
                        letterSpacing: .75,
                        fontWeight: FontWeight.bold,
                      ),
                    ))),
          ]),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocListener<UserAuthCubit, UserAuthState>(
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Center(
                  child: Column(
                    children: [
                      CachedNetworkImage(
                        imageUrl: widget.userAuthModel.userAuthFavicon,
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.userAuthModel.authName,
                        style: GoogleFonts.karla(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontSize: 16,
                          letterSpacing: .75,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  isRequired: true,
                  controller: _usernameController,
                  hintText: 'Enter Auth Username',
                  labelText: 'Username',
                ),
                CustomTextField(
                  isRequired: true,
                  controller: _passwordController,
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
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontSize: 16,
                            letterSpacing: .75,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    if (hasTransactionPass)
                      CustomTextField(
                        isRequired: true,
                        controller: _transactionPasswordController,
                        hintText: 'Enter Transaction Password',
                        labelText: 'Transaction Password',
                      ),
                  ],
                ),
                CustomTextField(
                  isRequired: true,
                  keyboardType: TextInputType.text,
                  controller: _noteController,
                  hintText: 'Write some notes',
                  labelText: 'Notes',
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
                  child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 53, 64, 79),
                            width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        // Initial Value
                        value: dropdownValue,
                        dropdownColor: const Color.fromARGB(255, 53, 64, 79),
                        icon: const Icon(Icons.keyboard_arrow_down),
                        isExpanded: true,
                        // Array list of items
                        items: AuthCategory.values.map((AuthCategory category) {
                          return DropdownMenuItem(
                            value: category
                                .toString()
                                .split('.')
                                .last, // Get the name of the enum value
                            child: Text(
                              category
                                  .toString()
                                  .split('.')
                                  .last, // Display the name of the enum value
                              style: GoogleFonts.karla(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                fontSize: 14,
                                letterSpacing: .75,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                        style: GoogleFonts.karla(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontSize: 14,
                          letterSpacing: .75,
                          fontWeight: FontWeight.w600,
                        ),
                        underline: Container(),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                            _authCategoryController.text = dropdownValue;
                          });
                        },
                      )),
                ),
                CustomTextField(
                  isRequired: true,
                  controller: _tagsController,
                  hintText: 'Enter Tags (comma-separated)',
                  labelText: 'Tags',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
