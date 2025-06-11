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
      // Common data fields
      final Map<String, dynamic> data = {
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
      };

      if (image != null) {
        // Create FormData for multipart request
        final formData = FormData.fromMap({
          ...data,
          'image': await MultipartFile.fromFile(
            image.path,
            filename: image.path.split('/').last,
          ),
        });

        print('Sending multipart request with data: $data');
        print('Image path: ${image.path}');

        final response = await apiService.postContent(
          endpoint: 'signup/register',
          data: formData,
          token: false,
        );

        return response;
      } else {
        // Regular JSON request without image
        print('Sending JSON request with data: $data');
        
        final response = await apiService.post(
          endpoint: 'signup/register',
          data: data,
          token: false,
        );

        return response;
      }
    } catch (e) {
      print('Registration error: $e');
      if (e is DioException) {
        print('DioError Response: ${e.response?.data}');
        print('DioError Status: ${e.response?.statusCode}');
        print('DioError Headers: ${e.response?.headers}');
        
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
      }
      throw Exception('Registration failed: $e');
    }
  }
}
