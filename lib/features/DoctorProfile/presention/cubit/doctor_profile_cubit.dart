import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediverse/features/DoctorProfile/data/models/doctor_profile.dart';
import 'package:mediverse/features/DoctorProfile/data/repositories/doctor_profile_repository.dart';

// States
abstract class DoctorProfileState {}

class DoctorProfileInitial extends DoctorProfileState {}

class DoctorProfileLoading extends DoctorProfileState {}

class DoctorProfileLoaded extends DoctorProfileState {
  final DoctorProfile doctor;
  DoctorProfileLoaded(this.doctor);
}

class DoctorProfileError extends DoctorProfileState {
  final String message;
  DoctorProfileError(this.message);
}

// Cubit
class DoctorProfileCubit extends Cubit<DoctorProfileState> {
  final DoctorProfileRepository repository;

  DoctorProfileCubit({required this.repository}) : super(DoctorProfileInitial());

  Future<void> getDoctorProfile(int id) async {
    emit(DoctorProfileLoading());
    try {
      final doctor = await repository.getDoctorProfile(id);
      emit(DoctorProfileLoaded(doctor));
    } catch (e) {
      emit(DoctorProfileError(e.toString()));
    }
  }
} 