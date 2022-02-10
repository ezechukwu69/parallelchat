import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupState());

  Future<void> signup(String email, String password,
      {ValueChanged<String>? onError, ValueChanged<String>? onSuccess}) async {
    if (state.loading) {
      return;
    }
    emit(state.copyWith(loading: true));
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.trim(), password: password.trim());
      if (userCredential.user?.uid != null) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(userCredential.user!.uid)
            .set({
          "email": userCredential.user!.email,
          "photoURL": userCredential.user!.photoURL
        });
        emit(state.copyWith(loading: false));
        onSuccess?.call("Registration Successful");
        return;
      }
      onError?.call("No user ID generated");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        onError?.call("The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        onError?.call("An account already exists for that email.");
      }
      emit(state.copyWith(loading: false));
    } catch (e) {
      onError?.call(e.toString());
      emit(state.copyWith(loading: false));
    }
  }
}
