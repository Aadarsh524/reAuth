import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reauth/bloc/states/profile_state.dart';
import 'package:reauth/models/profile_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
          'profileImage': profileData['profileImage'] ?? '',
          'isEmailVerified': profileData['isEmailVerified'] ?? false,
        });

        emit(ProfileLoaded(profile: profileModel));
      }
    } on FirebaseAuthException catch (e) {
      emit(ProfileLoadingError(error: e.toString()));
    }
  }

  Future<void> editProfile(
      String fullname, String email, String profileImage) async {
    try {
      emit(ProfileLoading());
      await FirebaseFirestore.instance
          .collection('profiles')
          .doc(user!.uid)
          .set({
        'fullname': fullname,
        'email': email,
        'profileImage': profileImage,
      });

      emit(ProfileUpdated());
    } on FirebaseAuthException catch (e) {
      emit(ProfileUpdateError(error: e.toString()));
    }
  }

  Future<void> uploadImageToFirebase(File image) async {
    try {
      emit(ProfileLoading());
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child('profile_images/${user!.uid}');
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      String downloadURL = await snapshot.ref.getDownloadURL();
      await saveImageURLToFirestore(downloadURL);
      emit(ProfileUpdated());
    } catch (e) {
      emit(ProfileUpdateError(error: e.toString()));
    }
  }

  Future<void> saveImageURLToFirestore(String imageUrl) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('profiles').doc(user!.uid).set({
      'profileImage': imageUrl,
    }, SetOptions(merge: true));
  }

  void clearUserData() {
    emit(ProfileInitial()); // Reset to initial state
  }
}
