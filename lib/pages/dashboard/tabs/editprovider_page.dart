import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reauth/components/authsprovideredit_card.dart';
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

  final List auths = [
    {
      "providerImage":
          "https://pngimg.com/uploads/facebook_logos/small/facebook_logos_PNG19753.png",
      "providerName": "Facebook",
      "providerId": "aadarshghimire524@gmail.com"
    },
    {
      "providerImage": "http://pngimg.com/uploads/google/google_PNG19635.png",
      "providerName": "Google",
      "providerId": "aadarshghimire524@gmail.com"
    },
    {
      "providerImage":
          "https://pngimg.com/uploads/github/small/github_PNG6.png",
      "providerName": "Github",
      "providerId": "aadarshghimire524@gmail.com"
    }
  ];
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
                                Icons.add_box_rounded,
                                color: Color.fromARGB(255, 43, 51, 63),
                              ))),
                    ),
                  ),
                ),
                Text(
                  "Edit Your Auths",
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
                  height: MediaQuery.of(context).size.height * .45,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                    child: ListView.builder(
                      itemCount: auths.length,
                      itemBuilder: (BuildContext context, int index) {
                        final auth = auths[index];
                        return AuthsProviderEditCard(
                          providerImage: auth["providerImage"],
                          providerName: auth["providerName"],
                          providerId: auth['providerId'],
                        );
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
