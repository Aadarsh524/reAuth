import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'dart:math';

class EncryptionService {
  static const _secretKey =
      "MySuperSecretKey12345"; // Replace with a securely stored key

  // Generate a user-specific key using Firebase UID and secret key
  static Future<encrypt.Key> _getUserSpecificKey() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not authenticated");
    }

    final userId = user.uid;
    final combinedKey = utf8.encode(userId + _secretKey);
    final hashedKey =
        encrypt.Key.fromUtf8(base64Encode(combinedKey).substring(0, 32));
    return hashedKey;
  }

  // Generate a secure random IV
  static encrypt.IV _generateIV() {
    final random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(256));
    return encrypt.IV(Uint8List.fromList(values));
  }

  static Future<String> encryptData(String plainText) async {
    if (plainText.isEmpty) return '';

    final key = await _getUserSpecificKey();
    final iv = _generateIV();
    final encrypter =
        encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final encrypted = encrypter.encrypt(plainText, iv: iv);

    return '${iv.base64}::${encrypted.base64}';
  }

  static Future<String> decryptData(String encryptedText) async {
    if (encryptedText.isEmpty) return '';

    final key = await _getUserSpecificKey();
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
