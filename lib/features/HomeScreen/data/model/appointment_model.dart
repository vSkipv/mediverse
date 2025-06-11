class AppointmentModel {
  final int doctorID;
  final String doctorName;
  final String status;
  final String reservation;

  AppointmentModel({
    required this.doctorID,
    required this.doctorName,
    required this.status,
    required this.reservation,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      doctorID: json['doctorID'] ?? 0,
      doctorName: json['doctorName'] ?? '',
      status: json['status'] ?? '',
      reservation: json['reservation'] ?? '',
    );
  }
} 