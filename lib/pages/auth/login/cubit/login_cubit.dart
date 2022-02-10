import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState());

  Future<void> login(String email, String password,
      {ValueChanged<String>? onError, ValueChanged<String>? onSuccess}) async {
    if (state.loading) {
      return;
    }
    emit(state.copyWith(loading: true));
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
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
        onSuccess?.call("Login Successful");
        return;
      }
      onError?.call("No user ID generated");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        onError?.call("No user found for that email.");
      } else if (e.code == 'wrong-password') {
        onError?.call("Wrong password provided for that user.");
      }
      emit(state.copyWith(loading: false));
    } catch (e) {
      onError?.call(e.toString());
      emit(state.copyWith(loading: false));
    }
  }
}
