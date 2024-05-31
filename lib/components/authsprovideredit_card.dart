import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthsProviderEditCard extends StatelessWidget {
  final String providerImage;
  final String providerName;
  final String providerId;

  const AuthsProviderEditCard({
    Key? key,
    required this.providerImage,
    required this.providerName,
    this.providerId = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      color: const Color.fromARGB(255, 53, 64, 79),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CachedNetworkImage(
                  imageUrl: providerImage,
                  width: 45,
                  height: 45,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => Container(
                    width: 45,
                    height: 45,
                    color: Colors.grey[300],
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      providerName,
                      style: GoogleFonts.karla(
                        color: Colors.white,
                        fontSize: 16,
                        letterSpacing: .75,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      providerId,
                      style: GoogleFonts.karla(
                        color: const Color.fromARGB(255, 125, 125, 125),
                        fontSize: 14,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            InkWell(
              onTap: () {
                // Add your edit functionality here
              },
              child: const Icon(
                Icons.edit,
                color: Color.fromARGB(255, 111, 163, 219),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
