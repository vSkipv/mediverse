import 'package:flutter/material.dart';
import 'package:mediverse/core/network/api/api_service.dart';
import 'package:mediverse/core/utililes/cached_sp.dart';
import 'package:mediverse/features/AppointmentIcon/data/models/doctor.dart';
import 'package:mediverse/features/AppointmentIcon/data/models/search_request.dart';

import '../../../../constants.dart' as Constant;
import 'appointment_repository.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final ApiService _apiService;
  final BuildContext context;

  AppointmentRepositoryImpl(this._apiService, this.context);

  @override
  Future<List<Doctor>> searchDoctors(SearchRequest request) async {
    try {
      final response = await _apiService.get(
        endpoint: '/Doctors/search',
        data: {
          'specialist': request.specialist,
          'country': request.country,
          'city': request.city,
        },
      );
      print(response);

      if (response is List) {
        return response.map((json) => Doctor.fromJson(json)).toList();
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      throw Exception('Failed to search doctors: $e');
    }
  }

  @override
  Future<List<Doctor>> searchDoctorsByName(String name, String city, String country, String specialist) async {
    try {
      final response = await _apiService.get(
        endpoint: '/Doctors/search-by-name?name=$name&city=$city&country=$country&specialist=$specialist',
      );

      if (response is List) {
        if (response.isEmpty) {
          return [];
        }
        return response.map((json) => Doctor.fromJson(json)).toList();
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      if (e.toString().contains('No doctors found')) {
        return [];
      }
      throw Exception('Failed to search doctors by name: $e');
    }
  }
}
