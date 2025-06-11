
sealed class MedicalHistoryState {}

final class MedicalHistoryInitial extends MedicalHistoryState {}

final class GetMedicalHistorySuccess extends MedicalHistoryState {}

final class GetMedicalHistoryFailed extends MedicalHistoryState {}

final class GetMedicalHistoryLoading extends MedicalHistoryState {}
