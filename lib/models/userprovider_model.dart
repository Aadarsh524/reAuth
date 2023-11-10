class UserProviderModel {
  String username;
  String password;
  String note;
  String authProviderLink;
  String providerCategory;
  String faviconUrl;
  String authName;

  UserProviderModel({
    required this.username,
    required this.authName,
    required this.password,
    required this.note,
    required this.authProviderLink,
    required this.providerCategory,
    required this.faviconUrl,
  });

  factory UserProviderModel.fromMap(Map<String, dynamic> map) {
    return UserProviderModel(
      authName: map['authName'],
      username: map['username'],
      password: map['password'],
      note: map['note'],
      authProviderLink: map['authProviderLink'],
      providerCategory: map['providerCategory'],
      faviconUrl: map['faviconUrl'],
    );
  }
}
