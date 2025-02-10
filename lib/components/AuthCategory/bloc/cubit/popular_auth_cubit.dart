import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:reauth/components/AuthCategory/bloc/states/popular_provider_state.dart';
import 'package:reauth/components/constants/auth_category.dart';
import 'package:reauth/models/popular_auth_model.dart';

class PopularAuthCubit extends Cubit<PopularAuthState> {
  final FirebaseFirestore _firestore;
  List<PopularAuthModel> _popularAuths = [];

  PopularAuthCubit({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        super(PopularAuthInitial());

  Future<void> fetchPopularAuths() async {
    try {
      emit(PopularAuthLoading());

      // Fetch data from Firestore
      final snapshot = await _firestore.collection('popularAuths').get();

      // Parse and map documents to PopularAuthModel
      _popularAuths = snapshot.docs.map((doc) {
        final data = doc.data();
        return PopularAuthModel(
          authName: data['authName'] ?? '',
          authLink: data['authLink'] ?? '',
          authCategory: _parseAuthCategory(data['authCategory']),
          authFavicon: data['authFavicon'] ?? '',
          authDescription: data['authDescription'] ?? '',
          tags: List<String>.from(data['tags'] ?? []),
        );
      }).toList();

      emit(PopularAuthLoadSuccess(auths: _popularAuths));
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(PopularAuthLoadFailure(error: 'Failed to load popular auths: $e'));
    }
  }

  AuthCategory _parseAuthCategory(String? category) {
    try {
      return AuthCategory.values.firstWhere(
        (e) => e.toString() == 'AuthCategory.$category',
        orElse: () => AuthCategory.others,
      );
    } catch (_) {
      return AuthCategory.others;
    }
  }

  void searchPopularAuth(String searchTerm) {
    if (searchTerm.isEmpty) {
      emit(PopularAuthSearchEmpty());
      return;
    }

    final lowerCaseSearchTerm = searchTerm.toLowerCase();
    final matchingProviders = _popularAuths.where((provider) {
      return provider.authName.toLowerCase().contains(lowerCaseSearchTerm);
    }).toList();

    if (matchingProviders.isEmpty) {
      emit(const PopularAuthSearchFailure(error: 'No matches found'));
    } else {
      // Prioritize exact matches
      final exactMatch = matchingProviders.firstWhere(
        (provider) => provider.authName.toLowerCase() == lowerCaseSearchTerm,
        orElse: () => matchingProviders.first,
      );

      emit(PopularAuthSearchSuccess(auth: exactMatch));
    }
  }

  void clearUserData() {
    _popularAuths.clear();
    emit(PopularAuthInitial());
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    // Log errors (e.g., using Crashlytics or Sentry)
    super.onError(error, stackTrace);
  }
}
