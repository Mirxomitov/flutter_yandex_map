part of 'map_bloc.dart';

class MapState {
  final List<UserWithBitmapImage> users;
  final Completer<YandexMapController> mapControllerCompleter;
  final bool initState;
  final Status status;
  final DateTime time;


  factory MapState.initial() {
    return MapState(users: [], mapControllerCompleter: Completer<YandexMapController>(), initState: true, status: Status.loading, time: DateTime.now() );
  }

  MapState({required this.users, required this.status, required this.mapControllerCompleter, required this.initState, required this.time});

  MapState copyWith({
    List<UserWithBitmapImage>? users,
    Completer<YandexMapController>? mapControllerCompleter,
    bool? initState,
    Status? status,
    DateTime? time,
  }) {
    return MapState(
      users: users ?? this.users,
      mapControllerCompleter: mapControllerCompleter ?? this.mapControllerCompleter,
      initState: initState ?? this.initState,
      status: status ?? this.status,
      time: time ?? this.time,
    );
  }
}

class UserWithBitmapImage {
  final String email;
  final String name;
  final String password;
  final double latitude;
  final double longitude;
  final String imagePath;
  final Uint8List bitmapImage;


  UserWithBitmapImage({
    required this.email,
    required this.name,
    required this.password,
    required this.latitude,
    required this.longitude,
    required this.bitmapImage,
    required this.imagePath,
  });
}
