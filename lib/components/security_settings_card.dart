import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:reauth/bloc/cubit/authentication_cubit.dart';
import 'package:reauth/bloc/states/auth_state.dart';
import 'package:reauth/components/custom_snackbar.dart';
import 'package:reauth/components/custom_textfield.dart';
import 'package:reauth/pages/auth/login_page.dart';

class SecuritySettingsCard extends StatefulWidget {
  const SecuritySettingsCard({Key? key}) : super(key: key);

  @override
  State<SecuritySettingsCard> createState() => _SecuritySettingsCardState();
}

class _SecuritySettingsCardState extends State<SecuritySettingsCard> {
  bool _isSecurityExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: ExpansionPanelList(
        elevation: 0,
        expandedHeaderPadding: EdgeInsets.zero,
        dividerColor: Colors.transparent,
        animationDuration: const Duration(milliseconds: 300),
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _isSecurityExpanded = !_isSecurityExpanded;
          });
        },
        children: [
          ExpansionPanel(
            backgroundColor: const Color.fromARGB(255, 50, 60, 75),
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(
                  "Security Settings",
                  style: GoogleFonts.karla(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            },
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Column(
                children: [
                  const Divider(),
                  _buildSettingItem(
                    icon: Icons.lock,
                    title: 'Change Password',
                    onTap: () => _changePassword(context),
                  ),
                  _buildSettingItem(
                    icon: Icons.email_outlined,
                    title: 'Change Email',
                    onTap: () => _showAccountActivity(context),
                  ),
                  // _buildSettingItem(
                  //   icon: Icons.security,
                  //   title: 'Set up Two-Factor Authentication',
                  //   onTap: () => _setup2FA(context),
                  // ),
                  _buildSettingItem(
                    icon: Icons.fingerprint,
                    title: 'Set up Biometric Authentication',
                    onTap: () => _setupBiometricAuth(context),
                  ),
                  _buildSettingItem(
                    icon: Icons.delete_forever,
                    title: 'Delete Account',
                    onTap: () => _deleteAccount(context),
                  ),
                ],
              ),
            ),
            isExpanded: _isSecurityExpanded,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'Karla',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _changePassword(BuildContext context) {
    final TextEditingController oldPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    bool isOldPasswordVisible = false;
    bool isNewPasswordVisible = false;

    String errorMessage = '';

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54, // Dark overlay color
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: StatefulBuilder(
            builder: (context, setDialogState) {
              return BlocConsumer<AuthenticationCubit, AuthenticationState>(
                listener: (context, state) {
                  if (state is AccountUpdateSuccess) {
                    BlocProvider.of<AuthenticationCubit>(context).logout();
                    Navigator.popUntil(context, (route) => route.isFirst);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                    CustomSnackbar.show(
                      context,
                      message: "Password change success",
                    );
                  }
                  if (state is AccountUpdateError) {
                    // Update the error message in the dialog and clear it after 4 seconds
                    setDialogState(() {
                      errorMessage = state.error.toString();
                    });
                    Future.delayed(const Duration(seconds: 4), () {
                      if (mounted) {
                        setDialogState(() {
                          errorMessage = '';
                        });
                      }
                    });
                  }
                  if (state is ValidationError) {
                    // Update the error message in the dialog and clear it after 4 seconds
                    setDialogState(() {
                      errorMessage = state.error.toString();
                    });
                    Future.delayed(const Duration(seconds: 4), () {
                      if (mounted) {
                        setDialogState(() {
                          errorMessage = '';
                        });
                      }
                    });
                  }
                },
                builder: (context, state) {
                  final isSubmitting = state is AccountUpdateInProgress;

                  return AlertDialog(
                    backgroundColor: const Color.fromARGB(255, 72, 80, 93),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: const Text(
                      "Change Password",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomTextField(
                            isRequired: true,
                            keyboardType: TextInputType.text,
                            controller: oldPasswordController,
                            hintText: 'Enter Old Password',
                            labelText: 'Old Password',
                            passwordVisibility: (e) {
                              setDialogState(() {
                                isOldPasswordVisible = !isOldPasswordVisible;
                              });
                            },
                          ),
                          const SizedBox(height: 8),
                          CustomTextField(
                            isRequired: true,
                            keyboardType: TextInputType.text,
                            controller: newPasswordController,
                            hintText: 'Enter New Password',
                            labelText: 'New Password',
                            passwordVisibility: (e) {
                              setDialogState(() {
                                isNewPasswordVisible = !isNewPasswordVisible;
                              });
                            },
                          ),
                          // Display error message if it exists
                          if (errorMessage.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Text(
                                errorMessage,
                                style: GoogleFonts.karla(
                                  color: Colors.red,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: isSubmitting
                            ? null
                            : () => Navigator.of(context).pop(),
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
                        onPressed: isSubmitting
                            ? null
                            : () {
                                // Validate input fields before dispatching the event.
                                final oldPassword =
                                    oldPasswordController.text.trim();
                                final newPassword =
                                    newPasswordController.text.trim();

                                // Dispatch the update password event.
                                BlocProvider.of<AuthenticationCubit>(context)
                                    .updatePassword(
                                  oldPassword: oldPassword,
                                  newPassword: newPassword,
                                );
                              },
                        style: TextButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 111, 163, 219),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  backgroundColor: Colors.transparent,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                "Save",
                                style: GoogleFonts.karla(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        if (animation.status == AnimationStatus.reverse) {
          return child;
        }
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack,
          ),
          child: child,
        );
      },
    );
  }

  void _setup2FA(BuildContext context) {
    // Implement 2FA setup functionality
    // Example: Navigate to 2FA setup page or show dialog
  }

  void _setupBiometricAuth(BuildContext context) async {
    final LocalAuthentication localAuth = LocalAuthentication();
    bool canCheckBiometrics = await localAuth.canCheckBiometrics;
    if (canCheckBiometrics) {
      bool authenticated = await localAuth.authenticate(
        localizedReason:
            'Please authenticate to enable biometric authentication',
      );

      if (authenticated) {
        // Save the biometric authentication preference
        // Example: Fluttertoast.showToast(msg: 'Biometric Authentication enabled');
      } else {
        // Example: Fluttertoast.showToast(msg: 'Failed to authenticate');
      }
    } else {
      // Example: Fluttertoast.showToast(msg: 'Biometric Authentication not available');
    }
  }

  void _showAccountActivity(BuildContext context) {
    // Implement account activity functionality
    // Example: Navigate to account activity page or show dialog
  }

  // ignore: unused_element
  void _logoutFromAllDevices(BuildContext context) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    try {
      await firebaseAuth.signOut();
      // Navigate to login page
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      // Example: Fluttertoast.showToast(msg: 'Failed to log out: ${e.toString()}');
    }
  }

  void _deleteAccount(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color.fromARGB(255, 72, 80, 93),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                "Delete Account",
                style: TextStyle(
                  fontSize: 16, // Smaller font size
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              content: const SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "This Will delete all your data.",
                      style: TextStyle(
                        fontSize: 14, // Smaller font size
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(
                        color: Color.fromARGB(255, 111, 163, 219),
                      ),
                    ),
                  ),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      fontSize: 14, // Smaller font size
                      color: Color.fromARGB(255, 111, 163, 219),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    BlocProvider.of<AuthenticationCubit>(context)
                        .deleteAccount();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(
                        color: Colors.red,
                      ),
                    ),
                  ),
                  child: const Text(
                    "Delete",
                    style: TextStyle(
                      fontSize: 14, // Smaller font size
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
