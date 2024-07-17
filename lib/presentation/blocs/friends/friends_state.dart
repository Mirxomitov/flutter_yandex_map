part of 'friends_bloc.dart';

class FriendsState {
  final List<UserData> friends;
  final Status status;

  final bool logout;

  FriendsState({
    required this.friends,
    required this.status,
    required this.logout,
  });

  factory FriendsState.initial() {
    return FriendsState(
      friends: [],
      status: Status.loading,
      logout: false,
    );
  }

  FriendsState copyWith({
    List<UserData>? friends,
    Status? status,
    bool? logout,
  }) {
    return FriendsState(
      friends: friends ?? this.friends,
      status: status ?? this.status,
      logout: logout ?? this.logout,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FriendsState && other.friends == friends && other.status == status && other.logout == logout;
  }

  @override
  int get hashCode => friends.hashCode ^ status.hashCode ^ logout.hashCode;
}
