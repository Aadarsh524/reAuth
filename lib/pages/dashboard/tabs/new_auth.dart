import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reauth/bloc/cubit/authentication_cubit.dart';
import 'package:reauth/bloc/cubit/popular_auth_cubit.dart';
import 'package:reauth/bloc/states/popular_provider_state.dart';

import 'package:reauth/components/custom_snackbar.dart';
import 'package:reauth/components/popular_auth_card.dart';
import 'package:reauth/pages/dashboard/add_auth_page.dart';

class NewAuthPage extends StatefulWidget {
  const NewAuthPage({Key? key}) : super(key: key);

  @override
  State<NewAuthPage> createState() => _NewProviderPageState();
}

class _NewProviderPageState extends State<NewAuthPage> {
  bool isSearchHasValue = false;
  TextEditingController searchController = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    final popularAuthCubit = BlocProvider.of<PopularAuthCubit>(context);
    popularAuthCubit.fetchPopularAuths();

    searchController.addListener(() {
      final userProviderCubit = BlocProvider.of<PopularAuthCubit>(context);
      if (searchController.text.isEmpty) {
        setState(() {
          isSearchHasValue = false;
          userProviderCubit.fetchPopularAuths();
        });
      } else {
        setState(() {
          isSearchHasValue = true;
          userProviderCubit.searchPopularAuth(searchController.text);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Add Auths",
                      style: GoogleFonts.karla(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontSize: 25,
                          letterSpacing: .75,
                          fontWeight: FontWeight.w600),
                    ),
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
                                    color: Color.fromARGB(255, 106, 172, 191)),
                                backgroundColor:
                                    const Color.fromARGB(255, 106, 172, 191)),
                            onPressed: () async {
                              final authCubit =
                                  context.read<AuthenticationCubit>();
                              bool isUserVerified = await authCubit
                                  .checkEmailVerification(); // Dispatch verification check
                              if (isUserVerified) {
                                // ignore: use_build_context_synchronously
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const AddAuthPage(),
                                  ),
                                );
                              } else {
                                CustomSnackbar.show(context,
                                    message:
                                        "You need to verify your email first.",
                                    isError: true);
                              }
                            },
                            child: const Icon(
                              Icons.add_circle,
                              color: Color.fromARGB(255, 43, 51, 63),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    "Popular Auths",
                    style: GoogleFonts.karla(
                      color: const Color.fromARGB(255, 125, 125, 125),
                      fontSize: 18,
                      letterSpacing: .75,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
                        onChanged: (text) {
                          setState(() {
                            isSearchHasValue = text.isNotEmpty;
                          });
                        },
                        backgroundColor: const WidgetStatePropertyAll(
                            Color.fromARGB(255, 43, 51, 63)),
                        hintText: "Search",
                        hintStyle: WidgetStatePropertyAll(GoogleFonts.karla(
                          color: const Color.fromARGB(255, 125, 125, 125),
                          fontSize: 16,
                          letterSpacing: .5,
                          fontWeight: FontWeight.w600,
                        )),
                        textStyle: WidgetStatePropertyAll(GoogleFonts.karla(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontSize: 16,
                          letterSpacing: .5,
                          fontWeight: FontWeight.w600,
                        )),
                        trailing: [
                          Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: Icon(Icons.search,
                                color: isSearchHasValue
                                    ? const Color.fromARGB(255, 255, 255, 255)
                                    : const Color.fromARGB(255, 125, 125, 125)),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .55,
                    width: MediaQuery.of(context).size.width,
                    child: BlocConsumer<PopularAuthCubit, PopularAuthState>(
                      listener: (context, state) {
                        if (state is PopularAuthLoadFailure) {
                          CustomSnackbar.show(context,
                              message:
                                  "Failed to load popular providers: ${state.error}",
                              isError: true);
                        }
                      },
                      builder: (context, state) {
                        if (state is PopularAuthLoading) {
                          return const Center(
                              child: CircularProgressIndicator(
                                  color: Color.fromARGB(255, 106, 172, 191)));
                        } else if (state is PopularAuthLoadSuccess &&
                            !isSearchHasValue) {
                          return ListView.builder(
                            itemCount: state.auths.length,
                            itemBuilder: (context, index) {
                              final provider = state.auths[index];
                              return PopularAuthCard(
                                authModel: provider,
                              );
                            },
                          );
                        } else if (state is PopularAuthSearching) {
                          return const Center(
                              child: CircularProgressIndicator(
                                  color: Color.fromARGB(255, 106, 172, 191)));
                        } else if (state is PopularAuthSearchSuccess) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              PopularAuthCard(
                                authModel: state.auth,
                              ),
                            ],
                          );
                        } else if (state is PopularAuthSearchFailure) {
                          return _buildSearchFailure(context, state.error);
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildSearchFailure(BuildContext context, String error) {
  return Center(
    child: Text(
      error,
      style: const TextStyle(color: Colors.red),
    ),
  );
}
