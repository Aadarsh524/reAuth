import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:reauth/bloc/states/user_auth_state.dart';
import 'package:reauth/constants/auth_category.dart';
import 'package:reauth/models/popular_auth_model.dart';
import 'package:reauth/models/user_auth_model.dart';
import 'package:http/http.dart' as http;

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
          'authLink': data['authLink'] ?? '',
          "accountNumber": data['accountNumber'] ?? '',
          'authCategory':
              data['authCategory'] ?? AuthCategory.others.toString(),
          'userAuthFavicon': data['userAuthFavicon'] ?? '',
          'authName': data['authName'] ?? '',
          'transactionPassword': data['transactionPassword'] ?? '',
          'hasTransactionPassword': data['hasTransactionPassword'] ?? false,
          'createdAt': data['createdAt'],
          'updatedAt': data['updatedAt'],
          'lastAccessed': data['lastAccessed'],
          'tags': (data['tags'] ?? []).cast<String>(),
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

  Future<void> submitUserAuth(
      UserAuthModel userAuthModel, bool popularAuth) async {
    try {
      emit(UserAuthLoading());
      final cleanAuthName = userAuthModel.authName.replaceAll(' ', '');

      final userAuthFavicon = await getFaviconUrl(popularAuth, cleanAuthName);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection('auths')
          .doc(userAuthModel.authName)
          .set({
        'authName': cleanAuthName,
        'username': userAuthModel.username,
        'password': userAuthModel.password,
        "accountNumber": userAuthModel.accountNumber,

        'note': userAuthModel.note, // Optional
        'authLink': userAuthModel.authLink,
        'authCategory': userAuthModel.authCategory.toString(),
        'userAuthFavicon': userAuthFavicon,
        'hasTransactionPassword': userAuthModel.hasTransactionPassword,
        'transactionPassword': userAuthModel.transactionPassword, // Optional
        'createdAt': userAuthModel.createdAt!.toIso8601String(),
        'updatedAt': "", // Only date
        'lastAccessed': "", // Only date, Optional
        'tags': userAuthModel.tags ?? [],
        'isFavorite': userAuthModel.isFavorite,
        'mfaOptions': userAuthModel.mfaOptions?.toMap(), // Optional
      });

      emit(UserAuthSubmissionSuccess());
      fetchUserAuths();
    } catch (e) {
      emit(UserAuthSubmissionFailure(error: e.toString()));
    }
  }

  Future<void> editAuth(UserAuthModel userAuthModel) async {
    try {
      emit(UserAuthLoading());
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection('auths')
          .doc(userAuthModel.authName)
          .update({
        'authName': userAuthModel.authName,
        'username': userAuthModel.username,
        'password': userAuthModel.password,
        "accountNumber":
            userAuthModel.accountNumber ?? "", // Provide default if null
        'note': userAuthModel.note ?? "", // Optional field
        'authLink': userAuthModel.authLink, // Optional field
        'authCategory': userAuthModel.authCategory.toString(),
        'userAuthFavicon': userAuthModel.userAuthFavicon, // Optional field
        'hasTransactionPassword':
            userAuthModel.hasTransactionPassword, // Default to false if null
        'transactionPassword':
            userAuthModel.transactionPassword ?? "", // Optional field
        'createdAt': userAuthModel.createdAt?.toIso8601String() ??
            "", // Null check with default
        'updatedAt': userAuthModel.updatedAt?.toIso8601String() ??
            "", // Null check with default
        'lastAccessed': userAuthModel.lastAccessed?.toIso8601String() ??
            "", // Null check with default
        'tags': userAuthModel.tags ?? [], // Default to empty list if null
        'isFavorite': userAuthModel.isFavorite, // Default to false if null
        'mfaOptions':
            userAuthModel.mfaOptions?.toMap() ?? {}, // Handle null map case
      });
      emit(UserAuthSubmissionSuccess());
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

Future<String?> getFaviconUrl(bool popularAuth, String authName) async {
  try {
    // Clean the authName by removing any spaces
    final cleanAuthName = authName.replaceAll(' ', '');

    if (popularAuth) {
      // Check predefined popular providers in Firebase
      final snapshot =
          await FirebaseFirestore.instance.collection('popularAuths').get();

      final auth = snapshot.docs.map((doc) {
        final data = doc.data();
        return PopularAuthModel.fromMap({
          'authName': data['authName'] ?? '',
          'authLink': data['authLink'] ?? '',
          'authCategory':
              data['authCategory'] ?? AuthCategory.others.toString(),
          'authFavicon': data['authFavicon'],
          'description': data['description'] ?? '',
          'tags': data['tags'] ?? []
        });
      }).toList();

      for (var auth in auth) {
        if (auth.authName.toLowerCase().contains(cleanAuthName.toLowerCase())) {
          return auth.authFavicon; // Return the favicon URL if found
        }
      }
    }

    // Use Favicon API for fallback
    String faviconLink =
        "https://api.statvoo.com/favicon/${cleanAuthName.toLowerCase()}.com";
    if (await _isValidUrl(faviconLink)) {
      return faviconLink;
    }

    // Try DuckDuckGo Favicon API as another fallback
    faviconLink =
        "https://icons.duckduckgo.com/ip3/${cleanAuthName.toLowerCase()}.com.ico";
    if (await _isValidUrl(faviconLink)) {
      return faviconLink;
    }

    // If no favicon is found
    return null;
  } catch (e) {
    return null; // Return null in case of errors
  }
}

/// Helper function to validate URL
Future<bool> _isValidUrl(String url) async {
  try {
    final response = await http.head(Uri.parse(url));
    return response.statusCode == 200;
  } catch (e) {
    return false;
  }
}
