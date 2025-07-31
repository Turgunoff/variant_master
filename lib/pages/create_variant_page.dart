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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Выбор предмета
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.school,
                            color: Colors.blue,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Выберите предмет',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: _selectedSubject,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          suffixIcon: Container(
                            margin: const EdgeInsets.only(right: 6),
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.grey.shade600,
                              size: 18,
                            ),
                          ),
                        ),
                        icon: const SizedBox.shrink(),
                        dropdownColor: Colors.white,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
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
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.red.shade200,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Ошибка загрузки: ${snapshot.error}',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final tests = snapshot.data ?? [];
                  final hasEnoughTests = tests.length >= 30;

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: hasEnoughTests
                            ? Colors.green.shade200
                            : Colors.orange.shade200,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (hasEnoughTests ? Colors.green : Colors.orange)
                              .withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color:
                                      (hasEnoughTests
                                              ? Colors.green
                                              : Colors.orange)
                                          .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  hasEnoughTests
                                      ? Icons.check_circle
                                      : Icons.warning,
                                  color: hasEnoughTests
                                      ? Colors.green
                                      : Colors.orange,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Информация о предмете',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: hasEnoughTests
                                            ? Colors.green
                                            : Colors.orange,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      _selectedSubject!,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color:
                                  (hasEnoughTests
                                          ? Colors.green
                                          : Colors.orange)
                                      .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  hasEnoughTests
                                      ? Icons.check_circle
                                      : Icons.warning,
                                  color: hasEnoughTests
                                      ? Colors.green
                                      : Colors.orange,
                                  size: 16,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Количество тестов: ${tests.length}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: hasEnoughTests
                                              ? Colors.green
                                              : Colors.orange,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        hasEnoughTests
                                            ? '✓ Достаточно тестов для создания варианта'
                                            : '⚠ Нужно минимум 30 тестов для создания варианта',
                                        style: TextStyle(
                                          color: hasEnoughTests
                                              ? Colors.green
                                              : Colors.orange,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _isGenerating || _selectedSubject == null
                    ? null
                    : _generateVariant,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isGenerating
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Создание варианта...',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_circle, size: 18),
                          SizedBox(width: 6),
                          Text(
                            'Создать вариант',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 24),

            // Информация о созданном варианте
            if (_selectedTests != null) ...[
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade200, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.picture_as_pdf,
                              color: Colors.green,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Созданный вариант',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            _buildInfoRow('Предмет', _selectedSubject!),
                            const SizedBox(height: 6),
                            _buildInfoRow(
                              'Количество вопросов',
                              '${_selectedTests!.length}',
                            ),
                            const SizedBox(height: 6),
                            _buildInfoRow(
                              'Дата создания',
                              '${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Инструкции
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.help_outline,
                            color: Colors.purple,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Как создать вариант',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          _buildInstructionStep(
                            '1',
                            'Выберите предмет из списка',
                          ),
                          _buildInstructionStep(
                            '2',
                            'Убедитесь, что у вас есть минимум 30 тестов',
                          ),
                          _buildInstructionStep(
                            '3',
                            'Нажмите "Создать вариант"',
                          ),
                          _buildInstructionStep(
                            '4',
                            'Дождитесь создания PDF файла',
                          ),
                          _buildInstructionStep(
                            '5',
                            'Выберите действие: печать или поделиться',
                          ),
                        ],
                      ),
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

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.green,
            fontSize: 13,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: Colors.black87, fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _buildInstructionStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
