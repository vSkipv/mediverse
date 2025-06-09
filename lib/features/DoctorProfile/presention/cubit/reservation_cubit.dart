import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/reservation_model.dart';
import '../../data/repositories/reservation_repository.dart';
import 'reservation_state.dart';

class ReservationCubit extends Cubit<ReservationState> {
  final ReservationRepository repository;

  ReservationCubit({required this.repository}) : super(ReservationInitial());

  Future<void> makeReservation({
    required int patientID,
    required int doctorID,
    required DateTime reservationDate,
  }) async {
    try {
      emit(ReservationLoading());
      
      final request = ReservationRequest(
        patientID: patientID,
        doctorID: doctorID,
        reservationDate: reservationDate,
      );
      
      await repository.makeReservation(request);
      emit(ReservationSuccess());
    } catch (e) {
      emit(ReservationError(e.toString()));
    }
  }
} 