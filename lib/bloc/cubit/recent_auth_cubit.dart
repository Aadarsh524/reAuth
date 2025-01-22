import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reauth/bloc/states/recent_auth_state.dart';
import 'package:reauth/models/user_auth_model.dart';

class RecentAuthCubit extends Cubit<RecentAuthState> {
  User? user = FirebaseAuth.instance.currentUser;
  RecentAuthCubit() : super(RecentAuthInitial());

  Future<void> fetchUserRecentProviders() async {
    try {
      emit(RecentAuthLoading());

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection("auths")
          .get();

      final auths = snapshot.docs.map((doc) {
        final data = doc.data();

        return UserAuthModel.fromMap({
          'username': data['username'] ?? '',
          'password': data['password'] ?? '',
          'note': data['note'] ?? '',
          'authProviderLink': data['authProviderLink'] ?? '',
          'providerCategory': data['providerCategory'] ?? '',
          'faviconUrl': data['faviconUrl'] ?? '',
          'authName': data['authName'] ?? '',
        });
      }).toList();

      emit(RecentAuthLoadSuccess(auths: auths));
    } catch (e) {
      emit(RecentAuthLoadFailure(error: e.toString()));
    }
  }
}
