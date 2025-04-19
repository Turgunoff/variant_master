import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:variant_master/core/theme/app_colors.dart';
import 'package:variant_master/core/utils/snackbar_utils.dart';
import 'package:variant_master/features/admin/presentation/widgets/table_pagination_footer.dart';
import 'package:variant_master/features/auth/bloc/auth_bloc.dart';
import 'package:variant_master/features/teacher/domain/entities/subject_with_tests.dart';
import 'package:variant_master/features/teacher/domain/entities/test.dart';

class SubjectTestsScreen extends StatefulWidget {
  final SubjectWithTests subject;

  const SubjectTestsScreen({
    super.key,
    required this.subject,
  });

  @override
  State<SubjectTestsScreen> createState() => _SubjectTestsScreenState();
}

class _SubjectTestsScreenState extends State<SubjectTestsScreen> {
  // Tests list
  late List<Test> _tests;
  late List<Test> _filteredTests;

  // Pagination variables
  int _rowsPerPage = 10;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _tests = widget.subject.tests.where((test) => !test.isDeleted).toList();
    _filteredTests = List.from(_tests);
  }

  void _filterTests(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredTests = List.from(_tests);
      } else {
        _filteredTests = _tests
            .where((test) =>
                test.text.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      _currentPage = 0; // Reset to first page when filtering
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

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text(
              '${widget.subject.name} fani testlari',
              style: const TextStyle(
                color: Color(0xFF1F2937),
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(
              color: Color(0xFF1F2937),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Jami: ${_tests.length} ta test',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Add test logic
                        _showAddTestDialog(context);
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Test qo\'shish'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                        hintText: 'Test matnini qidirish...',
                        hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
                        prefixIcon:
                            Icon(Icons.search, color: Color(0xFF6B7280)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 14, horizontal: 16),
                      ),
                      style: const TextStyle(fontSize: 15),
                      onChanged: _filterTests,
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
                                flex: 5,
                                child: Text(
                                  'Test matni',
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
                                  'To\'g\'ri javob',
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
                                  'Amallar',
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
                          child: _filteredTests.isEmpty
                              ? const Center(
                                  child: Text('Ma\'lumot topilmadi'))
                              : ListView.builder(
                                  itemCount:
                                      _getPaginatedTests().length,
                                  itemBuilder: (context, index) {
                                    final test =
                                        _getPaginatedTests()[index];
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
                                          // Test matni
                                          Expanded(
                                            flex: 5,
                                            child: Text(
                                              test.text,
                                              style: const TextStyle(
                                                color: Color(0xFF1F2937),
                                                fontWeight:
                                                    FontWeight.w500,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          // To'g'ri javob
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              test.correctAnswer,
                                              style: const TextStyle(
                                                color: Colors.green,
                                                fontWeight:
                                                    FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          // Amallar
                                          Expanded(
                                            flex: 2,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                // Edit button
                                                InkWell(
                                                  onTap: () => _showEditTestDialog(test),
                                                  borderRadius:
                                                      BorderRadius
                                                          .circular(4),
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.all(
                                                            4.0),
                                                    child: Icon(
                                                      Icons.edit,
                                                      color: AppColors
                                                          .primary,
                                                      size: 18,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                // Delete button
                                                InkWell(
                                                  onTap: () => _showDeleteTestDialog(test),
                                                  borderRadius:
                                                      BorderRadius
                                                          .circular(4),
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.all(
                                                            4.0),
                                                    child: Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                      size: 18,
                                                    ),
                                                  ),
                                                ),
                                              ],
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
                          totalItems: _filteredTests.length,
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
        );
      },
    );
  }

  // Pagination helpers
  int get _startIndex => _currentPage * _rowsPerPage;
  int get _endIndex => (_startIndex + _rowsPerPage) > _filteredTests.length
      ? _filteredTests.length
      : _startIndex + _rowsPerPage;

  // Get paginated tests
  List<Test> _getPaginatedTests() {
    if (_filteredTests.isEmpty) return [];
    return _filteredTests.sublist(_startIndex, _endIndex);
  }

  // Show add test dialog
  void _showAddTestDialog(BuildContext context) {
    final textController = TextEditingController();
    final correctAnswerController = TextEditingController();
    final optionAController = TextEditingController();
    final optionBController = TextEditingController();
    final optionCController = TextEditingController();
    final optionDController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Test qo\'shish'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Test matni
              const Text(
                'Test matni',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: textController,
                decoration: const InputDecoration(
                  hintText: 'Test savolini kiriting',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              
              // Javob variantlari
              const Text(
                'Javob variantlari',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              
              // A variant
              Row(
                children: [
                  const Text('A: '),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: optionAController,
                      decoration: const InputDecoration(
                        hintText: 'A varianti',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // B variant
              Row(
                children: [
                  const Text('B: '),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: optionBController,
                      decoration: const InputDecoration(
                        hintText: 'B varianti',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // C variant
              Row(
                children: [
                  const Text('C: '),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: optionCController,
                      decoration: const InputDecoration(
                        hintText: 'C varianti',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // D variant
              Row(
                children: [
                  const Text('D: '),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: optionDController,
                      decoration: const InputDecoration(
                        hintText: 'D varianti',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // To'g'ri javob
              const Text(
                'To\'g\'ri javob',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                hint: const Text('To\'g\'ri javobni tanlang'),
                items: [
                  DropdownMenuItem(
                    value: 'Javob A',
                    child: Text(() {
                      if (optionAController.text.isEmpty) {
                        return 'Javob A';
                      }
                      return 'A: ${optionAController.text}';
                    }()),
                  ),
                  DropdownMenuItem(
                    value: 'Javob B',
                    child: Text(() {
                      if (optionBController.text.isEmpty) {
                        return 'Javob B';
                      }
                      return 'B: ${optionBController.text}';
                    }()),
                  ),
                  DropdownMenuItem(
                    value: 'Javob C',
                    child: Text(() {
                      if (optionCController.text.isEmpty) {
                        return 'Javob C';
                      }
                      return 'C: ${optionCController.text}';
                    }()),
                  ),
                  DropdownMenuItem(
                    value: 'Javob D',
                    child: Text(() {
                      if (optionDController.text.isEmpty) {
                        return 'Javob D';
                      }
                      return 'D: ${optionDController.text}';
                    }()),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    correctAnswerController.text = value;
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Bekor qilish'),
          ),
          ElevatedButton(
            onPressed: () {
              if (textController.text.isNotEmpty &&
                  correctAnswerController.text.isNotEmpty &&
                  optionAController.text.isNotEmpty &&
                  optionBController.text.isNotEmpty &&
                  optionCController.text.isNotEmpty &&
                  optionDController.text.isNotEmpty) {
                setState(() {
                  final newId = (_tests.isEmpty)
                      ? '1'
                      : '${int.parse(_tests.last.id) + 1}';

                  final options = [
                    'Javob A',
                    'Javob B',
                    'Javob C',
                    'Javob D',
                  ];

                  final newTest = Test(
                    id: newId,
                    text: textController.text,
                    correctAnswer: correctAnswerController.text,
                    options: options,
                  );

                  _tests.add(newTest);
                  _filteredTests = List.from(_tests);
                });

                Navigator.pop(context);
                SnackBarUtils.showSuccessSnackBar(
                  context,
                  'Test muvaffaqiyatli qo\'shildi',
                );
              } else {
                SnackBarUtils.showErrorSnackBar(
                  context,
                  'Barcha maydonlarni to\'ldiring',
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

  // Show edit test dialog
  void _showEditTestDialog(Test test) {
    final textController = TextEditingController(text: test.text);
    final correctAnswerController = TextEditingController(text: test.correctAnswer);
    final optionAController = TextEditingController(text: test.options[0]);
    final optionBController = TextEditingController(text: test.options[1]);
    final optionCController = TextEditingController(text: test.options[2]);
    final optionDController = TextEditingController(text: test.options[3]);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Testni tahrirlash'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Test matni
              const Text(
                'Test matni',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: textController,
                decoration: const InputDecoration(
                  hintText: 'Test savolini kiriting',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              
              // Javob variantlari
              const Text(
                'Javob variantlari',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              
              // A variant
              Row(
                children: [
                  const Text('A: '),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: optionAController,
                      decoration: const InputDecoration(
                        hintText: 'A varianti',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // B variant
              Row(
                children: [
                  const Text('B: '),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: optionBController,
                      decoration: const InputDecoration(
                        hintText: 'B varianti',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // C variant
              Row(
                children: [
                  const Text('C: '),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: optionCController,
                      decoration: const InputDecoration(
                        hintText: 'C varianti',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // D variant
              Row(
                children: [
                  const Text('D: '),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: optionDController,
                      decoration: const InputDecoration(
                        hintText: 'D varianti',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // To'g'ri javob
              const Text(
                'To\'g\'ri javob',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                value: test.correctAnswer,
                items: [
                  DropdownMenuItem(
                    value: 'Javob A',
                    child: Text(() {
                      if (optionAController.text.isEmpty) {
                        return 'Javob A';
                      }
                      return 'A: ${optionAController.text}';
                    }()),
                  ),
                  DropdownMenuItem(
                    value: 'Javob B',
                    child: Text(() {
                      if (optionBController.text.isEmpty) {
                        return 'Javob B';
                      }
                      return 'B: ${optionBController.text}';
                    }()),
                  ),
                  DropdownMenuItem(
                    value: 'Javob C',
                    child: Text(() {
                      if (optionCController.text.isEmpty) {
                        return 'Javob C';
                      }
                      return 'C: ${optionCController.text}';
                    }()),
                  ),
                  DropdownMenuItem(
                    value: 'Javob D',
                    child: Text(() {
                      if (optionDController.text.isEmpty) {
                        return 'Javob D';
                      }
                      return 'D: ${optionDController.text}';
                    }()),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    correctAnswerController.text = value;
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Bekor qilish'),
          ),
          ElevatedButton(
            onPressed: () {
              if (textController.text.isNotEmpty &&
                  correctAnswerController.text.isNotEmpty &&
                  optionAController.text.isNotEmpty &&
                  optionBController.text.isNotEmpty &&
                  optionCController.text.isNotEmpty &&
                  optionDController.text.isNotEmpty) {
                setState(() {
                  final options = [
                    optionAController.text,
                    optionBController.text,
                    optionCController.text,
                    optionDController.text,
                  ];

                  final index = _tests.indexWhere((t) => t.id == test.id);
                  if (index != -1) {
                    _tests[index] = test.copyWith(
                      text: textController.text,
                      correctAnswer: correctAnswerController.text,
                      options: options,
                    );
                    _filteredTests = List.from(_tests);
                  }
                });

                Navigator.pop(context);
                SnackBarUtils.showSuccessSnackBar(
                  context,
                  'Test muvaffaqiyatli yangilandi',
                );
              } else {
                SnackBarUtils.showErrorSnackBar(
                  context,
                  'Barcha maydonlarni to\'ldiring',
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

  // Show delete test dialog
  void _showDeleteTestDialog(Test test) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Testni o\'chirish'),
        content: Text('Siz rostdan ham "${test.text}" testini o\'chirmoqchimisiz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Bekor qilish'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final index = _tests.indexWhere((t) => t.id == test.id);
                if (index != -1) {
                  _tests[index] = test.copyWith(isDeleted: true);
                  _tests.removeWhere((t) => t.id == test.id);
                  _filteredTests = List.from(_tests);
                }
              });

              Navigator.pop(context);
              SnackBarUtils.showSuccessSnackBar(
                context,
                'Test muvaffaqiyatli o\'chirildi',
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('O\'chirish'),
          ),
        ],
      ),
    );
  }
}
