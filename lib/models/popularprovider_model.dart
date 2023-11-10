class PopularProviderModel {
  String authName;
  String authLink;
  String authCategory;
  String faviconUrl;

  PopularProviderModel({
    required this.authName,
    required this.authLink,
    required this.authCategory,
    required this.faviconUrl,
  });

  factory PopularProviderModel.fromMap(Map<String, dynamic> map) {
    return PopularProviderModel(
      authName: map['authName'],
      authLink: map['authLink'],
      authCategory: map['authCategory'],
      faviconUrl: map['faviconUrl'],
    );
  }
}
