import 'package:reauth/constants/auth_category.dart';

class PopularAuthModel {
  String authName; // Name of the provider
  String authLink; // URL for the provider's authentication page
  AuthCategory authCategory; // Category as an enum for stricter typing
  String authFavicon; // Optional for handling cases without an icon
  String? authDescription; // Optional short description of the provider
  List<String>? tags; // Optional tags for categorization

  PopularAuthModel({
    required this.authName,
    required this.authLink,
    required this.authCategory,
    required this.authFavicon,
    this.authDescription,
    this.tags,
  });

  /// Factory constructor to create a PopularAuthModel instance from a map
  factory PopularAuthModel.fromMap(Map<String, dynamic> map) {
    return PopularAuthModel(
      authName: map['authName'] ?? '', // Default to empty string if null
      authLink: map['authLink'] ?? '', // Default to empty string if null
      authCategory: AuthCategory.values.firstWhere(
        (e) => e.toString() == map['authCategory'],
        orElse: () => AuthCategory.others, // Handle unknown categories
      ),
      authFavicon: map['authFavicon'] ?? '', // Default to empty string if null
      authDescription: map['authDescription'], // Optional field
      tags: map['tags']?.cast<String>(), // Cast to a list of strings
    );
  }

  /// Converts the PopularAuthModel instance to a map
  Map<String, dynamic> toMap() {
    return {
      'authName': authName,
      'authLink': authLink,
      'authCategory': authCategory.toString(),
      'authFavicon': authFavicon,
      'authDescription': authDescription,
      'tags': tags,
    };
  }
}
