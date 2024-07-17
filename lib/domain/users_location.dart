import '../data/model/user_data.dart';

abstract class UsersLocation {
  Future<List<UserData>> getUsersLocation();
}
