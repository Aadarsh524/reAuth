import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reauth/bloc/cubit/popular_provider_cubit.dart';
import 'package:reauth/bloc/cubit/profile_cubit.dart';
import 'package:reauth/bloc/cubit/user_provider_cubit.dart';
import 'package:reauth/bloc/states/popular_provider_state.dart';
import 'package:reauth/bloc/states/profile_state.dart';
import 'package:reauth/bloc/states/user_provider_state.dart';
import 'package:reauth/components/authsprovider_card.dart';
import 'package:reauth/components/custom_snackbar.dart';
import 'package:reauth/components/popularprovider_card.dart';
import 'package:reauth/models/popularprovider_model.dart';
import 'package:reauth/models/userprovider_model.dart';
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
    final userProviderCubit = BlocProvider.of<UserProviderCubit>(context);
    userProviderCubit.fetchUserProviders();

    searchController.addListener(() {
      final userProviderCubit = BlocProvider.of<UserProviderCubit>(context);
      if (searchController.text.isEmpty) {
        setState(() {
          isSearchHasValue = false;
          userProviderCubit.fetchUserProviders();
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

                            return SizedBox(
                              width: 30,
                              height: 30.0,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const ProfilePage(),
                                    ),
                                  );
                                },
                                child: profileImage != ''
                                    ? Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                                profileImage),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    : const CircleAvatar(
                                        radius: 50,
                                        backgroundImage: AssetImage(
                                            'assets/defaultAvatar.png'),
                                      ),
                              ),
                            );
                          }
                        }

                        return Container();
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
                      padding: const MaterialStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                      ),
                      controller: searchController,
                      backgroundColor: const MaterialStatePropertyAll(
                        Color.fromARGB(255, 43, 51, 63),
                      ),
                      hintText: "Search",
                      hintStyle: MaterialStatePropertyAll(
                        GoogleFonts.karla(
                          color: const Color.fromARGB(255, 125, 125, 125),
                          fontSize: 16,
                          letterSpacing: .5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      textStyle: MaterialStatePropertyAll(
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
                  child: BlocConsumer<UserProviderCubit, UserProviderState>(
                    listener: (context, state) {
                      if (state is UserProviderLoadFailure) {
                        customSnackbar = CustomSnackbar(
                            "Failed to load user providers: ${state.error}");
                        customSnackbar.showCustomSnackbar(context);
                      }
                    },
                    builder: (context, state) {
                      if (state is UserProviderLoading ||
                          state is UserProviderSearching) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color.fromARGB(255, 106, 172, 191),
                          ),
                        );
                      } else if (state is UserProviderLoadSuccess &&
                          !isSearchHasValue) {
                        if (state.providers.isNotEmpty) {
                          return _buildUserProviders(context, state.providers);
                        } else {
                          // If user providers are empty, render popular providers
                          return BlocConsumer<PopularProviderCubit,
                              PopularProviderState>(
                            listener: (context, state) {
                              if (state is PopularProviderLoadFailure) {
                                customSnackbar = CustomSnackbar(
                                    "Failed to load popular providers: ${state.error}");
                                customSnackbar.showCustomSnackbar(context);
                              }
                            },
                            builder: (context, state) {
                              if (state is PopularProviderLoadSuccess) {
                                return _buildPopularProviders(context);
                              } else if (state
                                  is PopularProviderSearchSuccess) {
                                return _buildPopularSearchResults(
                                    context, state.provider);
                              } else if (state
                                  is PopularProviderSearchFailure) {
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
                      } else if (state is UserProviderSearchSuccess) {
                        return _buildUserSearchResults(context, state.provider);
                      } else if (state is UserProviderSearchFailure) {
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

  Widget _buildUserProviders(
      BuildContext context, List<UserProviderModel> providers) {
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
            itemCount: providers.length,
            itemBuilder: (context, index) {
              final provider = providers[index];
              return AuthsProviderCard(
                providerModel: provider,
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
          child: BlocConsumer<PopularProviderCubit, PopularProviderState>(
            listener: (context, state) {
              if (state is PopularProviderLoadFailure) {
                customSnackbar = CustomSnackbar(
                    "Failed to load popular providers: ${state.error}");
                customSnackbar.showCustomSnackbar(context);
              }
            },
            builder: (context, state) {
              if (state is PopularProviderLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 106, 172, 191),
                  ),
                );
              } else if (state is PopularProviderLoadSuccess) {
                return ListView.builder(
                  itemCount: state.providers.length,
                  itemBuilder: (context, index) {
                    final provider = state.providers[index];
                    return PopularProviderCard(
                      providerModel: provider,
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

  Widget _buildUserSearchResults(
      BuildContext context, UserProviderModel provider) {
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
        AuthsProviderCard(
          providerModel: provider,
        )
      ],
    );
  }

  Widget _buildPopularSearchResults(
      BuildContext context, PopularProviderModel provider) {
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
      PopularProviderCard(
        providerModel: provider,
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
