import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object?> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class LoginSuccess extends AuthenticationState {}

class LoginFailure extends AuthenticationState {
  final String error;

  const LoginFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class LoginSubmissionFailure extends AuthenticationState {
  final String error;

  const LoginSubmissionFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class RegisterSuccess extends AuthenticationState {}

class RegisterFailure extends AuthenticationState {
  final String error;

  const RegisterFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class RegisterSubmissionFailure extends AuthenticationState {
  final String error;

  const RegisterSubmissionFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class PinMatched extends AuthenticationState {}

class PinSetSuccess extends AuthenticationState {}

class PinError extends AuthenticationState {
  final String error;

  const PinError({required this.error});

  @override
  List<Object?> get props => [error];
}

class LoggingOut extends AuthenticationState {}

class LoggedOutSuccess extends AuthenticationState {}
