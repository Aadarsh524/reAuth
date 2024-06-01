import 'package:equatable/equatable.dart';
import 'package:reauth/models/popularprovider_model.dart';

abstract class PopularProviderState extends Equatable {
  const PopularProviderState();

  @override
  List<Object?> get props => [];
}

class PopularProviderInitial extends PopularProviderState {}

class PopularProviderLoading extends PopularProviderState {}

class PopularProviderLoadSuccess extends PopularProviderState {
  final List<PopularProviderModel> providers;

  const PopularProviderLoadSuccess({required this.providers});

  @override
  List<Object?> get props => [providers];
}

class PopularProviderLoadFailure extends PopularProviderState {
  final String error;

  const PopularProviderLoadFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class PopularProviderSubmissionSuccess extends PopularProviderState {}

class PopularProviderSubmissionFailure extends PopularProviderState {
  final String error;

  const PopularProviderSubmissionFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class PopularProviderSearching extends PopularProviderState {}

class PopularProviderSearchSuccess extends PopularProviderState {
  final PopularProviderModel provider;

  const PopularProviderSearchSuccess({required this.provider});

  @override
  List<Object?> get props => [provider];
}

class PopularProviderSearchFailure extends PopularProviderState {
  final String error;

  const PopularProviderSearchFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class PopularProviderSearchEmpty extends PopularProviderState {}
