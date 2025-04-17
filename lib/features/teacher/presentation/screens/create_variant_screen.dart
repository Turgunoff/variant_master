import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:variant_master/core/theme/app_colors.dart';
import 'package:variant_master/features/admin/presentation/widgets/app_drawer.dart';
import 'package:variant_master/features/auth/bloc/auth_bloc.dart';
import 'package:variant_master/features/auth/domain/entities/user.dart';

class CreateVariantScreen extends StatelessWidget {
  const CreateVariantScreen({super.key});

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
        if (user.role != UserRole.admin && user.role != UserRole.teacher) {
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
              const AppDrawer(currentRoute: '/create-variant'),

              // Main content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      const Text(
                        'Variant yaratish',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Form
                      Expanded(
                        child: Card(
                          elevation: 0,
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Yo'nalish tanlash
                                const Text(
                                  'Yo\'nalish',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                  ),
                                  hint: const Text('Yo\'nalishni tanlang'),
                                  items: const [
                                    DropdownMenuItem(
                                      value: '1',
                                      child: Text('345345-Axborot tizimlari'),
                                    ),
                                    DropdownMenuItem(
                                      value: '2',
                                      child: Text('345346-Dasturiy injiniring'),
                                    ),
                                    DropdownMenuItem(
                                      value: '3',
                                      child: Text('345347-Kompyuter injiniringi'),
                                    ),
                                    DropdownMenuItem(
                                      value: '4',
                                      child: Text('345348-Sun\'iy intellekt'),
                                    ),
                                    DropdownMenuItem(
                                      value: '5',
                                      child: Text('345349-Telekommunikatsiya'),
                                    ),
                                  ],
                                  onChanged: (value) {},
                                ),
                                const SizedBox(height: 24),

                                // Fan tanlash
                                const Text(
                                  'Fan',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                  ),
                                  hint: const Text('Fanni tanlang'),
                                  items: const [
                                    DropdownMenuItem(
                                      value: '1',
                                      child: Text('Matematika'),
                                    ),
                                    DropdownMenuItem(
                                      value: '2',
                                      child: Text('Fizika'),
                                    ),
                                    DropdownMenuItem(
                                      value: '3',
                                      child: Text('Ingliz tili'),
                                    ),
                                    DropdownMenuItem(
                                      value: '4',
                                      child: Text('Informatika'),
                                    ),
                                    DropdownMenuItem(
                                      value: '5',
                                      child: Text('Kimyo'),
                                    ),
                                  ],
                                  onChanged: (value) {},
                                ),
                                const SizedBox(height: 24),

                                // Variant nomi
                                const Text(
                                  'Variant nomi',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    hintText: 'Variant nomini kiriting',
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Testlar soni
                                const Text(
                                  'Testlar soni',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    hintText: 'Testlar sonini kiriting',
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                                const SizedBox(height: 32),

                                // Buttons
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    OutlinedButton(
                                      onPressed: () {
                                        // Cancel logic
                                      },
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 12,
                                        ),
                                      ),
                                      child: const Text('Bekor qilish'),
                                    ),
                                    const SizedBox(width: 16),
                                    ElevatedButton(
                                      onPressed: () {
                                        // Save logic
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 12,
                                        ),
                                      ),
                                      child: const Text('Saqlash'),
                                    ),
                                  ],
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
