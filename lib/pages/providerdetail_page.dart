// import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reauth/models/provider_model.dart';
// import 'package:reauth/components/custom_snackbar.dart';
// import 'package:reauth/components/custom_textfield.dart';
// import 'package:reauth/models/provider_model.dart';
// import 'package:reauth/pages/dashboard/dashboard_page.dart';

class ProviderDetailPage extends StatelessWidget {
  final ProviderModel providerModel;
  const ProviderDetailPage({Key? key, required this.providerModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final providerCubit = BlocProvider.of<ProviderCubit>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 53, 64, 79),
        centerTitle: true,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: TextButton(
              onPressed: () {},
              child: Text(
                "Delete",
                style: GoogleFonts.karla(
                    color: const Color.fromARGB(255, 111, 163, 219),
                    fontSize: 20,
                    letterSpacing: .75,
                    fontWeight: FontWeight.w600),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * .95,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: const Color.fromARGB(255, 53, 64, 79),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20.0,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 10, top: 8, bottom: 8),
                          child: CachedNetworkImage(
                            imageUrl: providerModel.faviconUrl,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          providerModel.authProviderLink,
                          style: GoogleFonts.karla(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              fontSize: 20,
                              letterSpacing: .75,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Username:",
                              style: GoogleFonts.karla(
                                  color:
                                      const Color.fromARGB(255, 125, 125, 125),
                                  fontSize: 18,
                                  letterSpacing: .75,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              providerModel.username,
                              style: GoogleFonts.karla(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 18,
                                  letterSpacing: .75,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Password:",
                              style: GoogleFonts.karla(
                                  color:
                                      const Color.fromARGB(255, 125, 125, 125),
                                  fontSize: 18,
                                  letterSpacing: .75,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              providerModel.password,
                              style: GoogleFonts.karla(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 18,
                                  letterSpacing: .75,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Category:",
                              style: GoogleFonts.karla(
                                  color:
                                      const Color.fromARGB(255, 125, 125, 125),
                                  fontSize: 18,
                                  letterSpacing: .75,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              providerModel.providerCategory,
                              style: GoogleFonts.karla(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 18,
                                  letterSpacing: .75,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Note:",
                              style: GoogleFonts.karla(
                                  color:
                                      const Color.fromARGB(255, 125, 125, 125),
                                  fontSize: 18,
                                  letterSpacing: .75,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              providerModel.note,
                              style: GoogleFonts.karla(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 18,
                                  letterSpacing: .75,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: SizedBox(
                                height: 50,
                                width: 50,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.all(8.0),
                                        side: const BorderSide(
                                            color: Color.fromARGB(
                                                255, 53, 64, 79)),
                                        backgroundColor: const Color.fromARGB(
                                            255, 36, 45, 58)),
                                    onPressed: () {},
                                    child: Text("Copy Auth"))),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: SizedBox(
                                height: 50,
                                width: 50,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.all(8.0),
                                        side: const BorderSide(
                                            color: Color.fromARGB(
                                                255, 53, 64, 79)),
                                        backgroundColor: const Color.fromARGB(
                                            255, 36, 45, 58)),
                                    onPressed: () {},
                                    child: Text("Edit Auth"))),
                          ),
                        ],
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
