import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reauth/bloc/cubit/popular_auth_cubit.dart';
import 'package:reauth/bloc/cubit/profile_cubit.dart';
import 'package:reauth/bloc/cubit/user_auth_cubit.dart';
import 'package:reauth/bloc/states/popular_provider_state.dart';
import 'package:reauth/bloc/states/profile_state.dart';
import 'package:reauth/bloc/states/user_auth_state.dart';
import 'package:reauth/components/auths_card.dart';
import 'package:reauth/components/custom_snackbar.dart';
import 'package:reauth/components/popularprovider_card.dart';
import 'package:reauth/constants/auth_category.dart';
import 'package:reauth/models/popular_auth_model.dart';
import 'package:reauth/models/user_auth_model.dart';
import 'package:reauth/pages/dashboard/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSearchHasValue = false;
  TextEditingController searchController = TextEditingController();
  CustomSnackbar customSnackbar = CustomSnackbar('');
  String profileImage = '';

  @override
  void initState() {
    super.initState();
    final userProviderCubit = BlocProvider.of<UserAuthCubit>(context);
    final userProfileCubit = BlocProvider.of<ProfileCubit>(context);
    userProviderCubit.fetchUserAuths();
    userProfileCubit.fetchProfile();

    searchController.addListener(() {
      final userProviderCubit = BlocProvider.of<UserAuthCubit>(context);
      if (searchController.text.isEmpty) {
        setState(() {
          isSearchHasValue = false;
          userProviderCubit.fetchUserAuths();
        });
      } else {
        setState(() {
          isSearchHasValue = true;
          userProviderCubit.searchUserAuth(searchController.text);
        });
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * .95,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ReAuth",
                      style: GoogleFonts.karla(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontSize: 25,
                          letterSpacing: .75,
                          fontWeight: FontWeight.w600),
                    ),
                    BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) {
                        if (state is ProfileLoaded) {
                          if (state.profile.profileImage != '') {
                            profileImage =
                                state.profile.profileImage.toString();

                            return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const ProfilePage(),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                          profileImage),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ));
                          }
                        }

                        return const SizedBox(
                          width: 35,
                          height: 35,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                AssetImage('assets/defaultAvatar.png'),
                          ),
                        );
                      },
                    )
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0.0, vertical: 12),
                  child: SizedBox(
                    height: 50,
                    child: SearchBar(
                      padding: const WidgetStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                      ),
                      controller: searchController,
                      backgroundColor: const WidgetStatePropertyAll(
                        Color.fromARGB(255, 43, 51, 63),
                      ),
                      hintText: "Search",
                      hintStyle: WidgetStatePropertyAll(
                        GoogleFonts.karla(
                          color: const Color.fromARGB(255, 125, 125, 125),
                          fontSize: 16,
                          letterSpacing: .5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      textStyle: WidgetStatePropertyAll(
                        GoogleFonts.karla(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontSize: 16,
                          letterSpacing: .5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: [
                        Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: Icon(
                            Icons.search,
                            color: isSearchHasValue
                                ? const Color.fromARGB(255, 255, 255, 255)
                                : const Color.fromARGB(255, 125, 125, 125),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: BlocConsumer<UserAuthCubit, UserAuthState>(
                    listener: (context, state) {
                      if (state is UserAuthLoadFailure) {
                        customSnackbar = CustomSnackbar(
                            "Failed to load user providers: ${state.error}");
                        customSnackbar.showCustomSnackbar(context);
                      }
                    },
                    builder: (context, state) {
                      if (state is UserAuthLoading ||
                          state is UserAuthSearching) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color.fromARGB(255, 106, 172, 191),
                          ),
                        );
                      } else if (state is UserAuthLoadSuccess &&
                          !isSearchHasValue) {
                        if (state.auths.isNotEmpty) {
                          return _buildUserProviders(context, state.auths);
                        } else {
                          // If user providers are empty, render popular providers
                          return BlocConsumer<PopularAuthCubit,
                              PopularAuthState>(
                            listener: (context, state) {
                              if (state is PopularAuthLoadFailure) {
                                customSnackbar = CustomSnackbar(
                                    "Failed to load popular providers: ${state.error}");
                                customSnackbar.showCustomSnackbar(context);
                              }
                            },
                            builder: (context, state) {
                              if (state is PopularAuthLoadSuccess) {
                                return _buildPopularProviders(context);
                              } else if (state is PopularAuthSearchSuccess) {
                                return _buildPopularSearchResults(
                                    context, state.auth);
                              } else if (state is PopularAuthSearchFailure) {
                                return _buildSearchFailure(
                                    context, state.error);
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: Color.fromARGB(255, 106, 172, 191),
                                  ),
                                );
                              }
                            },
                          );
                        }
                      } else if (state is UserAuthSearchSuccess) {
                        return _buildUserSearchResults(context, state.auth);
                      } else if (state is UserAuthSearchFailure) {
                        return _buildSearchFailure(context, state.error);
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color.fromARGB(255, 106, 172, 191),
                          ),
                        );
                      }
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

  Widget _buildUserProviders(BuildContext context, List<UserAuthModel> auths) {
    // Group providers by category
    Map<AuthCategory, List<UserAuthModel>> categorizedAuths = {};

    for (var auth in auths) {
      final category = auth.authCategory; // Use AuthCategory enum directly
      if (categorizedAuths.containsKey(category)) {
        categorizedAuths[category]?.add(auth);
      } else {
        categorizedAuths[category] = [auth];
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Your Auths",
          style: GoogleFonts.karla(
            color: const Color.fromARGB(255, 125, 125, 125),
            fontSize: 18,
            letterSpacing: .75,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: categorizedAuths.keys.length,
            itemBuilder: (context, index) {
              final category = categorizedAuths.keys.elementAt(index);
              final categoryAuths = categorizedAuths[category];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display category name and divider

                  // Display auths under each category
                  ListView.builder(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(), // Disable scrolling here
                    itemCount: categoryAuths!.length,
                    itemBuilder: (context, authIndex) {
                      final provider = categoryAuths[authIndex];
                      return AuthsCard(providerModel: provider);
                    },
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          authCategoryStrings[category] ??
                              '', // Get category name from map
                          style: GoogleFonts.karla(
                            color: const Color.fromARGB(255, 125, 125, 125),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Colors.grey, // Divider color
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPopularProviders(BuildContext context) {
    CustomSnackbar customSnackbar = CustomSnackbar('');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Popular Auths",
          style: GoogleFonts.karla(
            color: const Color.fromARGB(255, 125, 125, 125),
            fontSize: 18,
            letterSpacing: .75,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: BlocConsumer<PopularAuthCubit, PopularAuthState>(
            listener: (context, state) {
              if (state is PopularAuthLoadFailure) {
                customSnackbar = CustomSnackbar(
                    "Failed to load popular providers: ${state.error}");
                customSnackbar.showCustomSnackbar(context);
              }
            },
            builder: (context, state) {
              if (state is PopularAuthLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 106, 172, 191),
                  ),
                );
              } else if (state is PopularAuthLoadSuccess) {
                return ListView.builder(
                  itemCount: state.auths.length,
                  itemBuilder: (context, index) {
                    final provider = state.auths[index];
                    return PopularAuthCard(
                      authModel: provider,
                    );
                  },
                );
              } else {
                return Container(); // Placeholder for other states
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUserSearchResults(BuildContext context, UserAuthModel provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Search Results",
          style: GoogleFonts.karla(
            color: const Color.fromARGB(255, 125, 125, 125),
            fontSize: 18,
            letterSpacing: .75,
            fontWeight: FontWeight.w600,
          ),
        ),
        AuthsCard(
          providerModel: provider,
        )
      ],
    );
  }

  Widget _buildPopularSearchResults(
      BuildContext context, PopularAuthModel provider) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Search Results",
        style: GoogleFonts.karla(
          color: const Color.fromARGB(255, 125, 125, 125),
          fontSize: 18,
          letterSpacing: .75,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 10),
      PopularAuthCard(
        authModel: provider,
      )
    ]);
  }

  Widget _buildSearchFailure(BuildContext context, String error) {
    return Center(
      child: Text(
        error,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}
