import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/auth_provider.dart';
import '../widgets/app_drawer.dart';
import '../core/theme/app_colors.dart';

class TeachersScreen extends StatelessWidget {
  const TeachersScreen({super.key});

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
            child: AppDrawer(currentRoute: '/teachers'),
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
                        'O\'qituvchilar ro\'yxati',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Add teacher logic
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('O\'qituvchi qo\'shish'),
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

                  // Teachers table
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
                            DataColumn(label: Text('F.I.SH')),
                            DataColumn(label: Text('Email')),
                            DataColumn(label: Text('Telefon')),
                            DataColumn(label: Text('Fan')),
                            DataColumn(label: Text('Holati')),
                            DataColumn(label: Text('Amallar')),
                          ],
                          rows: [
                            _buildTeacherRow(
                              '1',
                              'Aliyev Vali Salimovich',
                              'aliyev@example.com',
                              '+998 90 123 45 67',
                              'Matematika',
                              'Faol',
                            ),
                            _buildTeacherRow(
                              '2',
                              'Karimov Jasur Botirovich',
                              'karimov@example.com',
                              '+998 90 234 56 78',
                              'Fizika',
                              'Faol',
                            ),
                            _buildTeacherRow(
                              '3',
                              'Rahimov Sardor Anvarovich',
                              'rahimov@example.com',
                              '+998 90 345 67 89',
                              'Ingliz tili',
                              'Faol',
                            ),
                            _buildTeacherRow(
                              '4',
                              'Umarov Bobur Jamshidovich',
                              'umarov@example.com',
                              '+998 90 456 78 90',
                              'Informatika',
                              'Faol',
                            ),
                            _buildTeacherRow(
                              '5',
                              'Saidov Javohir Akmalovich',
                              'saidov@example.com',
                              '+998 90 567 89 01',
                              'Kimyo',
                              'Faol',
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

  DataRow _buildTeacherRow(
    String id,
    String name,
    String email,
    String phone,
    String subject,
    String status,
  ) {
    return DataRow(
      cells: [
        DataCell(Text(id)),
        DataCell(Text(name)),
        DataCell(Text(email)),
        DataCell(Text(phone)),
        DataCell(Text(subject)),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: Colors.green.shade800,
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
