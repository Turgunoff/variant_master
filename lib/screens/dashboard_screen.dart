import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dashboard title
          Text(
            'Boshqaruv Paneli',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          
          // Top stats cards
          Row(
            children: [
              // O'qituvchilar Soni
              Expanded(
                child: _StatCard(
                  icon: Icons.person,
                  iconColor: Colors.blue,
                  title: "O'qituvchilar Soni",
                  value: "156",
                  backgroundColor: Colors.blue.shade50,
                ),
              ),
              const SizedBox(width: 16),
              
              // Moderatorlar Soni
              Expanded(
                child: _StatCard(
                  icon: Icons.verified_user,
                  iconColor: Colors.teal,
                  title: "Moderatorlar Soni",
                  value: "5",
                  backgroundColor: Colors.teal.shade50,
                ),
              ),
              const SizedBox(width: 16),
              
              // Variantlar Toplami
              Expanded(
                child: _StatCard(
                  icon: Icons.science,
                  iconColor: Colors.purple,
                  title: "Variantlar Toplami",
                  value: "38",
                  backgroundColor: Colors.purple.shade50,
                ),
              ),
              const SizedBox(width: 16),
              
              // Jami Testlar
              Expanded(
                child: _StatCard(
                  icon: Icons.quiz,
                  iconColor: Colors.indigo,
                  title: "Jami Testlar",
                  value: "245",
                  backgroundColor: Colors.indigo.shade50,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Middle stats cards
          Row(
            children: [
              // Tasdiqlanishi Kutayotgan testlar
              Expanded(
                child: _StatCard(
                  icon: Icons.pending_actions,
                  iconColor: Colors.amber,
                  title: "Tasdiqlanishi Kutayotgan testlar",
                  value: "18",
                  backgroundColor: Colors.amber.shade50,
                ),
              ),
              const SizedBox(width: 16),
              
              // Tasdiqlangan Testlar
              Expanded(
                child: _StatCard(
                  icon: Icons.check_circle,
                  iconColor: Colors.green,
                  title: "Tasdiqlangan Testlar",
                  value: "227",
                  backgroundColor: Colors.green.shade50,
                ),
              ),
              const SizedBox(width: 16),
              
              // Jami Yo'nalishlar
              Expanded(
                child: _StatCard(
                  icon: Icons.directions,
                  iconColor: Colors.red,
                  title: "Jami Yo'nalishlar",
                  value: "12",
                  backgroundColor: Colors.red.shade50,
                ),
              ),
              const SizedBox(width: 16),
              
              // Jami Fanlar
              Expanded(
                child: _StatCard(
                  icon: Icons.book,
                  iconColor: Colors.pink,
                  title: "Jami Fanlar",
                  value: "48",
                  backgroundColor: Colors.pink.shade50,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Yo'nalishlar bo'yicha Variantlar section
          Text(
            "Yo'nalishlar bo'yicha Variantlar",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          
          // Yo'nalishlar table
          Expanded(
            flex: 3,
            child: _DirectionsTable(),
          ),
          
          const SizedBox(height: 24),
          
          // Fanlar bo'yicha Variantlar section
          Text(
            "Fanlar bo'yicha Variantlar",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          
          // Fanlar table
          Expanded(
            flex: 2,
            child: _SubjectsTable(),
          ),
        ],
      ),
    );
  }
}

// Stat Card Widget
class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final Color backgroundColor;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.black54,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Directions Table Widget
class _DirectionsTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: SingleChildScrollView(
        child: DataTable(
          columnSpacing: 24,
          headingRowColor: MaterialStateProperty.all(Colors.grey.shade100),
          columns: const [
            DataColumn(label: Text("Yo'nalish nomi")),
            DataColumn(label: Text("Fanlar")),
            DataColumn(label: Text("Variantlar soni")),
            DataColumn(label: Text("Holati")),
          ],
          rows: [
            _buildDirectionRow(
              "345345-Axborot tizimlari",
              "Matematika, Fizika",
              "15",
              "2024-02-20 14:30",
            ),
            _buildDirectionRow(
              "345346-Dasturiy injiniring",
              "Matematika, Fizika, Ingliz tili",
              "12",
              "2024-02-20 13:15",
            ),
            _buildDirectionRow(
              "345347-Kompyuter injiniringi",
              "Matematika, Fizika",
              "18",
              "2024-02-20 12:45",
            ),
            _buildDirectionRow(
              "345348-Sun'iy intellekt",
              "Matematika, Fizika, Informatika",
              "20",
              "2024-02-20 11:30",
            ),
            _buildDirectionRow(
              "345349-Telekommunikatsiya",
              "Matematika, Fizika",
              "14",
              "2024-02-20 10:20",
            ),
            _buildDirectionRow(
              "345350-Elektronika",
              "Matematika, Fizika, Kimyo",
              "16",
              "2024-02-20 09:15",
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildDirectionRow(
    String name,
    String subjects,
    String variantCount,
    String status,
  ) {
    return DataRow(
      cells: [
        DataCell(Text(name)),
        DataCell(Text(subjects)),
        DataCell(Text(variantCount)),
        DataCell(Text(status)),
      ],
    );
  }
}

// Subjects Table Widget
class _SubjectsTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: SingleChildScrollView(
        child: DataTable(
          columnSpacing: 24,
          headingRowColor: MaterialStateProperty.all(Colors.grey.shade100),
          columns: const [
            DataColumn(label: Text("Fan nomi")),
            DataColumn(label: Text("Variantlar soni")),
            DataColumn(label: Text("Holati")),
          ],
          rows: [
            _buildSubjectRow("Matematika", "45", "2024-02-20 14:30"),
            _buildSubjectRow("Fizika", "38", "2024-02-20 13:15"),
            _buildSubjectRow("Ingliz tili", "12", "2024-02-20 12:45"),
            _buildSubjectRow("Informatika", "20", "2024-02-20 11:30"),
            _buildSubjectRow("Kimyo", "16", "2024-02-20 10:20"),
          ],
        ),
      ),
    );
  }

  DataRow _buildSubjectRow(
    String name,
    String variantCount,
    String status,
  ) {
    return DataRow(
      cells: [
        DataCell(Text(name)),
        DataCell(Text(variantCount)),
        DataCell(Text(status)),
      ],
    );
  }
}
