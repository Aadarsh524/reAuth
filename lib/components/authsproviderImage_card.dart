import 'package:flutter/material.dart';

class AuthsProviderImageCard extends StatelessWidget {
  final String providerImage;
  final double margin;

  const AuthsProviderImageCard({
    Key? key,
    required this.providerImage,
    required this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        elevation: 5,
        margin: EdgeInsets.only(left: margin, right: 5, top: 5, bottom: 5),
        color: const Color.fromARGB(255, 43, 51, 63),
        child: InkWell(
          onTap: () {
            print("Tapped");
          },
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Image.network(
              height: 45,
              width: 45,
              providerImage,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
