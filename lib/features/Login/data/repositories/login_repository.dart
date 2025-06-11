 abstract class LoginRepository {
  Future<Map<String, dynamic>> login({
    required int nationalId,
    required String password,
  });
} 