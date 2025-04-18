import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:variant_master/core/theme/app_colors.dart';
import 'package:variant_master/features/auth/bloc/auth_bloc.dart';
import 'package:variant_master/features/auth/domain/entities/user.dart';
import 'package:variant_master/features/admin/presentation/widgets/app_drawer.dart';
import 'package:variant_master/features/admin/domain/entities/subject.dart';

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({super.key});

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  // Pagination variables
  int _rowsPerPage = 10;
  int _currentPage = 0;

  // Mock data
  late List<Subject> _subjects;
  late List<Subject> _filteredSubjects;

  @override
  void initState() {
    super.initState();
    _subjects = _generateMockSubjects(30); // Generate 30 mock subjects
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
              const AppDrawer(currentRoute: '/subjects'),

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
                            'Fanlar',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              // Add subject logic
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Qo\'shish'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Search and filter
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Qidirish...',
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 0),
                              ),
                              onChanged: _filterSubjects,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              onPressed: () {
                                // Filter logic
                              },
                              icon: const Icon(Icons.filter_list),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Data Table with fixed header
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(20),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Table header
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                  ),
                                ),
                                child: const Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        'ID',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        'Fan nomi',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Testlar soni',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        'Mavzular',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        'Amallar',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

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
                                            decoration: BoxDecoration(
                                              color: index % 2 == 0
                                                  ? Colors.white
                                                  : const Color(0xFFF9FAFB),
                                              border: const Border(
                                                bottom: BorderSide(
                                                  color: Color(0xFFE5E7EB),
                                                  width: 1,
                                                ),
                                              ),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 14),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    subject.id,
                                                    style: const TextStyle(
                                                      color: Color(0xFF1F2937),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Text(
                                                    subject.name,
                                                    style: const TextStyle(
                                                      color: Color(0xFF1F2937),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    '${subject.testsCount}',
                                                    style: const TextStyle(
                                                      color: Color(0xFF1F2937),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        subject.topics.isEmpty
                                                            ? 'Mavzu qo\'shilmagan'
                                                            : '${subject.topicsCount} ta mavzu',
                                                        style: const TextStyle(
                                                          color:
                                                              Color(0xFF1F2937),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                      if (subject
                                                          .topics.isNotEmpty)
                                                        Text(
                                                          subject.topics
                                                              .join(', '),
                                                          style:
                                                              const TextStyle(
                                                            color: Color(
                                                                0xFF6B7280),
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      IconButton(
                                                        onPressed: () {
                                                          // Edit subject logic
                                                        },
                                                        icon: const Icon(
                                                          Icons.edit,
                                                          color:
                                                              AppColors.primary,
                                                          size: 20,
                                                        ),
                                                        tooltip: 'Tahrirlash',
                                                      ),
                                                      IconButton(
                                                        onPressed: () {
                                                          // Delete subject logic
                                                        },
                                                        icon: const Icon(
                                                          Icons.delete,
                                                          color: Colors.red,
                                                          size: 20,
                                                        ),
                                                        tooltip: 'O\'chirish',
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
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                                  border: Border(
                                    top: BorderSide(
                                      color: Color(0xFFE5E7EB),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${_startIndex + 1}-$_endIndex / ${_filteredSubjects.length}',
                                      style: const TextStyle(
                                          color: Color(0xFF6B7280)),
                                    ),
                                    Row(
                                      children: [
                                        // Rows per page dropdown
                                        Row(
                                          children: [
                                            const Text(
                                              'Qatorlar: ',
                                              style: TextStyle(
                                                  color: Color(0xFF6B7280)),
                                            ),
                                            DropdownButton<int>(
                                              value: _rowsPerPage,
                                              underline: Container(),
                                              items: [5, 10, 20, 50]
                                                  .map((count) =>
                                                      DropdownMenuItem<int>(
                                                        value: count,
                                                        child: Text('$count'),
                                                      ))
                                                  .toList(),
                                              onChanged: (value) {
                                                if (value != null) {
                                                  setState(() {
                                                    _rowsPerPage = value;
                                                    _currentPage =
                                                        0; // Reset to first page
                                                  });
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 16),
                                        // Pagination controls
                                        IconButton(
                                          icon: const Icon(Icons.first_page),
                                          onPressed: _currentPage > 0
                                              ? () => setState(
                                                  () => _currentPage = 0)
                                              : null,
                                          color: _currentPage > 0
                                              ? AppColors.primary
                                              : const Color(0xFFD1D5DB),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.chevron_left),
                                          onPressed: _currentPage > 0
                                              ? () =>
                                                  setState(() => _currentPage--)
                                              : null,
                                          color: _currentPage > 0
                                              ? AppColors.primary
                                              : const Color(0xFFD1D5DB),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.chevron_right),
                                          onPressed: _hasNextPage
                                              ? () =>
                                                  setState(() => _currentPage++)
                                              : null,
                                          color: _hasNextPage
                                              ? AppColors.primary
                                              : const Color(0xFFD1D5DB),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.last_page),
                                          onPressed: _hasNextPage
                                              ? () => setState(
                                                  () => _currentPage = _maxPage)
                                              : null,
                                          color: _hasNextPage
                                              ? AppColors.primary
                                              : const Color(0xFFD1D5DB),
                                        ),
                                      ],
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
  bool get _hasNextPage => _endIndex < _filteredSubjects.length;
  int get _maxPage => (_filteredSubjects.length / _rowsPerPage).ceil() - 1;

  // Get paginated subjects
  List<Subject> _getPaginatedSubjects() {
    if (_filteredSubjects.isEmpty) return [];
    return _filteredSubjects.sublist(_startIndex, _endIndex);
  }

  // Generate mock subjects
  List<Subject> _generateMockSubjects(int count) {
    final subjects = [
      'Matematika',
      'Fizika',
      'Ingliz tili',
      'Informatika',
      'Kimyo',
      'Biologiya',
      'Tarix',
      'Geografiya',
      'Adabiyot',
      'Ona tili',
    ];

    final allTopics = {
      'Matematika': [
        'Algebra',
        'Trigonometriya',
        'Geometriya',
        'Funksiyalar',
        'Statistika'
      ],
      'Fizika': [
        'Mexanika',
        'Elektr',
        'Optika',
        'Termodinamika',
        'Kvant fizikasi'
      ],
      'Ingliz tili': [
        'Grammar',
        'Vocabulary',
        'Reading',
        'Listening',
        'Speaking'
      ],
      'Informatika': [
        'Algoritm',
        'Dasturlash',
        'Ma\'lumotlar bazasi',
        'Tarmoqlar',
        'Web dasturlash'
      ],
      'Kimyo': [
        'Organik kimyo',
        'Anorganik kimyo',
        'Polimerlar',
        'Analitik kimyo',
        'Biokimyo'
      ],
      'Biologiya': [
        'Botanika',
        'Zoologiya',
        'Anatomiya',
        'Genetika',
        'Ekologiya'
      ],
      'Tarix': [
        'Qadimgi dunyo',
        'O\'rta asrlar',
        'Yangi davr',
        'Eng yangi davr',
        'Mahalliy tarix'
      ],
      'Geografiya': [
        'Tabiiy geografiya',
        'Iqtisodiy geografiya',
        'Demografiya',
        'Kartografiya',
        'Ekologiya'
      ],
      'Adabiyot': [
        'Mumtoz adabiyot',
        'Zamonaviy adabiyot',
        'Jahon adabiyoti',
        'She\'riyat',
        'Nasr'
      ],
      'Ona tili': [
        'Fonetika',
        'Leksikologiya',
        'Morfologiya',
        'Sintaksis',
        'Uslubiyat'
      ],
    };

    return List.generate(count, (index) {
      final subjectName = subjects[index % subjects.length];
      final subjectTopics = allTopics[subjectName] ?? [];

      // Generate different numbers of topics for variety
      List<String> selectedTopics = [];

      // Some subjects will have 0 topics
      if (index % 7 == 0) {
        // No topics
        selectedTopics = [];
      } else {
        // 1-3 topics
        final topicsCount = (index % 3) + 1;
        selectedTopics = subjectTopics.take(topicsCount).toList();
      }

      return Subject(
        id: '${index + 1}',
        name: subjectName,
        testsCount: (index + 1) * 5,
        topics: selectedTopics,
      );
    });
  }
}
