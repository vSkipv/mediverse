class PredictionResponse {
  final String model;
  final String predictedLabel;
  final double confidence;

  PredictionResponse({
    required this.model,
    required this.predictedLabel,
    required this.confidence,
  });

  factory PredictionResponse.fromJson(Map<String, dynamic> json) {
    return PredictionResponse(
      model: json['model'] ?? '',
      predictedLabel: json['predicted_label'] ?? '',
      confidence: (json['confidence'] ?? 0.0).toDouble(),
    );
  }
} 