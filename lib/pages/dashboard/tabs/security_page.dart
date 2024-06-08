import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reauth/bloc/cubit/user_provider_cubit.dart';
import 'package:reauth/bloc/states/user_provider_state.dart';
import 'package:reauth/components/custom_textfield.dart';

import 'package:reauth/components/password_suggestion.dart';
import 'package:reauth/models/userprovider_model.dart';
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

  List<UserProviderModel> strongPasswords = [];
  List<UserProviderModel> weakPasswords = [];
  Color strongTabColor = Colors.green;
  Color weakTabColor = Colors.red;

  late TabController _tabController;
  Color appBarColor = Colors.green;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserProviderCubit>(context).fetchUserProviders();
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

  void classifyPasswords(List<UserProviderModel> providers) {
    strongPasswords.clear();
    weakPasswords.clear();

    for (var provider in providers) {
      if (checkPasswordStrength(provider.password) >= 3) {
        strongPasswords.add(provider);
      } else {
        weakPasswords.add(provider);
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
          child: BlocBuilder<UserProviderCubit, UserProviderState>(
            builder: (context, state) {
              if (state is UserProviderLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 106, 172, 191),
                  ),
                );
              } else if (state is UserProviderLoadSuccess) {
                allPasswords = state.providers
                    .map((provider) => provider.password)
                    .toList();

                classifyPasswords(state.providers);

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
              } else if (state is UserProviderLoadFailure) {
                return Center(
                  child: Text(
                    state.error,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }
              return Text("No Provider Added",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.karla(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ));
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordsList(
      List<UserProviderModel> providers, int passwordCount,
      {required bool isStrong}) {
    if (passwordCount == 0) {
      return Center(
        child: isStrong
            ? const Column(
                children: [
                  SizedBox(height: 20),
                  Text(
                    "Please improve your password",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  PasswordSuggestions(),
                ],
              )
            : const Text(
                "Congratulations, you have strong passwords!!!",
                style: TextStyle(color: Colors.white),
              ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: ListView.builder(
        itemCount: providers.length,
        itemBuilder: (context, index) {
          final provider = providers[index];
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
                  _showChangePasswordDialog(context, provider);
                },
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
              ),
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(provider.faviconUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(
                provider.authName.toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                "Strength: $strengthText",
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  letterSpacing: 0.75,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

void _showChangePasswordDialog(
    BuildContext context, UserProviderModel userProviderModel) {
  final userProviderCubit = BlocProvider.of<UserProviderCubit>(context);
  final TextEditingController passwordController = TextEditingController();

  final List<Map<String, dynamic>> suggestions = [
    {"text": "Use at least 8 characters.", "icon": Icons.security},
    {
      "text": "Include both upper and lower case characters.",
      "icon": Icons.text_fields
    },
    {"text": "Include at least one number.", "icon": Icons.looks_one},
    {"text": "Include at least one special character.", "icon": Icons.star},
  ];

  final List<bool> validations =
      List.generate(suggestions.length, (_) => false);

  bool isPasswordValid(String password) {
    validations[0] = password.length >= 8;
    validations[1] = password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[a-z]'));
    validations[2] = password.contains(RegExp(r'\d'));
    validations[3] = password.contains(RegExp(r'[!@#\$&*~]'));
    return validations.every((element) => element);
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: const Color.fromARGB(255, 72, 80, 93),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              "Change Password",
              style: TextStyle(
                fontSize: 16, // Smaller font size
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: userProviderModel.faviconUrl,
                        width: 40,
                        height: 40,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => Container(
                          width: 40,
                          height: 40,
                          color: Colors.grey[300],
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  CustomTextField(
                    keyboardType: TextInputType.text,
                    controller: passwordController,
                    hintText: 'Enter New Password',
                    labelText: 'New Password',
                    onChanged: (password) {
                      setState(() {
                        isPasswordValid(password);
                      });
                    },
                  ),
                  if (passwordController.text.isNotEmpty)
                    ...suggestions.map((suggestion) {
                      int index = suggestions.indexOf(suggestion);
                      return Row(
                        children: [
                          Icon(
                            validations[index]
                                ? Icons.check_circle
                                : Icons.cancel,
                            color:
                                validations[index] ? Colors.green : Colors.red,
                            size: 16, // Smaller icon size
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              suggestion['text'],
                              style: TextStyle(
                                color: validations[index]
                                    ? Colors.green
                                    : Colors.red,
                                fontSize: 10, // Smaller font size
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  userProviderCubit.editProvider(
                    UserProviderModel(
                      authName: userProviderModel.authName,
                      username: userProviderModel.username,
                      password: passwordController.text,
                      note: userProviderModel.note,
                      providerCategory: userProviderModel.providerCategory,
                      authProviderLink: userProviderModel.authProviderLink,
                      faviconUrl: userProviderModel.faviconUrl,
                      hasTransactionPassword:
                          userProviderModel.hasTransactionPassword,
                      transactionPassword:
                          userProviderModel.transactionPassword,
                    ),
                  );
                  Navigator.of(context).pop();
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
                child: const Text(
                  "Save",
                  style: TextStyle(
                    fontSize: 14, // Smaller font size
                    color: Color.fromARGB(255, 111, 163, 219),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(
                      color: Colors.red,
                    ),
                  ),
                ),
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    fontSize: 14, // Smaller font size
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
