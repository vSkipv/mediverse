import '../model/doctor_model.dart';

abstract class DoctorsRepository {
  Future<List<DoctorAdmin>> getAllDoctors();
  Future<void> deleteDoctor(int id);
} 