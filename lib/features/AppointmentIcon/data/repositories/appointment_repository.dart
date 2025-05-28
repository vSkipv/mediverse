import 'package:mediverse/features/AppointmentIcon/data/models/doctor.dart';
import 'package:mediverse/features/AppointmentIcon/data/models/search_request.dart';

abstract class AppointmentRepository {
  Future<List<Doctor>> searchDoctors(
    SearchRequest request,
  );
  Future<List<Doctor>> searchDoctorsByName(String name);
}