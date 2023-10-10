import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthsProviderEditCard extends StatelessWidget {
  final String providerImage;
  final String providerName;
  final String providerId;

  const AuthsProviderEditCard(
      {Key? key,
      required this.providerImage,
      required this.providerName,
      this.providerId = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
        color: const Color.fromARGB(255, 53, 64, 79),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 10, top: 8, bottom: 8),
                    child: CachedNetworkImage(
                      imageUrl: providerImage,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        providerName,
                        style: GoogleFonts.karla(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontSize: 16,
                            letterSpacing: .75,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        providerId,
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
              InkWell(
                onTap: () {},
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                  child: Icon(
                    Icons.edit,
                    color: Color.fromARGB(255, 111, 163, 219),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
