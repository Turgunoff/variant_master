class User {
  final String id;
  final String email;
  final String fullName;
  final UserRole role;

  User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      role: _parseRole(json['role'] as String),
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

  static UserRole _parseRole(String role) {
    switch (role.toLowerCase()) {
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
}

enum UserRole {
  admin,
  moderator,
  teacher,
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
