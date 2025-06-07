import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/doctors_repository.dart';
import 'doctors_state.dart';

class DoctorsCubit extends Cubit<DoctorsState> {
  final DoctorsRepository repository;

  DoctorsCubit({required this.repository}) : super(DoctorsInitial());

  Future<void> getAllDoctors() async {
    try {
      emit(DoctorsLoading());
      final doctors = await repository.getAllDoctors();
      emit(DoctorsLoaded(doctors));
    } catch (e) {
      emit(DoctorsError(e.toString()));
    }
  }

  Future<void> deleteDoctor(int id) async {
    try {
      emit(DoctorDeleting());
      await repository.deleteDoctor(id);
      emit(DoctorDeleted());
      getAllDoctors();
    } catch (e) {

      emit(DoctorDeleteError(e.toString()));
      getAllDoctors();

    }
  }
} 