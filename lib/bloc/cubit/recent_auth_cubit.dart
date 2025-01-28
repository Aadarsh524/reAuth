import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reauth/bloc/states/recent_auth_state.dart';
import 'package:reauth/models/user_auth_model.dart';

class RecentAuthCubit extends Cubit<RecentAuthState> {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  RecentAuthCubit({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        super(RecentAuthInitial());

  Future<void> fetchUserRecentProviders() async {
    try {
      emit(RecentAuthLoading());
      final currentUser = _auth.currentUser;

      if (currentUser == null) {
        emit(const RecentAuthLoadFailure(error: 'User not authenticated'));
        return;
      }

      final snapshot = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('auths')
          .get();

      final auths = snapshot.docs.map((doc) {
        return UserAuthModel.fromMap(doc.data());
      }).toList();

      emit(RecentAuthLoadSuccess(auths: auths));
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(RecentAuthLoadFailure(error: 'Failed to fetch recent auths: $e'));
    }
  }

  void clearUserData() {
    emit(RecentAuthInitial());
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    // Log errors (e.g., using Crashlytics or Sentry)
    super.onError(error, stackTrace);
  }
}
