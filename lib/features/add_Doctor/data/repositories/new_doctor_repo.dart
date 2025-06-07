import '../model/new_doctor.dart';

abstract class NewDoctorRepo{
  Future<Map<String,dynamic>>addDoctor({required NewDoctor doctor});
}