import 'package:flutter/material.dart';

class AuthsProviderImageCard extends StatelessWidget {
  final String providerImage;

  const AuthsProviderImageCard({
    Key? key,
    required this.providerImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
        color: const Color.fromARGB(255, 43, 51, 63),
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              providerImage,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
