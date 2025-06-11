import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mediverse/core/network/api/api_service.dart';
import 'package:mediverse/features/Sginup/data/repositories/register_repository.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final ApiService apiService;

  RegisterRepositoryImpl({required this.apiService});

  @override
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
     File? image,
  }) async {
    try {
      final response = await apiService.post(
        endpoint: 'signup/regesiter',
        data: {
          'nationalId': nationalId,
          'email': email,
          'firstName': firstName,
          'lastName': lastName,
          'gender': gender,
          'phoneNumber': phoneNumber,
          'country': country,
          'city': city,
          'fullAddress': fullAddress,
          'password': password,
          'image': image != null ? MultipartFile.fromFileSync(image.path) : null,
        },
        token: false,
      );

      return response;
    } on DioException catch (e) {
      print('DioError Response: ${e.response?.data}');
      if (e.response?.data != null) {
        if (e.response?.data is Map) {
          final data = e.response?.data as Map;
          if (data.containsKey('message')) {
            throw Exception(data['message']);
          } else if (data.containsKey('errors')) {
            final errors = data['errors'];
            if (errors is Map && errors.isNotEmpty) {
              final firstError = errors.values.first;
              if (firstError is List && firstError.isNotEmpty) {
                throw Exception(firstError.first.toString());
              } else {
                throw Exception(firstError.toString());
              }
            }
          }
        } else if (e.response?.data is String) {
          throw Exception(e.response?.data);
        }
      }
      throw Exception('Registration failed: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('Registration failed: $e');
    }
  }
} 