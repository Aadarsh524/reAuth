import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reauth/bloc/states/popular_provider_state.dart';
import 'package:reauth/models/popularprovider_model.dart';

class PopularProviderCubit extends Cubit<PopularProviderState> {
  User? user = FirebaseAuth.instance.currentUser;

  late List<PopularProviderModel> _popularProviders;

  PopularProviderCubit() : super(PopularProviderInitial()) {
    _popularProviders = [];
  }

  Future<void> fetchPopularProviders() async {
    try {
      emit(PopularProviderLoading());
      final snapshot =
          await FirebaseFirestore.instance.collection('popularAuths').get();

      _popularProviders = snapshot.docs.map((doc) {
        final data = doc.data();

        return PopularProviderModel.fromMap({
          'authName': data['authName'] ?? '',
          'authLink': data['authLink'] ?? '',
          'authCategory': data['authCategory'] ?? '',
          'faviconUrl': data['faviconUrl'] ?? ''
        });
      }).toList();

      emit(PopularProviderLoadSuccess(providers: _popularProviders));
    } catch (e) {
      emit(PopularProviderLoadFailure(error: e.toString()));
    }
  }

  void searchPopularAuth(String searchTerm) {
    final lowerCaseSearchTerm = searchTerm.toLowerCase();
    final matchingProviders = _popularProviders
        .where((provider) =>
            provider.authName.toLowerCase().contains(lowerCaseSearchTerm))
        .toList();

    if (matchingProviders.isEmpty) {
      // No exact or partial matches found
      emit(const PopularProviderSearchFailure(error: "Exact match not found"));
    } else {
      // Prioritize exact matches (if any)
      final exactMatch = matchingProviders.firstWhere(
          (provider) => provider.authName.toLowerCase() == lowerCaseSearchTerm);

      // Emit UserProviderSearchSuccess only for exact match
      emit(PopularProviderSearchSuccess(provider: exactMatch));
    }
  }
}
