import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/auth_provider.dart';
import '../widgets/app_drawer.dart';
import '../core/theme/app_colors.dart';

class TestReviewScreen extends StatelessWidget {
  const TestReviewScreen({super.key});

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
            child: AppDrawer(currentRoute: '/test-review'),
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
                    'Tasdiqlanishi kutilayotgan testlar',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
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
                            DataColumn(label: Text('O\'qituvchi')),
                            DataColumn(label: Text('Fan')),
                            DataColumn(label: Text('Yaratilgan sana')),
                            DataColumn(label: Text('Amallar')),
                          ],
                          rows: [
                            _buildTestRow(
                              '1',
                              'Matematika - Algebra asoslari',
                              'Aliyev Vali',
                              'Matematika',
                              '2024-02-20 14:30',
                            ),
                            _buildTestRow(
                              '2',
                              'Fizika - Mexanika',
                              'Karimov Jasur',
                              'Fizika',
                              '2024-02-19 13:15',
                            ),
                            _buildTestRow(
                              '3',
                              'Ingliz tili - Grammar',
                              'Rahimov Sardor',
                              'Ingliz tili',
                              '2024-02-18 12:45',
                            ),
                            _buildTestRow(
                              '4',
                              'Informatika - Algoritmlar',
                              'Umarov Bobur',
                              'Informatika',
                              '2024-02-17 11:30',
                            ),
                            _buildTestRow(
                              '5',
                              'Kimyo - Organik kimyo',
                              'Saidov Javohir',
                              'Kimyo',
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

  DataRow _buildTestRow(
    String id,
    String name,
    String teacher,
    String subject,
    String date,
  ) {
    return DataRow(
      cells: [
        DataCell(Text(id)),
        DataCell(Text(name)),
        DataCell(Text(teacher)),
        DataCell(Text(subject)),
        DataCell(Text(date)),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  // View logic
                },
                icon: const Icon(Icons.visibility, size: 16),
                label: const Text('Ko\'rish'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  textStyle: const TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () {
                  // Approve logic
                },
                icon: const Icon(Icons.check, size: 16),
                label: const Text('Tasdiqlash'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  textStyle: const TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () {
                  // Reject logic
                },
                icon: const Icon(Icons.close, size: 16),
                label: const Text('Rad etish'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  textStyle: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
