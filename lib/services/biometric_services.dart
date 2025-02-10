import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'encryption_service.dart';

class BiometricService {
  final LocalAuthentication _localAuth = LocalAuthentication();
  // Using Flutter Secure Storage to store the encrypted master password.
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Checks if biometric authentication is available and supported on the device.
  Future<bool> isBiometricAvailable() async {
    try {
      bool canCheck = await _localAuth.canCheckBiometrics;
      bool isSupported = await _localAuth.isDeviceSupported();
      return canCheck && isSupported;
    } catch (e) {
      print("Error checking biometric availability: $e");
      return false;
    }
  }

  /// Performs biometric authentication.
  Future<bool> authenticate() async {
    try {
      // Optionally, log available biometric types.
      List<BiometricType> availableBiometrics =
          await _localAuth.getAvailableBiometrics();
      print("Available biometrics: $availableBiometrics");

      // Initiate the authentication process.
      bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: "Scan your fingerprint or face to authenticate",
        options: const AuthenticationOptions(
          biometricOnly: false, // Allow fallback to device passcode if needed.
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

  /// Saves the master password securely.
  ///
  /// This method encrypts the master password using EncryptionService and stores
  /// it in secure storage. You would call this when a user sets or updates their
  /// master password.
  Future<void> saveMasterPassword(String masterPassword) async {
    try {
      String encryptedMasterPassword =
          await EncryptionService.encryptData(masterPassword);
      await _storage.write(
          key: 'encrypted_master_password', value: encryptedMasterPassword);
      print("Master password saved securely.");
    } catch (e) {
      print("Error saving master password: $e");
    }
  }

  /// Authenticates the user via biometrics and then retrieves (and decrypts)
  /// the stored master password.
  Future<String?> loginWithBiometrics() async {
    bool authenticated = await authenticate();
    if (authenticated) {
      try {
        String? encryptedMasterPassword =
            await _storage.read(key: 'encrypted_master_password');
        if (encryptedMasterPassword == null) {
          print("No master password found in secure storage.");
          return null;
        }
        // Decrypt the master password.
        String masterPassword =
            await EncryptionService.decryptData(encryptedMasterPassword);
        return masterPassword;
      } catch (e) {
        print("Error decrypting master password: $e");
        return null;
      }
    }
    return null;
  }
}
