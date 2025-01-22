import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reauth/models/user_auth_model.dart';
import 'package:reauth/pages/providerdetail_page.dart';

class AuthsProviderCard extends StatelessWidget {
  final UserAuthModel providerModel;

  const AuthsProviderCard({
    Key? key,
    required this.providerModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 53, 64, 79),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: providerModel.userAuthFavicon,
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
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      providerModel.authName,
                      style: GoogleFonts.karla(
                        color: Colors.white,
                        fontSize: 16,
                        letterSpacing: .75,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      providerModel.username,
                      style: GoogleFonts.karla(
                        color: const Color.fromARGB(255, 125, 125, 125),
                        fontSize: 14,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProviderDetailPage(
                      providerModel: providerModel,
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
