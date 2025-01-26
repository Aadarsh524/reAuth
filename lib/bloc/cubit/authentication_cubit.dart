import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reauth/bloc/cubit/popular_auth_cubit.dart';
import 'package:reauth/bloc/cubit/profile_cubit.dart';
import 'package:reauth/bloc/cubit/recent_auth_cubit.dart';
import 'package:reauth/bloc/cubit/user_auth_cubit.dart';
import 'package:reauth/bloc/states/auth_state.dart';
import 'package:reauth/utils/validator.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  User? user = FirebaseAuth.instance.currentUser;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();
  AuthenticationCubit() : super(AuthenticationInitial());

  Future<bool> isLoggedIn() async {
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> initiateLogin(String email, String password) async {
    final validationError = validateLogin(email, password);
    if (validationError != null) {
      emit(LoginSubmissionFailure(error: validationError));
      return;
    }
    try {
      emit(AuthenticationLoading());
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(const LoginFailure(error: "User not found with that email"));
      }
      if (e.code == 'invalid-credential') {
        emit(const LoginFailure(error: "Invalid Credentials"));
      } else if (e.code == 'too-many-requests') {
        emit(const LoginFailure(error: "Too many requests"));
      }
      emit(const LoginFailure(error: "Error login"));
    }
  }

  Future<void> setPin(String pin1, String pin2) async {
    final validationError = validateSetPin(pin1, pin1);
    if (validationError != null) {
      emit(PinError(error: validationError));
      return;
    }
    try {
      emit(AuthenticationLoading());

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('profile')
          .doc(user!.uid)
          .set({'pin': pin1});

      emit(PinSetSuccess());
    } on FirebaseAuthException catch (e) {
      emit(PinError(error: e.toString()));
    }
  }

  Future<void> initiateRegister(String fullname, String email, String password,
      String confirmPassword) async {
    final validationError = validateRegister(email, password, confirmPassword);
    if (validationError != null) {
      emit(RegisterSubmissionFailure(error: validationError));
      return;
    }
    try {
      emit(AuthenticationLoading());
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then(
        (value) async {
          await FirebaseFirestore.instance
              .collection('profiles')
              .doc(value.user!.uid)
              .set({
            'fullname': fullname,
            'email': email,
            'pin': '',
            'isEmailVerified': false,
            'avatar': ''
          });
        },
      );
      emit(RegisterSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(const RegisterFailure(error: "Password is too weak."));
      }
      if (e.code == 'email-already-in-use') {
        emit(const RegisterFailure(error: "Account already in exists."));
      } else {
        emit(const RegisterFailure(error: "Error Registeration"));
      }
    }
  }

  Future<void> changeEmailVerificationStatus() async {
    try {
      await FirebaseFirestore.instance
          .collection('profiles')
          .doc(user!.uid)
          .update({
        'isEmailVerified': true,
      });

      emit(RegisterSuccess());
    } on FirebaseAuthException {
      emit(const RegisterFailure(error: "Cannot Verify Email"));
    }
  }

  Future<void> changePassword(
      String email, String currentPassword, String newPassword) async {
    try {
      emit(AuthenticationLoading());
      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: currentPassword,
      );

      await user?.reauthenticateWithCredential(credential);

      await user!.updatePassword(newPassword);

      emit(RegisterSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(const RegisterFailure(error: "Password is too weak."));
      } else {
        emit(const RegisterFailure(error: "Error Changing Passwords"));
      }
    }
  }

  Future<void> deleteAccount() async {
    User? user = FirebaseAuth.instance.currentUser;
    try {
      emit(AuthenticationLoading());
      await user!.delete();

      emit(RegisterSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(const RegisterFailure(error: "Password is too weak."));
      } else {
        emit(const RegisterFailure(error: "Error Changing Passwords"));
      }
    }
  }

  void clearUserData() {
    emit(AuthenticationInitial()); // Reset to initial state
  }

  Future<bool> logOut(BuildContext context) async {
    try {
      // Emit loading state
      emit(LoggingOut());
      clearUserData();

      // Clear user data from the application
      BlocProvider.of<UserAuthCubit>(context).clearUserData();
      BlocProvider.of<PopularAuthCubit>(context).clearUserData();
      BlocProvider.of<ProfileCubit>(context).clearUserData();
      BlocProvider.of<RecentAuthCubit>(context).clearUserData();

      // Sign out from Google and Firebase
      await googleSignIn.signOut();
      await firebaseAuth.signOut();

      // Ensure the user is signed out
      if (FirebaseAuth.instance.currentUser == null) {
        emit(LoggedOutSuccess());
        return true; // Logout successful
      } else {
        emit(const RegisterFailure(
            error: "Failed to sign out. Please try again."));
        return false; // Logout failed
      }
    } catch (e) {
      // Emit a failure state with error message
      emit(const RegisterFailure(error: "An error occurred during sign-out."));
      return false; // An error occurred
    }
  }
}
