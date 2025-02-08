import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  /// Check if biometric authentication is available
  Future<bool> isBiometricAvailable() async {
    bool canCheck = await _localAuth.canCheckBiometrics;
    bool isSupported = await _localAuth.isDeviceSupported();
    return canCheck && isSupported;
  }

  Future<bool> authenticate() async {
    try {
      // Check available biometrics
      List<BiometricType> availableBiometrics =
          await _localAuth.getAvailableBiometrics();
      print("Available biometrics: $availableBiometrics");

      bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      bool isSupported = await _localAuth.isDeviceSupported();
      print(
          "canCheckBiometrics: $canCheckBiometrics, isDeviceSupported: $isSupported");

      // Attempt authentication
      bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: "Scan your fingerprint or face to authenticate",
        options: const AuthenticationOptions(
          biometricOnly: false, // Try setting to false if necessary
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );

      print("Authentication result: $didAuthenticate");
      return didAuthenticate;
    } catch (e, stackTrace) {
      print("Biometric authentication error: $e");
      print("Stacktrace: $stackTrace");
      return false;
    }
  }
}
