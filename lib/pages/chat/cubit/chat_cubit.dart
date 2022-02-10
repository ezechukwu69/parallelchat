import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>> chatStream;
  final String chatID;
  ChatCubit(this.chatID) : super(ChatState()) {
    chatStream = FirebaseFirestore.instance
        .collection("chats")
        .doc(chatID)
        .collection("messages")
        .orderBy("createdAt", descending: false)
        .limitToLast(25)
        .snapshots()
        .listen((event) {
      var data = event.docs;
      var listCopy = state.messages.map((e) => e).toList();
      for (var e in data) {
        var index = listCopy.indexWhere((i) => i.id == e.id);
        if (index == -1) {
          listCopy.insert(0, e);
        } else {
          if (listCopy[index].data()["read"] != e.data()["read"]) {
            listCopy[index] = e;
          }
        }
      }
      emit(state.copyWith(messages: listCopy));
    });
  }

  Future<void> send(String data, VoidCallback callback) async {
    var chatReference =
        FirebaseFirestore.instance.collection("chats").doc(chatID);
    chatReference
        .update({"lastMessage": data, "updatedAt": Timestamp.now()}).then(
            (value) => chatReference.collection("messages").add({
                  "message": data,
                  "createdAt": Timestamp.now(),
                  "owner": FirebaseAuth.instance.currentUser!.uid,
                  "read": false,
                }));
    callback.call();
  }

  @override
  Future<void> close() {
    chatStream.cancel();
    return super.close();
  }

  void loadNext() async {
    if (state.loading) {
      return;
    }
    emit(state.copyWith(loading: true));
    FirebaseFirestore.instance
        .collection("chats")
        .doc(chatID)
        .collection("messages")
        .orderBy("createdAt", descending: false)
        .endBeforeDocument(state.messages.last)
        .limitToLast(25)
        .get()
        .then((value) {
      var data = state.messages.map((e) => e).toList();
      data.addAll(value.docs.reversed.toList());
      emit(state.copyWith(messages: data, loading: false));
    });
  }
}
