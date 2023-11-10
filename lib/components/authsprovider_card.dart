import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reauth/models/userprovider_model.dart';
import 'package:reauth/pages/providerdetail_page.dart';

class AuthsProviderCard extends StatelessWidget {
  final UserProviderModel providerModel;

  const AuthsProviderCard({
    Key? key,
    required this.providerModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
        color: const Color.fromARGB(255, 53, 64, 79),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProviderDetailPage(
                  providerModel: providerModel,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  child: CachedNetworkImage(
                    imageUrl: providerModel.faviconUrl,
                    fit: BoxFit.contain,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      providerModel.authName,
                      style: GoogleFonts.karla(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontSize: 16,
                          letterSpacing: .75,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      providerModel.username,
                      style: GoogleFonts.karla(
                          color: const Color.fromARGB(255, 125, 125, 125),
                          fontSize: 14,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
