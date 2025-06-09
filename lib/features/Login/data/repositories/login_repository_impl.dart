import 'package:mediverse/core/network/api/api_service.dart';
import 'package:mediverse/features/Login/data/repositories/login_repository.dart';

import '../../../../constants.dart' as Constant;
import '../../../../core/utililes/cached_sp.dart';

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
          'id': nationalId,
          'password': password,
        },
        token: false,
      );
      final token = response['token'];
      CachedData.saveToken(token);
      final id = response['id'];
     CachedData.setData(Constant.id, id);
     print('Login successful: $response');
     print('Token saved: $token');
      print('User ID saved: $id');


      return response;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }
} 