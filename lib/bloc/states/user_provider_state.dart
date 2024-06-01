import 'package:equatable/equatable.dart';
import 'package:reauth/models/userprovider_model.dart';

abstract class UserProviderState extends Equatable {
  const UserProviderState();

  @override
  List<Object?> get props => [];
}

class UserProviderInitial extends UserProviderState {}

class UserProviderLoading extends UserProviderState {}

class UserProviderLoadSuccess extends UserProviderState {
  final List<UserProviderModel> providers;

  const UserProviderLoadSuccess({required this.providers});

  @override
  List<Object?> get props => [providers];
}

class UserProviderLoadFailure extends UserProviderState {
  final String error;

  const UserProviderLoadFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class UserProviderSubmissionSuccess extends UserProviderState {}

class UserProviderSubmissionFailure extends UserProviderState {
  final String error;

  const UserProviderSubmissionFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class UserProviderSearching extends UserProviderState {}

class UserProviderSearchSuccess extends UserProviderState {
  final UserProviderModel provider;

  const UserProviderSearchSuccess({required this.provider});

  @override
  List<Object?> get props => [provider];
}

class UserProviderSearchFailure extends UserProviderState {
  final String error;

  const UserProviderSearchFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class UserProviderSearchEmpty extends UserProviderState {}

class UserProviderDeletedSuccess extends UserProviderState {}

class UserProviderDeletedFailure extends UserProviderState {
  final String error;

  const UserProviderDeletedFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
