
abstract class Registration {
  Future<void> login(String email, String password);

  Future<void> register({
    required String email,
    required String password,
    required String imagePath,
    required String name,
    required double lat,
    required double long,
  });

  Future<void> logout();
}

