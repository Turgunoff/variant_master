import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:printing/printing.dart';
import 'dart:io';
import '../models/variant_model.dart';
import '../models/test_model.dart';

class SavedVariantsPage extends StatefulWidget {
  const SavedVariantsPage({super.key});

  @override
  State<SavedVariantsPage> createState() => _SavedVariantsPageState();
}

class _SavedVariantsPageState extends State<SavedVariantsPage> {
  void _deleteVariant(VariantModel variant) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Variantni o\'chirish'),
        content: const Text(
          'Ushbu variantni o\'chirishni xohlaysizmi? PDF fayl ham o\'chiriladi.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Bekor qilish'),
          ),
          TextButton(
            onPressed: () async {
              try {
                // PDF faylni o'chirish
                final file = File(variant.pdfPath);
                if (await file.exists()) {
                  await file.delete();
                }

                // Variant ma'lumotlarini o'chirish
                await variant.delete();

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Variant o\'chirildi'),
                    backgroundColor: Colors.red,
                  ),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Xatolik: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
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

  void _openPDF(VariantModel variant) async {
    try {
      final file = File(variant.pdfPath);
      if (await file.exists()) {
        final bytes = await file.readAsBytes();
        await Printing.layoutPdf(onLayout: (format) async => bytes);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PDF fayl topilmadi'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF ochishda xatolik: $e'),
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
            content: Text('PDF fayl topilmadi'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF baham ko\'rishda xatolik: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showVariantDetails(VariantModel variant) {
    final testBox = Hive.box<TestModel>('tests');
    final tests = variant.testIds
        .map((id) => testBox.get(id))
        .where((test) => test != null)
        .cast<TestModel>()
        .toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Variant tafsilotlari'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Yo\'nalish: ${variant.subject}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Yaratilgan sana: ${variant.createdAt.day}.${variant.createdAt.month}.${variant.createdAt.year}',
              ),
              const SizedBox(height: 8),
              Text('Testlar soni: ${tests.length} ta'),
              const SizedBox(height: 16),
              if (tests.isNotEmpty) ...[
                const Text(
                  'Testlar ro\'yxati:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...tests.take(5).toList().asMap().entries.map((entry) {
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
                if (tests.length > 5)
                  Text(
                    '... va yana ${tests.length - 5} ta test',
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
            child: const Text('Yopish'),
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
    final box = Hive.box<VariantModel>('variants');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saqlangan variantlar'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<VariantModel> box, _) {
          if (box.isEmpty) {
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
                    'Hech qanday variant topilmadi',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/create_variant'),
                    icon: const Icon(Icons.add),
                    label: const Text('Yangi variant yaratish'),
                  ),
                ],
              ),
            );
          }

          final variants = box.values.toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: variants.length,
            itemBuilder: (context, index) {
              final variant = variants[index];

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
                      Text('Testlar: ${variant.testIds.length} ta'),
                      Text('Sana: ${_formatDate(variant.createdAt)}'),
                      Text('Vaqt: ${_formatTime(variant.createdAt)}'),
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
                            Text('PDF ochish'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'share',
                        child: Row(
                          children: [
                            Icon(Icons.share),
                            SizedBox(width: 8),
                            Text('Baham ko\'rish'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'details',
                        child: Row(
                          children: [
                            Icon(Icons.info),
                            SizedBox(width: 8),
                            Text('Tafsilotlar'),
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
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/create_variant'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
