import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reauth/bloc/cubit/authentication_cubit.dart';
import 'package:reauth/bloc/cubit/profile_cubit.dart';
import 'package:reauth/bloc/states/profile_state.dart';
import 'package:reauth/components/custom_snackbar.dart';
import 'package:reauth/models/popular_auth_model.dart';
import 'package:reauth/pages/auth/addpin_page.dart';
import 'package:reauth/pages/dashboard/add_auth_page.dart';

class PopularAuthCard extends StatelessWidget {
  static const _cardColor = Color.fromARGB(255, 53, 64, 79);
  static const _iconColor = Color.fromARGB(255, 111, 163, 219);

  final PopularAuthModel authModel;

  const PopularAuthCard({super.key, required this.authModel});

  Future<void> _handleTap(BuildContext context) async {
    // Check if user is signed in
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      CustomSnackbar.show(
        context,
        isError: true,
        message: "Please sign in first",
      );
      return;
    }

    // 1. Check email verification first.
    final isVerified =
        await context.read<AuthenticationCubit>().checkEmailVerification();
    if (!isVerified) {
      // If the email is not verified, show the error and exit.
      CustomSnackbar.show(
        context,
        isError: true,
        message: "Verify Your Email First",
      );
      return;
    }

    // 2. Email is verified. Now check if the master PIN is set.
    final profileState = context.read<ProfileCubit>().state;
    if (profileState is ProfileLoaded && !profileState.profile.isMasterPinSet) {
      // If the master PIN is not set, show the dialog to prompt user.
      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black54,
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) {
          return Center(
            child: AlertDialog(
              backgroundColor: const Color.fromARGB(255, 72, 80, 93),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                "Master PIN Required",
                style: GoogleFonts.karla(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(
                "You haven't set a master PIN yet. Please set one for secure access to your saved passwords.",
                style: GoogleFonts.karla(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.karla(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog.
                    // Navigate to the page where the user can set the master PIN.
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddPinPage(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 111, 163, 219),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Set PIN",
                    style: GoogleFonts.karla(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutBack,
            ),
            child: child,
          );
        },
      );
      return;
    }

    // 3. Email is verified and the master PIN is set.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddAuthPage(popularAuthModel: authModel),
      ),
    );
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
