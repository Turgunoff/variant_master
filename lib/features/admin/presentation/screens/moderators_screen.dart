import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:variant_master/core/theme/app_colors.dart';
import 'package:variant_master/features/auth/bloc/auth_bloc.dart';
import 'package:variant_master/features/auth/domain/entities/user.dart';
import 'package:variant_master/features/admin/presentation/widgets/app_drawer.dart';

class ModeratorsScreen extends StatelessWidget {
  const ModeratorsScreen({super.key});

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
        if (user.role != UserRole.admin) {
          return const Scaffold(
            body: Center(
              child: Text('Access denied'),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Row(
            children: [
              // Left drawer
              const AppDrawer(currentRoute: '/moderators'),

              // Main content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Moderatorlar',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              // Add moderator logic
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Qo\'shish'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Search and filter
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Qidirish...',
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 0),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              onPressed: () {
                                // Filter logic
                              },
                              icon: const Icon(Icons.filter_list),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Table header
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(13),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                'F.I.SH',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                'Email',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Telefon',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Qo\'shilgan sana',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                'Status',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                'Amallar',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1F2937),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Table content
                      Expanded(
                        child: ListView.builder(
                          itemCount: 10, // Mock data
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      'Moderator ${index + 1}',
                                      style: const TextStyle(
                                        color: Color(0xFF1F2937),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      'moderator${index + 1}@example.com',
                                      style: const TextStyle(
                                        color: Color(0xFF1F2937),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      '+998 9${index + 1} 123 45 67',
                                      style: const TextStyle(
                                        color: Color(0xFF1F2937),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      '01.01.202${index + 1}',
                                      style: const TextStyle(
                                        color: Color(0xFF1F2937),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: index % 2 == 0
                                            ? Colors.green.withAlpha(26)
                                            : Colors.red.withAlpha(26),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        index % 2 == 0 ? 'Faol' : 'Nofaol',
                                        style: TextStyle(
                                          color: index % 2 == 0
                                              ? Colors.green
                                              : Colors.red,
                                          fontSize: 12,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            // Edit moderator logic
                                          },
                                          icon: const Icon(
                                            Icons.edit,
                                            color: AppColors.primary,
                                            size: 20,
                                          ),
                                          tooltip: 'Tahrirlash',
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            // Delete moderator logic
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                            size: 20,
                                          ),
                                          tooltip: 'O\'chirish',
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
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
