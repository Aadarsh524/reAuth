import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reauth/bloc/states/auth_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  User? get currentUser => _auth.currentUser;

  AuthenticationCubit({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        super(AuthenticationInitial()) {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        emit(Authenticated(user));
        // _checkEmailVerification(user);
      } else {
        emit(Unauthenticated());
      }
    });
  }

  Future<bool> checkEmailVerification(User user) async {
    await user.reload(); // Reload the user to get the latest data
    final updatedUser = _auth.currentUser;
    if (updatedUser != null && updatedUser.emailVerified) {
      emit(EmailVerificationSuccess());
      return true; // Email is verified
    } else {
      emit(EmailVerificationNeeded());
      return false; // Email is not verified
    }
  }

  Future<void> initialize() async {
    emit(AuthenticationLoading());
    try {
      // Reload the user to get the latest auth state
      await _auth.currentUser?.reload();
      final user = _auth.currentUser;
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(const AuthError(
          message: 'Initialization failed', errorType: AuthErrorType.generic));
    }
  }

  Future<void> _performAuthOperation(
    Future<void> Function() operation, {
    required AuthenticationState successState,
    required AuthErrorType errorType,
  }) async {
    try {
      emit(AuthenticationLoading());
      await operation();
      emit(successState);
    } catch (e) {
      emit(AuthError(
        message: _parseError(e),
        errorType: errorType,
      ));
    }
  }

  void clearUserData() {
    emit(AuthenticationInitial()); // Reset to initial state
  }

  Future<void> login(String email, String password) async {
    emit(AuthenticationInitial());
    final error = _validateFields({
      AuthField.email: email,
      AuthField.password: password,
    }, false);

    if (error.isNotEmpty) {
      emit(ValidationError(error));
      return;
    }

    await _performAuthOperation(
      () async {
        final result = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        emit(LoginSuccess(user: result.user!));
      },
      successState: LoginInProgress(),
      errorType: AuthErrorType.login,
    );
  }

  String _parseError(dynamic error) {
    // Check if it's a FirebaseAuthException
    if (error is FirebaseAuthException) {
      switch (error.code) {
        // Login Errors
        case 'user-not-found':
          return 'No user found for this email';
        case 'wrong-password':
          return 'Incorrect password';
        case 'invalid-email':
          return 'Invalid email format';
        case 'too-many-requests':
          return 'Too many attempts. Please try again later';

        // Registration Errors
        case 'email-already-in-use':
          return 'Email is already registered';
        case 'weak-password':
          return 'Password must be at least 6 characters';
        case 'operation-not-allowed':
          return 'Email/password sign-in is not enabled';

        // General Authentication Errors
        case 'network-request-failed':
          return 'Network request failed. Please check your internet connection';
        case 'user-disabled':
          return 'This account has been disabled. Please contact support';

        // Handle any other Firebase errors
        default:
          return error.message ?? 'Authentication failed';
      }
    }

    // Handle general errors (non-Firebase specific)
    if (error is Exception || error is Error) {
      return error.toString();
    }

    // Default error message
    return 'An unexpected error occurred';
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    emit(AuthenticationInitial());
    final error = _validateFields({
      AuthField.fullName: fullName,
      AuthField.email: email,
      AuthField.password: password,
      AuthField.confirmPassword: confirmPassword,
    }, true);

    if (error.isNotEmpty) {
      emit(ValidationError(error));
      return;
    }

    await _performAuthOperation(
      () async {
        final credential = await _auth.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );

        await _firestore.collection('profiles').doc(credential.user!.uid).set({
          'fullName': fullName,
          'email': email,
          'pin': '',
          'profileImage': '',
        });

        logout();

        emit(RegistrationSuccess(user: credential.user!));
      },
      successState: AuthenticationInitial(),
      errorType: AuthErrorType.registration,
    );
  }

  String _validateFields(Map<AuthField, String> fields, bool isRegistering) {
    // If login (not registration), check if both fields are empty.
    if (!isRegistering) {
      if ((fields[AuthField.email]?.isEmpty ?? true) &&
          (fields[AuthField.password]?.isEmpty ?? true)) {
        return 'Empty Credentials';
      }
      if (fields[AuthField.email]?.isEmpty ?? true) {
        return 'Email cannot be empty';
      }
      if (fields[AuthField.password]?.isEmpty ?? true) {
        return 'Password cannot be empty';
      }
      return ''; // No errors, return an empty string
    }

    // If in register flow, check for empty fields, email format, and password rules.
    if (fields[AuthField.email]?.isEmpty ?? true) {
      return 'Email cannot be empty';
    } else if (fields[AuthField.email]?.isValidEmail != true) {
      return 'Invalid email address';
    }

    if (fields[AuthField.password]?.isEmpty ?? true) {
      return 'Password cannot be empty';
    } else if (fields[AuthField.password]?.isValidPassword != true) {
      return 'Password must be 6+ characters';
    }

    // If confirm password is empty or doesn't match password.
    if (fields[AuthField.confirmPassword]?.isEmpty ?? true) {
      return 'Confirm Password cannot be empty';
    } else if (fields[AuthField.confirmPassword] !=
        fields[AuthField.password]) {
      return 'Passwords do not match';
    }

    // Check if full name is empty or invalid in register flow.
    if (fields[AuthField.fullName]?.isEmpty ?? true) {
      return 'Full name cannot be empty';
    } else if (fields[AuthField.fullName]?.isValidName != true) {
      return 'Invalid name';
    }

    // If no errors are found, return an empty string.
    return '';
  }

  Future<void> verifyEmail() async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _performAuthOperation(
      () async {
        await user.sendEmailVerification();
        emit(EmailVerificationSent());
      },
      successState: EmailVerificationSent(),
      errorType: AuthErrorType.emailVerification,
    );
  }

  Future<void> resetPassword(String email) async {
    await _performAuthOperation(
      () async {
        await _auth.sendPasswordResetEmail(email: email.trim());
        emit(PasswordResetSent());
      },
      successState: PasswordResetSent(),
      errorType: AuthErrorType.passwordReset,
    );
  }

  Future<void> logout() async {
    await _performAuthOperation(
      () async {
        emit(LogoutInProgress());
        clearUserData();

        // // Clear user data from the application
        // BlocProvider.of<UserAuthCubit>(context).clearUserData();
        // BlocProvider.of<PopularAuthCubit>(context).clearUserData();
        // BlocProvider.of<ProfileCubit>(context).clearUserData();
        // BlocProvider.of<RecentAuthCubit>(context).clearUserData();

        // Sign out from Google and Firebase
        await _auth.signOut();

        // Ensure the user is signed out
        if (FirebaseAuth.instance.currentUser == null) {
          emit(LogoutSuccess());
        }
      },
      successState: AuthenticationInitial(),
      errorType: AuthErrorType.logout,
    );
  }

  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _performAuthOperation(
      () async {
        await _firestore.collection('profiles').doc(user.uid).delete();
        await user.delete();
        emit(AccountDeletionSuccess());
      },
      successState: AccountDeletionInProgress(),
      errorType: AuthErrorType.accountDeletion,
    );
  }

  // Add other methods (updatePassword, setPin, etc.) following the same pattern

  @override
  void onError(Object error, StackTrace stackTrace) {
    // Implement proper error logging here
    super.onError(error, stackTrace);
  }
}

// Extension for validation
extension _ValidationExtensions on String? {
  bool get isValidEmail =>
      this != null &&
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this!);

  bool get isValidPassword => this != null && this!.length >= 6;

  bool get isValidName => this != null && this!.length >= 3;
}
