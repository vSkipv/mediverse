import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/model/appointment_model.dart';
import '../../data/repository/appointment_repository.dart';

// States
abstract class AppointmentState extends Equatable {
  const AppointmentState();

  @override
  List<Object> get props => [];
}

class AppointmentInitial extends AppointmentState {}

class AppointmentLoading extends AppointmentState {}

class AppointmentLoaded extends AppointmentState {
  final List<AppointmentModel> appointments;

  const AppointmentLoaded(this.appointments);

  @override
  List<Object> get props => [appointments];
}

class AppointmentError extends AppointmentState {
  final String message;

  const AppointmentError(this.message);

  @override
  List<Object> get props => [message];
}

// Cubit
class AppointmentCubit extends Cubit<AppointmentState> {
  final AppointmentRepository _repository;

  AppointmentCubit(this._repository) : super(AppointmentInitial());

  Future<void> getAppointments(String patientId) async {
    try {
      print('Cubit: Starting to fetch appointments');
      emit(AppointmentLoading());
      
      final appointments = await _repository.getAppointments(patientId);
      print('Cubit: Successfully fetched ${appointments.length} appointments');
      
      if (appointments.isEmpty) {
        print('Cubit: No appointments found');
        emit(AppointmentError('No appointments found'));
      } else {
        emit(AppointmentLoaded(appointments));
      }
    } catch (e) {
      print('Cubit Error: $e');
      emit(AppointmentError(e.toString()));
    }
  }
} 