import 'package:flutter/material.dart';

/// Application-wide constants
class AppConstants {
  // App information
  static const String appName = 'Test Boshqaruv Tizimi';
  static const String appVersion = '1.0.0';
  
  // Navigation routes
  static const String loginRoute = '/login';
  static const String mainRoute = '/main';
  
  // Navigation menu items
  static const List<NavigationItem> navigationItems = [
    NavigationItem(
      icon: Icons.dashboard,
      label: 'Boshqaruv Paneli',
      route: '/dashboard',
    ),
    NavigationItem(
      icon: Icons.science,
      label: 'Variant Yaratish',
      route: '/variants',
    ),
    NavigationItem(
      icon: Icons.school,
      label: 'O\'qituvchilar',
      route: '/teachers',
    ),
    NavigationItem(
      icon: Icons.quiz,
      label: 'Testlar',
      route: '/tests',
    ),
    NavigationItem(
      icon: Icons.verified_user,
      label: 'Moderatorlar',
      route: '/moderators',
    ),
    NavigationItem(
      icon: Icons.directions,
      label: 'Yo\'nalishlar',
      route: '/directions',
    ),
    NavigationItem(
      icon: Icons.book,
      label: 'Fanlar',
      route: '/subjects',
    ),
    NavigationItem(
      icon: Icons.settings,
      label: 'Sozlamalar',
      route: '/settings',
    ),
  ];
}

/// Navigation item model
class NavigationItem {
  final IconData icon;
  final String label;
  final String route;

  const NavigationItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}
