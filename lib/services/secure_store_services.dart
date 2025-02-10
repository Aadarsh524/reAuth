import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  /// Save encrypted master password securely
  static Future<void> saveMasterPassword(String encryptedPassword) async {
    await _storage.write(
        key: 'encrypted_master_password', value: encryptedPassword);
    print("🔐 Master password saved securely.");
  }

  /// Retrieve encrypted master password
  static Future<String?> getMasterPassword() async {
    return await _storage.read(key: 'encrypted_master_password');
  }

  /// Delete master password (e.g., when logging out)
  static Future<void> deleteMasterPassword() async {
    await _storage.delete(key: 'encrypted_master_password');
    print("❌ Master password deleted from secure storage.");
  }
}
