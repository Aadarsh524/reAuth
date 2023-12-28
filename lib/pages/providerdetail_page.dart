import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reauth/components/custom_snackbar.dart';
import 'package:reauth/models/userprovider_model.dart';

class ProviderDetailPage extends StatelessWidget {
  final UserProviderModel providerModel;
  const ProviderDetailPage({Key? key, required this.providerModel})
      : super(key: key);

  void copyToClipboard(BuildContext context) {
    CustomSnackbar customSnackbar = CustomSnackbar('');
    customSnackbar = CustomSnackbar("Copied");

    Clipboard.setData(ClipboardData(text: providerModel.password))
        .then((value) => customSnackbar.showCustomSnackbar(context));
  }

  @override
  Widget build(BuildContext context) {
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
                child: const Icon(Icons.delete,
                    size: 28, color: Color.fromARGB(255, 111, 163, 219))),
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
                        vertical: 20.0, horizontal: 20),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 10, top: 8, bottom: 8),
                          child: CachedNetworkImage(
                            imageUrl: providerModel.faviconUrl,
                            height: 60,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              providerModel.authProviderLink,
                              style: GoogleFonts.karla(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 18,
                                  letterSpacing: .75,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              providerModel.username,
                              style: GoogleFonts.karla(
                                  color:
                                      const Color.fromARGB(255, 125, 125, 125),
                                  fontSize: 16,
                                  letterSpacing: .5,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                child: Text(
                  "Details & Settings",
                  style: GoogleFonts.karla(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontSize: 18,
                      letterSpacing: .75,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 0.0),
                child: Divider(),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0.0, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Link:",
                              style: GoogleFonts.karla(
                                  color:
                                      const Color.fromARGB(255, 125, 125, 125),
                                  fontSize: 16,
                                  letterSpacing: .75,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              providerModel.authProviderLink,
                              style: GoogleFonts.karla(
                                  decoration: TextDecoration.underline,
                                  color:
                                      const Color.fromARGB(255, 111, 163, 219),
                                  fontSize: 16,
                                  letterSpacing: .75,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0.0, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Password:",
                              style: GoogleFonts.karla(
                                  color:
                                      const Color.fromARGB(255, 125, 125, 125),
                                  fontSize: 16,
                                  letterSpacing: .75,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              providerModel.password,
                              style: GoogleFonts.karla(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 16,
                                  letterSpacing: .75,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0.0, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Category:",
                              style: GoogleFonts.karla(
                                  color:
                                      const Color.fromARGB(255, 125, 125, 125),
                                  fontSize: 16,
                                  letterSpacing: .75,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              providerModel.providerCategory,
                              style: GoogleFonts.karla(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 16,
                                  letterSpacing: .75,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0.0, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Note:",
                              style: GoogleFonts.karla(
                                  color:
                                      const Color.fromARGB(255, 125, 125, 125),
                                  fontSize: 16,
                                  letterSpacing: .75,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              providerModel.note,
                              style: GoogleFonts.karla(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 16,
                                  letterSpacing: .75,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(8.0),
                                      side: const BorderSide(
                                          color: Color.fromARGB(
                                              255, 106, 172, 191)),
                                      backgroundColor: const Color.fromARGB(
                                          255, 36, 45, 58)),
                                  onPressed: () {
                                    copyToClipboard(context);
                                  },
                                  child: Text(
                                    'Copy Auth',
                                    style: GoogleFonts.karla(
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        fontSize: 16,
                                        letterSpacing: .75,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            child: SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(8.0),
                                      side: const BorderSide(
                                          color: Color.fromARGB(
                                              255, 106, 172, 191)),
                                      backgroundColor: const Color.fromARGB(
                                          255, 36, 45, 58)),
                                  onPressed: () {},
                                  child: Text(
                                    "Edit Auth",
                                    style: GoogleFonts.karla(
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        fontSize: 16,
                                        letterSpacing: .75,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )),
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
