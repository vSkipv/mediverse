class ReservationRequest {
  final int patientID;
  final int doctorID;
  final DateTime reservationDate;

  ReservationRequest({
    required this.patientID,
    required this.doctorID,
    required this.reservationDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'patientID': patientID,
      'doctorID': doctorID,
      'reservationDate': reservationDate.toIso8601String(),
    };
  }
} 