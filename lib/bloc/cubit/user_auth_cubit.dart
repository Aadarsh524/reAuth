import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:reauth/bloc/states/user_auth_state.dart';
import 'package:reauth/models/popular_auth_model.dart';
import 'package:reauth/models/user_auth_model.dart';

class UserAuthCubit extends Cubit<UserAuthState> {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final http.Client _httpClient;

  List<UserAuthModel> _userAuths = [];

  UserAuthCubit({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    http.Client? httpClient,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _httpClient = httpClient ?? http.Client(),
        super(UserAuthInitial());

  Future<void> fetchUserAuths() async {
    try {
      emit(UserAuthLoading());
      final currentUser = _auth.currentUser;

      if (currentUser == null) {
        emit(const UserAuthLoadFailure(error: 'User not authenticated'));
        return;
      }

      final snapshot = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('auths')
          .get();

      _userAuths = snapshot.docs.map((doc) {
        return UserAuthModel.fromMap(doc.data());
      }).toList();

      emit(UserAuthLoadSuccess(auths: _userAuths));
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(UserAuthLoadFailure(error: 'Failed to fetch user auths: $e'));
    }
  }

  Future<void> submitUserAuth({
    required UserAuthModel userAuthModel,
    required bool popularAuth,
  }) async {
    try {
      emit(UserAuthLoading());
      final currentUser = _auth.currentUser;

      if (currentUser == null) {
        emit(const UserAuthSubmissionFailure(error: 'User not authenticated'));
        return;
      }

      final cleanAuthName = userAuthModel.authName.replaceAll(' ', '');
      final userAuthFavicon = await _getFaviconUrl(popularAuth, cleanAuthName);

      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('auths')
          .doc(cleanAuthName)
          .set(userAuthModel.toMap()..['userAuthFavicon'] = userAuthFavicon);

      emit(UserAuthSubmissionSuccess());
      await fetchUserAuths(); // Refresh the list
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(UserAuthSubmissionFailure(error: 'Failed to submit user auth: $e'));
    }
  }

  Future<void> editAuth(UserAuthModel userAuthModel) async {
    try {
      emit(UserAuthLoading());
      final currentUser = _auth.currentUser;

      if (currentUser == null) {
        emit(const UserAuthSubmissionFailure(error: 'User not authenticated'));
        return;
      }

      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('auths')
          .doc(userAuthModel.authName)
          .update(userAuthModel.toMap());

      emit(UserAuthSubmissionSuccess());
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(UserAuthSubmissionFailure(error: 'Failed to edit user auth: $e'));
    }
  }

  Future<void> deleteProvider(String userAuthId) async {
    try {
      emit(UserAuthLoading());
      final currentUser = _auth.currentUser;

      if (currentUser == null) {
        emit(const UserAuthDeletedFailure(error: 'User not authenticated'));
        return;
      }

      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('auths')
          .doc(userAuthId)
          .delete();

      emit(UserAuthDeletedSuccess());
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(UserAuthDeletedFailure(error: 'Failed to delete provider: $e'));
    }
  }

  Future<void> updateAuthLastAccessed(
      String authName, DateTime lastAccessed) async {
    final currentUser = _auth.currentUser;

    if (currentUser == null) return;

    await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('auths')
        .doc(authName)
        .update({'lastAccessed': lastAccessed.toIso8601String()});
  }

  void searchUserAuth(String searchTerm) {
    if (searchTerm.isEmpty) {
      emit(UserAuthSearchEmpty());
      return;
    }

    final lowerCaseSearchTerm = searchTerm.toLowerCase();
    final matchingProviders = _userAuths
        .where((provider) =>
            provider.authName.toLowerCase().contains(lowerCaseSearchTerm))
        .toList();

    if (matchingProviders.isEmpty) {
      emit(const UserAuthSearchFailure(error: 'No matches found'));
    } else {
      final exactMatch = matchingProviders.firstWhere(
        (provider) => provider.authName.toLowerCase() == lowerCaseSearchTerm,
        orElse: () => matchingProviders.first,
      );

      emit(UserAuthSearchSuccess(auth: exactMatch));
    }
  }

  void clearUserData() {
    _userAuths.clear();
    emit(UserAuthInitial());
  }

  Future<String?> _getFaviconUrl(bool popularAuth, String authName) async {
    try {
      final cleanAuthName = authName.replaceAll(' ', '');

      if (popularAuth) {
        final snapshot = await _firestore.collection('popularAuths').get();
        final auths = snapshot.docs
            .map((doc) => PopularAuthModel.fromMap(doc.data()))
            .toList();

        for (final auth in auths) {
          if (auth.authName
              .toLowerCase()
              .contains(cleanAuthName.toLowerCase())) {
            return auth.authFavicon;
          }
        }
      }

      final faviconLinks = [
        "https://api.statvoo.com/favicon/${cleanAuthName.toLowerCase()}.com",
        "https://icons.duckduckgo.com/ip3/${cleanAuthName.toLowerCase()}.com.ico",
      ];

      for (final link in faviconLinks) {
        if (await _isValidUrl(link)) return link;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> _isValidUrl(String url) async {
    try {
      final response = await _httpClient.head(Uri.parse(url));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    // Log errors (e.g., using Crashlytics or Sentry)
    super.onError(error, stackTrace);
  }
}
