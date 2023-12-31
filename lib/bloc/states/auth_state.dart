import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class LoginSuccess extends AuthState {}

class LoginFailure extends AuthState {
  final String error;

  const LoginFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class AuthLoading extends AuthState {}

class RegisterSuccess extends AuthState {}

class PinMatched extends AuthState {}

class PinSetSuccess extends AuthState {}

class PinError extends AuthState {
  final String error;

  const PinError({required this.error});

  @override
  List<Object?> get props => [error];
}

class RegisterSubmissionFailure extends AuthState {
  final String error;

  const RegisterSubmissionFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class RegisterFailure extends AuthState {
  final String error;

  const RegisterFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
