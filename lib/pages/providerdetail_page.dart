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
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 53, 64, 79),
        centerTitle: true,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.delete,
                size: 28,
                color: Color.fromARGB(255, 111, 163, 219),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    CachedNetworkImage(
                      imageUrl: providerModel.faviconUrl,
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      providerModel.authProviderLink,
                      style: GoogleFonts.karla(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      providerModel.username,
                      style: GoogleFonts.karla(
                        color: const Color.fromARGB(255, 125, 125, 125),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Text(
                "Details & Settings",
                style: GoogleFonts.karla(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Divider(color: Colors.white),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow("Link:", providerModel.authProviderLink),
                  _buildDetailRow("Password:", providerModel.password),
                  _buildDetailRow("Category:", providerModel.providerCategory),
                  _buildDetailRow("Note:", providerModel.note),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildButton(
                        text: 'Copy Auth',
                        onPressed: () => copyToClipboard(context),
                      ),
                      _buildButton(
                        text: 'Edit Auth',
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.karla(
              color: const Color.fromARGB(255, 125, 125, 125),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.karla(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({required String text, required VoidCallback onPressed}) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(8.0),
          side: const BorderSide(color: Color.fromARGB(255, 106, 172, 191)),
          backgroundColor: const Color.fromARGB(255, 36, 45, 58),
        ),
        child: Text(
          text,
          style: GoogleFonts.karla(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
