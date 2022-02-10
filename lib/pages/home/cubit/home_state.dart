part of 'home_cubit.dart';

class HomeState {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> chats;
  HomeState({
    this.chats = const [],
  });

  HomeState copyWith({
    List<QueryDocumentSnapshot<Map<String, dynamic>>>? chats,
  }) {
    return HomeState(
      chats: chats ?? this.chats,
    );
  }
}
