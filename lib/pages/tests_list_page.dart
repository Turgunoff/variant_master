import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/test_model.dart';

class TestsListPage extends StatefulWidget {
  const TestsListPage({super.key});

  @override
  State<TestsListPage> createState() => _TestsListPageState();
}

class _TestsListPageState extends State<TestsListPage> {
  String _selectedSubject = 'Barchasi';

  final List<String> _subjects = [
    'Barchasi',
    'Matematika',
    'Fizika',
    'Kimyo',
    'Biologiya',
    'Tarix',
    'Geografiya',
    'Adabiyot',
    'Ingliz tili',
    'Rus tili',
    'Informatika',
  ];

  List<TestModel> _getFilteredTests(Box<TestModel> box) {
    if (_selectedSubject == 'Barchasi') {
      return box.values.toList();
    }
    return box.values
        .where((test) => test.subject == _selectedSubject)
        .toList();
  }

  void _deleteTest(int index, TestModel test) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Testni o\'chirish'),
        content: const Text('Ushbu testni o\'chirishni xohlaysizmi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Bekor qilish'),
          ),
          TextButton(
            onPressed: () {
              test.delete();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Test o\'chirildi'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text(
              'O\'chirish',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showTestDetails(TestModel test) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Test tafsilotlari'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Yo\'nalish: ${test.subject}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'Savol:',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(test.question),
              const SizedBox(height: 12),
              Text(
                'Javob variantlari:',
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
            child: const Text('Yopish'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<TestModel>('tests');

    return Scaffold(
      body: Column(
        children: [
          // Filter
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text(
                  'Yo\'nalish:',
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
                    },
                  ),
                ),
              ],
            ),
          ),

          // Tests list
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: box.listenable(),
              builder: (context, Box<TestModel> box, _) {
                final filteredTests = _getFilteredTests(box);

                if (filteredTests.isEmpty) {
                  return Center(
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
                          _selectedSubject == 'Barchasi'
                              ? 'Hech qanday test topilmadi'
                              : '$_selectedSubject yo\'nalishi bo\'yicha test topilmadi',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/add_test'),
                          icon: const Icon(Icons.add),
                          label: const Text('Yangi test qo\'shish'),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
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
                            Text('Yo\'nalish: ${test.subject}'),
                            const SizedBox(height: 2),
                            Text(
                              'To\'g\'ri javob: ${String.fromCharCode(65 + test.correctIndex)}',
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
                                  Text('Ko\'rish'),
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
                                    'O\'chirish',
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
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add_test'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
