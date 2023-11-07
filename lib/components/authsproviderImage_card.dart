import 'package:flutter/material.dart';
import 'package:reauth/models/provider_model.dart';
import 'package:reauth/pages/providerdetail_page.dart';

class AuthsProviderImageCard extends StatelessWidget {
  final ProviderModel providerModel;

  const AuthsProviderImageCard({
    Key? key,
    required this.providerModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
        color: const Color.fromARGB(255, 43, 51, 63),
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
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              providerModel.faviconUrl,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
