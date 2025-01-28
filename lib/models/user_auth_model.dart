import 'package:reauth/constants/auth_category.dart';

class UserAuthModel {
  // Required fields
  final String username;
  final String authName;
  final String password;
  final String authLink;
  final AuthCategory authCategory;

  // Optional fields
  final String? note;
  final String? accountNumber;
  final String? transactionPassword;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  late final DateTime? lastAccessed;
  final List<String>? tags;
  final MFAOptions? mfaOptions;

  // Flags and auxiliary fields
  final bool hasTransactionPassword;
  final bool isFavorite;
  final String? userAuthFavicon;

  UserAuthModel({
    required this.username,
    required this.authName,
    required this.password,
    required this.authLink,
    required this.authCategory,
    this.note,
    this.accountNumber,
    this.transactionPassword,
    this.createdAt,
    this.updatedAt,
    this.lastAccessed,
    this.tags,
    this.mfaOptions,
    required this.hasTransactionPassword,
    required this.isFavorite,
    this.userAuthFavicon,
  });

  /// Factory constructor to create an instance from a map
  factory UserAuthModel.fromMap(Map<String, dynamic> map) {
    return UserAuthModel(
      authName: map['authName'] ?? '',
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      authLink: map['authLink'] ?? '',
      authCategory: AuthCategory.values.firstWhere(
        (e) => e.toString() == map['authCategory'],
        orElse: () => AuthCategory.others,
      ),
      note: map['note'],
      accountNumber: map['accountNumber'],
      transactionPassword: map['transactionPassword'],
      createdAt:
          map['createdAt'] != null ? DateTime.tryParse(map['createdAt']) : null,
      updatedAt:
          map['updatedAt'] != null ? DateTime.tryParse(map['updatedAt']) : null,
      lastAccessed: map['lastAccessed'] != null
          ? DateTime.tryParse(map['lastAccessed'])
          : null,
      tags: (map['tags'] as List?)?.cast<String>(),
      hasTransactionPassword: map['hasTransactionPassword'] ?? false,
      isFavorite: map['isFavorite'] ?? false,
      userAuthFavicon: map['userAuthFavicon'],
      mfaOptions: map['mfaOptions'] != null
          ? MFAOptions.fromMap(map['mfaOptions'])
          : null,
    );
  }

  /// Method to convert the instance into a map
  Map<String, dynamic> toMap() {
    return {
      'authName': authName,
      'username': username,
      'password': password,
      'authLink': authLink,
      'authCategory': authCategory.toString(),
      'note': note,
      'accountNumber': accountNumber,
      'transactionPassword': transactionPassword,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'lastAccessed': lastAccessed?.toIso8601String(),
      'tags': tags,
      'hasTransactionPassword': hasTransactionPassword,
      'isFavorite': isFavorite,
      'userAuthFavicon': userAuthFavicon,
      'mfaOptions': mfaOptions?.toMap(),
    };
  }
}

class MFAOptions {
  final String? otpKey;
  final List<String>? recoveryCodes;

  MFAOptions({this.otpKey, this.recoveryCodes});

  /// Factory constructor to create an instance from a map
  factory MFAOptions.fromMap(Map<String, dynamic> map) {
    return MFAOptions(
      otpKey: map['otpKey'],
      recoveryCodes: (map['recoveryCodes'] as List?)?.cast<String>(),
    );
  }

  /// Method to convert the instance into a map
  Map<String, dynamic> toMap() {
    return {
      'otpKey': otpKey,
      'recoveryCodes': recoveryCodes,
    };
  }
}
