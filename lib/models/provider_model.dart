class ProviderModel {
  String username;
  String password;
  String note;
  String authProviderLink;
  String providerCategory;
  String faviconUrl;

  ProviderModel({
    required this.username,
    required this.password,
    required this.note,
    required this.authProviderLink,
    required this.providerCategory,
    required this.faviconUrl,
  });

  // Map<String, dynamic> toMap() {
  //   return {
  //     'username': username,
  //     'password': password,
  //     'note': note,
  //     'authProviderLink': authProviderLink,
  //     'providerCategory': providerCategory,
  //   };
  // }

  factory ProviderModel.fromMap(Map<String, dynamic> map) {
    return ProviderModel(
      username: map['username'],
      password: map['password'],
      note: map['note'],
      authProviderLink: map['authProviderLink'],
      providerCategory: map['providerCategory'],
      faviconUrl: map['faviconUrl'],
    );
  }
}
