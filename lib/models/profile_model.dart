class ProfileModel {
  final String fullName;
  final String email;
  final String profileImage;

  ProfileModel({
    required this.fullName,
    required this.email,
    required this.profileImage,
  });

  /// Factory constructor to create a ProfileModel instance from a map
  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      profileImage: map['profileImage'] ?? '',
    );
  }

  /// Converts the ProfileModel instance to a map
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'profileImage': profileImage,
    };
  }
}
