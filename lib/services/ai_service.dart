import 'dart:math';
import 'dart:typed_data';
import '../models/analysis_result.dart';
import '../models/urgency_level.dart';

class AIService {
  static final AIService _instance = AIService._internal();
  static AIService get instance => _instance;
  AIService._internal();
  
  final Random _random = Random();

  Future<AnalysisResult> analyzeTeethImage({
    required String horseId,
    required Uint8List imageBytes,
    required String imagePath,
  }) async {
    await Future.delayed(const Duration(seconds: 2, milliseconds: 500));
    return _generateMockAnalysis(horseId, imagePath);
  }

  AnalysisResult _generateMockAnalysis(String horseId, String imagePath) {
    final baseAge = _random.nextInt(25) + 3;
    final confidenceVariation = _random.nextDouble() * 0.3 + 0.7;
    
    return AnalysisResult(
      id: _generateResultId(),
      horseId: horseId,
      imagePath: imagePath,
      estimatedAge: baseAge,
      confidence: confidenceVariation,
      observations: _generateHealthObservations(baseAge),
      recommendations: _generateRecommendations(baseAge),
      analysisDate: DateTime.now(),
      urgentConcerns: _generateUrgentConcerns(baseAge),
    );
  }

  List<String> _generateHealthObservations(int age) {
    final observations = <String>[];
    
    if (age <= 5) {
      observations.addAll([
        'Deciduous teeth present with normal wear patterns',
        'Central incisors show rectangular occlusal surfaces',
        'Infundibular cups clearly visible',
        'No abnormal wear detected',
      ]);
    } else if (age <= 10) {
      observations.addAll([
        'Permanent incisors fully erupted',
        'Occlusal surfaces transitioning from rectangular to oval',
        'Infundibular cups beginning to disappear',
        'Normal age-appropriate wear patterns',
      ]);
    } else {
      observations.addAll([
        'Triangular occlusal surfaces',
        'Dental stars becoming more prominent',
        'Galvayne\'s groove clearly visible',
        'Increased tooth angulation',
      ]);
    }
    return observations;
  }

  String _generateResultId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomSuffix = _random.nextInt(9999).toString().padLeft(4, '0');
    return 'analysis_${timestamp}_$randomSuffix';
  }

  bool validateImage(Uint8List imageBytes) {
    if (imageBytes.isEmpty) return false;
    if (imageBytes.length < 1000) return false;
    if (imageBytes.length > 10 * 1024 * 1024) return false;
    return true;
  }
}
