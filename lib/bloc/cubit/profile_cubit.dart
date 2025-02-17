import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../states/profile_state.dart';
import '../../models/profile_model.dart';
import '../../services/encryption_service.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  ProfileCubit({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance,
        super(ProfileInitial());

  Future<void> fetchProfile() async {
    try {
      emit(ProfileLoading());
      final currentUser = _auth.currentUser;

      if (currentUser == null) {
        emit(const ProfileLoadingError(error: 'User not authenticated'));
        return;
      }

      final profileDoc =
          await _firestore.collection('profiles').doc(currentUser.uid).get();

      if (!profileDoc.exists) {
        emit(const ProfileLoadingError(error: 'Profile not found'));
        return;
      }

      final profileModel = ProfileModel.fromMap(profileDoc.data()!);

      // If master pin is set, securely store it
      if (profileModel.isMasterPinSet && profileModel.masterPin.isNotEmpty) {
        // Encrypt before storing
        String encryptedMasterPassword =
            await EncryptionService.encryptData(profileModel.masterPin);
        await _secureStorage.write(
            key: 'encrypted_master_password', value: encryptedMasterPassword);
      }

      emit(ProfileLoaded(profile: profileModel));
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(ProfileLoadingError(error: 'Failed to fetch profile: $e'));
    }
  }

  Future<void> updateProfile({
    required String fullname,
    String? profileImage,
  }) async {
    try {
      emit(ProfileLoading());
      final currentUser = _auth.currentUser;

      if (currentUser == null) {
        emit(const ProfileUpdateError(error: 'User not authenticated'));
        return;
      }
      await _firestore.collection('profiles').doc(currentUser.uid).update({
        'fullName': fullname,
      });

      emit(ProfileUpdated());
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(ProfileUpdateError(error: 'Failed to update profile: $e'));
    }
  }

  Future<void> clearMasterPin() async {
    try {
      emit(ProfileLoading());
      final currentUser = _auth.currentUser;

      if (currentUser == null) {
        emit(const ProfileUpdateError(error: 'User not authenticated'));
        return;
      }
      await _firestore
          .collection('profiles')
          .doc(currentUser.uid)
          .update({'isMasterPinSet': false, 'isBiometricSet': false});

      emit(ProfileUpdated());
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(ProfileUpdateError(error: 'Failed to update profile: $e'));
    }
  }

  Future<void> uploadImageToFirebase(File image) async {
    try {
      emit(ProfileLoading());
      final currentUser = _auth.currentUser;

      if (currentUser == null) {
        emit(const ProfileUpdateError(error: 'User not authenticated'));
        return;
      }

      final ref = _storage.ref().child('profile_images/${currentUser.uid}');
      final uploadTask = ref.putFile(image);
      final snapshot = await uploadTask;
      final downloadURL = await snapshot.ref.getDownloadURL();

      await _firestore.collection('profiles').doc(currentUser.uid).set({
        'profileImage': downloadURL,
      }, SetOptions(merge: true));

      emit(ProfileUpdated());
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(ProfileUpdateError(error: 'Failed to upload image: $e'));
    }
  }

  void clearUserData() {
    emit(ProfileInitial());
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    // Log errors (e.g., using Crashlytics or Sentry)
    super.onError(error, stackTrace);
  }
}
