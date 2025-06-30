import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class User {
  final String id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        name: json['name'],
        email: json['email'],
      );
}

class AuthService extends ChangeNotifier {
  User? _currentUser;
  bool _isLoggedIn = false;

  User? get currentUser => _currentUser;
  bool get isUserLoggedIn => _isLoggedIn;

  Future<bool> login(String email, String password) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      final user = User(
        id: _generateUserId(email),
        name: _extractNameFromEmail(email),
        email: email,
      );

      await _saveUserSession(user);
      _currentUser = user;
      _isLoggedIn = true;
      notifyListeners();

      if (kDebugMode) print("✅ Login successful: ${user.email}");
      return true;
    } catch (e) {
      if (kDebugMode) print("❌ Login failed: $e");
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      final user = User(
        id: _generateUserId(email),
        name: name,
        email: email,
      );

      await _saveUserSession(user);
      _currentUser = user;
      _isLoggedIn = true;
      notifyListeners();

      if (kDebugMode) print("✅ Registration successful: ${user.email}");
      return true;
    } catch (e) {
      if (kDebugMode) print("❌ Registration failed: $e");
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userSession = prefs.getString('user_session');

      if (kDebugMode) {
        print("🔍 Checking stored user session...");
        print("📦 Raw session data: $userSession");
      }

      if (userSession != null && userSession.isNotEmpty) {
        final userData = jsonDecode(userSession);
        _currentUser = User.fromJson(userData);
        _isLoggedIn = true;
        notifyListeners();

        if (kDebugMode) print("✅ User is logged in: ${_currentUser!.email}");
        return true;
      }

      if (kDebugMode) print("⚠️ No user session found.");
      return false;
    } catch (e) {
      if (kDebugMode) print("❌ Error checking login status: $e");
      return false;
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_session');

      _currentUser = null;
      _isLoggedIn = false;
      notifyListeners();

      if (kDebugMode) print("👋 User logged out.");
    } catch (e) {
      if (kDebugMode) print("❌ Error during logout: $e");
    }
  }

  Future<void> _saveUserSession(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_session', jsonEncode(user.toJson()));
    if (kDebugMode) print("💾 User session saved: ${user.email}");
  }

  String _generateUserId(String email) {
    final bytes = utf8.encode(email);
    final digest = sha256.convert(bytes);
    return digest.toString().substring(0, 16);
  }

  String _extractNameFromEmail(String email) {
    final username = email.split('@')[0];
    return username
        .replaceAll('.', ' ')
        .split(' ')
        .map((word) =>
            word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
