import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:variant_master/core/theme/app_colors.dart';
import 'package:variant_master/features/admin/presentation/widgets/app_drawer.dart';
import 'package:variant_master/features/auth/bloc/auth_bloc.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

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

        final user = state.user;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Row(
            children: [
              // Left drawer
              const AppDrawer(currentRoute: '/dashboard'),

              // Main content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Text(
                        'Salom, ${user.fullName}!',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Bugun: ${_getFormattedDate()}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Dashboard content
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 3,
                          crossAxisSpacing: 24,
                          mainAxisSpacing: 24,
                          children: [
                            _buildDashboardCard(
                              context,
                              title: 'Testlar',
                              icon: Icons.quiz,
                              count: '125',
                              color: AppColors.primary,
                              onTap: () =>
                                  Navigator.pushNamed(context, '/tests'),
                            ),
                            _buildDashboardCard(
                              context,
                              title: 'O\'qituvchilar',
                              icon: Icons.school,
                              count: '48',
                              color: Colors.orange,
                              onTap: () =>
                                  Navigator.pushNamed(context, '/teachers'),
                            ),
                            _buildDashboardCard(
                              context,
                              title: 'Moderatorlar',
                              icon: Icons.verified_user,
                              count: '12',
                              color: Colors.green,
                              onTap: () =>
                                  Navigator.pushNamed(context, '/moderators'),
                            ),
                            _buildDashboardCard(
                              context,
                              title: 'Yo\'nalishlar',
                              icon: Icons.directions,
                              count: '8',
                              color: Colors.purple,
                              onTap: () =>
                                  Navigator.pushNamed(context, '/directions'),
                            ),
                            _buildDashboardCard(
                              context,
                              title: 'Fanlar',
                              icon: Icons.book,
                              count: '24',
                              color: Colors.teal,
                              onTap: () =>
                                  Navigator.pushNamed(context, '/subjects'),
                            ),
                            _buildDashboardCard(
                              context,
                              title: 'Variant yaratish',
                              icon: Icons.create,
                              count: 'Yangi',
                              color: Colors.red,
                              onTap: () => Navigator.pushNamed(
                                  context, '/create-variant'),
                            ),
                          ],
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

  Widget _buildDashboardCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String count,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withAlpha(26),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              count,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF1F2937),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final months = [
      'Yanvar',
      'Fevral',
      'Mart',
      'Aprel',
      'May',
      'Iyun',
      'Iyul',
      'Avgust',
      'Sentabr',
      'Oktabr',
      'Noyabr',
      'Dekabr'
    ];
    return '${now.day} ${months[now.month - 1]}, ${now.year}';
  }
}
