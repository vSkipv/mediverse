import 'package:mediverse/core/network/api/api_service.dart';
import '../models/genetic_history_model.dart';
import 'genetic_history_repository.dart';

class GeneticHistoryRepositoryImpl implements GeneticHistoryRepository {
  final ApiService _apiService;

  GeneticHistoryRepositoryImpl(this._apiService);

  @override
  Future<void> addGeneticHistory(GeneticHistoryRequest request) async {
    try {
      await _apiService.post(
        endpoint: '/MedicalHistory/Add-genatic',
        data: request.toJson(),
      );
    } catch (e) {
      throw Exception('Failed to add genetic history: $e');
    }
  }
} 