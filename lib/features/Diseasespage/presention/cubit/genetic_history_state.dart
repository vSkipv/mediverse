abstract class GeneticHistoryState {}

class GeneticHistoryInitial extends GeneticHistoryState {}

class GeneticHistoryLoading extends GeneticHistoryState {}

class GeneticHistorySuccess extends GeneticHistoryState {}

class GeneticHistoryError extends GeneticHistoryState {
  final String message;
  GeneticHistoryError(this.message);
} 