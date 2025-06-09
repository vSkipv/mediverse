class GeneticHistoryRequest {
  final int patientId;
  final String diseaseName;
  final String parent;
  final String additionalInfo;

  GeneticHistoryRequest({
    required this.patientId,
    required this.diseaseName,
    required this.parent,
    required this.additionalInfo,
  });

  Map<String, dynamic> toJson() {
    return {
      'patientId': patientId,
      'diseaseName': diseaseName,
      'parent': parent,
      'additionalInfo': additionalInfo,
    };
  }
} 