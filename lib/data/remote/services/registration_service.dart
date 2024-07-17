import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_yandex_map/domain/registration.dart';

import '../../model/app_lat_long.dart';
import '../../model/user_data.dart';
import 'location_service.dart';

class RegistrationService extends Registration {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<void> login(
    String email,
    String password,
  ) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      if (!await LocationService().checkPermission()) {
        await LocationService().requestPermission();
      }
      final location = await _fetchCurrentLocation();

      var collection = FirebaseFirestore.instance.collection('users');
      collection.doc(_auth.currentUser?.uid).update({
        'latitude': location.lat,
        "longitude": location.long,
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> register({
    required String email,
    required String password,
    required String imagePath,
    required String name,
    required double lat,
    required double long,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);

      String imageUrl = await uploadPhotoToFirebase(File(imagePath));

      await _firestore.collection("users").doc(_auth.currentUser?.uid).set(
            UserData(
              email: email,
              name: name,
              password: password,
              image: imageUrl,
              latitude: lat,
              longitude: long,
            ).toJson(),
          );

      await Future.delayed(const Duration(seconds: 1));
      print('await registration');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<AppLatLong> _fetchCurrentLocation() async {
    AppLatLong location;
    const defLocation = TashkentLocation();
    try {
      location = await LocationService().getCurrentLocation();
    } catch (_) {
      location = defLocation;
    }

    return location;
  }

  Future<String> uploadPhotoToFirebase(File photo) async {
    try {
      String ref = 'images/img-${DateTime.now().toString()}.jpeg';
      final storageRef = FirebaseStorage.instance.ref();
      UploadTask uploadTask = storageRef.child(ref).putFile(photo);
      var url = await uploadTask.then((task) => task.ref.getDownloadURL());
      return url;
    } on FirebaseException catch (e) {
      throw Exception('Error no upload: ${e.code}');
    }
  }
}
