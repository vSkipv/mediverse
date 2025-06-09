import '../model/reservation_model.dart';

abstract class ReservationRepository {
  Future<void> makeReservation(ReservationRequest request);
} 