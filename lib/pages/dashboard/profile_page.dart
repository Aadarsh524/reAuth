import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
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

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ProfileCubit>(context).fetchProfile();
    BlocProvider.of<UserAuthCubit>(context).fetchUserAuths();

    return Scaffold(
      backgroundColor: const Color(0xFF212C3C), // A deep blue-grey background
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xFF212C3C),
        centerTitle: true,
        title: Text(
          "Profile",
          style: GoogleFonts.karla(
            color: Colors.white,
            fontSize: 25,
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
          if (profileState is ProfileLoaded) {
            verifiedEmail = profileState.profile.isEmailVerified;
            String profileImage = profileState.profile.profileImage;

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
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Profile Picture with a gradient background
                          profileImage != ''
                              ? Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.blue.shade400,
                                        Colors.blue.shade600
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                          profileImage),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : const CircleAvatar(
                                  radius: 50,
                                  backgroundImage:
                                      AssetImage('assets/defaultAvatar.png'),
                                ),
                          const SizedBox(height: 15),
                          Text(
                            profileState.profile.fullname,
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
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          verifiedEmail
                              ? Center(
                                  child: _buildVerificationStatus(
                                    status: "Verified",
                                    color: Colors.green,
                                    icon: Icons.check_circle,
                                  ),
                                )
                              : Column(
                                  children: [
                                    Center(
                                      child: _buildVerificationStatus(
                                        status: "Not Verified",
                                        color: Colors.red,
                                        icon: Icons.cancel,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const EmailVerificationPage(),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.email, size: 20),
                                      label: const Text(
                                        "Verify Now",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                          const SizedBox(height: 30),
                          _buildProfileCard(
                            totalPasswords.toString(),
                            "Saved Passwords",
                            Icons.lock,
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildProfileCard(
                                strongPasswordsCount.toString(),
                                "Strong",
                                Icons.security,
                              ),
                              _buildProfileCard(
                                weakPasswordsCount.toString(),
                                "Weak",
                                Icons.warning,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF6AABC0),
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF6AABC0),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVerificationStatus({
    required String status,
    required Color color,
    required IconData icon,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(
          status,
          style: GoogleFonts.karla(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard(String count, String label, IconData icon) {
    return Card(
      color: const Color(0xFF2A3241),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          children: [
            Icon(
              icon,
              color: label == "Weak" ? Colors.red : const Color(0xFF6AABC0),
              size: 30,
            ),
            const SizedBox(height: 10),
            Text(
              count,
              style: GoogleFonts.karla(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: GoogleFonts.karla(
                color: Colors.grey[400],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
