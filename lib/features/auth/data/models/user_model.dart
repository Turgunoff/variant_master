import 'package:variant_master/features/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.fullName,
    required super.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      role: _roleFromString(json['role'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'role': role.name,
    };
  }

  static UserRole _roleFromString(String roleStr) {
    switch (roleStr) {
      case 'admin':
        return UserRole.admin;
      case 'moderator':
        return UserRole.moderator;
      case 'teacher':
        return UserRole.teacher;
      default:
        return UserRole.teacher;
    }
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      fullName: user.fullName,
      role: user.role,
    );
  }
}
