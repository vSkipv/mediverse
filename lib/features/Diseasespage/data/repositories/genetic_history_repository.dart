import '../models/genetic_history_model.dart';

abstract class GeneticHistoryRepository {
  Future<void> addGeneticHistory(GeneticHistoryRequest request);
} 