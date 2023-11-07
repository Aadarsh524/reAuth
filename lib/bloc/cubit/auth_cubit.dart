import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reauth/bloc/states/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  User? user = FirebaseAuth.instance.currentUser;
  AuthCubit() : super(AuthInitial());

  Future<void> initiateLogin(String email, String password) async {
    final validationError = validateLogin(email, password);
    if (validationError != null) {
      emit(RegisterSubmissionFailure(error: validationError));
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
    }
  }

  Future<void> initiateRegister(
      String email, String password, String confirmPassword) async {
    final validationError = validateRegister(email, password, confirmPassword);
    if (validationError != null) {
      emit(RegisterSubmissionFailure(error: validationError));
      return;
    }
    try {
      emit(AuthLoading());
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(RegisterSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(const LoginFailure(error: "Password is too weak."));
      }
      if (e.code == 'email-already-in-use') {
        emit(const LoginFailure(error: "Account already in exists."));
      }
    }
  }
}

String? validateRegister(
    String email, String password, String confirmPassword) {
  if (email.isEmpty) {
    return 'Email is required';
  }
  if (email.isNotEmpty) {
    final RegExp emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)*(\.[a-z]{2,})$',
      caseSensitive: false,
    );
    if (!emailRegex.hasMatch(email)) {
      return 'Email format is not matched';
    }
  }
  if (password.isEmpty) {
    return 'Username is required';
  }
  if (confirmPassword.isEmpty) {
    return 'Password is required';
  }
  if (password.isNotEmpty && confirmPassword.isNotEmpty) {
    if (password != confirmPassword) {
      return 'Password donot matches';
    }
  }

  return null;
}

String? validateLogin(String email, String password) {
  if (email.isEmpty) {
    return 'Email is required';
  }
  if (email.isNotEmpty) {
    final RegExp emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)*(\.[a-z]{2,})$',
      caseSensitive: false,
    );
    if (!emailRegex.hasMatch(email)) {
      return 'Email format is not matched';
    }
  }
  if (password.isEmpty) {
    return 'Username is required';
  }

  return null;
}
