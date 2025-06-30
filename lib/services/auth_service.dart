import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:crypto/crypto.dart';
import '../services/storage_service.dart';

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

      await StorageService.instance.saveUserSession(user.toJson());

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

      await StorageService.instance.saveUserSession(user.toJson());

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
      final session = await StorageService.instance.getUserSession();

      if (kDebugMode) {
        print("🔍 Checking login session...");
        print("📦 Session data: $session");
      }

      if (session != null) {
        _currentUser = User.fromJson(session);
        _isLoggedIn = true;
        notifyListeners();

        if (kDebugMode) print("✅ Already logged in: ${_currentUser!.email}");
        return true;
      }

      if (kDebugMode) print("⚠️ No active session found.");
      return false;
    } catch (e) {
      if (kDebugMode) print("❌ Error during isLoggedIn check: $e");
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await StorageService.instance.clearUserSession();

      _currentUser = null;
      _isLoggedIn = false;
      notifyListeners();

      if (kDebugMode) print("👋 User logged out.");
    } catch (e) {
      if (kDebugMode) print("❌ Logout error: $e");
    }
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
