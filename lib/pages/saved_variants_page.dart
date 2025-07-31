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

  void _deleteVariant(VariantModel variant) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить вариант'),
        content: const Text(
          'Вы хотите удалить этот вариант? PDF файл также будет удален.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () async {
              try {
                // Удаление PDF файла
                final file = File(variant.pdfPath);
                if (await file.exists()) {
                  await file.delete();
                }

                // Удаление данных варианта
                await _dbHelper.deleteVariantTests(variant.id!);
                await _dbHelper.deleteVariant(variant.id!);

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
                    content: Text('Ошибка: $e'),
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

  void _openPDF(VariantModel variant) async {
    try {
      final file = File(variant.pdfPath);
      if (await file.exists()) {
        final bytes = await file.readAsBytes();
        await Printing.layoutPdf(onLayout: (format) async => bytes);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PDF файл не найден'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка при открытии PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _sharePDF(VariantModel variant) async {
    try {
      final file = File(variant.pdfPath);
      if (await file.exists()) {
        await Printing.sharePdf(
          bytes: await file.readAsBytes(),
          filename:
              'variant_${variant.subject}_${variant.createdAt.millisecondsSinceEpoch}.pdf',
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PDF файл не найден'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка при отправке PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showVariantDetails(VariantModel variant) async {
    final tests = await _dbHelper.getTestsForVariant(variant.id!);
    final testModels = tests.map((map) => TestModel.fromMap(map)).toList();

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
              Text('Количество тестов: ${testModels.length}'),
              const SizedBox(height: 16),
              if (testModels.isNotEmpty) ...[
                const Text(
                  'Список тестов:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...testModels.take(5).toList().asMap().entries.map((entry) {
                  final index = entry.key + 1;
                  final test = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      '$index. ${test.question.length > 50 ? test.question.substring(0, 50) + '...' : test.question}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  );
                }).toList(),
                if (testModels.length > 5)
                  Text(
                    '... и еще ${testModels.length - 5} тестов',
                    style: const TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_variants.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.picture_as_pdf_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Варианты не найдены',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _variants.length,
        itemBuilder: (context, index) {
          final variant = _variants[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.picture_as_pdf,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
              ),
              title: Text(
                variant.subject,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text('Тестов: ${variant.testIds.length}'),
                  Text('Дата: ${_formatDate(variant.createdAt)}'),
                  Text('Время: ${_formatTime(variant.createdAt)}'),
                ],
              ),
              trailing: PopupMenuButton(
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'open',
                    child: Row(
                      children: [
                        Icon(Icons.open_in_new),
                        SizedBox(width: 8),
                        Text('Открыть PDF'),
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
                        Text('Удалить', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  switch (value) {
                    case 'open':
                      _openPDF(variant);
                      break;
                    case 'share':
                      _sharePDF(variant);
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
              onTap: () => _openPDF(variant),
            ),
          );
        },
      ),
    );
  }
}
