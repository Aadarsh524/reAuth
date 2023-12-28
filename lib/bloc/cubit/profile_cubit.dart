import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reauth/bloc/states/profile_state.dart';
import 'package:reauth/models/profile_model.dart';

class ProfileCubit extends Cubit<ProfileState> {
  User? user = FirebaseAuth.instance.currentUser;
  ProfileCubit() : super(ProfileInitial());

  Future<void> fetchProfile() async {
    try {
      emit(ProfileLoading());

      final profile = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('profile')
          .doc(user!.uid)
          .get();

      final profileData = profile.data();

      if (profileData != null) {
        final profileModel = ProfileModel.fromMap({
          'name': profileData['name'] ?? '',
          'email': profileData['email'] ?? '',
          'pin': profileData['pin'] ?? '',
          'savedPasswords': profileData['savedPasswords'] ?? '',
          'isEmailVerified': profileData['isEmailVerified'] ?? false,
        });

        emit(ProfileLoaded(profile: profileModel));
      }
    } on FirebaseAuthException catch (e) {
      emit(ProfileLoadingError(error: e.toString()));
    }
  }
}
