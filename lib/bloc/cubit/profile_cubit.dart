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
          .collection('profiles')
          .doc(user!.uid)
          .get();

      final profileData = profile.data();

      if (profileData != null) {
        final profileModel = ProfileModel.fromMap({
          'fullname': profileData['fullname'] ?? '',
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

  Future<void> editProfile(String fullname, String email) async {
    try {
      emit(ProfileLoading());
      await FirebaseFirestore.instance
          .collection('profiles')
          .doc(user!.uid)
          .set({
        'fullname': fullname,
        'email': email,
      });

      emit(ProfileUpdated());
    } on FirebaseAuthException catch (e) {
      emit(ProfileUpdateError(error: e.toString()));
    }
  }
}
