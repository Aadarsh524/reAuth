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
import 'package:reauth/components/popular_auth_card.dart';
import 'package:reauth/constants/auth_category.dart';
import 'package:reauth/models/popular_auth_model.dart';
import 'package:reauth/models/user_auth_model.dart';
import 'package:reauth/pages/auth/addpin_page.dart';
import 'package:reauth/pages/dashboard/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSearchHasValue = false;
  TextEditingController searchController = TextEditingController();
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
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoaded) {
          // Check whether the master PIN is set.
          // (Assuming your ProfileModel now includes a boolean `isMasterPinSet`)
          if (!state.profile.isMasterPinSet) {
            // Show the dialog to ask the user to add a master PIN.
            showGeneralDialog(
              context: context,
              barrierDismissible: true,
              barrierLabel:
                  MaterialLocalizations.of(context).modalBarrierDismissLabel,
              barrierColor: Colors.black54,
              transitionDuration: const Duration(milliseconds: 300),
              pageBuilder: (context, animation, secondaryAnimation) {
                return Center(
                  child: StatefulBuilder(
                    builder: (context, setDialogState) {
                      return AlertDialog(
                        backgroundColor: const Color.fromARGB(255, 72, 80, 93),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        title: Text(
                          "Set Master PIN",
                          style: GoogleFonts.karla(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: Text(
                          "Would you like to add a master PIN for quick and secure access to your saved passwords?",
                          style: GoogleFonts.karla(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
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
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                              // Navigate to AddPinPage
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AddPinPage(),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "Set PIN",
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
                  ),
                );
              },
              transitionBuilder:
                  (context, animation, secondaryAnimation, child) {
                if (animation.status == AnimationStatus.reverse) {
                  return child;
                }
                return ScaleTransition(
                  scale: CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutBack,
                  ),
                  child: child,
                );
              },
            );
          }
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * .95,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header and Profile setup
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
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: profileImage,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              );
                            }
                          }

                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const ProfilePage(),
                                ),
                              );
                            },
                            child: const SizedBox(
                              width: 35,
                              height: 35,
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    AssetImage('assets/defaultAvatar.png'),
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                  // Search Bar setup
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 0.0, vertical: 12),
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
                  // Data Content Section
                  Expanded(
                    child: BlocConsumer<UserAuthCubit, UserAuthState>(
                      listener: (context, state) {
                        if (state is UserAuthLoadFailure) {
                          CustomSnackbar.show(
                            context,
                            message:
                                "Failed to load user providers: ${state.error}",
                            isError: true,
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is UserAuthLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Color.fromARGB(255, 106, 172, 191),
                            ),
                          );
                        } else if (state is UserAuthLoadSuccess &&
                            !isSearchHasValue) {
                          return _buildUserProviders(context, state.auths);
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
      ),
    );
  }

  Widget _buildUserProviders(BuildContext context, List<UserAuthModel> auths) {
    // Group providers by category
    Map<AuthCategory, List<UserAuthModel>> categorizedAuths = {};

    for (var auth in auths) {
      final category = auth.authCategory;
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
        const SizedBox(height: 5),
        Expanded(
          child: ListView.builder(
            itemCount: categorizedAuths.keys.length,
            itemBuilder: (context, index) {
              final category = categorizedAuths.keys.elementAt(index);
              final categoryAuths = categorizedAuths[category];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
                          authCategoryStrings[category] ?? '',
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
                          color: Colors.grey,
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
                CustomSnackbar.show(
                  context,
                  message: "Failed to load user providers: ${state.error}",
                  isError: true,
                );
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
                return Container();
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
        const SizedBox(height: 10),
        PopularAuthCard(
          authModel: provider,
        )
      ],
    );
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
