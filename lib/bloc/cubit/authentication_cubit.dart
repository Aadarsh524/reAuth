import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../states/authentication_state.dart';
import '../../services/encryption_service.dart';
import '../../services/secure_store_services.dart';
import '../../validator/authentication_validator/authentication_field_validator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  User? get currentUser => _auth.currentUser;
  AuthenticationState? _lastEmittedState;
  StreamSubscription<User?>? _authStateSubscription;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  AuthenticationCubit({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        super(AuthenticationInitial());

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }

  @override
  void emit(AuthenticationState state) {
    // Prevent duplicate validation errors.
    if (state is ValidationError && _lastEmittedState is ValidationError) {
      return;
    }
    _lastEmittedState = state;
    super.emit(state);
  }

  void startAuthStateListener() {
    _authStateSubscription?.cancel();
    _authStateSubscription = _auth.authStateChanges().listen((user) {
      if (state is! AuthenticationLoading) {
        user != null ? emit(Authenticated(user)) : emit(Unauthenticated());
      }
    });
  }

  Future<void> initialize() async {
    emit(AuthenticationLoading());
    try {
      await _auth.currentUser?.reload();
      final user = _auth.currentUser;
      emit(user != null ? Authenticated(user) : Unauthenticated());
    } catch (e) {
      emit(const AuthenticationError(error: 'Initialization failed'));
    }
  }

  Future<void> login(String email, String password) async {
    final validationError = validateLoginFields(email, password);
    if (validationError != null) {
      emit(AuthenticationInitial());
      await Future.delayed(const Duration(milliseconds: 100));
      emit(ValidationError(validationError));
      return;
    }

    try {
      emit(AuthenticationLoading());
      final credentials = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('just_logged_in', true);
      emit(Authenticated(credentials.user!));
    } catch (e) {
      emit(AuthenticationError(error: _parseError(e)));
    }
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final validationError =
        validateRegisterFields(fullName, email, password, confirmPassword);
    if (validationError != null) {
      emit(AuthenticationInitial());
      await Future.delayed(const Duration(milliseconds: 100));
      emit(ValidationError(validationError));
      return;
    }

    try {
      emit(AuthenticationLoading());
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      await _firestore.collection('profiles').doc(credential.user!.uid).set({
        'fullName': fullName,
        'email': email,
        'profileImage': '',
        'isMasterPinSet': false,
        'masterPin': '',
        'isBiometricSet': false,
      });

      // Temporarily pause the auth state listener.
      _authStateSubscription?.pause();
      await _auth.signOut();
      _authStateSubscription?.resume();

      emit(RegistrationSuccess());
    } catch (e) {
      emit(AuthenticationError(error: _parseError(e)));
    }
  }

  Future<bool> checkEmailVerification() async {
    final user = _auth.currentUser;
    if (user == null) return false;
    await user.reload();
    return _auth.currentUser?.emailVerified ?? false;
  }

  Future<void> verifyEmail() async {
    try {
      emit(AuthenticationLoading());
      await _auth.currentUser?.sendEmailVerification();
      emit(EmailVerificationSent());
    } catch (e) {
      emit(AuthenticationError(error: _parseError(e)));
    }
  }

  Future<void> updatePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final validationError = validateUpdatePassword(oldPassword, newPassword);
    if (validationError != null) {
      emit(ValidationError(validationError));
      return;
    }

    final user = _auth.currentUser;
    if (user != null && user.email != null) {
      try {
        emit(AccountUpdateInProgress());
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: oldPassword,
        );
        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPassword);
        emit(AccountUpdateSuccess());
      } catch (e) {
        emit(AccountUpdateError(error: _parseError(e)));
      }
    } else {
      emit(const AuthenticationError(error: 'No user Signed In'));
    }
  }

  Future<void> changeEmail({
    required String newEmail,
    required String password,
  }) async {
    final validationError = validateUpdateEmail(newEmail, password);
    if (validationError != null) {
      emit(ValidationError(validationError));
      return;
    }

    final user = _auth.currentUser;
    if (user != null && user.email != null) {
      try {
        emit(AccountUpdateInProgress());
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );
        await user.reauthenticateWithCredential(credential);
        await user.updateEmail(newEmail);
        emit(AccountUpdateSuccess());
      } catch (e) {
        emit(AccountUpdateError(error: _parseError(e)));
      }
    } else {
      emit(const AuthenticationError(error: 'No user Signed In'));
    }
  }

  Future<void> setMasterPin({
    required String pin,
    required String confirmPin,
  }) async {
    if (pin.isEmpty || confirmPin.isEmpty) {
      emit(const ValidationError("Please enter a valid PIN"));
      return;
    }
    if (pin != confirmPin) {
      emit(const ValidationError("PINs do not match"));
      return;
    }
    if (pin.length < 4) {
      emit(const ValidationError("PIN must be at least 4 digits"));
      return;
    }
    try {
      emit(SettingPinInProgress());
      final user = _auth.currentUser;
      if (user == null) {
        emit(const AccountUpdateError(error: "No user signed in"));
        return;
      }

      final encryptedPin = await EncryptionService.encryptData(pin);
      await _secureStorage.write(
        key: 'encrypted_master_password',
        value: encryptedPin,
      );
      await _firestore.collection('profiles').doc(user.uid).set({
        'masterPin': encryptedPin,
        'isMasterPinSet': true,
      }, SetOptions(merge: true));

      emit(SettingPinInSuccess());
    } catch (e) {
      emit(AccountUpdateError(error: _parseError(e)));
    }
  }

  Future<void> updateMasterPin({
    required String oldPin,
    required String newPin,
  }) async {
    final validationError = validateUpdatePassword(oldPin, newPin);
    if (validationError != null) {
      emit(ValidationError(validationError));
      return;
    }

    final user = _auth.currentUser;
    if (user != null && user.email != null) {
      try {
        emit(AccountUpdateInProgress());
        final encryptedPin = await EncryptionService.encryptData(newPin);
        await _firestore.collection('profiles').doc(user.uid).set({
          'masterPin': encryptedPin,
          'isMasterPinSet': true,
          'isBiometricSet': false,
        }, SetOptions(merge: true));
        emit(AccountUpdateSuccess());
      } catch (e) {
        emit(AccountUpdateError(error: _parseError(e)));
      }
    } else {
      emit(const AuthenticationError(error: 'No user Signed In'));
    }
  }

  Future<void> resetPassword({required String email}) async {
    final validationError = validateEmailField(email);
    if (validationError != null) {
      emit(ValidationError(validationError));
      return;
    }
    try {
      emit(AccountUpdateInProgress());
      await _auth.sendPasswordResetEmail(email: email);
      emit(PasswordResetSent());
    } on FirebaseAuthException catch (e) {
      emit(AccountUpdateError(error: _parseError(e)));
    }
  }

  Future<void> logout() async {
    try {
      emit(LogoutInProgress());
      await SecureStorageService.deleteMasterPassword();
      await _auth.signOut();
      emit(LogoutSuccess());
    } catch (e) {
      emit(AuthenticationError(error: _parseError(e)));
    }
  }

  Future<void> deleteAccount() async {
    try {
      emit(AccountDeletionInProgress());
      final user = _auth.currentUser!;
      await _firestore.collection('profiles').doc(user.uid).delete();
      await user.delete();
      emit(AccountDeletionSuccess());
    } catch (e) {
      emit(AuthenticationError(error: _parseError(e)));
    }
  }

  String _parseError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'INVALID_LOGIN_CREDENTIALS':
          return 'Invalid login credentials';
        case 'invalid-email':
          return 'Invalid email format';
        case 'user-disabled':
          return 'Account disabled';
        case 'user-not-found':
          return 'User not found';
        case 'wrong-password':
          return 'Incorrect password';
        case 'email-already-in-use':
          return 'Email already registered';
        case 'weak-password':
          return 'Password too weak';
        case 'operation-not-allowed':
          return 'Operation not allowed';
        default:
          return error.message ?? 'Authentication error';
      }
    }
    return error.toString();
  }
}
