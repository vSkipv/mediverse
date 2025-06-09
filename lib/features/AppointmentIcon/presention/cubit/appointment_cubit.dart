import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediverse/features/AppointmentIcon/data/models/doctor.dart';
import 'package:mediverse/features/AppointmentIcon/data/models/search_request.dart';

import '../../data/repositories/appointment_repository.dart';

// States
abstract class AppointmentState {}

class AppointmentInitial extends AppointmentState {}

class AppointmentLoading extends AppointmentState {}

class AppointmentLoaded extends AppointmentState {
  final List<Doctor> doctors;
  AppointmentLoaded(this.doctors);
}

class AppointmentError extends AppointmentState {
  final String message;
  final bool isAuthError;
  AppointmentError(this.message, {this.isAuthError = false});
}

// Cubit
class AppointmentCubit extends Cubit<AppointmentState> {
  final AppointmentRepository repository;

  AppointmentCubit({required this.repository}) : super(AppointmentInitial());

  Future<void> searchDoctors({
    required String specialist,
    required String country,
    required String city,
  }) async {
    try {
      emit(AppointmentLoading());

      final request = SearchRequest(
        specialist: specialist,
        country: country,
        city: city,
      );

      final doctors = await repository.searchDoctors(request);
      emit(AppointmentLoaded(doctors));
    } catch (e) {
      final errorMessage = e.toString();
      final isAuthError = errorMessage.contains('Please login to continue');
      emit(AppointmentError(errorMessage, isAuthError: isAuthError));
    }
  }

  Future<void> searchDoctorsByName(String name, String city, String country, String specialist) async {
    emit(AppointmentLoading());
    try {
      final doctors = await repository.searchDoctorsByName(name, city, country, specialist);
      emit(AppointmentLoaded(doctors));
    } catch (e) {
      if (e.toString().contains('No doctors found')) {
        emit(AppointmentLoaded([])); // Emit empty list for no results
      } else {
        emit(AppointmentError(e.toString()));
      }
    }
  }
} 