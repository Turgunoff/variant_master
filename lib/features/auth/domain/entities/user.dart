import 'package:equatable/equatable.dart';

enum UserRole { admin, moderator, teacher }

class User extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final UserRole role;

  const User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
  });

  @override
  List<Object?> get props => [id, email, fullName, role];
}

extension UserRoleExtension on UserRole {
  String get name {
    switch (this) {
      case UserRole.admin:
        return 'admin';
      case UserRole.moderator:
        return 'moderator';
      case UserRole.teacher:
        return 'teacher';
    }
  }

  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'Administrator';
      case UserRole.moderator:
        return 'Moderator';
      case UserRole.teacher:
        return 'O\'qituvchi';
    }
  }
}
