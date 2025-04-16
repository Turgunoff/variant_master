import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/auth_provider.dart';
import '../widgets/app_drawer.dart';
import '../core/theme/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('User not authenticated'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,

      // Drawer o'rniga Row widget ishlatamiz
      body: Row(
        children: [
          // Statik drawer (chap panel)
          const SizedBox(
            width: 250, // Drawer kengligi
            child: AppDrawer(currentRoute: '/settings'),
          ),
          // Asosiy kontent
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with title
                  Text(
                    'Sozlamalar',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 24),

                  // Settings
                  Expanded(
                    child: Card(
                      elevation: 0,
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Profile settings
                            const Text(
                              'Profil sozlamalari',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ListTile(
                              leading: const Icon(Icons.person),
                              title: const Text('Shaxsiy ma\'lumotlar'),
                              subtitle: const Text(
                                  'Ismingiz, emailingiz va boshqa ma\'lumotlarni o\'zgartirish'),
                              trailing:
                                  const Icon(Icons.arrow_forward_ios, size: 16),
                              onTap: () {
                                // Navigate to profile settings
                              },
                            ),
                            const Divider(),
                            ListTile(
                              leading: const Icon(Icons.lock),
                              title: const Text('Parolni o\'zgartirish'),
                              subtitle: const Text(
                                  'Hisobingiz xavfsizligini ta\'minlash uchun parolingizni o\'zgartiring'),
                              trailing:
                                  const Icon(Icons.arrow_forward_ios, size: 16),
                              onTap: () {
                                // Navigate to change password
                              },
                            ),
                            const SizedBox(height: 32),

                            // App settings
                            const Text(
                              'Ilova sozlamalari',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),

                            ListTile(
                              leading: const Icon(Icons.notifications),
                              title: const Text('Bildirishnomalar'),
                              subtitle:
                                  const Text('Bildirishnomalar sozlamalari'),
                              trailing: Switch(
                                value: true,
                                onChanged: (value) {
                                  // Toggle notifications
                                },
                                activeColor: AppColors.primary,
                              ),
                              onTap: () {
                                // Navigate to notification settings
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
