part of 'friends_bloc.dart';

abstract class FriendsEvent {}

final class LoadFriendsEvent extends FriendsEvent {}

final class LogoutEvent extends FriendsEvent {}
