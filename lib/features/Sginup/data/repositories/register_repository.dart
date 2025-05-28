abstract class RegisterRepository {
  Future<Map<String, dynamic>> register({
    required int nationalId,
    required String email,
    required String firstName,
    required String lastName,
    required String gender,
    required String phoneNumber,
    required String country,
    required String city,
    required String fullAddress,
    required String password,
  });
} 