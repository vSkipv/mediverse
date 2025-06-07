import '../../../data/model/doctor_model.dart';

abstract class DoctorsState {}

class DoctorsInitial extends DoctorsState {}

class DoctorsLoading extends DoctorsState {}

class DoctorsLoaded extends DoctorsState {
  final List<DoctorAdmin> doctors;
  DoctorsLoaded(this.doctors);
}

class DoctorsError extends DoctorsState {
  final String message;
  DoctorsError(this.message);
}

class DoctorDeleting extends DoctorsState {}

class DoctorDeleted extends DoctorsState {}

class DoctorDeleteError extends DoctorsState {
  final String message;
  DoctorDeleteError(this.message);
} 