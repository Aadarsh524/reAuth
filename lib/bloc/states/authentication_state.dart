import 'package:equatable/equatable.dart';

import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object?> get props => [];
}

// General States
class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

// Login Session Management
class LogoutInProgress extends AuthenticationState {}

class LogoutSuccess extends AuthenticationState {}

class LoginSessionExpired extends AuthenticationState {}

// Registration States
class RegistrationInProgress extends AuthenticationState {}

class RegistrationSuccess extends AuthenticationState {}

// Common Error State
class AuthenticationError extends AuthenticationState {
  final String error;

  const AuthenticationError({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}

// PIN Operations
class SettingPinInProgress extends AuthenticationState {}

class SettingPinInSuccess extends AuthenticationState {}

class PinUpdateSuccess extends AuthenticationState {}

// Email Verification
class EmailVerificationSent extends AuthenticationState {}

class EmailVerificationSuccess extends AuthenticationState {}

class EmailVerificationNeeded extends AuthenticationState {}

// Password Management
class PasswordResetSent extends AuthenticationState {}

class PasswordResetSuccess extends AuthenticationState {}

class PasswordUpdateInProgress extends AuthenticationState {}

// Account Management
class AccountDeletionInProgress extends AuthenticationState {}

class AccountDeletionSuccess extends AuthenticationState {}

//Account Update
class AccountUpdateInProgress extends AuthenticationState {}

class AccountUpdateSuccess extends AuthenticationState {}

class AccountUpdateError extends AuthenticationState {
  final String error;

  const AccountUpdateError({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}

// Validation Error
class ValidationError extends AuthenticationState {
  final String error;

  const ValidationError(this.error);

  @override
  List<Object?> get props => [error];
}

// User Presence
class Authenticated extends AuthenticationState {
  final User user;
  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthenticationState {}
