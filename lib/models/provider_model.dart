class ProviderModel {
  String username;
  String password;
  String note;
  String authproviderLink;
  String providerCategory;

  ProviderModel({
    required this.username,
    required this.password,
    required this.note,
    required this.authproviderLink,
    required this.providerCategory,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
      'note': note,
      'authproviderlink': authproviderLink,
      'providerCategory': providerCategory,
    };
  }

  factory ProviderModel.fromMap(Map<String, dynamic> map) {
    return ProviderModel(
      username: map['username'],
      password: map['password'],
      note: map['note'],
      authproviderLink: map['authproviderLink'],
      providerCategory: map['providerCategory'],
    );
  }
}
