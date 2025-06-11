import 'package:dio/dio.dart';
import '../../../../core/network/api/api_service.dart';
import '../model/appointment_model.dart';

class AppointmentRepository {
  final ApiService _apiService;

  AppointmentRepository(this._apiService);

  Future<List<AppointmentModel>> getAppointments(String patientId) async {
    try {
      print('Fetching appointments for patient: $patientId');
      final response = await _apiService.get(
        endpoint: 'patient/appointments?PatientId=${patientId}',
      );
      
      print('API Response: $response');

      if (response is List) {
        final appointments = response.map((json) => AppointmentModel.fromJson(json)).toList();
        print('Parsed appointments: ${appointments.length}');
        return appointments;
      } else {
        print('Invalid response format: $response');
        throw Exception('Invalid response format');
      }
    } catch (e) {
      print('Error fetching appointments: $e');
      throw Exception('Failed to fetch appointments: $e');
    }
  }
} 