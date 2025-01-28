import 'package:equatable/equatable.dart';

import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object?> get props => [];
}

// Base states
class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

// Common Error State
class AuthError extends AuthenticationState {
  final String message;
  final AuthErrorType errorType;

  const AuthError({
    required this.message,
    required this.errorType,
  });

  @override
  List<Object?> get props => [message, errorType];
}

enum AuthErrorType {
  login,
  registration,
  logout,
  passwordReset,
  emailVerification,
  pinOperation,
  accountDeletion,
  generic
}

// Login States
class LoginInProgress extends AuthenticationState {}

class LoginSuccess extends AuthenticationState {
  final User user;
  const LoginSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

// Registration States
class RegistrationInProgress extends AuthenticationState {}

class RegistrationSuccess extends AuthenticationState {
  final User user;
  const RegistrationSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

// PIN Operations
class PinValidationInProgress extends AuthenticationState {}

class PinValidationSuccess extends AuthenticationState {}

class PinUpdateSuccess extends AuthenticationState {}

// Email Verification
class EmailVerificationSent extends AuthenticationState {}

class EmailVerificationSuccess extends AuthenticationState {}

class EmailVerificationNeeded extends AuthenticationState {}

// Password Management
class PasswordResetSent extends AuthenticationState {}

class PasswordResetSuccess extends AuthenticationState {}

class PasswordUpdateInProgress extends AuthenticationState {}

// Session Management
class LogoutInProgress extends AuthenticationState {}

class LogoutSuccess extends AuthenticationState {}

class SessionExpired extends AuthenticationState {}

// Account Management
class AccountDeletionInProgress extends AuthenticationState {}

class AccountDeletionSuccess extends AuthenticationState {}

// Validation Error
class ValidationError extends AuthenticationState {
  final String error;

  const ValidationError(this.error);

  @override
  List<Object?> get props => [error];
}

enum AuthField {
  email,
  password,
  confirmPassword,
  currentPassword,
  newPassword,
  pin,
  confirmPin,
  fullName
}

// User Presence
class Authenticated extends AuthenticationState {
  final User user;
  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthenticationState {}
