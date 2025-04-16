import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class AuthService {
  static const String _userKey = 'user';

  // Mock users for demonstration
  final List<User> _mockUsers = [
    User(
      id: '1',
      email: 'admin@example.com',
      fullName: 'Admin User',
      role: UserRole.admin,
    ),
    User(
      id: '2',
      email: 'moderator@example.com',
      fullName: 'Moderator User',
      role: UserRole.moderator,
    ),
    User(
      id: '3',
      email: 'teacher@example.com',
      fullName: 'Teacher User',
      role: UserRole.teacher,
    ),
  ];

  // Singleton instance
  static final AuthService _instance = AuthService._internal();

  factory AuthService() => _instance;

  AuthService._internal();

  // Current user
  User? _currentUser;
  User? get currentUser => _currentUser;

  // Login method
  Future<User?> login(String email, String password) async {
    // In a real app, you would validate credentials against a backend
    // For demo purposes, we'll just check against our mock users
    // and accept any password

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Find user by email
      final user = _mockUsers.firstWhere(
        (user) => user.email.toLowerCase() == email.toLowerCase(),
        orElse: () => throw Exception('User not found'),
      );

      // In a real app, you would verify the password here
      // For demo purposes, we'll accept any password

      // Set current user (xotiraga saqlamasdan)
      _currentUser = user;

      return user;
    } catch (e) {
      if (kDebugMode) {
        print('Login error: $e');
      }
      return null;
    }
  }

  // Logout method
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    _currentUser = null;
  }

  // Check if user is logged in
  Future<User?> checkAuth() async {
    // Faqat joriy sessiya uchun user qaytariladi
    // Xotiradan o'qilmaydi
    return _currentUser;
  }

  // Save user to shared preferences - o'chirildi
  // Login ma'lumotlari xotiraga saqlanmaydi
}
