import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String email;
  final String name;
  final String password;
  final String image;
  final double latitude;
  final double longitude;

  UserData({
    required this.email,
    required this.name,
    required this.password,
    required this.image,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'password': password,
      'image': image,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory UserData.fromJson(DocumentSnapshot doc) {
    return UserData(
      email: doc['email'],
      name: doc['name'],
      password: doc['password'],
      image: doc['image'],
      latitude: doc['latitude'],
      longitude: doc['longitude'],
    );
  }

  @override
  String toString() {
    return 'UserData{email: $email, name: $name, password: $password, image: $image, latitude: $latitude, longitude: $longitude}';
  }
}
