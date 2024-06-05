import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reauth/bloc/states/auth_state.dart';
import 'package:reauth/utils/validator.dart';

class AuthCubit extends Cubit<AuthState> {
  User? user = FirebaseAuth.instance.currentUser;
  AuthCubit() : super(AuthInitial());

  Future<void> initiateLogin(String email, String password) async {
    final validationError = validateLogin(email, password);
    if (validationError != null) {
      emit(LoginSubmissionFailure(error: validationError));
      return;
    }
    try {
      emit(AuthLoading());
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
      emit(AuthLoading());

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
      emit(AuthLoading());
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
}
