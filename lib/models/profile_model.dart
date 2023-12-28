class ProfileModel {
  final String name;
  final String email;
  final String savedPasswords;
  final String pin;
  final bool isEmailVerified;

  ProfileModel({
    required this.pin,
    required this.isEmailVerified,
    required this.name,
    required this.email,
    required this.savedPasswords,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      name: map['name'],
      email: map['email'],
      savedPasswords: map['savedPasswords'],
      isEmailVerified: map['isEmailVerified'],
      pin: map['pin'],
    );
  }
}
