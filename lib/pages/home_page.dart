import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/test_model.dart';
import '../models/variant_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final testBox = Hive.box<TestModel>('tests');
    final variantBox = Hive.box<VariantModel>('variants');
    final tests = testBox.values.toList();
    final variants = variantBox.values.toList();
    final subjects = tests.map((e) => e.subject).toSet();

    // Eng ko'p testli fan
    String? mostPopularSubject;
    if (tests.isNotEmpty) {
      final subjectCounts = <String, int>{};
      for (var t in tests) {
        subjectCounts[t.subject] = (subjectCounts[t.subject] ?? 0) + 1;
      }
      mostPopularSubject = subjectCounts.entries
          .reduce((a, b) => a.value >= b.value ? a : b)
          .key;
    }

    // Oxirgi test va variant
    final lastTest = tests.isNotEmpty ? tests.last : null;
    final lastVariant = variants.isNotEmpty ? variants.last : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Icon(Icons.quiz, size: 64, color: Colors.blue),
                const SizedBox(height: 8),
                const Text(
                  'Test Variantlari',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Offline test va variantlar ilovasi',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: [
              _StatCard(
                icon: Icons.quiz,
                label: 'Jami testlar',
                value: tests.length.toString(),
                color: Colors.blue,
              ),
              _StatCard(
                icon: Icons.picture_as_pdf,
                label: 'Jami variantlar',
                value: variants.length.toString(),
                color: Colors.green,
              ),
              _StatCard(
                icon: Icons.category,
                label: 'Jami fanlar',
                value: subjects.length.toString(),
                color: Colors.orange,
              ),
              if (mostPopularSubject != null)
                _StatCard(
                  icon: Icons.star,
                  label: 'Eng ko\'p testli fan',
                  value: mostPopularSubject,
                  color: Colors.purple,
                ),
            ],
          ),
          const SizedBox(height: 24),

          if (lastTest != null) ...[
            const Text(
              'Oxirgi qo\'shilgan test',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.quiz, color: Colors.blue),
                title: Text(
                  lastTest.question,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text('Fan: ${lastTest.subject}'),
              ),
            ),
          ],
          if (lastVariant != null) ...[
            const Text(
              'Oxirgi yaratilgan variant',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.picture_as_pdf, color: Colors.green),
                title: Text('Fan: ${lastVariant.subject}'),
                subtitle: Text(
                  'Sana: ${lastVariant.createdAt.day}.${lastVariant.createdAt.month}.${lastVariant.createdAt.year}',
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),
          const Text(
            'Ilova haqida qisqacha',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            '''• Barcha ma'lumotlar lokal saqlanadi va offline ishlaydi.
• Variant yaratish uchun kamida 30 ta test kerak.
• PDF fayllarni yuklab olish va baham ko'rish mumkin.
• Ilova bepul va reklamasiz.''',
            style: TextStyle(fontSize: 15, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 130,
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
