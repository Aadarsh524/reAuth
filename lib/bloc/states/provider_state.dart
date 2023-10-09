import 'package:equatable/equatable.dart';
import 'package:reauth/models/provider_model.dart';

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

class ProviderLoadSuccess extends ProviderState {
  final List<ProviderModel> providers;

  const ProviderLoadSuccess({required this.providers});

  @override
  List<Object?> get props => [providers];
}

class ProviderLoadFailure extends ProviderState {
  final String error;

  const ProviderLoadFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
