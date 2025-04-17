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
                          crossAxisCount: 4,
                          crossAxisSpacing: 24,
                          mainAxisSpacing: 24,
                          children: [
                            // Birinchi qator
                            _buildStatCard(
                              title: 'O\'qituvchilar Soni',
                              value: '156',
                              icon: Icons.school,
                              iconColor: Colors.indigo,
                              backgroundColor: Colors.indigo.shade50,
                            ),
                            _buildStatCard(
                              title: 'Moderatorlar Soni',
                              value: '5',
                              icon: Icons.verified_user,
                              iconColor: Colors.teal,
                              backgroundColor: Colors.teal.shade50,
                            ),
                            _buildStatCard(
                              title: 'Variantlar Toplami',
                              value: '38',
                              icon: Icons.library_books,
                              iconColor: Colors.purple,
                              backgroundColor: Colors.purple.shade50,
                            ),
                            _buildStatCard(
                              title: 'Jami Testlar',
                              value: '245',
                              icon: Icons.quiz,
                              iconColor: Colors.blue,
                              backgroundColor: Colors.blue.shade50,
                            ),

                            // Ikkinchi qator
                            _buildStatCard(
                              title: 'Tasdiqlashni Kutayotgan testlar',
                              value: '18',
                              icon: Icons.pending_actions,
                              iconColor: Colors.amber,
                              backgroundColor: Colors.amber.shade50,
                            ),
                            _buildStatCard(
                              title: 'Tasdiqlangan Testlar',
                              value: '227',
                              icon: Icons.check_circle,
                              iconColor: Colors.green,
                              backgroundColor: Colors.green.shade50,
                            ),
                            _buildStatCard(
                              title: 'Jami Yo\'nalishlar',
                              value: '12',
                              icon: Icons.directions,
                              iconColor: Colors.red,
                              backgroundColor: Colors.red.shade50,
                            ),
                            _buildStatCard(
                              title: 'Jami Fanlar',
                              value: '48',
                              icon: Icons.book,
                              iconColor: Colors.pink,
                              backgroundColor: Colors.pink.shade50,
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

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
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
