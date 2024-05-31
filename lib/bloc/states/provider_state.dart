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
  final List<PopularProviderModel> providers;

  const PopularProviderSearchSuccess({required this.providers});

  @override
  List<Object?> get props => [providers];
}

class UserProviderSearchSuccess extends ProviderState {
  final List<UserProviderModel> providers;

  const UserProviderSearchSuccess({required this.providers});

  @override
  List<Object?> get props => [providers];
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

class UserProviderSearchEmpty extends ProviderState {}

class PopularProviderSearchEmpty extends ProviderState {}
