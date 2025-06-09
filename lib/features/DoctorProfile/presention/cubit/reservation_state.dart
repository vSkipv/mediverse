abstract class ReservationState {}

class ReservationInitial extends ReservationState {}

class ReservationLoading extends ReservationState {}

class ReservationSuccess extends ReservationState {}

class ReservationError extends ReservationState {
  final String message;
  ReservationError(this.message);
} 