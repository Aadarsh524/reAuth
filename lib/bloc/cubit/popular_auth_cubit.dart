import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reauth/bloc/states/popular_provider_state.dart';
import 'package:reauth/constants/auth_category.dart';
import 'package:reauth/models/popular_auth_model.dart';

class PopularAuthCubit extends Cubit<PopularAuthState> {
  User? user = FirebaseAuth.instance.currentUser;

  late List<PopularAuthModel> _popularAuths;

  PopularAuthCubit() : super(PopularAuthInitial()) {
    _popularAuths = [];
  }

  Future<void> fetchPopularAuths() async {
    try {
      emit(PopularAuthLoading());

      // Fetch the collection snapshot from Firestore
      final snapshot =
          await FirebaseFirestore.instance.collection('popularAuths').get();

      // Map each document to a PopularAuthModel
      _popularAuths = snapshot.docs.map((doc) {
        final data = doc.data();

        // Handle potential parsing issues for authCategory
        AuthCategory? authCategory;
        try {
          authCategory = AuthCategory.values.firstWhere(
            (e) => e.toString() == 'AuthCategory.${data['authCategory']}',
            orElse: () => AuthCategory.others, // Use a default if no match
          );
        } catch (_) {
          authCategory = AuthCategory.others; // Fallback for invalid values
        }
        return PopularAuthModel(
          authName: data['authName'] ?? '',
          authLink: data['authLink'] ?? '',
          authCategory: authCategory,
          authFavicon: data['authFavicon'] ?? '',
          authDescription: data['authDescription'],
          tags: List<String>.from(data['tags'] ?? []),
        );
      }).toList();

      // Emit success state with the loaded list
      emit(PopularAuthLoadSuccess(auths: _popularAuths));
    } catch (e) {
      // Emit failure state with the error message
      emit(PopularAuthLoadFailure(error: e.toString()));
    }
  }

  void searchPopularAuth(String searchTerm) {
    final lowerCaseSearchTerm = searchTerm.toLowerCase();
    final matchingProviders = _popularAuths
        .where((provider) =>
            provider.authName.toLowerCase().contains(lowerCaseSearchTerm))
        .toList();

    if (matchingProviders.isEmpty) {
      // No exact or partial matches found
      emit(const PopularAuthSearchFailure(error: "Exact match not found"));
    } else {
      // Prioritize exact matches (if any)
      final exactMatch = matchingProviders.firstWhere(
          (provider) => provider.authName.toLowerCase() == lowerCaseSearchTerm);

      // Emit UserProviderSearchSuccess only for exact match
      emit(PopularAuthSearchSuccess(auth: exactMatch));
    }
  }
}
