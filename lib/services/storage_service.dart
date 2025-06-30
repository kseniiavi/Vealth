import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/horse.dart';
import '../models/analysis_result.dart';

class StorageService {
  static const String _horsesKey = 'vealth_horses';
  static const String _analysisResultsKey = 'vealth_analysis_results';
  static const String _settingsKey = 'vealth_settings';
  static const String _userSessionKey = 'user_session';

  static StorageService? _instance;
  SharedPreferences? _prefs;

  static StorageService get instance {
    _instance ??= StorageService._internal();
    return _instance!;
  }

  StorageService._internal();

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('StorageService not initialized. Call init() first.');
    }
    return _prefs!;
  }

  // ✅ AUTH SESSION
  Future<void> saveUserSession(Map<String, dynamic> userJson) async {
    await prefs.setString(_userSessionKey, jsonEncode(userJson));
  }

  Future<Map<String, dynamic>?> getUserSession() async {
    final session = prefs.getString(_userSessionKey);
    if (session == null || session.isEmpty) return null;
    return jsonDecode(session) as Map<String, dynamic>;
  }

  Future<void> clearUserSession() async {
    await prefs.remove(_userSessionKey);
  }

  // ✅ HORSE DATA
  Future<List<Horse>> getHorses() async {
    try {
      final horsesJson = prefs.getStringList(_horsesKey) ?? [];
      return horsesJson.map((json) => Horse.fromJsonString(json)).toList();
    } catch (e) {
      throw Exception('Failed to load horses: $e');
    }
  }

  Future<void> saveHorse(Horse horse) async {
    try {
      final horses = await getHorses();
      final existingIndex = horses.indexWhere((h) => h.id == horse.id);

      if (existingIndex >= 0) {
        horses[existingIndex] = horse.copyWith(updatedAt: DateTime.now());
      } else {
        horses.add(horse);
      }

      final horsesJson = horses.map((h) => h.toJsonString()).toList();
      await prefs.setStringList(_horsesKey, horsesJson);
    } catch (e) {
      throw Exception('Failed to save horse: $e');
    }
  }

  Future<void> deleteHorse(String horseId) async {
    try {
      final horses = await getHorses();
      horses.removeWhere((h) => h.id == horseId);

      final analysisResults = await getAnalysisResults();
      analysisResults.removeWhere((result) => result.horseId == horseId);

      await prefs.setStringList(
        _horsesKey,
        horses.map((h) => h.toJsonString()).toList(),
      );

      await prefs.setStringList(
        _analysisResultsKey,
        analysisResults.map((r) => r.toJsonString()).toList(),
      );
    } catch (e) {
      throw Exception('Failed to delete horse: $e');
    }
  }

  Future<Horse?> getHorse(String horseId) async {
    try {
      final horses = await getHorses();
      return horses.firstWhere(
        (h) => h.id == horseId,
        orElse: () => null,
      );
    } catch (_) {
      return null;
    }
  }

  Future<List<AnalysisResult>> getAnalysisResults() async {
    try {
      final resultsJson = prefs.getStringList(_analysisResultsKey) ?? [];
      return resultsJson.map((json) => AnalysisResult.fromJsonString(json)).toList();
    } catch (e) {
      throw Exception('Failed to load analysis results: $e');
    }
  }

  Future<void> saveAnalysisResult(AnalysisResult result) async {
    try {
      final results = await getAnalysisResults();
      results.add(result);

      final horse = await getHorse(result.horseId);
      if (horse != null) {
        final updatedHorse = horse.copyWith(
          analysisIds: [...horse.analysisIds, result.id],
          updatedAt: DateTime.now(),
        );
        await saveHorse(updatedHorse);
      }

      final resultsJson = results.map((r) => r.toJsonString()).toList();
      await prefs.setStringList(_analysisResultsKey, resultsJson);
    } catch (e) {
      throw Exception('Failed to save analysis result: $e');
    }
  }

  Future<List<AnalysisResult>> getAnalysisResultsForHorse(String horseId) async {
    try {
      final results = await getAnalysisResults();
      return results.where((r) => r.horseId == horseId).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<AnalysisResult>> getRecentAnalysisResults({int limit = 5}) async {
    try {
      final results = await getAnalysisResults();
      results.sort((a, b) => b.analysisDate.compareTo(a.analysisDate));
      return results.take(limit).toList();
    } catch (_) {
      return [];
    }
  }

  // ✅ SETTINGS
  Future<void> saveSetting(String key, dynamic value) async {
    try {
      final settings = await getSettings();
      settings[key] = value;
      await prefs.setString(_settingsKey, jsonEncode(settings));
    } catch (e) {
      throw Exception('Failed to save setting: $e');
    }
  }

  Future<T?> getSetting<T>(String key, [T? defaultValue]) async {
    try {
      final settings = await getSettings();
      return settings[key] as T? ?? defaultValue;
    } catch (_) {
      return defaultValue;
    }
  }

  Future<Map<String, dynamic>> getSettings() async {
    try {
      final settingsJson = prefs.getString(_settingsKey);
      if (settingsJson == null) return {};
      return jsonDecode(settingsJson) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  // ✅ ADMIN / MAINTENANCE
  Future<void> clearAllData() async {
    await prefs.remove(_horsesKey);
    await prefs.remove(_analysisResultsKey);
    await prefs.remove(_settingsKey);
    await prefs.remove(_userSessionKey);
  }

  Future<Map<String, int>> getDataStatistics() async {
    try {
      final horses = await getHorses();
      final results = await getAnalysisResults();
      final recent = results.where((r) =>
        r.analysisDate.isAfter(DateTime.now().subtract(const Duration(days: 30)))).length;

      return {
        'totalHorses': horses.length,
        'totalAnalyses': results.length,
        'recentAnalyses': recent,
      };
    } catch (_) {
      return {
        'totalHorses': 0,
        'totalAnalyses': 0,
        'recentAnalyses': 0,
      };
    }
  }
}
