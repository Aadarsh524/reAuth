import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:reauth/bloc/states/user_provider_state.dart';
import 'package:reauth/models/popularprovider_model.dart';
import 'package:reauth/models/userprovider_model.dart';

class UserProviderCubit extends Cubit<UserProviderState> {
  User? user = FirebaseAuth.instance.currentUser;
  late List<UserProviderModel> _userProviders;

  UserProviderCubit() : super(UserProviderInitial()) {
    _userProviders = [];
  }

  Future<void> fetchUserProviders() async {
    try {
      emit(UserProviderLoading());
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection("auths")
          .get();

      _userProviders = snapshot.docs.map((doc) {
        final data = doc.data();

        return UserProviderModel.fromMap({
          'username': data['username'] ?? '',
          'password': data['password'] ?? '',
          'note': data['note'] ?? '',
          'authProviderLink': data['authProviderLink'] ?? '',
          'providerCategory': data['providerCategory'] ?? '',
          'faviconUrl': data['faviconUrl'] ?? '',
          'authName': data['authName'] ?? '',
          'hasTransactionPassword': data['hasTransactionPassword'] ?? false,
          'transactionPassword': data['transactionPassword'] ?? '',
        });
      }).toList();

      emit(UserProviderLoadSuccess(providers: _userProviders));
    } catch (e) {
      emit(UserProviderLoadFailure(error: e.toString()));
    }
  }

  void searchUserAuth(String searchTerm) {
    final matchingProvider = _userProviders.firstWhere((provider) {
      return provider.authName.toLowerCase().contains(searchTerm.toLowerCase());
    });

    emit(UserProviderSearchSuccess(provider: matchingProvider));
  }

  String? validateProvider(UserProviderModel provider) {
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
    if (provider.hasTransactionPassword == true) {
      if (provider.transactionPassword!.isEmpty) {
        return 'Transaction Pass is empty';
      }
    }

    return null;
  }

  Future<void> submitProvider(
      UserProviderModel providerModel, bool popularProvider) async {
    try {
      emit(UserProviderLoading());
      final validationError = validateProvider(providerModel);
      if (validationError != null) {
        emit(UserProviderSubmissionFailure(error: validationError));
        return;
      }

      final faviconUrl =
          await getFaviconUrl(popularProvider, providerModel.authName);

      // Send data to Firebase
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection('auths')
          .doc(providerModel.authName)
          .set({
        'authName': providerModel.authName,
        'username': providerModel.username,
        'password': providerModel.password,
        'note': providerModel.note,
        'authProviderLink': providerModel.authProviderLink,
        'providerCategory': providerModel.providerCategory,
        'faviconUrl': faviconUrl,
        'hasTransactionPassword': providerModel.hasTransactionPassword,
        'transactionPassword': providerModel.transactionPassword,
      });

      emit(UserProviderSubmissionSuccess());
      fetchUserProviders();
    } catch (e) {
      emit(UserProviderSubmissionFailure(error: e.toString()));
    }
  }

  Future<void> deleteProvider(String userAuthId) async {
    try {
      emit(UserProviderLoading());

      // Delete the provider document from Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection('auths')
          .doc(userAuthId)
          .delete();

      emit(UserProviderDeletedSuccess());
    } catch (e) {
      emit(UserProviderDeletedFailure(error: e.toString()));
    }
  }
}

Future<String> getFaviconUrl(bool popularProvider, String authName) async {
  String auth = authName.toLowerCase();
  try {
    if (popularProvider == true) {
      String faviconLink = '';
      final snapshot =
          await FirebaseFirestore.instance.collection('popularAuths').get();

      final providers = snapshot.docs.map((doc) {
        final data = doc.data();

        return PopularProviderModel.fromMap({
          'authName': data['authName'] ?? '',
          'authLink': data['authLink'] ?? '',
          'authCategory': data['authCategory'] ?? '',
          'faviconUrl': data['faviconUrl'] ?? ''
        });
      }).toList();

      for (var provider in providers) {
        if (provider.authName.toLowerCase().contains(auth)) {
          faviconLink = provider.faviconUrl;
        }
      }
      return faviconLink;
    } else {
      String faviconLink = "https://api.statvoo.com/favicon/$auth.com";
      return faviconLink;
    }
  } catch (e) {
    return e.toString();
  }
}
