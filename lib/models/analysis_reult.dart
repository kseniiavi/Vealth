import 'dart:convert';

enum UrgencyLevel { none, low, medium, high }

class AnalysisResult {
  final String id;
  final String horseId;
  final String imagePath;
  final int estimatedAge;
  final double confidence;
  final List<String> observations;
  final List<String> recommendations;
  final DateTime analysisDate;
  final List<String> urgentConcerns;
  final UrgencyLevel urgencyLevel;
  final Map<String, dynamic> additionalData;

  AnalysisResult({
    required this.id,
    required this.horseId,
    required this.imagePath,
    required this.estimatedAge,
    required this.confidence,
    required this.observations,
    required this.recommendations,
    required this.analysisDate,
    required this.urgentConcerns,
    required this.urgencyLevel,
    required this.additionalData,
  });

  AnalysisResult copyWith({
    String? id,
    String? horseId,
    String? imagePath,
    int? estimatedAge,
    double? confidence,
    List<String>? observations,
    List<String>? recommendations,
    DateTime? analysisDate,
    List<String>? urgentConcerns,
    UrgencyLevel? urgencyLevel,
    Map<String, dynamic>? additionalData,
  }) {
    return AnalysisResult(
      id: id ?? this.id,
      horseId: horseId ?? this.horseId,
      imagePath: imagePath ?? this.imagePath,
      estimatedAge: estimatedAge ?? this.estimatedAge,
      confidence: confidence ?? this.confidence,
      observations: observations ?? this.observations,
      recommendations: recommendations ?? this.recommendations,
      analysisDate: analysisDate ?? this.analysisDate,
      urgentConcerns: urgentConcerns ?? this.urgentConcerns,
      urgencyLevel: urgencyLevel ?? this.urgencyLevel,
      additionalData: additionalData ?? this.additionalData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'horseId': horseId,
      'imagePath': imagePath,
      'estimatedAge': estimatedAge,
      'confidence': confidence,
      'observations': observations,
      'recommendations': recommendations,
      'analysisDate': analysisDate.toIso8601String(),
      'urgentConcerns': urgentConcerns,
      'urgencyLevel': urgencyLevel.index,
      'additionalData': additionalData,
    };
  }

  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    return AnalysisResult(
      id: json['id'] as String,
      horseId: json['horseId'] as String,
      imagePath: json['imagePath'] as String,
      estimatedAge: json['estimatedAge'] as int,
      confidence: (json['confidence'] as num).toDouble(),
      observations: List<String>.from(json['observations'] as List),
      recommendations: List<String>.from(json['recommendations'] as List),
      analysisDate: DateTime.parse(json['analysisDate'] as String),
      urgentConcerns: List<String>.from(json['urgentConcerns'] as List),
      urgencyLevel: UrgencyLevel.values[json['urgencyLevel'] as int],
      additionalData: Map<String, dynamic>.from(json['additionalData'] as Map),
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory AnalysisResult.fromJsonString(String source) =>
      AnalysisResult.fromJson(jsonDecode(source) as Map<String, dynamic>);

  bool get hasUrgentConcerns => urgentConcerns.isNotEmpty;
  
  String get urgencyLevelString {
    switch (urgencyLevel) {
      case UrgencyLevel.none:
        return 'Normal';
      case UrgencyLevel.low:
        return 'Monitor';
      case UrgencyLevel.medium:
        return 'Schedule Check-up';
      case UrgencyLevel.high:
        return 'Veterinary Attention Required';
    }
  }

  String get confidencePercentage => '${(confidence * 100).toStringAsFixed(1)}%';

  @override
  String toString() {
    return 'AnalysisResult(id: $id, horseId: $horseId, estimatedAge: $estimatedAge, '
           'confidence: $confidence, urgencyLevel: $urgencyLevel)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AnalysisResult && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
