part of 'register_bloc.dart';

abstract class RegisterEvent {}

final class RegisterImageSelected extends RegisterEvent {
  final XFile image;

  RegisterImageSelected({required this.image});
}

final class RegisterUser extends RegisterEvent {
  final String email;
  final String password;
  final String userName;
  final XFile image;
  final AppLatLong location;

  RegisterUser({
    required this.email,
    required this.password,
    required this.userName,
    required this.image,
    required this.location,
  });
}
