import 'package:equatable/equatable.dart';

enum PasswordDifficulty {
  easy, // 4 belgi + raqamlar
  medium, // 6 belgi + raqamlar
  hard, // 8 belgi + raqamlar + maxsus belgilar
}

class AppSettings extends Equatable {
  // Umumiy sozlamalar
  final String organizationName;
  final String logoPath;
  final String defaultLanguage;

  // Xavfsizlik sozlamalari
  final PasswordDifficulty passwordDifficulty;
  final int sessionTimeout; // daqiqalarda

  const AppSettings({
    required this.organizationName,
    required this.logoPath,
    required this.defaultLanguage,
    required this.passwordDifficulty,
    required this.sessionTimeout,
  });

  // Default qiymatlar bilan yaratish
  factory AppSettings.defaultSettings() {
    return const AppSettings(
      organizationName: 'Profi University',
      logoPath: '',
      defaultLanguage: 'O\'zbek',
      passwordDifficulty: PasswordDifficulty.medium,
      sessionTimeout: 60,
    );
  }

  // Nusxa olish va o'zgartirish
  AppSettings copyWith({
    String? organizationName,
    String? logoPath,
    String? defaultLanguage,
    PasswordDifficulty? passwordDifficulty,
    int? sessionTimeout,
  }) {
    return AppSettings(
      organizationName: organizationName ?? this.organizationName,
      logoPath: logoPath ?? this.logoPath,
      defaultLanguage: defaultLanguage ?? this.defaultLanguage,
      passwordDifficulty: passwordDifficulty ?? this.passwordDifficulty,
      sessionTimeout: sessionTimeout ?? this.sessionTimeout,
    );
  }

  @override
  List<Object?> get props => [
        organizationName,
        logoPath,
        defaultLanguage,
        passwordDifficulty,
        sessionTimeout,
      ];
}

// PasswordDifficulty uchun qo'shimcha funksiyalar
extension PasswordDifficultyExtension on PasswordDifficulty {
  String get displayName {
    switch (this) {
      case PasswordDifficulty.easy:
        return 'Oson (4 belgi + raqamlar)';
      case PasswordDifficulty.medium:
        return 'O\'rta (6 belgi + raqamlar)';
      case PasswordDifficulty.hard:
        return 'Qiyin (8 belgi + raqamlar + maxsus belgilar)';
    }
  }
}
