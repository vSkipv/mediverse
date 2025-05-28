import 'package:mediverse/features/DoctorProfile/data/models/doctor_profile.dart';

abstract class DoctorProfileRepository {
  Future<DoctorProfile> getDoctorProfile(int id);
} 