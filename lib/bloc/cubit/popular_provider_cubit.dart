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
    final matchingProvider = _popularProviders.firstWhere((provider) {
      return provider.authName.toLowerCase().contains(searchTerm.toLowerCase());
    });

    emit(PopularProviderSearchSuccess(provider: matchingProvider));
  }
}
