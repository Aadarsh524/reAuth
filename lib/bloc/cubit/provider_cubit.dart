import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reauth/bloc/states/provider_state.dart';

import 'package:reauth/models/popularprovider_model.dart';
import 'package:reauth/models/userprovider_model.dart';

import 'package:http/http.dart' as http;

class ProviderCubit extends Cubit<ProviderState> {
  User? user = FirebaseAuth.instance.currentUser;
  ProviderCubit() : super(ProviderInitial());

  Future<void> fetchUserProviders() async {
    try {
      emit(ProviderLoading());
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection("auths")
          .get();

      final providers = snapshot.docs.map((doc) {
        final data = doc.data();

        return UserProviderModel.fromMap({
          'username': data['username'] ?? '',
          'password': data['password'] ?? '',
          'note': data['note'] ?? '',
          'authProviderLink': data['authProviderLink'] ?? '',
          'providerCategory': data['providerCategory'] ?? '',
          'faviconUrl': data['faviconUrl'] ?? '',
          'authName': data['authName'] ?? '',
        });
      }).toList();

      emit(ProviderLoadSuccess(providers: providers));
    } catch (e) {
      emit(ProviderLoadFailure(error: e.toString()));
    }
  }

  Future<void> fetchPopularProviders() async {
    try {
      emit(ProviderLoading());
      final snapshot =
          await FirebaseFirestore.instance.collection('popularAuths').get();

      final providers = snapshot.docs.map((doc) {
        final data = doc.data();

        return PopularProviderModel.fromMap({
          'authName': data['authName'] ?? '',
          'authLink': data['authLink'] ?? '',
          'authCategory': data['authCategory'] ?? '',
          'faviconUrl': data['faviconUrl'] ?? ''
        });
      }).toList();

      emit(PopularProviderLoadSuccess(providers: providers));
    } catch (e) {
      emit(ProviderLoadFailure(error: e.toString()));
    }
  }

  Future<void> searchUserAuth(String searchTerm) async {
    try {
      emit(Searching());
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection("auths")
          .get();
      final providers = snapshot.docs.map((doc) {
        final data = doc.data();

        return UserProviderModel.fromMap({
          'authName': data['authName'] ?? '',
          'username': data['username'] ?? '',
          'password': data['password'] ?? '',
          'note': data['note'] ?? '',
          'authProviderLink': data['authProviderLink'] ?? '',
          'providerCategory': data['providerCategory'] ?? '',
          'faviconUrl': data['faviconUrl'] ?? ''
        });
      }).toList();

      for (var provider in providers) {
        if (provider.authName
            .toLowerCase()
            .contains(searchTerm.toLowerCase())) {
          emit(UserProviderSearchSuccess(provider: provider));
        }
      }
    } catch (e) {
      emit(ProviderLoadFailure(error: e.toString()));
    }
  }

  Future<void> searchPopularAuth(String searchTerm) async {
    try {
      emit(Searching());
      final snapshot =
          await FirebaseFirestore.instance.collection('popularAuths').get();
      final providers = snapshot.docs.map((doc) {
        final data = doc.data();

        return PopularProviderModel.fromMap({
          'authName': data['authName'] ?? '',
          'authLink': data['authLink'] ?? '',
          'authCategory': data['authCategory'] ?? '',
          'faviconUrl': data['faviconUrl'] ?? ''
        });
      }).toList();

      for (var provider in providers) {
        if (provider.authName
            .toLowerCase()
            .contains(searchTerm.toLowerCase())) {
          emit(PopularProviderSearchSuccess(provider: provider));
        }
      }
    } catch (e) {
      emit(ProviderLoadFailure(error: e.toString()));
    }
  }

  String? validateProvider(UserProviderModel provider) {
    if (provider.authProviderLink.isEmpty) {
      return 'Auth Provider Link is required';
    }
    if (provider.authProviderLink.isNotEmpty) {
      final urlPattern = RegExp(r'^www\.\w+\.\w+$');
      if (!urlPattern.hasMatch(provider.authProviderLink)) {
        return 'Url format is not matched';
      }
    }
    if (provider.username.isEmpty) {
      return 'Username is required';
    }
    if (provider.password.isEmpty) {
      return 'Password is required';
    }
    if (provider.providerCategory.isEmpty) {
      return 'Provider Category is required';
    }
    if (provider.note.isEmpty) {
      return 'Note is required';
    }

    return null;
  }

  Future<void> submitProvider(UserProviderModel providerModel) async {
    try {
      final validationError = validateProvider(providerModel);
      if (validationError != null) {
        emit(ProviderSubmissionFailure(error: validationError));
        return;
      }

      final faviconUrl = await getFaviconUrl(providerModel.authName);

      // Send data to Firebase
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection('auths')
          .doc()
          .set({
        'authName': providerModel.authName,
        'username': providerModel.username,
        'password': providerModel.password,
        'note': providerModel.note,
        'authProviderLink': providerModel.authProviderLink,
        'providerCategory': providerModel.providerCategory,
        'faviconUrl': faviconUrl,
      });

      emit(ProviderSubmissionSuccess());
      fetchUserProviders();
    } catch (e) {
      emit(ProviderSubmissionFailure(error: e.toString()));
    }
  }
}

Future<String> getFaviconUrl(String authName) async {
  String auth = authName.toLowerCase();
  try {
    final snapshot =
        await FirebaseFirestore.instance.collection('popularAuths').get();

    final providers = snapshot.docs.map((doc) {
      final data = doc.data();

      return PopularProviderModel.fromMap({
        'authName': data['authName'] ?? '',
        'authLink': data['authLink'] ?? '',
        'authCategory': data['authCategory'] ?? '',
        'faviconUrl': data['faviconUrl'] ?? ''
      });
    }).toList();

    for (var provider in providers) {
      if (provider.authName.toLowerCase().contains(auth)) {
        return provider.faviconUrl;
      }
    }
    return "https://api.statvoo.com/favicon/$auth.com";
  } catch (e) {
    return e.toString();
  }
}
