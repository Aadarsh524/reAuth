import 'package:equatable/equatable.dart';

import 'package:reauth/models/userprovider_model.dart';

abstract class RecentProviderState extends Equatable {
  const RecentProviderState();

  @override
  List<Object?> get props => [];
}

class RecentProviderInitial extends RecentProviderState {}

class RecentProviderLoading extends RecentProviderState {}

class RecentProviderLoadSuccess extends RecentProviderState {
  final List<UserProviderModel> providers;

  const RecentProviderLoadSuccess({required this.providers});

  @override
  List<Object?> get props => [providers];
}

class RecentProviderLoadFailure extends RecentProviderState {
  final String error;

  const RecentProviderLoadFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
