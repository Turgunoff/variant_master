import 'package:flutter/material.dart';
import '../models/test_model.dart';
import '../database/database_helper.dart';

class TestsListPage extends StatefulWidget {
  const TestsListPage({super.key});

  @override
  State<TestsListPage> createState() => _TestsListPageState();
}

class _TestsListPageState extends State<TestsListPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  String _selectedSubject = 'Все';
  List<TestModel> _tests = [];
  bool _isLoading = true;

  final List<String> _subjects = [
    'Все',
    'Математика',
    'Физика',
    'Химия',
    'Биология',
    'История',
    'География',
    'Литература',
    'Английский язык',
    'Русский язык',
    'Информатика',
  ];

  @override
  void initState() {
    super.initState();
    _loadTests();
  }

  Future<void> _loadTests() async {
    setState(() => _isLoading = true);

    try {
      List<Map<String, dynamic>> testMaps;
      if (_selectedSubject == 'Все') {
        testMaps = await _dbHelper.getAllTests();
      } else {
        testMaps = await _dbHelper.getTestsBySubject(_selectedSubject);
      }

      _tests = testMaps.map((map) => TestModel.fromMap(map)).toList();
    } catch (e) {
      print('Ошибка загрузки тестов: $e');
    }

    setState(() => _isLoading = false);
  }

  List<TestModel> _getFilteredTests() {
    if (_selectedSubject == 'Все') {
      return _tests;
    }
    return _tests.where((test) => test.subject == _selectedSubject).toList();
  }

  void _deleteTest(int index, TestModel test) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить тест'),
        content: const Text('Вы хотите удалить этот тест?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await _dbHelper.deleteTest(test.id!);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Тест удален'),
                    backgroundColor: Colors.red,
                  ),
                );
                _loadTests(); // Перезагружаем список
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Ошибка удаления: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showTestDetails(TestModel test) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Детали теста'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Предмет: ${test.subject}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'Вопрос:',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(test.question),
              const SizedBox(height: 12),
              Text(
                'Варианты ответов:',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...test.answers.asMap().entries.map((entry) {
                int index = entry.key;
                String answer = entry.value;
                bool isCorrect = index == test.correctIndex;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: isCorrect
                              ? Colors.green
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            String.fromCharCode(65 + index),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isCorrect ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          answer,
                          style: TextStyle(
                            fontWeight: isCorrect
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isCorrect ? Colors.green : null,
                          ),
                        ),
                      ),
                      if (isCorrect)
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 20,
                        ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final filteredTests = _getFilteredTests();

    return Scaffold(
      body: Column(
        children: [
          // Фильтр
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text(
                  'Предмет:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedSubject,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    items: _subjects.map((subject) {
                      return DropdownMenuItem(
                        value: subject,
                        child: Text(subject),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSubject = value!;
                      });
                      _loadTests();
                    },
                  ),
                ),
              ],
            ),
          ),

          // Список тестов
          Expanded(
            child: filteredTests.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.quiz_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _selectedSubject == 'Все'
                              ? 'Тесты не найдены'
                              : 'Тесты по предмету $_selectedSubject не найдены',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredTests.length,
                    itemBuilder: (context, index) {
                      final test = filteredTests[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text(
                            test.question,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text('Предмет: ${test.subject}'),
                              const SizedBox(height: 2),
                              Text(
                                'Правильный ответ: ${String.fromCharCode(65 + test.correctIndex)}',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          trailing: PopupMenuButton(
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'view',
                                child: Row(
                                  children: [
                                    Icon(Icons.visibility),
                                    SizedBox(width: 8),
                                    Text('Просмотр'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text(
                                      'Удалить',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            onSelected: (value) {
                              if (value == 'view') {
                                _showTestDetails(test);
                              } else if (value == 'delete') {
                                _deleteTest(index, test);
                              }
                            },
                          ),
                          onTap: () => _showTestDetails(test),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
