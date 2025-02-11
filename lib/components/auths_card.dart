import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user_auth_model.dart';
import '../pages/dashboard/auth_detail_page.dart';

class AuthsCard extends StatelessWidget {
  static const _cardColor = Color.fromARGB(255, 53, 64, 79);
  static const _subtitleColor = Color.fromARGB(255, 125, 125, 125);
  static const _iconColor = Colors.white;
  static const _errorAsset = 'assets/error.png';

  final UserAuthModel providerModel;

  const AuthsCard({super.key, required this.providerModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Card(
        elevation: 4,
        color: _cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => _navigateToDetail(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: _CardContent(providerModel: providerModel),
          ),
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AuthDetailPage(authModel: providerModel),
      ),
    );
  }
}

class _CardContent extends StatelessWidget {
  const _CardContent({required this.providerModel});

  final UserAuthModel providerModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _AuthImage(providerModel: providerModel),
        const SizedBox(width: 10),
        Expanded(child: _AuthTextInfo(providerModel: providerModel)),
        const _DetailButton(),
      ],
    );
  }
}

class _AuthImage extends StatelessWidget {
  const _AuthImage({required this.providerModel});

  final UserAuthModel providerModel;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: providerModel.userAuthFavicon ?? '',
        width: 45,
        height: 45,
        fit: BoxFit.contain,
        placeholder: (_, __) => const _LoadingPlaceholder(),
        errorWidget: (_, __, ___) => Image.asset(
          AuthsCard._errorAsset,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _AuthTextInfo extends StatelessWidget {
  const _AuthTextInfo({required this.providerModel});

  final UserAuthModel providerModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            providerModel.authName.toUpperCase(),
            style: context._titleStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            providerModel.username,
            style: context._subtitleStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _DetailButton extends StatelessWidget {
  const _DetailButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.more_vert, color: AuthsCard._iconColor),
      onPressed: () => _showDetail(context),
    );
  }

  void _showDetail(BuildContext context) {
    // Navigation logic could be moved here if needed
    final authsCard = context.findAncestorWidgetOfExactType<AuthsCard>();
    if (authsCard != null) {
      authsCard._navigateToDetail(context);
    }
  }
}

class _LoadingPlaceholder extends StatelessWidget {
  const _LoadingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      color: Colors.grey[300],
      child: const Center(child: CircularProgressIndicator(color: Colors.blue)),
    );
  }
}

extension _StyleExtension on BuildContext {
  TextStyle get _titleStyle => GoogleFonts.karla(
        color: AuthsCard._iconColor,
        fontSize: 16,
        letterSpacing: 0.75,
        fontWeight: FontWeight.w600,
      );

  TextStyle get _subtitleStyle => GoogleFonts.karla(
        color: AuthsCard._subtitleColor,
        fontSize: 14,
        letterSpacing: 0.5,
        fontWeight: FontWeight.w400,
      );
}
