import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reauth/bloc/cubit/authentication_cubit.dart';
import 'package:reauth/components/custom_snackbar.dart';
import 'package:reauth/models/popular_auth_model.dart';
import 'package:reauth/pages/dashboard/add_auth_page.dart';

class PopularAuthCard extends StatelessWidget {
  static const _cardColor = Color.fromARGB(255, 53, 64, 79);
  static const _iconColor = Color.fromARGB(255, 111, 163, 219);

  final PopularAuthModel authModel;

  const PopularAuthCard({super.key, required this.authModel});

  Future<void> _handleTap(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      CustomSnackbar.show(
        context,
        isError: true,
        message: "Please sign in first",
      );

      return;
    }

    final isVerified =
        await context.read<AuthenticationCubit>().checkEmailVerification();

    if (!context.mounted) return;

    if (isVerified) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddAuthPage(popularAuthModel: authModel),
          ));
    } else {
      CustomSnackbar.show(
        context,
        isError: true,
        message: "Verify your email first",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: _cardColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => _handleTap(context),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: _CardContent(authModel: authModel),
          ),
        ),
      ),
    );
  }
}

class _CardContent extends StatelessWidget {
  const _CardContent({required this.authModel});

  final PopularAuthModel authModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _AuthCardHeader(authModel: authModel),
        const Icon(Icons.add_circle,
            color: PopularAuthCard._iconColor, size: 30),
      ],
    );
  }
}

class _AuthCardHeader extends StatelessWidget {
  const _AuthCardHeader({required this.authModel});

  final PopularAuthModel authModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CachedNetworkImage(
          imageUrl: authModel.authFavicon,
          height: 45,
          width: 45,
          fit: BoxFit.contain,
          placeholder: (_, __) => const _LoadingPlaceholder(),
          errorWidget: (_, __, ___) =>
              const Icon(Icons.error, color: Colors.white),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(authModel.authName, style: context._titleStyle),
            const SizedBox(height: 4),
            Text(authModel.authLink, style: context._subtitleStyle),
          ],
        ),
      ],
    );
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
      child: const Center(
        child: CircularProgressIndicator(color: PopularAuthCard._iconColor),
      ),
    );
  }
}

extension _StyleExtension on BuildContext {
  TextStyle get _titleStyle => GoogleFonts.karla(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );

  TextStyle get _subtitleStyle => GoogleFonts.karla(
        color: const Color.fromARGB(255, 125, 125, 125),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      );
}
