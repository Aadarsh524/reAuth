class ProfileModel {
  final String fullname;
  final String email;
  final String savedPasswords;
  final String pin;
  final bool isEmailVerified;

  ProfileModel({
    required this.pin,
    required this.isEmailVerified,
    required this.fullname,
    required this.email,
    required this.savedPasswords,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      fullname: map['fullname'],
      email: map['email'],
      savedPasswords: map['savedPasswords'],
      isEmailVerified: map['isEmailVerified'],
      pin: map['pin'],
    );
  }
}
