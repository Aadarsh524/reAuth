import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reauth/bloc/states/recentprovider_state.dart';
import 'package:reauth/models/userprovider_model.dart';

class RecentProviderCubit extends Cubit<RecentProviderState> {
  User? user = FirebaseAuth.instance.currentUser;
  RecentProviderCubit() : super(RecentProviderInitial());

  Future<void> fetchUserRecentProviders() async {
    try {
      emit(RecentProviderLoading());

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection("auths")
          .get();

      final providers = snapshot.docs.map((doc) {
        final data = doc.data();

        return UserProviderModel.fromMap({
          'username': data['username'] ?? '',
          'password': data['password'] ?? '',
          'note': data['note'] ?? '',
          'authProviderLink': data['authProviderLink'] ?? '',
          'providerCategory': data['providerCategory'] ?? '',
          'faviconUrl': data['faviconUrl'] ?? '',
          'authName': data['authName'] ?? '',
        });
      }).toList();

      emit(RecentProviderLoadSuccess(providers: providers));
    } catch (e) {
      emit(RecentProviderLoadFailure(error: e.toString()));
    }
  }
}
