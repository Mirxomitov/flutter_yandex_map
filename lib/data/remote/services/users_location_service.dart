import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_yandex_map/data/model/user_data.dart';
import 'package:flutter_yandex_map/domain/users_location.dart';

class UsersLocationService extends UsersLocation {
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<List<UserData>> getUsersLocation() async {
    final ls = <UserData>[];

    final users = await _firestore.collection("users").get();

    for (var element in users.docs) {
      ls.add(UserData.fromJson(element));
    }

    return ls;
  }
}
