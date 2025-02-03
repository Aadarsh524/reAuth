import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptionService {
  static const _encryptionKeyStorageKey = 'encryption_key';
  static const _secureStorage = FlutterSecureStorage();

  static Future<encrypt.Key> _getOrCreateKey() async {
    final existingKey =
        await _secureStorage.read(key: _encryptionKeyStorageKey);
    if (existingKey != null) {
      return encrypt.Key.fromBase64(existingKey);
    } else {
      final newKey = encrypt.Key.fromSecureRandom(32);
      await _secureStorage.write(
        key: _encryptionKeyStorageKey,
        value: newKey.base64,
      );
      return newKey;
    }
  }

  static Future<String> encryptData(String plainText) async {
    if (plainText.isEmpty) {
      return ''; // Handle empty passwords gracefully
    }

    final key = await _getOrCreateKey();
    final iv = encrypt.IV.fromSecureRandom(16);
    final encrypter =
        encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return '${iv.base64}::${encrypted.base64}';
  }

  static Future<String> decryptData(String encryptedText) async {
    if (encryptedText.isEmpty) {
      return ''; // Return empty if no password
    }

    final key = await _getOrCreateKey();
    final parts = encryptedText.split('::');
    if (parts.length != 2) {
      throw const FormatException('Invalid encrypted text format');
    }

    try {
      final iv = encrypt.IV.fromBase64(parts[0]);
      final encrypted = encrypt.Encrypted.fromBase64(parts[1]);
      final encrypter =
          encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
      return encrypter.decrypt(encrypted, iv: iv);
    } catch (e) {
      throw Exception('Decryption failed: $e');
    }
  }
}
