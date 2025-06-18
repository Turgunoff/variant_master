import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:math';
import '../models/test_model.dart';
import '../models/variant_model.dart';

class CreateVariantPage extends StatefulWidget {
  const CreateVariantPage({super.key});

  @override
  State<CreateVariantPage> createState() => _CreateVariantPageState();
}

class _CreateVariantPageState extends State<CreateVariantPage> {
  String? _selectedSubject;
  bool _isGenerating = false;
  List<TestModel>? _selectedTests;

  List<String> get _subjects {
    final box = Hive.box<TestModel>('tests');
    return box.values.map((e) => e.subject).toSet().toList();
  }

  List<TestModel> _getTestsBySubject(String subject) {
    final box = Hive.box<TestModel>('tests');
    return box.values.where((test) => test.subject == subject).toList();
  }

  void _generateVariant() {
    if (_selectedSubject == null) return;
    final availableTests = _getTestsBySubject(_selectedSubject!);
    if (availableTests.length < 30) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Tanlangan yo\'nalishda kamida 30 ta test bo\'lishi kerak!',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    setState(() => _isGenerating = true);
    Future.delayed(const Duration(milliseconds: 500), () {
      final random = Random();
      final shuffled = List<TestModel>.from(availableTests)..shuffle(random);
      setState(() {
        _selectedTests = shuffled.take(30).toList();
        _isGenerating = false;
      });
    });
  }

  Future<void> _generatePDF() async {
    if (_selectedTests == null) return;
    setState(() => _isGenerating = true);
    try {
      final pdf = pw.Document();
      final variantNumber = Random().nextInt(9999) + 1;
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              pw.Center(
                child: pw.Text(
                  'TEST VARIANTI',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Center(
                child: pw.Text(
                  'Yo\'nalish: $_selectedSubject',
                  style: pw.TextStyle(fontSize: 14),
                ),
              ),
              pw.Center(
                child: pw.Text(
                  'Variant raqami: $variantNumber',
                  style: pw.TextStyle(fontSize: 14),
                ),
              ),
              pw.SizedBox(height: 20),
              ..._selectedTests!.asMap().entries.map((entry) {
                final idx = entry.key + 1;
                final test = entry.value;
                return pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 12),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        '$idx. ${test.question}',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                      pw.SizedBox(height: 4),
                      ...test.answers.asMap().entries.map((ans) {
                        final letter = String.fromCharCode(65 + ans.key);
                        return pw.Text(
                          '$letter) ${ans.value}',
                          style: const pw.TextStyle(fontSize: 11),
                        );
                      }),
                    ],
                  ),
                );
              }),
              pw.SizedBox(height: 24),
              pw.Text(
                'JAVOBLAR KALITI',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  ..._selectedTests!.asMap().entries.map((entry) {
                    final idx = entry.key + 1;
                    final correct = String.fromCharCode(
                      65 + entry.value.correctIndex,
                    );
                    return pw.Text(
                      '$idx: $correct',
                      style: const pw.TextStyle(fontSize: 12),
                    );
                  }),
                ],
              ),
            ];
          },
        ),
      );
      final dir = await getApplicationDocumentsDirectory();
      final file = File(
        '${dir.path}/variant_${variantNumber}_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
      await file.writeAsBytes(await pdf.save());
      // Saqlash uchun variant modelini yaratish
      final variant = VariantModel(
        testIds: _selectedTests!.map((t) => t.key as int).toList(),
        subject: _selectedSubject!,
        createdAt: DateTime.now(),
        pdfPath: file.path,
      );
      final variantBox = Hive.box<VariantModel>('variants');
      await variantBox.add(variant);
      setState(() => _isGenerating = false);
      await Printing.layoutPdf(onLayout: (format) async => pdf.save());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PDF muvaffaqiyatli yaratildi va saqlandi!'),
          backgroundColor: Colors.green,
        ),
      );
      // Sahifani to'liq yangilash (reset)
      setState(() {
        _selectedSubject = null;
        _selectedTests = null;
        _isGenerating = false;
      });
    } catch (e) {
      setState(() => _isGenerating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Xatolik: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Variant yaratish',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedSubject,
              items: _subjects
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) => setState(() {
                _selectedSubject = v;
                _selectedTests = null;
              }),
              decoration: const InputDecoration(
                labelText: 'Yo\'nalishni tanlang',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: (_selectedSubject != null && !_isGenerating)
                  ? _generateVariant
                  : null,
              icon: const Icon(Icons.shuffle),
              label: _isGenerating
                  ? const Text('Yaratilmoqda...')
                  : const Text('30 ta random test tanlash'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
            ),
            const SizedBox(height: 24),
            if (_selectedTests != null) ...[
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Variant tayyor!',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('Fan: $_selectedSubject'),
                      Text('Testlar soni: ${_selectedTests?.length ?? 0}'),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: _isGenerating ? null : _generatePDF,
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text('PDF yaratish va saqlash'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.07),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Variant yaratish uchun kamida 30 ta test kerak. PDF faylni yuklab olish va baham ko‘rish mumkin.',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
