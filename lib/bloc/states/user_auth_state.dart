import 'package:equatable/equatable.dart';
import '../../models/user_auth_model.dart';

abstract class UserAuthState extends Equatable {
  const UserAuthState();

  @override
  List<Object?> get props => [];
}

class UserAuthInitial extends UserAuthState {}

class UserAuthLoading extends UserAuthState {}

class UserAuthLoadSuccess extends UserAuthState {
  final List<UserAuthModel> auths;

  const UserAuthLoadSuccess({required this.auths});

  @override
  List<Object?> get props => [auths];
}

class UserAuthLoadFailure extends UserAuthState {
  final String error;

  const UserAuthLoadFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class UserAuthSubmissionSuccess extends UserAuthState {}

class UserAuthSubmissionFailure extends UserAuthState {
  final String error;

  const UserAuthSubmissionFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class UserAuthUpdateInProgress extends UserAuthState {}

class UserAuthUpdateSuccess extends UserAuthState {}

class UserAuthUpdateFailure extends UserAuthState {
  final String error;

  const UserAuthUpdateFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class UserAuthSearchSuccess extends UserAuthState {
  final UserAuthModel auth;

  const UserAuthSearchSuccess({required this.auth});

  @override
  List<Object?> get props => [auth];
}

class UserAuthSearchFailure extends UserAuthState {
  final String error;

  const UserAuthSearchFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class UserAuthSearchEmpty extends UserAuthState {}

class UserAuthDeletedSuccess extends UserAuthState {}

class UserAuthDeletedFailure extends UserAuthState {
  final String error;

  const UserAuthDeletedFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
