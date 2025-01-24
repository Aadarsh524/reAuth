import 'package:reauth/constants/auth_category.dart';

class UserAuthModel {
  String username;
  String password;
  String? note; // Made optional
  String authLink;
  AuthCategory authCategory; // Changed to enum
  String userAuthFavicon; // Made optional for custom icons
  String authName;
  String? accountNumber;

  String?
      transactionPassword; // Optional for providers with transaction passwords
  bool hasTransactionPassword;
  DateTime? createdAt; // Nullable field for record creation timestamp
  DateTime? updatedAt; // Nullable field for last update timestamp
  DateTime? lastAccessed; // Nullable field for tracking last usage
  List<String>? tags; // Optional tags for categorization
  bool isFavorite; // Flag for marking favorite providers
  MFAOptions? mfaOptions; // Optional multi-factor authentication configuration

  UserAuthModel({
    required this.username,
    required this.authName,
    required this.password,
    this.note,
    this.accountNumber,
    required this.authLink,
    required this.authCategory,
    required this.userAuthFavicon,
    this.transactionPassword,
    required this.hasTransactionPassword,
    this.createdAt,
    this.updatedAt,
    this.lastAccessed,
    this.tags,
    required this.isFavorite,
    this.mfaOptions,
  });

  factory UserAuthModel.fromMap(Map<String, dynamic> map) {
    return UserAuthModel(
      authName: map['authName'] ?? '',
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      note: map['note'],
      authLink: map['authLink'] ?? '',
      accountNumber: map['accountNumber'],
      authCategory: AuthCategory.values.firstWhere(
        (e) => e.toString() == map['authCategory'],
        orElse: () => AuthCategory.others,
      ),
      userAuthFavicon: map['userAuthFavicon'] ?? '',
      transactionPassword: map['transactionPassword'],
      hasTransactionPassword: map['hasTransactionPassword'] ?? false,
      createdAt: map['createdAt'] != null && map['createdAt'] != ''
          ? DateTime.tryParse(map['createdAt'])
          : null,
      updatedAt: map['updatedAt'] != null && map['updatedAt'] != ''
          ? DateTime.tryParse(map['updatedAt'])
          : null,
      lastAccessed: map['lastAccessed'] != null && map['lastAccessed'] != ''
          ? DateTime.tryParse(map['lastAccessed'])
          : null,
      tags: (map['tags'] ?? []).cast<String>(),
      isFavorite: map['isFavorite'] ?? false,
      mfaOptions: map['mfaOptions'] != null
          ? MFAOptions.fromMap(map['mfaOptions'])
          : null,
    );
  }
}

class MFAOptions {
  String? otpKey;
  String? recoveryCodes; // Serialized format for recovery codes
  MFAOptions({this.otpKey, this.recoveryCodes});

  factory MFAOptions.fromMap(Map<String, dynamic> map) {
    return MFAOptions(
      otpKey: map['otpKey'],
      recoveryCodes: map['recoveryCodes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'otpKey': otpKey,
      'recoveryCodes': recoveryCodes,
    };
  }
}
