import 'package:equatable/equatable.dart';
import 'package:reauth/models/profile_model.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileUpdated extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileModel profile;

  const ProfileLoaded({required this.profile});

  @override
  List<Object?> get props => [profile];
}

class ProfileLoadingError extends ProfileState {
  final String error;

  const ProfileLoadingError({required this.error});

  @override
  List<Object?> get props => [error];
}

class ProfileUpdateError extends ProfileState {
  final String error;

  const ProfileUpdateError({required this.error});

  @override
  List<Object?> get props => [error];
}
