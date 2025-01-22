import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:reauth/bloc/states/user_auth_state.dart';
import 'package:reauth/constants/auth_category.dart';
import 'package:reauth/models/popular_auth_model.dart';
import 'package:reauth/models/user_auth_model.dart';

class UserAuthCubit extends Cubit<UserAuthState> {
  User? user = FirebaseAuth.instance.currentUser;
  late List<UserAuthModel> _userAuths;

  UserAuthCubit() : super(UserAuthInitial()) {
    _userAuths = [];
  }

  Future<void> fetchUserAuths() async {
    try {
      emit(UserAuthLoading());
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection("auths")
          .get();

      _userAuths = snapshot.docs.map((doc) {
        final data = doc.data();

        return UserAuthModel.fromMap({
          'username': data['username'] ?? '',
          'password': data['password'] ?? '',
          'note': data['note'] ?? '',
          'authProviderLink': data['authProviderLink'] ?? '',
          'providerCategory':
              data['providerCategory'] ?? AuthCategory.others.toString(),
          'faviconUrl': data['faviconUrl'],
          'authName': data['authName'] ?? '',
          'transactionPassword': data['transactionPassword'],
          'hasTransactionPassword': data['hasTransactionPassword'] ?? false,
          'createdAt': data['createdAt'] ?? DateTime.now().toIso8601String(),
          'updatedAt': data['updatedAt'] ?? DateTime.now().toIso8601String(),
          'lastAccessed': data['lastAccessed'],
          'tags': data['tags']?.cast<String>(),
          'isFavorite': data['isFavorite'] ?? false,
          'mfaOptions': data['mfaOptions'],
        });
      }).toList();

      emit(UserAuthLoadSuccess(auths: _userAuths));
    } catch (e) {
      emit(UserAuthLoadFailure(error: e.toString()));
    }
  }

  void searchUserAuth(String searchTerm) {
    final lowerCaseSearchTerm = searchTerm.toLowerCase();
    final matchingProviders = _userAuths
        .where((provider) =>
            provider.authName.toLowerCase().contains(lowerCaseSearchTerm))
        .toList();

    if (matchingProviders.isEmpty) {
      // No exact or partial matches found
      emit(const UserAuthSearchFailure(error: "Exact match not found"));
    } else {
      // Prioritize exact matches (if any)
      final exactMatch = matchingProviders.firstWhere(
          (provider) => provider.authName.toLowerCase() == lowerCaseSearchTerm);

      // Emit UserProviderSearchSuccess only for exact match
      emit(UserAuthSearchSuccess(auth: exactMatch));
    }
  }

  String? validateProvider(UserAuthModel provider) {
    if (provider.authLink.isEmpty) {
      return 'Auth Provider Link is required';
    }
    if (provider.authLink.isNotEmpty) {
      final urlPattern = RegExp(r'^www\.\w+\.\w+$');
      if (!urlPattern.hasMatch(provider.authLink)) {
        return 'Url format is not matched';
      }
    }
    if (provider.username.isEmpty) {
      return 'Username is required';
    }
    if (provider.password.isEmpty) {
      return 'Password is required';
    }
    // ignore: unrelated_type_equality_checks
    if (provider.authCategory == '') {
      return 'Provider Category is required';
    }

    if (provider.hasTransactionPassword == true) {
      if (provider.transactionPassword!.isEmpty) {
        return 'Transaction Pass is empty';
      }
    }

    return null;
  }

  Future<void> submitProvider(
      UserAuthModel providerModel, bool popularProvider) async {
    try {
      emit(UserAuthLoading());
      final validationError = validateProvider(providerModel);
      if (validationError != null) {
        emit(UserAuthSubmissionFailure(error: validationError));
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
        'authLink': providerModel.authLink,
        'providerCategory': providerModel.authCategory,
        'faviconUrl': faviconUrl,
        'hasTransactionPassword': providerModel.hasTransactionPassword,
        'transactionPassword': providerModel.transactionPassword,
      });

      emit(UserAuthSubmissionSuccess());
      fetchUserAuths();
    } catch (e) {
      emit(UserAuthSubmissionFailure(error: e.toString()));
    }
  }

  Future<void> editProvider(UserAuthModel providerModel) async {
    try {
      emit(UserAuthLoading());
      final validationError = validateProvider(providerModel);
      if (validationError != null) {
        emit(UserAuthSubmissionFailure(error: validationError));
        return;
      }

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
        'authLink': providerModel.authLink,
        'providerCategory': providerModel.authCategory,
        'faviconUrl': providerModel.userAuthFavicon,
        'hasTransactionPassword': providerModel.hasTransactionPassword,
        'transactionPassword': providerModel.transactionPassword,
      });

      emit(UserAuthSubmissionSuccess());
      fetchUserAuths();
    } catch (e) {
      emit(UserAuthSubmissionFailure(error: e.toString()));
    }
  }

  Future<void> deleteProvider(String userAuthId) async {
    try {
      emit(UserAuthLoading());

      // Delete the provider document from Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection('auths')
          .doc(userAuthId)
          .delete();

      emit(UserAuthDeletedSuccess());
    } catch (e) {
      emit(UserAuthDeletedFailure(error: e.toString()));
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

        return PopularAuthModel.fromMap({
          'authName': data['authName'] ?? '',
          'authLink': data['authLink'] ?? '',
          'authCategory':
              data['authCategory'] ?? AuthCategory.others.toString(),
          'faviconUrl': data['faviconUrl'],
          'popularityRank': data['popularityRank'] ?? 0,
          'description': data['description'] ?? '',
        });
      }).toList();

      for (var provider in providers) {
        if (provider.authName.toLowerCase().contains(auth)) {
          faviconLink = provider.authFavicon;
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
