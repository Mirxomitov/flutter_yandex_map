part of 'map_bloc.dart';

abstract class MapEvent {}

final class ShowAllUsers extends MapEvent {
  ShowAllUsers({required this.friends});

  final List<UserData> friends;
}

final class ShowOneFriend extends MapEvent {
  final List<UserData> friends;
  final UserData friend;

  ShowOneFriend({required this.friends, required this.friend});
}

class UpdateTime extends MapEvent {}
