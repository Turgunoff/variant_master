import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:variant_master/core/theme/app_colors.dart';
import 'package:variant_master/core/utils/snackbar_utils.dart';
import 'package:variant_master/features/admin/presentation/widgets/app_drawer.dart';
import 'package:variant_master/features/admin/presentation/widgets/table_pagination_footer.dart';
import 'package:variant_master/features/auth/bloc/auth_bloc.dart';
import 'package:variant_master/features/teacher/domain/entities/subject_with_tests.dart';
import 'package:variant_master/features/teacher/domain/entities/test.dart';
import 'package:variant_master/features/teacher/presentation/screens/subject_tests_screen.dart';

class TestsScreen extends StatefulWidget {
  const TestsScreen({super.key});

  @override
  State<TestsScreen> createState() => _TestsScreenState();
}

class _TestsScreenState extends State<TestsScreen> {
  // Mock data
  late List<SubjectWithTests> _subjects;
  late List<SubjectWithTests> _filteredSubjects;

  // Pagination variables
  int _rowsPerPage = 10;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _subjects = _generateMockSubjects(15); // Generate 15 mock subjects
    _filteredSubjects = List.from(_subjects);
  }

  void _filterSubjects(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredSubjects = List.from(_subjects);
      } else {
        _filteredSubjects = _subjects
            .where((subject) =>
                subject.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      _currentPage = 0; // Reset to first page when filtering
    });
  }

  void _navigateToSubjectTests(BuildContext context, SubjectWithTests subject) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubjectTestsScreen(subject: subject),
      ),
    );
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

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Row(
            children: [
              // Left drawer
              const AppDrawer(currentRoute: '/tests'),

              // Main content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Fanlar va testlar',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              // Add subject logic
                              _showAddSubjectDialog(context);
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Fan qo\'shish'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Modern search
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 8),
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(13),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: 'Fan nomini qidirish...',
                              hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
                              prefixIcon:
                                  Icon(Icons.search, color: Color(0xFF6B7280)),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 16),
                            ),
                            style: const TextStyle(fontSize: 15),
                            onChanged: _filterSubjects,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Data Table with fixed header
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(13),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Table header
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withAlpha(13),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: AppColors.primary.withAlpha(25)),
                                ),
                                child: const Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        '#',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1F2937),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        'Fan nomi',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1F2937),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Testlar',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1F2937),
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Table content with scrolling
                              Expanded(
                                child: _filteredSubjects.isEmpty
                                    ? const Center(
                                        child: Text('Ma\'lumot topilmadi'))
                                    : ListView.builder(
                                        itemCount:
                                            _getPaginatedSubjects().length,
                                        itemBuilder: (context, index) {
                                          final subject =
                                              _getPaginatedSubjects()[index];
                                          return Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 8),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 16),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  color:
                                                      const Color(0xFFE5E7EB)),
                                            ),
                                            child: Row(
                                              children: [
                                                // #
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    '${_startIndex + index + 1}',
                                                    style: const TextStyle(
                                                      color: Color(0xFF1F2937),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                // Fan nomi
                                                Expanded(
                                                  flex: 4,
                                                  child: Text(
                                                    subject.name,
                                                    style: const TextStyle(
                                                      color: Color(0xFF1F2937),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                // Testlar soni
                                                Expanded(
                                                  flex: 2,
                                                  child: Center(
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        _navigateToSubjectTests(
                                                            context, subject);
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            AppColors.primary,
                                                        foregroundColor:
                                                            Colors.white,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 12,
                                                                vertical: 8),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        '${subject.testsCount} ta test',
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                              ),

                              // Pagination footer
                              TablePaginationFooter(
                                currentPage: _currentPage,
                                totalItems: _filteredSubjects.length,
                                rowsPerPage: _rowsPerPage,
                                onPageChanged: (page) {
                                  setState(() {
                                    _currentPage = page;
                                  });
                                },
                                onRowsPerPageChanged: (value) {
                                  setState(() {
                                    _rowsPerPage = value;
                                    _currentPage = 0; // Reset to first page
                                  });
                                },
                              ),
                            ],
                          ),
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

  // Pagination helpers
  int get _startIndex => _currentPage * _rowsPerPage;
  int get _endIndex => (_startIndex + _rowsPerPage) > _filteredSubjects.length
      ? _filteredSubjects.length
      : _startIndex + _rowsPerPage;

  // Get paginated subjects
  List<SubjectWithTests> _getPaginatedSubjects() {
    if (_filteredSubjects.isEmpty) return [];
    return _filteredSubjects.sublist(_startIndex, _endIndex);
  }

  // Generate mock subjects with tests
  List<SubjectWithTests> _generateMockSubjects(int count) {
    final subjectNames = [
      'Matematika',
      'Fizika',
      'Kimyo',
      'Biologiya',
      'Tarix',
      'Geografiya',
      'Adabiyot',
      'Ingliz tili',
      'Informatika',
      'Ona tili',
      'Rus tili',
      'Chizmachilik',
      'Jismoniy tarbiya',
      'Astronomiya',
      'Iqtisodiyot',
    ];

    return List.generate(count, (index) {
      final name = subjectNames[index % subjectNames.length];
      final testsCount = 5 + (index % 20); // 5-24 ta test

      return SubjectWithTests(
        id: '${index + 1}',
        name: name,
        tests: _generateMockTests(testsCount, name),
      );
    });
  }

  // Generate mock tests for a subject
  List<Test> _generateMockTests(int count, String subjectName) {
    return List.generate(count, (index) {
      final options = [
        'Javob A',
        'Javob B',
        'Javob C',
        'Javob D',
      ];
      final correctIndex = index % 4;

      return Test(
        id: '${index + 1}',
        text:
            '$subjectName bo\'yicha test savoli ${index + 1}. Bu yerda test matni bo\'ladi.',
        correctAnswer: options[correctIndex],
        options: options,
      );
    });
  }

  // Show add subject dialog
  void _showAddSubjectDialog(BuildContext context) {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Fan qo\'shish'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Fan nomi',
                hintText: 'Masalan: Matematika',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Bekor qilish'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                setState(() {
                  final newId = (_subjects.isEmpty)
                      ? '1'
                      : '${int.parse(_subjects.last.id) + 1}';

                  final newSubject = SubjectWithTests(
                    id: newId,
                    name: nameController.text,
                    tests: [],
                  );

                  _subjects.add(newSubject);
                  _filteredSubjects = List.from(_subjects);
                });

                Navigator.pop(context);
                SnackBarUtils.showSuccessSnackBar(
                  context,
                  '${nameController.text} fani muvaffaqiyatli qo\'shildi',
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text('Saqlash'),
          ),
        ],
      ),
    );
  }
}
