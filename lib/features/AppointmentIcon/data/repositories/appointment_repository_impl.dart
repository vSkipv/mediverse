import 'package:flutter/material.dart';
import 'package:mediverse/core/network/api/api_service.dart';
import 'package:mediverse/core/utililes/cached_sp.dart';
import 'package:mediverse/features/AppointmentIcon/data/models/doctor.dart';
import 'package:mediverse/features/AppointmentIcon/data/models/search_request.dart';
import 'package:mediverse/features/AppointmentIcon/domain/repositories/appointment_repository.dart';

import '../../../../constants.dart' as Constant;

class AppointmentRepositoryImpl implements AppointmentRepository {
  final ApiService _apiService;
  final BuildContext context;

  AppointmentRepositoryImpl(this._apiService, this.context);

  @override
  Future<List<Doctor>> searchDoctors(SearchRequest request) async {
    try {
      // Check for token
      print(CachedData.getData(Constant.accessToekn));

      final response = await _apiService.post(
        endpoint: 'Doctors/search',
        data: {
          'specialist': request.specialist,
          'country': request.country,
          'city': request.city,
        },
        token: true,
      );

      print('Raw API Response: $response');
      print('Response type: ${response.runtimeType}');

      if (response == null) {
        throw Exception('Empty response from API');
      }

      // Handle direct list response
      if (response is List) {
        if (response.isEmpty) {
          throw Exception('No doctors found matching your search criteria');
        }
        final doctors = response
            .map((json) => Doctor.fromJson(json))
            .toList();
        print('Parsed ${doctors.length} doctors from direct list response');
        return doctors;
      }

      // Handle response with data field
      if (response is Map<String, dynamic>) {
        if (response['data'] == null) {
          throw Exception('No data field in API response');
        }

        if (response['data'] is! List) {
          throw Exception('Data field is not a list: ${response['data']}');
        }

        final List<dynamic> doctorsData = response['data'] as List;
        
        if (doctorsData.isEmpty) {
          throw Exception('No doctors found matching your search criteria');
        }

        final doctors = doctorsData
            .map((json) => Doctor.fromJson(json))
            .toList();

        print('Parsed ${doctors.length} doctors from response data field');
        return doctors;
      }

      throw Exception('Unexpected response format: $response');
    } catch (e) {
      print('Error searching doctors: $e');
      throw Exception('Failed to search doctors: $e');
    }
  }
} 