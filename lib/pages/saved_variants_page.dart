import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'dart:io';
import '../models/variant_model.dart';
import '../models/test_model.dart';
import '../database/database_helper.dart';

class SavedVariantsPage extends StatefulWidget {
  const SavedVariantsPage({super.key});

  @override
  State<SavedVariantsPage> createState() => _SavedVariantsPageState();
}

class _SavedVariantsPageState extends State<SavedVariantsPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<VariantModel> _variants = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVariants();
  }

  Future<void> _loadVariants() async {
    setState(() => _isLoading = true);

    try {
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
      print('Ошибка загрузки вариантов: $e');
    }

    setState(() => _isLoading = false);
  }

  void _openVariant(VariantModel variant) {
    final file = File(variant.pdfPath);
    if (file.existsSync()) {
      Printing.layoutPdf(onLayout: (format) => file.readAsBytesSync());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Файл не найден'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _shareVariant(VariantModel variant) {
    final file = File(variant.pdfPath);
    if (file.existsSync()) {
      Printing.sharePdf(
        bytes: file.readAsBytesSync(),
        filename:
            'variant_${variant.subject}_${variant.createdAt.millisecondsSinceEpoch}.pdf',
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Файл не найден'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _deleteVariant(VariantModel variant) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить вариант'),
        content: const Text('Вы хотите удалить этот вариант?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () async {
              try {
                // Удаляем связи с тестами
                await _dbHelper.deleteVariantTests(variant.id!);
                // Удаляем вариант
                await _dbHelper.deleteVariant(variant.id!);
                // Удаляем файл
                final file = File(variant.pdfPath);
                if (file.existsSync()) {
                  await file.delete();
                }
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Вариант удален'),
                    backgroundColor: Colors.red,
                  ),
                );
                _loadVariants(); // Перезагружаем список
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

  void _showVariantDetails(VariantModel variant) async {
    try {
      final testMaps = await _dbHelper.getTestsForVariant(variant.id!);
      final tests = testMaps.map((map) => TestModel.fromMap(map)).toList();

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Детали варианта'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Предмет: ${variant.subject}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Дата создания: ${variant.createdAt.day}.${variant.createdAt.month}.${variant.createdAt.year}',
                ),
                const SizedBox(height: 8),
                Text('Количество вопросов: ${tests.length}'),
                const SizedBox(height: 8),
                Text('Путь к файлу: ${variant.pdfPath}'),
                const SizedBox(height: 16),
                const Text(
                  'Первые 5 вопросов:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...tests.take(5).toList().asMap().entries.map((entry) {
                  int index = entry.key;
                  TestModel test = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${index + 1}. ${test.question}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Правильный ответ: ${String.fromCharCode(65 + test.correctIndex)}',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                if (tests.length > 5)
                  Text(
                    '... и еще ${tests.length - 5} вопросов',
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка загрузки деталей: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: _variants.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.picture_as_pdf_outlined,
                      size: 40,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Сохраненные варианты не найдены',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Создайте варианты на странице "Создать вариант"',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _variants.length,
              itemBuilder: (context, index) {
                final variant = _variants[index];
                final file = File(variant.pdfPath);
                final fileExists = file.existsSync();

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: fileExists
                          ? Colors.green.shade200
                          : Colors.grey.shade200,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (fileExists ? Colors.green : Colors.grey)
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
                        // Заголовок с иконкой
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: (fileExists ? Colors.green : Colors.grey)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.picture_as_pdf,
                                color: fileExists ? Colors.green : Colors.grey,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    variant.subject,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Вариант теста',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Статус файла
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: fileExists
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                fileExists ? 'Доступен' : 'Не найден',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: fileExists ? Colors.green : Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Информация о варианте
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              _buildInfoItem(
                                Icons.calendar_today,
                                'Дата',
                                '${variant.createdAt.day}.${variant.createdAt.month}.${variant.createdAt.year}',
                                Colors.blue,
                              ),
                              const SizedBox(width: 16),
                              _buildInfoItem(
                                Icons.quiz,
                                'Вопросов',
                                '${variant.testIds.length}',
                                Colors.orange,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Кнопки действий
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (fileExists) ...[
                              _buildActionButton(
                                Icons.open_in_new,
                                'Открыть',
                                Colors.blue,
                                () => _openVariant(variant),
                              ),
                              const SizedBox(width: 8),
                              _buildActionButton(
                                Icons.share,
                                'Поделиться',
                                Colors.green,
                                () => _shareVariant(variant),
                              ),
                              const SizedBox(width: 8),
                            ],
                            _buildActionButton(
                              Icons.info_outline,
                              'Детали',
                              Colors.purple,
                              () => _showVariantDetails(variant),
                            ),
                            const SizedBox(width: 8),
                            _buildActionButton(
                              Icons.delete_outline,
                              'Удалить',
                              Colors.red,
                              () => _deleteVariant(variant),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildInfoItem(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Expanded(
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: color, size: 14),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    Color color,
    VoidCallback onPressed,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
