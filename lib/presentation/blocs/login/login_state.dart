part of 'login_bloc.dart';

class LoginState {
  final LoginStatus status;
  final String errorMessage;
  final bool toRegister;

  const LoginState( {
    this.status = LoginStatus.initial,
    this.errorMessage = '',
    this.toRegister = false,
  });

  factory LoginState.initial() => const LoginState();

  LoginState copyWith({LoginStatus? status, String? errorMessage, bool? toRegister}) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      toRegister: toRegister ?? this.toRegister,
    );
  }
}

enum LoginStatus { initial, loading, success, failure }