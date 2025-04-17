import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:variant_master/features/auth/domain/entities/user.dart';
import 'package:variant_master/features/auth/data/models/user_model.dart';

abstract class AuthLocalDatasource {
  /// Gets the cached [UserModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<UserModel?> getLastLoggedInUser();

  /// Caches the [UserModel].
  Future<void> cacheUser(UserModel user);

  /// Removes the cached [UserModel].
  Future<void> removeUser();

  /// Login with email and password
  Future<UserModel> login({required String email, required String password});
}

@LazySingleton(as: AuthLocalDatasource)
class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  final SharedPreferences sharedPreferences;
  static const String cachedUserKey = 'CACHED_USER';

  // Mock users for demonstration
  final List<UserModel> _mockUsers = [
    const UserModel(
      id: '1',
      email: 'admin',
      fullName: 'Admin User',
      role: UserRole.admin,
    ),
    const UserModel(
      id: '2',
      email: 'moderator',
      fullName: 'Moderator User',
      role: UserRole.moderator,
    ),
    const UserModel(
      id: '3',
      email: 'teacher',
      fullName: 'Teacher User',
      role: UserRole.teacher,
    ),
  ];

  AuthLocalDatasourceImpl({required this.sharedPreferences});

  @override
  Future<UserModel?> getLastLoggedInUser() async {
    final jsonString = sharedPreferences.getString(cachedUserKey);
    if (jsonString != null) {
      return UserModel.fromJson(json.decode(jsonString));
    }
    return null;
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    await sharedPreferences.setString(
      cachedUserKey,
      json.encode(user.toJson()),
    );
  }

  @override
  Future<void> removeUser() async {
    await sharedPreferences.remove(cachedUserKey);
  }

  @override
  Future<UserModel> login(
      {required String email, required String password}) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Find user by email
      final user = _mockUsers.firstWhere(
        (user) => user.email.toLowerCase() == email.toLowerCase(),
        orElse: () => throw Exception('Foydalanuvchi topilmadi'),
      );

      // In a real app, you would verify the password here
      // For demo purposes, we'll accept any password
      // But for this task, we'll check if password is not empty
      if (password.isEmpty) {
        throw Exception('Parol kiritilmagan');
      }

      // Cache user
      await cacheUser(user);

      return user;
    } catch (e) {
      if (kDebugMode) {
        print('Login error: $e');
      }
      // Xatolikni qaytarish
      rethrow;
    }
  }
}
