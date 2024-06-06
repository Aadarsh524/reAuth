import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Security"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSettingItem(
              icon: Icons.security,
              title: "Set up Two-Factor Authentication",
              onTap: () => _setup2FA(context),
            ),
            _buildSettingItem(
              icon: Icons.lock,
              title: "Change Password",
              onTap: () => _changePassword(context),
            ),
            _buildSettingItem(
              icon: Icons.fingerprint,
              title: "Set up Biometric Authentication",
              onTap: () => _setupBiometricAuth(context),
            ),
            _buildSettingItem(
              icon: Icons.history,
              title: "Account Activity",
              onTap: () => _showAccountActivity(context),
            ),
            _buildSettingItem(
              icon: Icons.logout,
              title: "Logout from All Devices",
              onTap: () => _logoutFromAllDevices(context),
            ),
            _buildSettingItem(
              icon: Icons.delete_forever,
              title: "Delete Account",
              onTap: () => _deleteAccount(context),
            ),
            // Add more setting items here
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      color: const Color.fromARGB(255, 50, 60, 75),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: onTap,
      ),
    );
  }

  void _setup2FA(BuildContext context) {
    // Implement 2FA setup functionality
    // Example: Navigate to 2FA setup page or show dialog
  }

  void _changePassword(BuildContext context) {
    // Implement change password functionality
    // Example: Navigate to change password page or show dialog
  }

  void _setupBiometricAuth(BuildContext context) async {
    final LocalAuthentication _localAuth = LocalAuthentication();
    bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
    if (canCheckBiometrics) {
      bool authenticated = await _localAuth.authenticate(
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

  void _logoutFromAllDevices(BuildContext context) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    try {
      await _firebaseAuth.signOut();
      // Navigate to login page
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      // Example: Fluttertoast.showToast(msg: 'Failed to log out: ${e.toString()}');
    }
  }

  void _deleteAccount(BuildContext context) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    try {
      await _firebaseAuth.currentUser?.delete();
      // Navigate to sign-up page
      Navigator.pushReplacementNamed(context, '/signup');
      // Example: Fluttertoast.showToast(msg: 'Account deleted');
    } catch (e) {
      // Example: Fluttertoast.showToast(msg: 'Failed to delete account: ${e.toString()}');
    }
  }
}
