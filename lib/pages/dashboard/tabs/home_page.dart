import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reauth/bloc/cubit/provider_cubit.dart';
import 'package:reauth/bloc/cubit/recentprovider_cubit.dart';
import 'package:reauth/bloc/states/provider_state.dart';
import 'package:reauth/components/authsprovider_card.dart';
import 'package:reauth/components/popularprovider_card.dart';
import 'package:reauth/pages/dashboard/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSearchHasValue = false;
  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.text = '';
    searchController.clear();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<RecentProviderCubit>(context).fetchUserRecentProviders();
    BlocProvider.of<ProviderCubit>(context).fetchPopularProviders();
    BlocProvider.of<ProviderCubit>(context).fetchUserProviders();
  }

  @override
  Widget build(BuildContext context) {
    final providerCubit = BlocProvider.of<ProviderCubit>(context);

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
                    SizedBox(
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
                        child: CircleAvatar(
                          radius: 50.0,
                          child: Image.asset(
                              fit: BoxFit.contain, 'assets/defaultAvatar.png'),
                        ),
                      ),
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
                        onChanged: (e) {
                          if (e.isEmpty) {
                            setState(() {
                              isSearchHasValue = false;
                              providerCubit.fetchUserProviders();
                            });
                          } else {
                            setState(() {
                              isSearchHasValue = true;
                            });
                            providerCubit.searchUserAuth(searchController.text);
                          }
                        },
                        backgroundColor: const MaterialStatePropertyAll(
                            Color.fromARGB(255, 43, 51, 63)),
                        hintText: "Search",
                        hintStyle: MaterialStatePropertyAll(GoogleFonts.karla(
                            color: const Color.fromARGB(255, 125, 125, 125),
                            fontSize: 16,
                            letterSpacing: .5,
                            fontWeight: FontWeight.w600)),
                        textStyle: MaterialStatePropertyAll(GoogleFonts.karla(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontSize: 16,
                            letterSpacing: .5,
                            fontWeight: FontWeight.w600)),
                        trailing: [
                          Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: Icon(Icons.search,
                                color: isSearchHasValue
                                    ? const Color.fromARGB(255, 255, 255, 255)
                                    : const Color.fromARGB(255, 125, 125, 125)),
                          )
                        ]),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                BlocConsumer<ProviderCubit, ProviderState>(
                  listener: (context, state) {
                    if (state is ProviderLoadFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Failed to load providers: ${state.error}',
                          ),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is ProviderLoadSuccess && !isSearchHasValue) {
                      if (state.providers.isEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Popular Providers",
                              style: GoogleFonts.karla(
                                  color:
                                      const Color.fromARGB(255, 125, 125, 125),
                                  fontSize: 18,
                                  letterSpacing: .75,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 10),
                          ],
                        );
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Your Auths",
                              style: GoogleFonts.karla(
                                  color:
                                      const Color.fromARGB(255, 125, 125, 125),
                                  fontSize: 18,
                                  letterSpacing: .75,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 10),
                          ],
                        );
                      }
                    } else if (state is PopularProviderLoadSuccess &&
                        !isSearchHasValue) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Popular Providers",
                            style: GoogleFonts.karla(
                                color: const Color.fromARGB(255, 125, 125, 125),
                                fontSize: 18,
                                letterSpacing: .75,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    } else {
                      return const SizedBox
                          .shrink(); // Placeholder for other states
                    }
                  },
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: BlocConsumer<ProviderCubit, ProviderState>(
                      listener: (context, state) {
                        if (state is ProviderLoadFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Failed to load providers: ${state.error}')),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is ProviderLoading) {
                          return const Center(
                              child: CircularProgressIndicator(
                                  color: Color.fromARGB(255, 106, 172, 191)));
                        } else if (state is ProviderLoadSuccess &&
                            !isSearchHasValue) {
                          if (state.providers.isEmpty) {
                            return _buildPopularProviders(context);
                          }
                          return ListView.builder(
                            itemCount: state.providers.length,
                            itemBuilder: (context, index) {
                              final provider = state.providers[index];
                              return AuthsProviderCard(
                                providerModel: provider,
                              );
                            },
                          );
                        } else if (state is Searching) {
                          return const Center(
                              child: CircularProgressIndicator(
                                  color: Color.fromARGB(255, 106, 172, 191)));
                        } else if (state is UserProviderSearchSuccess) {
                          return ListView.builder(
                            itemCount: state.providers.length,
                            itemBuilder: (context, index) {
                              final provider = state.providers[index];
                              return AuthsProviderCard(
                                providerModel: provider,
                              );
                            },
                          );
                        } else if (state is PopularProviderLoadSuccess &&
                            !isSearchHasValue) {
                          return ListView.builder(
                            itemCount: state.providers.length,
                            itemBuilder: (context, index) {
                              final provider = state.providers[index];
                              return PopularProviderCard(
                                providerModel: provider,
                              );
                            },
                          );
                        } else if (state is PopularProviderSearchSuccess) {
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPopularProviders(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Expanded(
          child: BlocConsumer<ProviderCubit, ProviderState>(
            listener: (context, state) {
              if (state is ProviderLoadFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'Failed to load popular providers: ${state.error}')),
                );
              }
            },
            builder: (context, state) {
              if (state is ProviderLoading) {
                return const Center(
                    child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 106, 172, 191)));
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
}
