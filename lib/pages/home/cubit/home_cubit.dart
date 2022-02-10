import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>> listener;
  HomeCubit() : super(HomeState()) {
    var instance = FirebaseFirestore.instance;
    var currentUser = FirebaseAuth.instance.currentUser;

    listener = instance
        .collection("chats")
        .orderBy("updatedAt", descending: true)
        .where("participants", arrayContains: {
          "email": currentUser?.email ?? "",
          "userID": currentUser?.uid ?? "",
        })
        .snapshots()
        .listen((event) {
          emit(state.copyWith(chats: event.docs));
        });
  }

  @override
  Future<void> close() {
    listener.cancel();
    return super.close();
  }
}
