import 'package:mediverse/core/network/api/api_service.dart';
import '../model/doctor_model.dart';
import 'doctors_repository.dart';

class DoctorsRepositoryImpl implements DoctorsRepository {
  final ApiService apiService;

  DoctorsRepositoryImpl({required this.apiService});

  @override
  Future<List<DoctorAdmin>> getAllDoctors() async {
    try {
      final response = await apiService.get(
        endpoint: 'Doctors/GetAllDoctors',

      );
      
      final List<dynamic> doctorsJson = response;
      return doctorsJson.map((json) => DoctorAdmin.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch doctors: $e');
    }
  }

  @override
  Future<void> deleteDoctor(int id) async {
    try {
      await apiService.delete(
        endpoint: 'Doctors/id=$id',
      );
      print("success delete doctor");
    } catch (e) {
      throw Exception('Failed to delete doctor: $e');
    }
  }
} 