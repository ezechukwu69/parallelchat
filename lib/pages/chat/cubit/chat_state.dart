part of 'chat_cubit.dart';

class ChatState {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> messages;
  final bool loading;
  ChatState({this.messages = const [], this.loading = false});

  ChatState copyWith({
    List<QueryDocumentSnapshot<Map<String, dynamic>>>? messages,
    bool? loading,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      loading: loading ?? this.loading,
    );
  }
}
