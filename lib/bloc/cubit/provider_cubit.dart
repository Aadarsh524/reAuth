import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reauth/bloc/states/provider_state.dart';
import 'package:reauth/models/provider_model.dart';

class ProviderCubit extends Cubit<ProviderState> {
  User? user = FirebaseAuth.instance.currentUser;
  ProviderCubit() : super(ProviderInitial());

  Future<void> fetchProviders() async {
    try {
      emit(ProviderLoading());
      final snapshot =
          await FirebaseFirestore.instance.collection('providers').get();
      final providers = snapshot.docs
          .map((doc) => ProviderModel.fromMap(doc as Map<String, dynamic>))
          .toList();
      emit(ProviderLoadSuccess(providers: providers));
    } catch (e) {
      emit(ProviderLoadFailure(error: e.toString()));
    }
  }

  String? validateProvider(ProviderModel provider) {
    if (provider.username.isEmpty) {
      return 'Username is required';
    }
    if (provider.password.isEmpty) {
      return 'Password is required';
    }
    if (provider.note.isEmpty) {
      return 'Note is required';
    }
    if (provider.authproviderLink.isEmpty) {
      return 'Auth Provider Link is required';
    }
    if (provider.providerCategory.isEmpty) {
      return 'Provider Category is required';
    }

    return null;
  }

  Future<void> submitProvider(ProviderModel providerModel) async {
    try {
      final validationError = validateProvider(providerModel);
      if (validationError != null) {
        emit(ProviderSubmissionFailure(error: validationError));
        return;
      }

      // Send data to Firebase
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection('auths')
          .doc()
          .set({
        'username': providerModel.username,
        'password': providerModel.password,
        'note': providerModel.note,
        'authProviderLink': providerModel.authproviderLink,
        'providerCategory': providerModel.providerCategory,
      });

      emit(ProviderSubmissionSuccess());
      fetchProviders();
    } catch (e) {
      emit(ProviderSubmissionFailure(error: e.toString()));
    }
  }
}
