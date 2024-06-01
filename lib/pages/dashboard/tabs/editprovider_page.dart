import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reauth/bloc/cubit/popular_provider_cubit.dart';

import 'package:reauth/bloc/states/popular_provider_state.dart';
import 'package:reauth/components/custom_snackbar.dart';
import 'package:reauth/components/popularprovider_card.dart';
import 'package:reauth/pages/addprovider_page.dart';

class EditProviderPage extends StatefulWidget {
  const EditProviderPage({Key? key}) : super(key: key);

  @override
  State<EditProviderPage> createState() => _EditProviderPageState();
}

class _EditProviderPageState extends State<EditProviderPage> {
  bool isSearchHasValue = false;
  TextEditingController searchController = TextEditingController();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  CustomSnackbar customSnackbar = CustomSnackbar('');

  @override
  Widget build(BuildContext context) {
    final popularProviderCubit = BlocProvider.of<PopularProviderCubit>(context);
    if (!isSearchHasValue) {
      popularProviderCubit.fetchPopularProviders();
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * .95,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Add Auths",
                  style: GoogleFonts.karla(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontSize: 25,
                      letterSpacing: .75,
                      fontWeight: FontWeight.w600),
                ),
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 20.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: SizedBox(
                          height: 50,
                          width: 50,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(8.0),
                                  side: const BorderSide(
                                      color:
                                          Color.fromARGB(255, 106, 172, 191)),
                                  backgroundColor:
                                      const Color.fromARGB(255, 106, 172, 191)),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AddProviderPage(),
                                  ),
                                );
                              },
                              child: const Icon(
                                Icons.add_circle,
                                color: Color.fromARGB(255, 43, 51, 63),
                              ))),
                    ),
                  ),
                ),
                Text(
                  "Popular Auths",
                  style: GoogleFonts.karla(
                      color: const Color.fromARGB(255, 125, 125, 125),
                      fontSize: 18,
                      letterSpacing: .75,
                      fontWeight: FontWeight.w600),
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
                            // popularProviderCubit
                            //     .searchPopularAuth(searchController.text);
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
                SizedBox(
                    height: MediaQuery.of(context).size.height * .55,
                    width: MediaQuery.of(context).size.width,
                    child: BlocConsumer<PopularProviderCubit,
                        PopularProviderState>(listener: (context, state) {
                      if (state is PopularProviderLoadFailure) {
                        customSnackbar = CustomSnackbar(
                            "Failed to load popular providers: ${state.error}");
                        customSnackbar.showCustomSnackbar(context);
                      }
                    }, builder: (context, state) {
                      if (state is PopularProviderLoading) {
                        return const Center(
                            child: CircularProgressIndicator(
                                color: Color.fromARGB(255, 106, 172, 191)));
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
                      } else if (state is PopularProviderSearching) {
                        return const Center(
                            child: CircularProgressIndicator(
                                color: Color.fromARGB(255, 106, 172, 191)));
                      } else if (state is PopularProviderSearchSuccess) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            PopularProviderCard(
                              providerModel: state.provider,
                            ),
                          ],
                        );
                      } else {
                        return Container(); // Placeholder for other states
                      }
                    }))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
