import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_yandex_map/data/model/app_lat_long.dart';
import 'package:flutter_yandex_map/data/remote/services/location_service.dart';
import 'package:flutter_yandex_map/presentation/blocs/map/map_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../../util/status.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<MapBloc, MapState>(
        listener: (context, state) {
          if (state.initState) {
            _initPermission(state.mapControllerCompleter);
          }
        },
        builder: (context, state) {
          final size = MediaQuery.sizeOf(context);

          return switch (state.status) {
            Status.loading =>
              Container(alignment: Alignment.center, child: Lottie.asset("assets/images/anim.json", width: size.width, height: size.height)),
            Status.success => Stack(
                children: [
                  YandexMap(
                    onMapCreated: (controller) {
                      state.mapControllerCompleter.complete(controller);
                    },
                    onMapTap: (point) {},
                    onObjectTap: (geoObject) {},
                    zoomGesturesEnabled: true,
                    mapObjects: [
                      if (state.users.isNotEmpty)
                        ...state.users.map(
                          (userData) => PlacemarkMapObject(
                            onTap: (a, b) {
                              if (DateTime.now().millisecondsSinceEpoch - state.time.millisecondsSinceEpoch > 1000) {
                                showInfo(userData, context);
                                context.read<MapBloc>().add(UpdateTime());
                              }
                            },
                            mapId: MapObjectId(userData.email),
                            point: Point(latitude: userData.latitude, longitude: userData.longitude),
                            icon: PlacemarkIcon.single(PlacemarkIconStyle(scale: 0.8, image: BitmapDescriptor.fromBytes(userData.bitmapImage))),
                            text: PlacemarkText(text: userData.name, style: const PlacemarkTextStyle(size: 12, placement: TextStylePlacement.bottom)),
                          ),
                        ),
                    ],
                  ),
                  if (state.users.length == 1)
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: IconButton(
                        onPressed: () =>
                            _moveToCurrentLocation(state.users.first.latitude, state.users.first.longitude, state.mapControllerCompleter),
                        icon: const Icon(Icons.my_location, color: Colors.black),
                      ),
                    ),
                ],
              ),
            Status.failure => const Center(child: Text('PLEASE CHECK INTERNET CONNECTION')),
            Status.initial =>
              Container(alignment: Alignment.center, child: Lottie.asset("assets/images/anim.json", width: size.width, height: size.height)),
          };
        },
      ),
    );
  }

  Future<void> _initPermission(Completer<YandexMapController> mapControllerCompleter) async {
    if (!await LocationService().checkPermission()) {
      await LocationService().requestPermission();
    }
    await _fetchCurrentLocation(mapControllerCompleter);
  }

  Future<void> _fetchCurrentLocation(Completer<YandexMapController> mapControllerCompleter) async {
    AppLatLong location;
    const defLocation = TashkentLocation();
    try {
      location = await LocationService().getCurrentLocation();
    } catch (_) {
      location = defLocation;
    }
    _moveToCurrentLocation(location.lat, location.long, mapControllerCompleter);
  }

  Future<void> _moveToCurrentLocation(double lat, double lon, Completer<YandexMapController> mapControllerCompleter) async {
    print(lat);
    print(lon);

    (await mapControllerCompleter.future).moveCamera(
      animation: const MapAnimation(type: MapAnimationType.linear, duration: 1),
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(
            latitude: lat,
            longitude: lon,
          ),
          zoom: 15,
        ),
      ),
    );
  }

  void showInfo(UserWithBitmapImage userData, BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext ctx) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Image.network(
                    userData.imagePath,
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  userData.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Text(
                  userData.email,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'LatLong: ${userData.latitude} ${userData.longitude}',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              // const SizedBox(height: 8),
              /*Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      IntentUtils.launchGoogleMaps(userData.latitude, userData.longitude);
                    },
                    icon: const Icon(Icons.directions),
                    label: const Text('Open in Google Maps'),
                  ),
                ],
              ),*/
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
