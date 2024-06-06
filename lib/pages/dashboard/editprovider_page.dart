import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reauth/bloc/cubit/user_provider_cubit.dart';
import 'package:reauth/bloc/states/user_provider_state.dart';
import 'package:reauth/components/custom_snackbar.dart';
import 'package:reauth/components/custom_textfield.dart';
import 'package:reauth/models/userprovider_model.dart';
import 'package:reauth/pages/dashboard/dashboard_page.dart';

class EditProviderPage extends StatefulWidget {
  final UserProviderModel userProviderModel;

  const EditProviderPage({Key? key, required this.userProviderModel})
      : super(key: key);

  @override
  _EditProviderPageState createState() => _EditProviderPageState();
}

class _EditProviderPageState extends State<EditProviderPage> {
  late TextEditingController _providerLinkController;
  late TextEditingController _passwordController;
  late TextEditingController _usernameController;
  late TextEditingController _noteController;
  late TextEditingController _transactionPasswordController;
  late bool hasTransactionPass;
  late TextEditingController _providerCategoryController;

  var authCategories = [
    'Social Media',
    'Ecommerce',
    'Educational',
    'Lifestyle',
    'Productivity',
    'Entertainment',
    'Game',
  ];
  late String dropdownvalue;

  @override
  void initState() {
    super.initState();
    _providerLinkController =
        TextEditingController(text: widget.userProviderModel.authProviderLink);
    _passwordController =
        TextEditingController(text: widget.userProviderModel.password);
    _usernameController =
        TextEditingController(text: widget.userProviderModel.username);
    _noteController =
        TextEditingController(text: widget.userProviderModel.note);
    _transactionPasswordController = TextEditingController(
        text: widget.userProviderModel.transactionPassword);

    _providerCategoryController =
        TextEditingController(text: widget.userProviderModel.providerCategory);
    dropdownvalue = widget.userProviderModel.providerCategory;

    hasTransactionPass = widget.userProviderModel.hasTransactionPassword;
  }

  @override
  void dispose() {
    _providerLinkController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _noteController.dispose();
    _transactionPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProviderCubit = BlocProvider.of<UserProviderCubit>(context);

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
                        UserProviderModel(
                          authName: widget.userProviderModel.authName,
                          username: _usernameController.text,
                          password: _passwordController.text,
                          note: _noteController.text,
                          providerCategory: _providerCategoryController.text,
                          authProviderLink: _providerLinkController.text,
                          faviconUrl: widget.userProviderModel.faviconUrl,
                          hasTransactionPassword:
                              widget.userProviderModel.hasTransactionPassword,
                          transactionPassword:
                              _transactionPasswordController.text,
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
                    )))
          ]),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocListener<UserProviderCubit, UserProviderState>(
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
                        imageUrl: widget.userProviderModel.faviconUrl,
                        height: 50, // Adjust the height as needed
                        width: 50, // Adjust the width as needed
                        fit: BoxFit
                            .cover, // Use BoxFit.cover for a more visually appealing effect
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(), // Placeholder widget while loading
                        errorWidget: (context, url, error) => const Icon(
                            Icons.error), // Widget to show in case of an error
                      ),
                      const SizedBox(
                          height:
                              8), // Add some space between the image and text
                      Text(
                        widget.userProviderModel.authName,
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
                  controller: _usernameController,
                  hintText: 'Enter Auth Username',
                  labelText: 'Username',
                ),
                CustomTextField(
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
                          value:
                              widget.userProviderModel.hasTransactionPassword,
                          onChanged: (value) {
                            setState(() {
                              widget.userProviderModel.hasTransactionPassword =
                                  value!;
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
                    if (widget.userProviderModel.hasTransactionPassword) ...[
                      CustomTextField(
                        controller: _transactionPasswordController,
                        hintText: 'Enter Transaction Password',
                        labelText: 'Transaction Password',
                      ),
                    ],
                  ],
                ),
                CustomTextField(
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
                      value: dropdownvalue,
                      dropdownColor: const Color.fromARGB(255, 53, 64, 79),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      isExpanded: true,
                      // Array list of items
                      items: authCategories.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items,
                              // Customize the style of each item
                              style: GoogleFonts.karla(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 14,
                                  letterSpacing: .75,
                                  fontWeight: FontWeight.w600)),
                        );
                      }).toList(),
                      style: GoogleFonts.karla(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontSize: 14,
                          letterSpacing: .75,
                          fontWeight: FontWeight.w600),
                      underline: Container(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownvalue = newValue!;
                          _providerCategoryController.text = dropdownvalue;
                        });
                      },
                    ),
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
