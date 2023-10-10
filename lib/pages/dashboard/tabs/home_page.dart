import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reauth/bloc/cubit/provider_cubit.dart';
import 'package:reauth/bloc/states/provider_state.dart';
import 'package:reauth/components/authsprovider_card.dart';
import 'package:reauth/components/authsproviderimage_card.dart';

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
    searchController.dispose();
    super.dispose();
  }

  final List auths = [
    {
      "providerImage": "http://pngimg.com/uploads/google/google_PNG19635.png",
      "providerName": "Facebook",
      "providerId": "aadarshghimire524@gmail.com"
    },
    {
      "providerImage": "http://pngimg.com/uploads/google/google_PNG19635.png",
      "providerName": "Google",
      "providerId": "aadarshghimire524@gmail.com"
    },
    {
      "providerImage": "http://pngimg.com/uploads/google/google_PNG19635.png",
      "providerName": "Github",
      "providerId": "aadarshghimire524@gmail.com"
    }
  ];

  @override
  Widget build(BuildContext context) {
    final providerCubit = BlocProvider.of<ProviderCubit>(context);
    providerCubit.fetchProviders();
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
                      child: CircleAvatar(
                        radius: 50.0,
                        child: Image.asset(
                            fit: BoxFit.contain, 'assets/splash.png'),
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
                            });
                          } else {
                            setState(() {
                              isSearchHasValue = true;
                            });
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
                Text(
                  "Recently Used",
                  style: GoogleFonts.karla(
                      color: const Color.fromARGB(255, 125, 125, 125),
                      fontSize: 18,
                      letterSpacing: .75,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 5,
                ),
                BlocConsumer<ProviderCubit, ProviderState>(
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
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ProviderLoadSuccess) {
                      return SizedBox(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.providers.length,
                          itemBuilder: (BuildContext context, int index) {
                            final provider = state.providers[index];

                            return AuthsProviderImageCard(
                              providerImage: provider.faviconUrl,
                            );
                          },
                        ),
                      );
                    } else {
                      return Container(); // Placeholder for other states
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Your Auths",
                  style: GoogleFonts.karla(
                      color: const Color.fromARGB(255, 125, 125, 125),
                      fontSize: 18,
                      letterSpacing: .75,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .45,
                  width: MediaQuery.of(context).size.width,
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
                              child: CircularProgressIndicator());
                        } else if (state is ProviderLoadSuccess) {
                          return ListView.builder(
                            itemCount: state.providers.length,
                            itemBuilder: (context, index) {
                              final provider = state.providers[index];

                              return AuthsProviderCard(
                                providerImage: provider.faviconUrl,
                                providerName: provider.authProviderLink,
                                providerId: provider.username,
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
}
