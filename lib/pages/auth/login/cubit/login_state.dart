part of 'login_cubit.dart';

class LoginState {
  final bool loading;
  LoginState({
    this.loading = false,
  });

  LoginState copyWith({
    bool? loading,
  }) {
    return LoginState(
      loading: loading ?? this.loading,
    );
  }
}
