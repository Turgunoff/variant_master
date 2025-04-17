import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:variant_master/core/theme/app_colors.dart';
import 'package:variant_master/features/admin/presentation/widgets/app_drawer.dart';
import 'package:variant_master/features/auth/bloc/auth_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! AuthAuthenticated) {
          return const Scaffold(
            body: Center(
              child: Text('User not authenticated'),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Row(
            children: [
              // Left drawer
              const AppDrawer(currentRoute: '/settings'),

              // Main content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      const Text(
                        'Sozlamalar',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
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
      },
    );
  }
}
