import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:variant_master/core/theme/app_colors.dart';
import 'package:variant_master/core/utils/snackbar_utils.dart';
import 'package:variant_master/features/admin/domain/entities/direction.dart';
import 'package:variant_master/features/admin/domain/entities/subject.dart';
import 'package:variant_master/features/admin/domain/entities/variant.dart';
import 'package:variant_master/features/admin/presentation/widgets/app_drawer.dart';
import 'package:variant_master/features/auth/bloc/auth_bloc.dart';
import 'package:variant_master/features/auth/domain/entities/user.dart';

class CreateVariantScreen extends StatefulWidget {
  const CreateVariantScreen({super.key});

  @override
  State<CreateVariantScreen> createState() => _CreateVariantScreenState();
}

class _CreateVariantScreenState extends State<CreateVariantScreen> {
  // Form key
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _variantNameController = TextEditingController();
  final _testsPerSubjectController = TextEditingController(text: '30');

  // Selected values
  String? _selectedDirectionId;
  List<String> _selectedSubjectIds = [];
  List<String> _selectedSubjectNames = [];
  String _exportFormat = 'PDF';
  bool _isNewPage = true;

  // Mock data
  late List<Direction> _directions;
  late List<Subject> _subjects;

  @override
  void initState() {
    super.initState();
    _directions = _generateMockDirections();
    _subjects = _generateMockSubjects();
  }

  @override
  void dispose() {
    _variantNameController.dispose();
    _testsPerSubjectController.dispose();
    super.dispose();
  }

  // Get subjects for selected direction
  List<Subject> _getSubjectsForDirection(String? directionId) {
    if (directionId == null) return [];

    final direction = _directions.firstWhere(
      (d) => d.id == directionId,
      orElse: () => const Direction(
        id: '',
        name: '',
        code: '',
        subjects: [],
      ),
    );

    return _subjects
        .where((subject) => direction.subjects.contains(subject.id))
        .toList();
  }

  // Create variant
  void _createVariant() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedDirectionId == null) {
        SnackBarUtils.showErrorSnackBar(
          context,
          'Yo\'nalishni tanlang',
        );
        return;
      }

      if (_selectedSubjectIds.isEmpty) {
        SnackBarUtils.showErrorSnackBar(
          context,
          'Kamida bitta fanni tanlang',
        );
        return;
      }

      // Get direction name
      final directionName = _directions
          .firstWhere((d) => d.id == _selectedDirectionId)
          .name;

      // Create variant
      final variant = Variant(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _variantNameController.text,
        directionId: _selectedDirectionId!,
        directionName: directionName,
        subjectIds: _selectedSubjectIds,
        subjectNames: _selectedSubjectNames,
        testsPerSubject: int.parse(_testsPerSubjectController.text),
        isNewPage: _isNewPage,
        exportFormat: _exportFormat,
      );

      // Show success message
      SnackBarUtils.showSuccessSnackBar(
        context,
        'Variant muvaffaqiyatli yaratildi',
      );

      // Reset form
      _resetForm();
    }
  }

  // Reset form
  void _resetForm() {
    setState(() {
      _variantNameController.clear();
      _testsPerSubjectController.text = '30';
      _selectedDirectionId = null;
      _selectedSubjectIds = [];
      _selectedSubjectNames = [];
      _exportFormat = 'PDF';
      _isNewPage = true;
      _formKey.currentState?.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! AuthAuthenticated) {
          return const Scaffold(
            body: Center(
              child: Text('User not authenticated'),
            ),
          );
        }

        final user = state.user;
        if (user.role != UserRole.admin) {
          return const Scaffold(
            body: Center(
              child: Text('Access denied'),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Row(
            children: [
              // Left drawer
              const AppDrawer(currentRoute: '/create-variant'),

              // Main content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      const Text(
                        'Variant yaratish',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Content
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left panel - Variant parameters
                            Expanded(
                              child: Card(
                                elevation: 0,
                                margin: const EdgeInsets.only(right: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Section title
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: AppColors.primary.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: const Icon(
                                                Icons.settings,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            const Text(
                                              'Variant parametrlarini tanlash',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF1F2937),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 24),

                                        // Variant parameters
                                        const Text(
                                          'Variant parametrlari',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF1F2937),
                                          ),
                                        ),
                                        const SizedBox(height: 16),

                                        // Yo'nalish
                                        const Text(
                                          'Yo\'nalish',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF1F2937),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        DropdownButtonFormField<String>(
                                          value: _selectedDirectionId,
                                          decoration: InputDecoration(
                                            hintText: 'Yo\'nalishni tanlang',
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              borderSide: const BorderSide(color: AppColors.primary, width: 2),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                          ),
                                          items: _directions.map((direction) {
                                            return DropdownMenuItem<String>(
                                              value: direction.id,
                                              child: Text('${direction.code}-${direction.name}'),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedDirectionId = value;
                                              // Reset selected subjects when direction changes
                                              _selectedSubjectIds = [];
                                              _selectedSubjectNames = [];
                                            });
                                          },
                                        ),
                                        const SizedBox(height: 16),

                                        // Fanlar
                                        const Text(
                                          'Fanlar',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF1F2937),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(color: const Color(0xFFE5E7EB)),
                                            borderRadius: BorderRadius.circular(8),
                                            color: Colors.white,
                                          ),
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // Selected subjects
                                              if (_selectedSubjectNames.isNotEmpty) ...[
                                                Wrap(
                                                  spacing: 8,
                                                  runSpacing: 8,
                                                  children: _selectedSubjectNames.map((subject) {
                                                    return Chip(
                                                      label: Text(subject),
                                                      deleteIcon: const Icon(Icons.close, size: 16),
                                                      onDeleted: () {
                                                        setState(() {
                                                          final index = _selectedSubjectNames.indexOf(subject);
                                                          if (index != -1) {
                                                            _selectedSubjectNames.removeAt(index);
                                                            _selectedSubjectIds.removeAt(index);
                                                          }
                                                        });
                                                      },
                                                      backgroundColor: AppColors.primary.withOpacity(0.1),
                                                      labelStyle: const TextStyle(color: AppColors.primary),
                                                      deleteIconColor: AppColors.primary,
                                                    );
                                                  }).toList(),
                                                ),
                                                const SizedBox(height: 8),
                                                const Divider(),
                                                const SizedBox(height: 8),
                                              ],

                                              // Available subjects
                                              if (_selectedDirectionId != null) ...[
                                                for (final subject in _getSubjectsForDirection(_selectedDirectionId))
                                                  if (!_selectedSubjectIds.contains(subject.id))
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          _selectedSubjectIds.add(subject.id);
                                                          _selectedSubjectNames.add(subject.name);
                                                        });
                                                      },
                                                      borderRadius: BorderRadius.circular(4),
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(vertical: 8),
                                                        child: Row(
                                                          children: [
                                                            const Icon(Icons.add, size: 16, color: AppColors.primary),
                                                            const SizedBox(width: 8),
                                                            Text(
                                                              subject.name,
                                                              style: const TextStyle(
                                                                color: Color(0xFF1F2937),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                              ] else
                                                const Text(
                                                  'Avval yo\'nalishni tanlang',
                                                  style: TextStyle(
                                                    color: Color(0xFF6B7280),
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 16),

                                        // Variant soni
                                        const Text(
                                          'Variant soni',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF1F2937),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        TextFormField(
                                          controller: _variantNameController,
                                          decoration: InputDecoration(
                                            hintText: 'Variant (N)',
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              borderSide: const BorderSide(color: AppColors.primary, width: 2),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Variant nomini kiriting';
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Right panel - Variant generation
                            Expanded(
                              child: Card(
                                elevation: 0,
                                margin: const EdgeInsets.only(left: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Section title
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: AppColors.primary.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: const Icon(
                                              Icons.generating_tokens,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          const Text(
                                            'Variant Generatsiyasi',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1F2937),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 24),

                                      // Variantdagi Test Soni
                                      const Text(
                                        'Variantdagi Test Soni',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF1F2937),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        controller: _testsPerSubjectController,
                                        decoration: InputDecoration(
                                          hintText: '30',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: const BorderSide(color: AppColors.primary, width: 2),
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                        ),
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                        ],
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Test sonini kiriting';
                                          }
                                          final number = int.tryParse(value);
                                          if (number == null || number <= 0) {
                                            return 'Noto\'g\'ri qiymat';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 16),

                                      // Eksport Formati
                                      const Text(
                                        'Eksport Formati',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF1F2937),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      DropdownButtonFormField<String>(
                                        value: _exportFormat,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: const BorderSide(color: AppColors.primary, width: 2),
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                        ),
                                        items: const [
                                          DropdownMenuItem(value: 'PDF', child: Text('PDF')),
                                          DropdownMenuItem(value: 'DOCX', child: Text('DOCX')),
                                          DropdownMenuItem(value: 'TXT', child: Text('TXT')),
                                        ],
                                        onChanged: (value) {
                                          if (value != null) {
                                            setState(() {
                                              _exportFormat = value;
                                            });
                                          }
                                        },
                                      ),
                                      const SizedBox(height: 16),

                                      // Variant Nomlash
                                      const Text(
                                        'Variant Nomlash',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF1F2937),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        initialValue: 'Variant (N)',
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: const BorderSide(color: AppColors.primary, width: 2),
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                        ),
                                        enabled: false,
                                      ),
                                      const SizedBox(height: 16),

                                      // Har Variant Yangi Sahifadan
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: _isNewPage,
                                            onChanged: (value) {
                                              setState(() {
                                                _isNewPage = value ?? true;
                                              });
                                            },
                                            activeColor: AppColors.primary,
                                          ),
                                          const Text(
                                            'Har Variant Yangi Sahifadan',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF1F2937),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 32),

                                      // Generate button
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: _createVariant,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.primary,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(vertical: 16),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text(
                                            'Test variantlarini yaratish va yuklab olish',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
            ],
          ),
        );
      },
    );
  }

  // Generate mock directions
  List<Direction> _generateMockDirections() {
    return [
      const Direction(
        id: '1',
        name: 'Axborot tizimlari',
        code: '902343',
        subjects: ['1', '2', '3', '4'],
      ),
      const Direction(
        id: '2',
        name: 'Dasturiy injiniring',
        code: '902344',
        subjects: ['1', '2', '5', '6'],
      ),
      const Direction(
        id: '3',
        name: 'Kompyuter injiniringi',
        code: '902345',
        subjects: ['1', '2', '4', '7'],
      ),
      const Direction(
        id: '4',
        name: 'Sun\'iy intellekt',
        code: '902346',
        subjects: ['1', '2', '3', '8'],
      ),
      const Direction(
        id: '5',
        name: 'Telekommunikatsiya',
        code: '902347',
        subjects: ['1', '2', '9', '10'],
      ),
    ];
  }

  // Generate mock subjects
  List<Subject> _generateMockSubjects() {
    return [
      const Subject(
        id: '1',
        name: 'Matematika',
        testsCount: 150,
        topics: ['Algebra', 'Geometriya', 'Trigonometriya'],
      ),
      const Subject(
        id: '2',
        name: 'Fizika',
        testsCount: 120,
        topics: ['Mexanika', 'Elektr', 'Optika'],
      ),
      const Subject(
        id: '3',
        name: 'Ingliz tili',
        testsCount: 100,
        topics: ['Grammar', 'Vocabulary', 'Reading'],
      ),
      const Subject(
        id: '4',
        name: 'Informatika',
        testsCount: 80,
        topics: ['Algoritmlar', 'Dasturlash', 'Ma\'lumotlar bazasi'],
      ),
      const Subject(
        id: '5',
        name: 'Kimyo',
        testsCount: 90,
        topics: ['Organik kimyo', 'Anorganik kimyo'],
      ),
      const Subject(
        id: '6',
        name: 'Biologiya',
        testsCount: 85,
        topics: ['Botanika', 'Zoologiya', 'Anatomiya'],
      ),
      const Subject(
        id: '7',
        name: 'Tarix',
        testsCount: 70,
        topics: ['Jahon tarixi', 'O\'zbekiston tarixi'],
      ),
      const Subject(
        id: '8',
        name: 'Geografiya',
        testsCount: 65,
        topics: ['Fizik geografiya', 'Iqtisodiy geografiya'],
      ),
      const Subject(
        id: '9',
        name: 'Adabiyot',
        testsCount: 60,
        topics: ['Jahon adabiyoti', 'O\'zbek adabiyoti'],
      ),
      const Subject(
        id: '10',
        name: 'Ona tili',
        testsCount: 75,
        topics: ['Morfologiya', 'Sintaksis', 'Leksikologiya'],
      ),
    ];
  }
}
