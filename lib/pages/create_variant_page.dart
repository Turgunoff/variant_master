import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/test_model.dart';
import '../models/variant_model.dart';
import '../database/database_helper.dart';

class CreateVariantPage extends StatefulWidget {
  const CreateVariantPage({super.key});

  @override
  State<CreateVariantPage> createState() => _CreateVariantPageState();
}

class _CreateVariantPageState extends State<CreateVariantPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  String? _selectedSubject;
  bool _isGenerating = false;
  List<TestModel>? _selectedTests;
  List<String> _subjects = [];

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  Future<void> _loadSubjects() async {
    try {
      final testMaps = await _dbHelper.getAllTests();
      final subjects = testMaps
          .map((map) => map['subject'] as String)
          .toSet()
          .toList();
      setState(() {
        _subjects = subjects;
      });
    } catch (e) {
      print('Ошибка загрузки предметов: $e');
    }
  }

  Future<List<TestModel>> _getTestsBySubject(String subject) async {
    try {
      final testMaps = await _dbHelper.getTestsBySubject(subject);
      return testMaps.map((map) => TestModel.fromMap(map)).toList();
    } catch (e) {
      print('Ошибка загрузки тестов: $e');
      return [];
    }
  }

  Future<void> _generateVariant() async {
    if (_selectedSubject == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Выберите предмет'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
    });

    try {
      final tests = await _getTestsBySubject(_selectedSubject!);

      if (tests.length < 30) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Недостаточно тестов для создания варианта. Нужно минимум 30, а у вас ${tests.length}',
            ),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isGenerating = false;
        });
        return;
      }

      // Перемешиваем тесты
      tests.shuffle();

      // Берем первые 30 тестов
      final selectedTests = tests.take(30).toList();

      setState(() {
        _selectedTests = selectedTests;
      });

      // Генерируем PDF
      await _generatePDF(selectedTests);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  Future<void> _generatePDF(List<TestModel> tests) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (context) => [
            // Заголовок
            pw.Header(
              level: 0,
              child: pw.Text(
                'Вариант по предмету: $_selectedSubject',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),

            // Инструкции
            pw.Paragraph(
              text: 'Инструкции:',
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
            pw.Paragraph(
              text:
                  '1. Внимательно прочитайте каждый вопрос\n'
                  '2. Выберите правильный ответ из вариантов A, B, C, D\n'
                  '3. Запишите ответы на отдельном листе\n'
                  '4. Время выполнения: 45 минут',
            ),

            pw.SizedBox(height: 20),

            // Тесты
            ...tests.asMap().entries.map((entry) {
              int index = entry.key;
              TestModel test = entry.value;

              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    '${index + 1}. ${test.question}',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  ...test.answers.asMap().entries.map((answerEntry) {
                    int answerIndex = answerEntry.key;
                    String answer = answerEntry.value;
                    return pw.Padding(
                      padding: const pw.EdgeInsets.only(left: 20, bottom: 4),
                      child: pw.Text(
                        '${String.fromCharCode(65 + answerIndex)}) $answer',
                        style: const pw.TextStyle(fontSize: 11),
                      ),
                    );
                  }).toList(),
                  pw.SizedBox(height: 12),
                ],
              );
            }).toList(),
          ],
        ),
      );

      // Сохраняем PDF
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final pdfPath =
          '${directory.path}/variant_${_selectedSubject}_$timestamp.pdf';
      final file = File(pdfPath);
      await file.writeAsBytes(await pdf.save());

      // Сохраняем в базу данных
      final variant = VariantModel(
        subject: _selectedSubject!,
        pdfPath: pdfPath,
        createdAt: DateTime.now(),
        testIds: tests.map((t) => t.id!).toList(),
      );

      final variantId = await _dbHelper.insertVariant(variant.toMap());
      await _dbHelper.insertVariantTests(variantId, variant.testIds);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Вариант создан: $pdfPath'),
            backgroundColor: Colors.green,
          ),
        );

        // Показываем диалог с опциями
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Вариант создан'),
            content: const Text('Что вы хотите сделать с вариантом?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Printing.layoutPdf(onLayout: (format) => pdf.save());
                },
                child: const Text('Печать'),
              ),
                             TextButton(
                 onPressed: () async {
                   Navigator.pop(context);
                   final bytes = await pdf.save();
                   Printing.sharePdf(
                     bytes: bytes,
                     filename: 'variant_${_selectedSubject}_$timestamp.pdf',
                   );
                 },
                 child: const Text('Поделиться'),
               ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Закрыть'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка создания PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Выбор предмета
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Выберите предмет:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _selectedSubject,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      hint: const Text('Выберите предмет'),
                      items: _subjects.map((subject) {
                        return DropdownMenuItem(
                          value: subject,
                          child: Text(subject),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedSubject = value;
                          _selectedTests = null;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Информация о предмете
            if (_selectedSubject != null)
              FutureBuilder<List<TestModel>>(
                future: _getTestsBySubject(_selectedSubject!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Ошибка загрузки: ${snapshot.error}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    );
                  }

                  final tests = snapshot.data ?? [];
                  final hasEnoughTests = tests.length >= 30;

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Информация о предмете: $_selectedSubject',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(
                                hasEnoughTests
                                    ? Icons.check_circle
                                    : Icons.warning,
                                color: hasEnoughTests
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Количество тестов: ${tests.length}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: hasEnoughTests
                                        ? Colors.green
                                        : Colors.orange,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            hasEnoughTests
                                ? '✓ Достаточно тестов для создания варианта'
                                : '⚠ Нужно минимум 30 тестов для создания варианта',
                            style: TextStyle(
                              color: hasEnoughTests
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

            const SizedBox(height: 24),

            // Кнопка создания варианта
            ElevatedButton(
              onPressed: _isGenerating || _selectedSubject == null
                  ? null
                  : _generateVariant,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isGenerating
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text('Создание варианта...'),
                      ],
                    )
                  : const Text(
                      'Создать вариант',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),

            const SizedBox(height: 24),

            // Информация о созданном варианте
            if (_selectedTests != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Созданный вариант:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text('Предмет: $_selectedSubject'),
                      Text('Количество вопросов: ${_selectedTests!.length}'),
                      Text(
                        'Дата создания: ${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}',
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Инструкции
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Как создать вариант:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '1. Выберите предмет из списка\n'
                      '2. Убедитесь, что у вас есть минимум 30 тестов\n'
                      '3. Нажмите "Создать вариант"\n'
                      '4. Дождитесь создания PDF файла\n'
                      '5. Выберите действие: печать или поделиться',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
