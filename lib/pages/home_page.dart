import 'package:flutter/material.dart';
import '../models/test_model.dart';
import '../models/variant_model.dart';
import '../database/database_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<TestModel> _tests = [];
  List<VariantModel> _variants = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      // Загружаем тесты
      final testMaps = await _dbHelper.getAllTests();
      _tests = testMaps.map((map) => TestModel.fromMap(map)).toList();

      // Загружаем варианты
      final variantMaps = await _dbHelper.getAllVariants();
      _variants = variantMaps.map((map) => VariantModel.fromMap(map)).toList();

      // Загружаем testIds для каждого варианта
      for (int i = 0; i < _variants.length; i++) {
        final testMapsForVariant = await _dbHelper.getTestsForVariant(
          _variants[i].id!,
        );
        final testIds = testMapsForVariant
            .map((map) => map['id'] as int)
            .toList();
        _variants[i] = _variants[i].copyWith(testIds: testIds);
      }
    } catch (e) {
      print('Ошибка загрузки данных: $e');
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final subjects = _tests.map((e) => e.subject).toSet();

    // Предмет с наибольшим количеством тестов
    String? mostPopularSubject;
    if (_tests.isNotEmpty) {
      final subjectCounts = <String, int>{};
      for (var t in _tests) {
        subjectCounts[t.subject] = (subjectCounts[t.subject] ?? 0) + 1;
      }
      mostPopularSubject = subjectCounts.entries
          .reduce((a, b) => a.value >= b.value ? a : b)
          .key;
    }

    // Последний тест и вариант
    final lastTest = _tests.isNotEmpty ? _tests.first : null;
    final lastVariant = _variants.isNotEmpty ? _variants.first : null;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _StatCard(
                  icon: Icons.quiz,
                  label: 'Всего тестов',
                  value: _tests.length.toString(),
                  color: Colors.green,
                ),
                const SizedBox(height: 12),
                _StatCard(
                  icon: Icons.picture_as_pdf,
                  label: 'Всего вариантов',
                  value: _variants.length.toString(),
                  color: Colors.green,
                ),
                const SizedBox(height: 12),
                _StatCard(
                  icon: Icons.category,
                  label: 'Всего предметов',
                  value: subjects.length.toString(),
                  color: Colors.green,
                ),
                if (mostPopularSubject != null) ...[
                  const SizedBox(height: 12),
                  _StatCard(
                    icon: Icons.star,
                    label: 'Самый популярный предмет',
                    value: mostPopularSubject,
                    color: Colors.green,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 24),

            if (lastTest != null) ...[
              const Text(
                'Последний добавленный тест',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.quiz, color: Colors.green),
                  title: Text(
                    lastTest.question,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text('Предмет: ${lastTest.subject}'),
                ),
              ),
            ],
            if (lastVariant != null) ...[
              const Text(
                'Последний созданный вариант',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: const Icon(
                    Icons.picture_as_pdf,
                    color: Colors.green,
                  ),
                  title: Text('Предмет: ${lastVariant.subject}'),
                  subtitle: Text(
                    'Дата: ${lastVariant.createdAt.day}.${lastVariant.createdAt.month}.${lastVariant.createdAt.year}',
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            const Text(
              'Кратко о приложении',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '''• Все данные сохраняются локально и работают офлайн.
• Для создания варианта нужно минимум 30 тестов.
• Можно скачивать PDF файлы и делиться ими.
• Приложение бесплатное и без рекламы.''',
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
          ],
        ),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 24, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
