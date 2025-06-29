import 'dart:math';
import 'dart:async';
import 'package:uuid/uuid.dart';
import '../models/analysis_result.dart';
import '../models/urgency_level.dart';

class AIService {
  static final AIService instance = AIService._internal();
  final _uuid = const Uuid();

  AIService._internal();

  Future<AnalysisResult> analyzeTeethImage({
    required String horseId,
    required String imagePath,
  }) async {
    await Future.delayed(const Duration(seconds: 2)); // simulate analysis time
    return _generateMockAnalysis(horseId, imagePath);
  }

  AnalysisResult _generateMockAnalysis(String horseId, String imagePath) {
    final id = _uuid.v4();
    final now = DateTime.now();
    final random = Random();

    final estimatedAge = 3 + random.nextDouble() * 20; // 3 to 23 years
    final confidence = 0.6 + random.nextDouble() * 0.4; // 60% to 100%
    final observations = [
      'Visible central incisors',
      'Slight enamel wear',
      'Mild tartar accumulation'
    ];
    final recommendations = _generateRecommendations(estimatedAge);
    final urgentConcerns = _generateUrgentConcerns(estimatedAge);

    final urgency = urgentConcerns.isEmpty
        ? UrgencyLevel.none
        : estimatedAge > 18
            ? UrgencyLevel.high
            : UrgencyLevel.medium;

    return AnalysisResult(
      id: id,
      horseId: horseId,
      imagePath: imagePath,
      analysisDate: now,
      estimatedAge: estimatedAge.round(),
      confidence: confidence,
      observations: observations,
      recommendations: recommendations,
      urgentConcerns: urgentConcerns,
      urgencyLevel: urgency,
      additionalData: {},
    );
  }

  List<String> _generateRecommendations(double age) {
    if (age < 5) {
      return ['Monitor for tooth eruption', 'Introduce mild dental checks'];
    } else if (age < 15) {
      return ['Routine annual dental checkup', 'Ensure proper diet consistency'];
    } else {
      return ['Soft feed recommended', 'Bi-annual dental care', 'Monitor wear regularly'];
    }
  }

  List<String> _generateUrgentConcerns(double age) {
    if (age < 10) return [];
    if (age < 18) return ['Early signs of enamel erosion'];
    return ['Tooth wear', 'Potential gum recession', 'Evaluate for wave mouth'];
  }

  bool validateImage(List<int> bytes) {
    // Placeholder: Require image > 10KB to consider it valid
    return bytes.length > 10000;
  }
}
