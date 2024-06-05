import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reauth/bloc/cubit/user_provider_cubit.dart';
import 'package:reauth/bloc/states/user_provider_state.dart';
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
  Color appBarColor = Colors.green; // Default color for strong passwords

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
      appBarColor = _tabController.index == 0 ? Colors.green : Colors.red;
    });
  }

  void classifyPasswords(List<UserProviderModel> providers) {
    strongPasswords.clear();
    weakPasswords.clear();

    for (var provider in providers) {
      if (checkPasswordStrength(provider.password) == 1) {
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
          child: ListView(
            children: [
              _buildPasswordsSecurityChecker(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordsSecurityChecker() {
    return Card(
      color: const Color.fromARGB(255, 40, 50, 65),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
            const SizedBox(height: 10),
            BlocBuilder<UserProviderCubit, UserProviderState>(
              builder: (context, state) {
                if (state is UserProviderLoading) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 106, 172, 191),
                  ));
                } else if (state is UserProviderLoadSuccess) {
                  allPasswords = state.providers
                      .map((provider) => provider.password)
                      .toList();

                  classifyPasswords(state.providers);

                  return Column(
                    children: [
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 600,
                        child: Scaffold(
                          appBar: PreferredSize(
                            preferredSize: const Size.fromHeight(50.0),
                            child: AppBar(
                              backgroundColor: _tabController.index == 0
                                  ? strongTabColor
                                  : weakTabColor,
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
                                    color:
                                        Colors.white, // Color of the underline
                                  ),
                                  insets:
                                      EdgeInsets.symmetric(horizontal: 16.0),
                                ),
                                indicatorWeight: 4.0,
                                indicatorSize: TabBarIndicatorSize.label,
                                labelColor: Colors.white,
                                unselectedLabelColor: Colors.white70,
                                labelPadding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
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
                                  weakPasswords, strongPasswords.length,
                                  isStrong: false),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                } else if (state is UserProviderLoadFailure) {
                  return Text(
                    state.error,
                    style: const TextStyle(color: Colors.red),
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordsList(
      List<UserProviderModel> providers, int passwordCount,
      {required bool isStrong}) {
    if (passwordCount == 0 && isStrong) {
      return Expanded(child: Center(child: _buildPasswordSuggestions()));
    }
    if (passwordCount == 0 && isStrong) {
      return const Expanded(
          child: Center(
              child: Text("Congratulations, you have strong passwords")));
    }
    return ListView.builder(
      itemCount: providers.length,
      itemBuilder: (context, index) {
        final provider = providers[index];
        final color = isStrong ? Colors.green : Colors.red;
        final strengthText = isStrong ? "Strong" : "Weak";

        return ListTile(
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
            provider.authName,
            style: TextStyle(color: color),
          ),
          subtitle: Text(
            "Strength: $strengthText",
            style: TextStyle(color: color),
          ),
          onTap: () {
            // Implement onTap functionality here
          },
        );
      },
    );
  }
}

Widget _buildPasswordSuggestions() {
  List<Map<String, dynamic>> suggestions = [
    {"text": "Use at least 12 characters.", "icon": Icons.security},
    {
      "text": "Include both upper and lower case characters.",
      "icon": Icons.text_fields
    },
    {"text": "Include at least one number.", "icon": Icons.looks_one},
    {"text": "Include at least one special character.", "icon": Icons.star},
  ];

  return Card(
    color: const Color.fromARGB(255, 40, 50, 65),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb, color: Colors.yellow, size: 24),
              SizedBox(width: 10),
              Text(
                "Password Suggestions",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...suggestions.map((suggestion) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Icon(suggestion["icon"], color: Colors.white, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        suggestion["text"],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    ),
  );
}
