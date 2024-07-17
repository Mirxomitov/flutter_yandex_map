import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_yandex_map/data/model/user_data.dart';
import 'package:flutter_yandex_map/util/status.dart';
import "package:http/http.dart" as http;
import 'package:image/image.dart' as img;
import 'package:yandex_mapkit/yandex_mapkit.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapState.initial()) {
    on<ShowAllUsers>((event, emit) => _loadUsersLocation(event, emit));

    on<ShowOneFriend>((event, emit) => _loadFriend(event, emit));

    on<UpdateTime>((event, emit) {
      emit(state.copyWith(time: DateTime.now()));
    });
  }

  Future<Uint8List> _toBitmap(String imagePath) async {
    print("imagePath: $imagePath");
    var request = await http.get(Uri.parse(imagePath));
    var bytes = request.bodyBytes;

    // Decode the image to manipulate it
    var image = img.decodeImage(bytes);

    // Resize the image to 24x24
    var resizedImage = img.copyResize(image!, width: 72, height: 72);

    // Encode the image back to bytes
    return Uint8List.fromList(img.encodePng(resizedImage));
  }

  _loadUsersLocation(ShowAllUsers event, Emitter<MapState> emit) async {
    emit(state.copyWith(status: Status.loading));

    final futures = event.friends
        .map((e) async => UserWithBitmapImage(
              email: e.email,
              name: e.name,
              password: e.password,
              latitude: e.latitude,
              longitude: e.longitude,
              imagePath: e.image,
              bitmapImage: await _toBitmap(e.image),
            ))
        .toList();

    final userWithBitmapImages = await Future.wait(futures);

    emit(state.copyWith(users: userWithBitmapImages, initState: true, status: Status.success));
  }

  _loadFriend(ShowOneFriend event, Emitter<MapState> emit) async {
    final user = event.friend;

    final userWithBitmapImage = UserWithBitmapImage(
      email: user.email,
      name: user.name,
      password: user.password,
      latitude: user.latitude,
      longitude: user.longitude,
      imagePath: user.image,
      bitmapImage: await _toBitmap(user.image),
    );

    emit(state.copyWith(users: [userWithBitmapImage], initState: true, status: Status.success));
  }
}
