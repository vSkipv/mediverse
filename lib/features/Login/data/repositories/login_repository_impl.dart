import 'package:mediverse/core/network/api/api_service.dart';
import 'package:mediverse/features/Login/data/repositories/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final ApiService apiService;

  LoginRepositoryImpl({required this.apiService});

  @override
  Future<Map<String, dynamic>> login({
    required int nationalId,
    required String password,
  }) async {
    try {
      final response = await apiService.post(
        endpoint: 'login',
        data: {
          'nationalId': nationalId,
          'password': password,
        },
        token: false,
      );
      return response;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }
} 