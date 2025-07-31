import 'package:flutter/material.dart';
import '../models/test_model.dart';
import '../database/database_helper.dart';

class AddTestPage extends StatefulWidget {
  const AddTestPage({super.key});

  @override
  State<AddTestPage> createState() => _AddTestPageState();
}

class _AddTestPageState extends State<AddTestPage> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _answerAController = TextEditingController();
  final _answerBController = TextEditingController();
  final _answerCController = TextEditingController();
  final _answerDController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  String _selectedSubject = 'Математика';
  int _correctAnswerIndex = 0;

  final List<String> _subjects = [
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
  void dispose() {
    _questionController.dispose();
    _answerAController.dispose();
    _answerBController.dispose();
    _answerCController.dispose();
    _answerDController.dispose();
    super.dispose();
  }

  void _saveTest() async {
    if (_formKey.currentState!.validate()) {
      final test = TestModel(
        question: _questionController.text.trim(),
        answers: [
          _answerAController.text.trim(),
          _answerBController.text.trim(),
          _answerCController.text.trim(),
          _answerDController.text.trim(),
        ],
        correctIndex: _correctAnswerIndex,
        subject: _selectedSubject,
        createdAt: DateTime.now(),
      );

      try {
        await _dbHelper.insertTest(test.toMap());

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Тест успешно сохранен!'),
              backgroundColor: Colors.green,
            ),
          );

          // Очистить форму
          _questionController.clear();
          _answerAController.clear();
          _answerBController.clear();
          _answerCController.clear();
          _answerDController.clear();
          setState(() {
            _correctAnswerIndex = 0;
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ошибка сохранения: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Выбор предмета
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Предмет:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
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
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Текст вопроса
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Текст вопроса:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _questionController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Введите вопрос...',
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Текст вопроса обязателен';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Ответы
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Варианты ответов:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Ответ A
                      Row(
                        children: [
                          Radio<int>(
                            value: 0,
                            groupValue: _correctAnswerIndex,
                            onChanged: (value) {
                              setState(() {
                                _correctAnswerIndex = value!;
                              });
                            },
                          ),
                          const Text(
                            'A)',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _answerAController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Введите вариант A...',
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Вариант A обязателен';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Ответ B
                      Row(
                        children: [
                          Radio<int>(
                            value: 1,
                            groupValue: _correctAnswerIndex,
                            onChanged: (value) {
                              setState(() {
                                _correctAnswerIndex = value!;
                              });
                            },
                          ),
                          const Text(
                            'B)',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _answerBController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Введите вариант B...',
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Вариант B обязателен';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Ответ C
                      Row(
                        children: [
                          Radio<int>(
                            value: 2,
                            groupValue: _correctAnswerIndex,
                            onChanged: (value) {
                              setState(() {
                                _correctAnswerIndex = value!;
                              });
                            },
                          ),
                          const Text(
                            'C)',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _answerCController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Введите вариант C...',
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Вариант C обязателен';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Ответ D
                      Row(
                        children: [
                          Radio<int>(
                            value: 3,
                            groupValue: _correctAnswerIndex,
                            onChanged: (value) {
                              setState(() {
                                _correctAnswerIndex = value!;
                              });
                            },
                          ),
                          const Text(
                            'D)',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _answerDController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Введите вариант D...',
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Вариант D обязателен';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.green.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info, color: Colors.green),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Правильный ответ: ${String.fromCharCode(65 + _correctAnswerIndex)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Кнопка сохранения
              ElevatedButton(
                onPressed: _saveTest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Сохранить тест',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
