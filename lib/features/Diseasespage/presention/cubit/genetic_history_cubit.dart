import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/genetic_history_model.dart';
import '../../data/repositories/genetic_history_repository.dart';
import 'genetic_history_state.dart';

class GeneticHistoryCubit extends Cubit<GeneticHistoryState> {
  final GeneticHistoryRepository repository;

  GeneticHistoryCubit({required this.repository}) : super(GeneticHistoryInitial());

  Future<void> addGeneticHistory({
    required int patientId,
    required String diseaseName,
    required String parent,
    required String additionalInfo,
  }) async {
    try {
      emit(GeneticHistoryLoading());
      
      final request = GeneticHistoryRequest(
        patientId: patientId,
        diseaseName: diseaseName,
        parent: parent,
        additionalInfo: additionalInfo,
      );
      
      await repository.addGeneticHistory(request);
      emit(GeneticHistorySuccess());
    } catch (e) {
      emit(GeneticHistoryError(e.toString()));
    }
  }
} 