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
      Printing.layoutPdf(
        onLayout: (format) => file.readAsBytesSync(),
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

  void _shareVariant(VariantModel variant) {
    final file = File(variant.pdfPath);
    if (file.existsSync()) {
      Printing.sharePdf(
        bytes: file.readAsBytesSync(),
        filename: 'variant_${variant.subject}_${variant.createdAt.millisecondsSinceEpoch}.pdf',
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
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: _variants.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.picture_as_pdf_outlined,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Сохраненные варианты не найдены',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Создайте варианты на странице "Создать вариант"',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _variants.length,
              itemBuilder: (context, index) {
                final variant = _variants[index];
                final file = File(variant.pdfPath);
                final fileExists = file.existsSync();

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Icon(
                      Icons.picture_as_pdf,
                      color: fileExists ? Colors.green : Colors.grey,
                    ),
                    title: Text(
                      'Предмет: ${variant.subject}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Дата: ${variant.createdAt.day}.${variant.createdAt.month}.${variant.createdAt.year}',
                        ),
                        Text(
                          'Вопросов: ${variant.testIds.length}',
                        ),
                        if (!fileExists)
                          const Text(
                            'Файл не найден',
                            style: TextStyle(color: Colors.red),
                          ),
                      ],
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        if (fileExists) ...[
                          const PopupMenuItem(
                            value: 'open',
                            child: Row(
                              children: [
                                Icon(Icons.open_in_new),
                                SizedBox(width: 8),
                                Text('Открыть'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'share',
                            child: Row(
                              children: [
                                Icon(Icons.share),
                                SizedBox(width: 8),
                                Text('Поделиться'),
                              ],
                            ),
                          ),
                        ],
                        const PopupMenuItem(
                          value: 'details',
                          child: Row(
                            children: [
                              Icon(Icons.info),
                              SizedBox(width: 8),
                              Text('Детали'),
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
                        switch (value) {
                          case 'open':
                            _openVariant(variant);
                            break;
                          case 'share':
                            _shareVariant(variant);
                            break;
                          case 'details':
                            _showVariantDetails(variant);
                            break;
                          case 'delete':
                            _deleteVariant(variant);
                            break;
                        }
                      },
                    ),
                    onTap: () => _showVariantDetails(variant),
                  ),
                );
              },
            ),
    );
  }
}
