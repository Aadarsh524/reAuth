import 'package:equatable/equatable.dart';
import 'package:reauth/models/user_auth_model.dart';

abstract class RecentAuthState extends Equatable {
  const RecentAuthState();

  @override
  List<Object?> get props => [];
}

class RecentAuthInitial extends RecentAuthState {}

class RecentAuthLoading extends RecentAuthState {}

class RecentAuthLoadSuccess extends RecentAuthState {
  final List<UserAuthModel> auths;

  const RecentAuthLoadSuccess({required this.auths});

  @override
  List<Object?> get props => [auths];
}

class RecentAuthLoadFailure extends RecentAuthState {
  final String error;

  const RecentAuthLoadFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
