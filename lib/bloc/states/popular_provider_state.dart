import 'package:equatable/equatable.dart';
import 'package:reauth/models/popular_auth_model.dart';

abstract class PopularAuthState extends Equatable {
  const PopularAuthState();

  @override
  List<Object?> get props => [];
}

class PopularAuthInitial extends PopularAuthState {}

class PopularAuthLoading extends PopularAuthState {}

class PopularAuthLoadSuccess extends PopularAuthState {
  final List<PopularAuthModel> auths;

  const PopularAuthLoadSuccess({required this.auths});

  @override
  List<Object?> get props => [auths];
}

class PopularAuthLoadFailure extends PopularAuthState {
  final String error;

  const PopularAuthLoadFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class PopularAuthSubmissionSuccess extends PopularAuthState {}

class PopularAuthSubmissionFailure extends PopularAuthState {
  final String error;

  const PopularAuthSubmissionFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class PopularAuthSearching extends PopularAuthState {}

class PopularAuthSearchSuccess extends PopularAuthState {
  final PopularAuthModel auth;

  const PopularAuthSearchSuccess({required this.auth});

  @override
  List<Object?> get props => [auth];
}

class PopularAuthSearchFailure extends PopularAuthState {
  final String error;

  const PopularAuthSearchFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class PopularAuthSearchEmpty extends PopularAuthState {}
