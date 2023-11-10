import 'package:equatable/equatable.dart';
import 'package:reauth/models/popularprovider_model.dart';
import 'package:reauth/models/userprovider_model.dart';

abstract class ProviderState extends Equatable {
  const ProviderState();

  @override
  List<Object?> get props => [];
}

class ProviderInitial extends ProviderState {}

class ProviderSubmissionSuccess extends ProviderState {}

class ProviderSubmissionFailure extends ProviderState {
  final String error;

  const ProviderSubmissionFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class ProviderLoading extends ProviderState {}

class PopularProviderSearchSuccess extends ProviderState {
  final PopularProviderModel provider;
  const PopularProviderSearchSuccess({required this.provider});

  @override
  List<Object?> get props => [provider];
}

class UserProviderSearchSuccess extends ProviderState {
  final UserProviderModel provider;
  const UserProviderSearchSuccess({required this.provider});

  @override
  List<Object?> get props => [provider];
}

class Searching extends ProviderState {}

class ProviderLoadSuccess extends ProviderState {
  final List<UserProviderModel> providers;

  const ProviderLoadSuccess({required this.providers});

  @override
  List<Object?> get props => [providers];
}

class PopularProviderLoadSuccess extends ProviderState {
  final List<PopularProviderModel> providers;

  const PopularProviderLoadSuccess({required this.providers});

  @override
  List<Object?> get props => [providers];
}

class ProviderLoadFailure extends ProviderState {
  final String error;

  const ProviderLoadFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
