import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reauth/bloc/states/provider_state.dart';
import 'package:reauth/models/provider_model.dart';
import 'package:http/http.dart' as http;

class ProviderCubit extends Cubit<ProviderState> {
  User? user = FirebaseAuth.instance.currentUser;
  ProviderCubit() : super(ProviderInitial());

  Future<void> fetchProviders() async {
    try {
      emit(ProviderLoading());
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection("auths")
          .get();

      final providers = snapshot.docs.map((doc) {
        final data = doc.data();

        return ProviderModel.fromMap({
          'username': data['username'] ?? '',
          'password': data['password'] ?? '',
          'note': data['note'] ?? '',
          'authProviderLink': data['authProviderLink'] ?? '',
          'providerCategory': data['providerCategory'] ?? '',
          'faviconUrl': data['faviconUrl'] ?? ''
        });
      }).toList();

      emit(ProviderLoadSuccess(providers: providers));
    } catch (e) {
      emit(ProviderLoadFailure(error: e.toString()));
    }
  }

  String? validateProvider(ProviderModel provider) {
    if (provider.authProviderLink.isEmpty) {
      return 'Auth Provider Link is required';
    }
    if (provider.authProviderLink.isNotEmpty) {
      final urlPattern = RegExp(r'^www\.\w+\.\w+$');
      if (!urlPattern.hasMatch(provider.authProviderLink)) {
        return 'Url format is not matched';
      }
    }
    if (provider.username.isEmpty) {
      return 'Username is required';
    }
    if (provider.password.isEmpty) {
      return 'Password is required';
    }
    if (provider.providerCategory.isEmpty) {
      return 'Provider Category is required';
    }
    if (provider.note.isEmpty) {
      return 'Note is required';
    }

    return null;
  }

  Future<void> submitProvider(ProviderModel providerModel) async {
    try {
      final validationError = validateProvider(providerModel);
      if (validationError != null) {
        emit(ProviderSubmissionFailure(error: validationError));
        return;
      }

      final faviconUrl = await fetchFaviconUrl(providerModel.faviconUrl);

      // Send data to Firebase
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection('auths')
          .doc()
          .set({
        'username': providerModel.username,
        'password': providerModel.password,
        'note': providerModel.note,
        'authProviderLink': providerModel.authProviderLink,
        'providerCategory': providerModel.providerCategory,
        'faviconUrl': faviconUrl,
      });

      emit(ProviderSubmissionSuccess());
      fetchProviders();
    } catch (e) {
      emit(ProviderSubmissionFailure(error: e.toString()));
    }
  }
}

Future<String?> fetchFaviconUrl(String websiteUrl) async {
  try {
    final faviconUrl = 'https://$websiteUrl/favicon.ico';
    final url = Uri.parse(faviconUrl);
    final response = await http.get(url);

    String errorUrl = 'https://www.facebook.com/favicon.ico';

    if (response.statusCode == 200) {
      return faviconUrl.toString();
    } else {
      return errorUrl.toString();
    }
  } catch (e) {
    return null;
  }
}
