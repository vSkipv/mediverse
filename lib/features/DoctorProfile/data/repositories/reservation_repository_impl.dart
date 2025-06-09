import 'package:mediverse/core/network/api/api_service.dart';
import '../model/reservation_model.dart';
import 'reservation_repository.dart';

class ReservationRepositoryImpl implements ReservationRepository {
  final ApiService apiService;

  ReservationRepositoryImpl({required this.apiService});

  @override
  Future<void> makeReservation(ReservationRequest request) async {
    try {
      await apiService.post(
        endpoint: 'Reservation/make',
        data: request.toJson(),
        token: true,
      );
    } catch (e) {
      throw Exception('Failed to make reservation: $e');
    }
  }
} 