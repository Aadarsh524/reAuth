class ProfileModel {
  final String fullName;
  final String email;
  final String profileImage;
  final bool isMasterPinSet;
  final bool isBiometricSet;

  final String masterPin;

  ProfileModel({
    required this.fullName,
    required this.email,
    required this.profileImage,
    this.isMasterPinSet = false,
    this.isBiometricSet = false,
    this.masterPin = '',
  });

  /// Factory constructor to create a ProfileModel instance from a map
  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      profileImage: map['profileImage'] ?? '',
      isMasterPinSet: map['isMasterPinSet'] ?? false,
      masterPin: map['masterPin'] ?? '',
      isBiometricSet: map['isBiometricSet'] ?? false,
    );
  }

  /// Converts the ProfileModel instance to a map
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'profileImage': profileImage,
      'isMasterPinSet': isMasterPinSet,
      'masterPin': masterPin,
      'isBiometricSet': isBiometricSet,
    };
  }
}
