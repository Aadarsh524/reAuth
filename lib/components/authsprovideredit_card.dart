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
                  Image.network(
                    providerImage,
                    height: 50,
                    width: 50,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        providerName,
                        style: GoogleFonts.oxygenMono(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontSize: 14,
                            letterSpacing: .75,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        providerId,
                        style: GoogleFonts.oxygenMono(
                            color: const Color.fromARGB(255, 125, 125, 125),
                            fontSize: 12,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Icon(Icons.edit),
              )
            ],
          ),
        ),
      ),
    );
  }
}
