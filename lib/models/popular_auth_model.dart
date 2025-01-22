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
    this.tags, // Optional tags for categorization
  });

  factory PopularAuthModel.fromMap(Map<String, dynamic> map) {
    return PopularAuthModel(
      authName: map['authName'] ?? '', // Default to empty string if null
      authLink: map['authLink'] ?? '', // Default to empty string if null
      authCategory: AuthCategory.values.firstWhere(
        (e) => e.toString() == map['authCategory'],
        orElse: () => AuthCategory.others, // Handle unknown categories
      ),
      authFavicon: map['authFavicon'], // Handle optional field
      authDescription: map['authDescription'], // Handle optional field
      tags: map['tags']?.cast<String>(), // Cast to a list of strings
    );
  }
}
