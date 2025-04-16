import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/auth_provider.dart';
import '../widgets/app_drawer.dart';
import '../core/theme/app_colors.dart';

class TestsScreen extends StatelessWidget {
  const TestsScreen({super.key});

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
            child: AppDrawer(currentRoute: '/tests'),
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
                        'Mening testlarim',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Add test logic
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Test yaratish'),
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

                  // Tests table
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
                            DataColumn(label: Text('Test nomi')),
                            DataColumn(label: Text('Fan')),
                            DataColumn(label: Text('Yaratilgan sana')),
                            DataColumn(label: Text('Holati')),
                            DataColumn(label: Text('Amallar')),
                          ],
                          rows: [
                            _buildTestRow(
                              '1',
                              'Matematika - Algebra asoslari',
                              'Matematika',
                              '2024-02-20 14:30',
                              'Tasdiqlangan',
                            ),
                            _buildTestRow(
                              '2',
                              'Fizika - Mexanika',
                              'Fizika',
                              '2024-02-19 13:15',
                              'Tasdiqlanishi kutilmoqda',
                            ),
                            _buildTestRow(
                              '3',
                              'Ingliz tili - Grammar',
                              'Ingliz tili',
                              '2024-02-18 12:45',
                              'Tasdiqlangan',
                            ),
                            _buildTestRow(
                              '4',
                              'Informatika - Algoritmlar',
                              'Informatika',
                              '2024-02-17 11:30',
                              'Tasdiqlangan',
                            ),
                            _buildTestRow(
                              '5',
                              'Kimyo - Organik kimyo',
                              'Kimyo',
                              '2024-02-16 10:20',
                              'Tasdiqlanishi kutilmoqda',
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

  DataRow _buildTestRow(
    String id,
    String name,
    String subject,
    String date,
    String status,
  ) {
    final bool isApproved = status == 'Tasdiqlangan';

    return DataRow(
      cells: [
        DataCell(Text(id)),
        DataCell(Text(name)),
        DataCell(Text(subject)),
        DataCell(Text(date)),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isApproved ? Colors.green.shade100 : Colors.amber.shade100,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              status,
              style: TextStyle(
                color:
                    isApproved ? Colors.green.shade800 : Colors.amber.shade800,
                fontSize: 12,
              ),
            ),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.visibility, size: 20),
                color: Colors.blue,
                onPressed: () {
                  // View logic
                },
                tooltip: 'Ko\'rish',
              ),
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                color: Colors.green,
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
