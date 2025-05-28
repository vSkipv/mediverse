import 'package:flutter/material.dart';
import 'package:mediverse/core/network/api/api_service.dart';
import 'package:mediverse/features/DoctorProfile/data/models/doctor_profile.dart';
import 'package:mediverse/features/DoctorProfile/data/repositories/doctor_profile_repository.dart';

class DoctorProfileRepositoryImpl implements DoctorProfileRepository {
  final ApiService _apiService;
  final BuildContext context;

  DoctorProfileRepositoryImpl(this._apiService, this.context);

  @override
  Future<DoctorProfile> getDoctorProfile(int id) async {
    try {
      final response = await _apiService.get(
        endpoint: '/Doctors/get-by-id?id=$id',
      );

      if (response is Map<String, dynamic>) {
        return DoctorProfile.fromJson(response);
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      throw Exception('Failed to get doctor profile: $e');
    }
  }
} 