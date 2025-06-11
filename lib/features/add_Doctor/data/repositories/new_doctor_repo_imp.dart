import 'package:mediverse/core/network/api/api_service.dart';
import 'package:mediverse/features/add_Doctor/data/model/new_doctor.dart';
import 'package:mediverse/features/add_Doctor/data/repositories/new_doctor_repo.dart';

class NewDoctorRepoImp extends NewDoctorRepo{
  final ApiService apiService;

  NewDoctorRepoImp({required this.apiService});

  @override
  Future<Map<String, dynamic>> addDoctor({required NewDoctor doctor}) async {
    try{
      // Use multipart form data if there's an image, otherwise use JSON
      if (doctor.image != null) {
        final formData = await doctor.toFormData();
        final response = await apiService.postContent(
            endpoint: "Doctors/create", data: formData, token: true);
        return response;
      } else {
        final response = await apiService.post(
            endpoint: "Doctors/create", data: doctor.toJson(), token: true);
        return response;
      }
    }catch(e){
      throw Exception('Failed to add doctor: $e');
    }
  }
  
}
