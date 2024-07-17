part of 'login_bloc.dart';

sealed class LoginEvent {}

final class LoginUserEvent extends LoginEvent {
  final String email;
  final String password;

  LoginUserEvent({required this.email, required this.password});
}

final class ToRegisterEvent extends LoginEvent {}

final class NavigateToRegisterEvent extends LoginEvent {}