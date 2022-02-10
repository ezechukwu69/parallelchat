part of 'signup_cubit.dart';

class SignupState {
  final bool loading;

  SignupState({
    this.loading = false,
  });

  SignupState copyWith({
    bool? loading,
  }) {
    return SignupState(
      loading: loading ?? this.loading,
    );
  }
}
