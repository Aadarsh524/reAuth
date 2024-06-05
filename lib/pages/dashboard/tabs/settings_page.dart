import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Security"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.security),
                title: const Text("Set up Two-Factor Authentication"),
                onTap: _setup2FA,
              ),
              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text("Change Password"),
                onTap: _changePassword,
              ),
              ListTile(
                leading: const Icon(Icons.fingerprint),
                title: const Text("Set up Biometric Authentication"),
                onTap: _setupBiometricAuth,
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text("Account Activity"),
                onTap: _showAccountActivity,
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("Logout from All Devices"),
                onTap: _logoutFromAllDevices,
              ),
              ListTile(
                leading: const Icon(Icons.delete_forever),
                title: const Text("Delete Account"),
                onTap: _deleteAccount,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _setup2FA() {
    // Navigate to 2FA setup page or show dialog
  }

  void _changePassword() {
    // Navigate to change password page or show dialog
  }

  void _setupBiometricAuth() async {
    bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
    if (canCheckBiometrics) {
      bool authenticated = await _localAuth.authenticate(
        localizedReason:
            'Please authenticate to enable biometric authentication',
        options: const AuthenticationOptions(biometricOnly: true),
      );

      if (authenticated) {
        // Save the biometric authentication preference
        // Fluttertoast.showToast(msg: 'Biometric Authentication enabled');
      } else {
        // Fluttertoast.showToast(msg: 'Failed to authenticate');
      }
    } else {
      // Fluttertoast.showToast(msg: 'Biometric Authentication not available');
    }
  }

  void _showAccountActivity() {
    // Navigate to account activity page or show dialog
  }

  void _logoutFromAllDevices() async {
    try {
      await _firebaseAuth.signOut();
      // Navigate to login page
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      // Fluttertoast.showToast(msg: 'Failed to log out: ${e.toString()}');
    }
  }

  void _deleteAccount() async {
    try {
      await _firebaseAuth.currentUser?.delete();
      // Navigate to sign-up page
      Navigator.pushReplacementNamed(context, '/signup');
      // Fluttertoast.showToast(msg: 'Account deleted');
    } catch (e) {
      // Fluttertoast.showToast(msg: 'Failed to delete account: ${e.toString()}');
    }
  }
}
