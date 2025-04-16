import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/auth_provider.dart';
import '../widgets/app_drawer.dart';
import '../core/theme/app_colors.dart';

class DirectionsScreen extends StatelessWidget {
  const DirectionsScreen({super.key});

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
            child: AppDrawer(currentRoute: '/directions'),
          ),
          // Asosiy kontent
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with title and add button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Yo\'nalishlar ro\'yxati',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Add direction logic
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Yo\'nalish qo\'shish'),
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
                          tooltip: 'Filter',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Directions table
                  Expanded(
                    child: Card(
                      elevation: 0,
                      margin: EdgeInsets.zero,
                      child: SingleChildScrollView(
                        child: DataTable(
                          columnSpacing: 24,
                          headingRowColor:
                              MaterialStateProperty.all(Colors.grey.shade100),
                          columns: const [
                            DataColumn(label: Text('ID')),
                            DataColumn(label: Text('Yo\'nalish nomi')),
                            DataColumn(label: Text('Fanlar')),
                            DataColumn(label: Text('Yaratilgan sana')),
                            DataColumn(label: Text('Amallar')),
                          ],
                          rows: [
                            _buildDirectionRow(
                              '1',
                              '345345-Axborot tizimlari',
                              'Matematika, Fizika',
                              '2024-02-20 14:30',
                            ),
                            _buildDirectionRow(
                              '2',
                              '345346-Dasturiy injiniring',
                              'Matematika, Fizika, Ingliz tili',
                              '2024-02-19 13:15',
                            ),
                            _buildDirectionRow(
                              '3',
                              '345347-Kompyuter injiniringi',
                              'Matematika, Fizika',
                              '2024-02-18 12:45',
                            ),
                            _buildDirectionRow(
                              '4',
                              '345348-Sun\'iy intellekt',
                              'Matematika, Fizika, Informatika',
                              '2024-02-17 11:30',
                            ),
                            _buildDirectionRow(
                              '5',
                              '345349-Telekommunikatsiya',
                              'Matematika, Fizika',
                              '2024-02-16 10:20',
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

  DataRow _buildDirectionRow(
    String id,
    String name,
    String subjects,
    String date,
  ) {
    return DataRow(
      cells: [
        DataCell(Text(id)),
        DataCell(Text(name)),
        DataCell(Text(subjects)),
        DataCell(Text(date)),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                color: Colors.blue,
                onPressed: () {
                  // Edit logic
                },
                tooltip: 'Tahrirlash',
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 20),
                color: Colors.red,
                onPressed: () {
                  // Delete logic
                },
                tooltip: 'O\'chirish',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
