import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reauth/bloc/cubit/authentication_cubit.dart';
import 'package:reauth/bloc/cubit/profile_cubit.dart';
import 'package:reauth/bloc/cubit/user_auth_cubit.dart';
import 'package:reauth/bloc/states/authentication_state.dart';
import 'package:reauth/bloc/states/profile_state.dart';
import 'package:reauth/bloc/states/user_auth_state.dart';
import 'package:reauth/models/profile_model.dart';
import 'package:reauth/pages/dashboard/edit_profile_page.dart';
import 'package:reauth/utils/strength_checker.dart';
import 'package:reauth/components/custom_snackbar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  bool verifiedEmail = false;
  List<String> allPasswords = [];
  User? user = FirebaseAuth.instance.currentUser;
  ProfileModel? profileModel;
  Timer? _verificationTimer;
  Timer? _resendTimer;
  final int _resendCooldown = 30;
  int _remainingTime = 0;
  bool _canResend = true;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _checkEmailVerification();
    BlocProvider.of<ProfileCubit>(context).fetchProfile();
    BlocProvider.of<UserAuthCubit>(context).fetchUserAuths();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _verificationTimer?.cancel();
    _resendTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkEmailVerification() async {
    bool verified = await BlocProvider.of<AuthenticationCubit>(context)
        .checkEmailVerification();
    if (mounted) {
      setState(() => verifiedEmail = verified);
    }
  }

  void _startVerificationCheck() {
    _verificationTimer?.cancel();
    _verificationTimer =
        Timer.periodic(const Duration(seconds: 3), (timer) async {
      await _checkEmailVerification();
      if (verifiedEmail) timer.cancel();
    });
  }

  void _showVerificationDialog() {
    _animationController.forward();
    showDialog(
      context: context,
      builder: (context) => ScaleTransition(
        scale: _scaleAnimation,
        child: AlertDialog(
          backgroundColor: const Color(0xFF2D2D39),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Verify Email',
            style: GoogleFonts.karla(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Send verification email to: ',
                  style: GoogleFonts.karla(
                    color: Colors.grey[300],
                    fontSize: 16,
                  ),
                ),
                TextSpan(
                  text: '${user?.email}',
                  style: GoogleFonts.karla(
                    color:
                        Colors.green, // Or any color you prefer for the email
                    fontSize: 16,
                    fontWeight:
                        FontWeight.bold, // Making the email bold for emphasis
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _sendVerificationEmail();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                            255, 106, 172, 191), // Grey when disabled
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 32),
                        textStyle: GoogleFonts.karla(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      child: Text(
                        _canResend
                            ? 'Send Verification Email'
                            : 'Resend in $_remainingTime seconds',
                        style: GoogleFonts.karla(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    _animationController.reverse();
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 25),
                  ),
                  child: Text(
                    'Try Later',
                    style: GoogleFonts.karla(
                      color: Colors.grey[400],
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendVerificationEmail() async {
    try {
      setState(() {
        _canResend = false;
        _remainingTime = _resendCooldown;
      });

      await BlocProvider.of<AuthenticationCubit>(context).verifyEmail();
      _startVerificationCheck();

      _resendTimer?.cancel();
      _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingTime > 0) {
          setState(() => _remainingTime--);
        } else {
          timer.cancel();
          setState(() => _canResend = true);
        }
      });

      CustomSnackbar.show(
        context,
        message: 'Verification email sent! Check your inbox.',
        isError: false,
      );
    } catch (e) {
      CustomSnackbar.show(
        context,
        message: 'Failed to send verification email',
        isError: true,
      );
    }
  }

  Widget _buildVerificationSection() {
    // Timer to check after 30 seconds
    Timer? verificationTimer;

    return BlocListener<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        // Listener for email verification success
        if (state is EmailVerificationSuccess) {
          CustomSnackbar.show(context, message: 'Email verified successfully!');
          setState(() => verifiedEmail = true);
          verificationTimer?.cancel(); // Cancel the timer if verified
        }

        // Listener for authentication errors
        if (state is AuthenticationError) {
          CustomSnackbar.show(context, message: state.error, isError: true);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: verifiedEmail
                ? [
                    Colors.green.withOpacity(0.15),
                    Colors.green.withOpacity(0.25)
                  ]
                : [Colors.red.withOpacity(0.15), Colors.red.withOpacity(0.25)],
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
                    color: verifiedEmail ? Colors.green : Colors.red[300],
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        verifiedEmail ? "Verified Account" : "Unverified",
                        style: GoogleFonts.karla(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (!verifiedEmail)
                ElevatedButton.icon(
                  icon: const Icon(Icons.mail_outline, size: 16),
                  label: Text(_canResend ? 'Verify ' : '$_remainingTime s',
                      style: const TextStyle(fontSize: 14)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _canResend
                      ? () {
                          _showVerificationDialog();
                          // Start the timer when sending the verification email
                          verificationTimer =
                              Timer(const Duration(seconds: 30), () {
                            if (!verifiedEmail) {
                              CustomSnackbar.show(
                                context,
                                message:
                                    'You did not verify your email in time.',
                                isError: true,
                              );
                            }
                          });
                        }
                      : null,
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          IconButton(
            splashRadius: 25,
            icon: const Icon(
              Icons.edit,
              size: 24,
              color: Color(0xFF6FA3DB),
            ),
            onPressed: () {
              if (profileModel != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        EditProfilePage(profileModel: profileModel!),
                  ),
                );
              }
            },
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
                "Error Loading Profile",
                style: GoogleFonts.karla(
                  color: Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
          }
          if (profileState is ProfileLoaded) {
            profileModel = profileState.profile;
            return BlocBuilder<UserAuthCubit, UserAuthState>(
              builder: (context, userProviderState) {
                if (userProviderState is UserAuthLoadSuccess) {
                  final totalPasswords = userProviderState.auths.length;
                  allPasswords = userProviderState.auths
                      .map((provider) => provider.password)
                      .toList();

                  final strengthCounts =
                      classifyPasswordStrengths(allPasswords);
                  final weakPasswordsCount = strengthCounts['Weak'] ?? 0;
                  final strongPasswordsCount = strengthCounts['Strong'] ?? 0;

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
            radius: 60,
            backgroundColor: Colors.transparent,
            child: profileState.profile.profileImage.isNotEmpty
                ? Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF6FA3DB),
                        width: 3,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: CachedNetworkImageProvider(
                          profileState.profile.profileImage),
                    ),
                  )
                : const CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/defaultAvatar.png'),
                  ),
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
          itemBuilder: (context, index) =>
              _buildStatCard(index, total, strong, weak),
        ),
      ],
    );
  }

  Widget _buildStatCard(int index, int total, int strong, int weak) {
    final stats = [
      {
        'title': 'Total Passwords',
        'value': total.toString(),
        'icon': Icons.lock_outlined,
        'gradient': [Colors.blue.shade400, Colors.blue.shade600]
      },
      {
        'title': 'Strong Passwords',
        'value': strong.toString(),
        'icon': Icons.security_rounded,
        'gradient': [Colors.green.shade400, Colors.green.shade600]
      },
      {
        'title': 'Weak Passwords',
        'value': weak.toString(),
        'icon': Icons.warning_amber_rounded,
        'gradient': [Colors.orange.shade400, Colors.orange.shade600]
      },
      {
        'title': 'Last Updated',
        'value': 'Today',
        'icon': Icons.update_rounded,
        'gradient': [Colors.purple.shade300, Colors.purple.shade500]
      },
    ];

    final data = stats[index];
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(colors: data['gradient'] as List<Color>),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 12)
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child:
                  Icon(data['icon'] as IconData, color: Colors.white, size: 24),
            ),
            Column(
              children: [
                Text(
                  data['value'] as String,
                  style: GoogleFonts.karla(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  data['title'] as String,
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
