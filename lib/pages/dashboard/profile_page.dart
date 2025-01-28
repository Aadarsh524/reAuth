import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reauth/bloc/cubit/authentication_cubit.dart';
import 'package:reauth/bloc/cubit/profile_cubit.dart';
import 'package:reauth/bloc/cubit/user_auth_cubit.dart';
import 'package:reauth/bloc/states/profile_state.dart';
import 'package:reauth/bloc/states/user_auth_state.dart';
import 'package:reauth/pages/auth/email_verification_page.dart';
import 'package:reauth/pages/dashboard/edit_profile_page.dart';
import 'package:reauth/utils/strength_checker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool verifiedEmail = false;
  List<String> allPasswords = [];
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _checkEmailVerification();
  }

  Future<void> _checkEmailVerification() async {
    bool verified = await BlocProvider.of<AuthenticationCubit>(context)
        .checkEmailVerification(user!);
    setState(() {
      verifiedEmail = verified;
    });
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ProfileCubit>(context).fetchProfile();
    BlocProvider.of<UserAuthCubit>(context).fetchUserAuths();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Profile",
          style: GoogleFonts.karla(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.75,
          ),
        ),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              splashRadius: 25,
              icon: const Icon(
                Icons.edit,
                size: 24,
                color: Color(0xFF6FA3DB), // Lighter blue for edit icon
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const EditProfilePage(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, profileState) {
          if (profileState is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (profileState is ProfileLoadingError) {
            return Center(
              child: Text(
                "Error on Loading Profile",
                style: GoogleFonts.karla(
                  color: Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
          }
          if (profileState is ProfileLoaded) {
            return BlocBuilder<UserAuthCubit, UserAuthState>(
              builder: (context, userProviderState) {
                if (userProviderState is UserAuthLoadSuccess) {
                  int totalPasswords = userProviderState.auths.length;
                  allPasswords = userProviderState.auths
                      .map((provider) => provider.password)
                      .toList();

                  Map<String, int> strengthCounts =
                      classifyPasswordStrengths(allPasswords);
                  int weakPasswordsCount = strengthCounts['Weak'] ?? 0;
                  int strongPasswordsCount = strengthCounts['Strong'] ?? 0;

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildProfileHeader(profileState),
                          const SizedBox(height: 15),
                          _buildVerificationSection(),
                          const SizedBox(height: 20),
                          _buildSecurityOverview(
                            totalPasswords,
                            strongPasswordsCount,
                            weakPasswordsCount,
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildProfileHeader(ProfileLoaded profileState) {
    return Container(
      padding: const EdgeInsets.only(top: 25),
      alignment: Alignment.center,
      child: Column(
        children: [
          CircleAvatar(
            radius: 45,
            backgroundImage: profileState.profile.profileImage.isNotEmpty
                ? CachedNetworkImageProvider(profileState.profile.profileImage)
                : const AssetImage('assets/defaultAvatar.png') as ImageProvider,
            backgroundColor: Colors.transparent,
          ),
          const SizedBox(height: 15),
          Text(
            profileState.profile.fullName,
            style: GoogleFonts.karla(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            profileState.profile.email,
            style: GoogleFonts.karla(
              color: Colors.grey[400],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationSection() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: verifiedEmail
              ? [
                  Colors.green.withOpacity(0.1),
                  Colors.grey.withOpacity(0.1),
                  Colors.green.withOpacity(0.1),
                ]
              : [
                  Colors.red.withOpacity(0.3),
                  Colors.red.withOpacity(0.2),
                  Colors.green.withOpacity(0.1)
                ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: verifiedEmail ? 12 : 8,
            horizontal: verifiedEmail ? 0 : 16),
        child: Row(
          mainAxisAlignment: verifiedEmail
              ? MainAxisAlignment.center
              : MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  verifiedEmail ? Icons.verified : Icons.warning_rounded,
                  color: verifiedEmail ? Colors.green : Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  verifiedEmail ? "Verified Account" : "Unverified Account",
                  style: GoogleFonts.karla(
                    color: verifiedEmail ? Colors.green : Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            if (!verifiedEmail) ...[
              ElevatedButton.icon(
                icon: const Icon(Icons.mail_outline, size: 16),
                label: const Text("Verify", style: TextStyle(fontSize: 14)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EmailVerificationPage(),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityOverview(int total, int strong, int weak) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Security Overview",
          style: GoogleFonts.karla(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 15),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.05,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return _buildStatCard(
                  title: "Total Passwords",
                  value: total.toString(),
                  icon: Icons.lock_outlined,
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.shade400,
                      Colors.blue.shade600,
                    ],
                  ),
                );
              case 1:
                return _buildStatCard(
                  title: "Strong Passwords",
                  value: strong.toString(),
                  icon: Icons.security_rounded,
                  gradient: LinearGradient(
                    colors: [
                      Colors.green.shade400,
                      Colors.green.shade600,
                    ],
                  ),
                );
              case 2:
                return _buildStatCard(
                  title: "Weak Passwords",
                  value: weak.toString(),
                  icon: Icons.warning_amber_rounded,
                  gradient: LinearGradient(
                    colors: [
                      Colors.orange.shade400,
                      Colors.orange.shade600,
                    ],
                  ),
                );
              default:
                return _buildStatCard(
                  title: "Last Updated",
                  value: "Today",
                  icon: Icons.update_rounded,
                  gradient: LinearGradient(
                    colors: [
                      Colors.purple.shade300,
                      Colors.purple.shade500,
                    ],
                  ),
                );
            }
          },
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Gradient gradient,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: gradient,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: GoogleFonts.karla(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: GoogleFonts.karla(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
