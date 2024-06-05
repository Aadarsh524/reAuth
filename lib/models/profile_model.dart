class ProfileModel {
  final String fullname;
  final String email;
  final String pin;
  final String profileImage;
  final bool isEmailVerified;

  ProfileModel({
    required this.pin,
    required this.isEmailVerified,
    required this.fullname,
    required this.email,
    required this.profileImage,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      fullname: map['fullname'],
      email: map['email'],
      isEmailVerified: map['isEmailVerified'],
      pin: map['pin'],
      profileImage: map['profileImage'] ?? '',
    );
  }
}
