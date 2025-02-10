import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reauth/components/AuthCategory/bloc/cubit/user_auth_cubit.dart';
import 'package:reauth/components/AuthCategory/bloc/states/user_auth_state.dart';
import 'package:reauth/components/custom_snackbar.dart';

import 'package:reauth/components/custom_textfield.dart';

import 'package:reauth/components/password_suggestion.dart';
import 'package:reauth/models/user_auth_model.dart';

import 'package:reauth/utils/strength_checker.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({Key? key}) : super(key: key);

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _passwordController = TextEditingController();
  List<String> allPasswords = [];

  List<UserAuthModel> strongPasswords = [];
  List<UserAuthModel> weakPasswords = [];
  Color strongTabColor = Colors.green;
  Color weakTabColor = Colors.red;

  late TabController _tabController;
  Color appBarColor = Colors.green;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserAuthCubit>(context).fetchUserAuths();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    setState(() {
      appBarColor = _tabController.index == 0 ? strongTabColor : weakTabColor;
    });
  }

  void classifyPasswords(List<UserAuthModel> auths) {
    strongPasswords.clear();
    weakPasswords.clear();

    for (var auth in auths) {
      if (checkPasswordStrength(auth.password) > 3) {
        strongPasswords.add(auth);
      } else {
        weakPasswords.add(auth);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Security"),
        backgroundColor: const Color.fromARGB(255, 40, 50, 65),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<UserAuthCubit, UserAuthState>(
            builder: (context, state) {
              if (state is UserAuthLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 106, 172, 191),
                  ),
                );
              } else if (state is UserAuthLoadSuccess) {
                allPasswords =
                    state.auths.map((auth) => auth.password).toList();

                classifyPasswords(state.auths);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your Passwords Security Type",
                      style: GoogleFonts.karla(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Scaffold(
                        appBar: PreferredSize(
                          preferredSize: const Size.fromHeight(50.0),
                          child: AppBar(
                            backgroundColor: appBarColor,
                            flexibleSpace: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    appBarColor.withOpacity(0.7),
                                    appBarColor,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                            ),
                            bottom: TabBar(
                              controller: _tabController,
                              indicator: const UnderlineTabIndicator(
                                borderSide: BorderSide(
                                  width: 4.0,
                                  color: Colors.white,
                                ),
                                insets: EdgeInsets.symmetric(horizontal: 16.0),
                              ),
                              indicatorWeight: 4.0,
                              indicatorSize: TabBarIndicatorSize.label,
                              labelColor: Colors.white,
                              unselectedLabelColor: Colors.white70,
                              labelPadding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              tabs: [
                                Tab(
                                  child: Text(
                                    "Strong Passwords (${strongPasswords.length})",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.karla(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    "Weak Passwords (${weakPasswords.length})",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.karla(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        body: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildPasswordsList(
                                strongPasswords, strongPasswords.length,
                                isStrong: true),
                            _buildPasswordsList(
                                weakPasswords, weakPasswords.length,
                                isStrong: false),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              } else if (state is UserAuthLoadFailure) {
                return Center(
                  child: Text(
                    state.error,
                    style: GoogleFonts.karla(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
              return Center(
                child: Text("No auth Added",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.karla(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordsList(List<UserAuthModel> auths, int passwordCount,
      {required bool isStrong}) {
    if (passwordCount == 0) {
      return Center(
        child: isStrong
            ? const Column(
                children: [
                  SizedBox(height: 20),
                  PasswordSuggestions(),
                ],
              )
            : Center(
                child: Text(
                  "Congratulations, you have strong passwords!!!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.karla(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: ListView.builder(
        itemCount: auths.length,
        itemBuilder: (context, index) {
          final auth = auths[index];
          final color = isStrong ? Colors.green : Colors.red;
          final strengthText = isStrong ? "Strong" : "Weak";

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 50, 60, 75),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              trailing: IconButton(
                onPressed: () {
                  showChangePasswordDialog(context, auth);
                },
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
              ),
              leading: SizedBox(
                width: 50,
                height: 50,
                child: CachedNetworkImage(
                  imageUrl: auth.userAuthFavicon!,
                  height: 60,
                  fit: BoxFit.contain,
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/error.png',
                    height: 60,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              title: Text(
                auth.authName.toUpperCase(),
                style: GoogleFonts.karla(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                "Strength: $strengthText",
                style: GoogleFonts.karla(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

void showChangePasswordDialog(
    BuildContext context, UserAuthModel userauthModel) {
  final userauthCubit = BlocProvider.of<UserAuthCubit>(context);
  final TextEditingController passwordController = TextEditingController();

  // List of password suggestions
  final List<Map<String, dynamic>> suggestions = [
    {"text": "Use at least 8 characters.", "icon": Icons.security},
    {
      "text": "Include both upper and lower case characters.",
      "icon": Icons.text_fields
    },
    {"text": "Include at least one number.", "icon": Icons.looks_one},
    {"text": "Include at least one special character.", "icon": Icons.star},
  ];

  // Create a boolean list for each suggestion's validation state.
  final List<bool> validations =
      List.generate(suggestions.length, (_) => false);

  // Checks if the entered password meets all criteria.
  bool isPasswordValid(String password) {
    validations[0] = password.length >= 8;
    validations[1] = password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[a-z]'));
    validations[2] = password.contains(RegExp(r'\d'));
    validations[3] = password.contains(RegExp(r'[!@#\$&*~]'));
    return validations.every((element) => element);
  }

  String? error;

  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54, // Dark overlay color
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Center(
        child: StatefulBuilder(
          builder: (context, setState) {
            return BlocConsumer<UserAuthCubit, UserAuthState>(
              listener: (context, state) {
                if (state is UserAuthUpdateSuccess) {
                  Navigator.of(context).pop();
                  userauthCubit.fetchUserAuths();
                  CustomSnackbar.show(
                    context,
                    message: "Password change success",
                  );
                }
                if (state is UserAuthUpdateFailure) {
                  setState(() {
                    error = state.error.toString();
                  });
                }
              },
              builder: (context, state) {
                final isSubmitting = state is UserAuthUpdateInProgress;

                return AlertDialog(
                  backgroundColor: const Color.fromARGB(255, 72, 80, 93),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: Text(
                    "Change Password",
                    style: GoogleFonts.karla(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomTextField(
                          isRequired: true,
                          keyboardType: TextInputType.text,
                          controller: passwordController,
                          hintText: 'Enter New Password',
                          labelText: 'New Password',
                          onChanged: (password) {
                            setState(() {
                              // If the password is empty, set error; otherwise, clear it.
                              if (password.isEmpty) {
                                error =
                                    "Please fulfill all password requirements";
                              } else {
                                error = null;
                              }
                              // Update the validations.
                              isPasswordValid(password);
                            });
                          },
                        ),
                        // Display the suggestions only if there is input.
                        if (passwordController.text.isNotEmpty)
                          ...suggestions.map((suggestion) {
                            final index = suggestions.indexOf(suggestion);
                            return Row(
                              children: [
                                Icon(
                                  validations[index]
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  color: validations[index]
                                      ? Colors.green
                                      : Colors.red,
                                  size: 16,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    suggestion['text'],
                                    style: GoogleFonts.karla(
                                      color: validations[index]
                                          ? Colors.green
                                          : Colors.red,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        // Show error message if localError is set.
                        if (error != null)
                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                error!,
                                style: GoogleFonts.karla(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: isSubmitting
                          ? null
                          : () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: Colors.red),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.karla(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: isSubmitting
                          ? null
                          : () {
                              if (passwordController.text.isEmpty) {
                                setState(() {
                                  error = "Please enter new password to save.";
                                });
                                return;
                              }

                              userauthCubit.editAuth(
                                UserAuthModel(
                                  authName: userauthModel.authName,
                                  username: userauthModel.username,
                                  password: passwordController.text,
                                  note: userauthModel.note,
                                  authLink: userauthModel.authLink,
                                  userAuthFavicon:
                                      userauthModel.userAuthFavicon,
                                  hasTransactionPassword:
                                      userauthModel.hasTransactionPassword,
                                  transactionPassword:
                                      userauthModel.transactionPassword,
                                  authCategory: userauthModel.authCategory,
                                  createdAt: userauthModel.createdAt,
                                  updatedAt: DateTime.now(),
                                  isFavorite: false,
                                  lastAccessed: userauthModel.createdAt,
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 111, 163, 219),
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
                              "Save",
                              style: GoogleFonts.karla(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      );
    },
  );
}
