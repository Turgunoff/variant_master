import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:variant_master/core/theme/app_colors.dart';
import 'package:variant_master/core/utils/snackbar_utils.dart';
import 'package:variant_master/features/auth/bloc/auth_bloc.dart';
import 'package:variant_master/features/auth/domain/entities/user.dart';
import 'package:variant_master/features/admin/presentation/widgets/app_drawer.dart';
import 'package:variant_master/features/admin/domain/entities/teacher.dart';
import 'package:variant_master/features/admin/presentation/widgets/teacher_dialogs.dart';

class TeachersScreen extends StatefulWidget {
  const TeachersScreen({super.key});

  @override
  State<TeachersScreen> createState() => _TeachersScreenState();
}

class _TeachersScreenState extends State<TeachersScreen> {
  // Pagination variables
  int _rowsPerPage = 10;
  int _currentPage = 0;

  // Mock data
  late List<Teacher> _teachers;
  late List<Teacher> _filteredTeachers;

  @override
  void initState() {
    super.initState();
    _teachers = _generateMockTeachers(30); // Generate 30 mock teachers
    _filteredTeachers = List.from(_teachers);
  }

  void _filterTeachers(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredTeachers = List.from(_teachers);
      } else {
        _filteredTeachers = _teachers
            .where((teacher) =>
                teacher.fullName.toLowerCase().contains(query.toLowerCase()) ||
                teacher.username.toLowerCase().contains(query.toLowerCase()))
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
        if (user.role != UserRole.admin && user.role != UserRole.moderator) {
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
              const AppDrawer(currentRoute: '/teachers'),

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
                            'O\'qituvchilar',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: _showAddTeacherDialog,
                            icon: const Icon(Icons.add),
                            label: const Text('O\'qituvchi qo\'shish'),
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
                              hintText: 'O\'qituvchi nomini qidirish...',
                              hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
                              prefixIcon:
                                  Icon(Icons.search, color: Color(0xFF6B7280)),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 16),
                            ),
                            style: const TextStyle(fontSize: 15),
                            onChanged: _filterTeachers,
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
                                      flex: 3,
                                      child: Text(
                                        'F.I.SH',
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
                                        'Username',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1F2937),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        'Fanlar',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1F2937),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        'Testlar soni',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1F2937),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        'Holati',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1F2937),
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
                                child: _filteredTeachers.isEmpty
                                    ? const Center(
                                        child: Text('Ma\'lumot topilmadi'))
                                    : ListView.builder(
                                        itemCount:
                                            _getPaginatedTeachers().length,
                                        itemBuilder: (context, index) {
                                          final teacher =
                                              _getPaginatedTeachers()[index];
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
                                                // F.I.SH
                                                Expanded(
                                                  flex: 3,
                                                  child: Text(
                                                    teacher.fullName,
                                                    style: const TextStyle(
                                                      color: Color(0xFF1F2937),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                // Username
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    teacher.username,
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
                                                        teacher.subjects.isEmpty
                                                            ? 'Fan qo\'shilmagan'
                                                            : '${teacher.subjectsCount} ta fan',
                                                        style: const TextStyle(
                                                          color:
                                                              Color(0xFF1F2937),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                      if (teacher
                                                          .subjects.isNotEmpty)
                                                        Text(
                                                          teacher.subjects
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
                                                // Testlar soni
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    '${teacher.testsCount}',
                                                    style: const TextStyle(
                                                      color: Color(0xFF1F2937),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),

                                                // Holati
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: teacher.isActive
                                                          ? Colors.green
                                                              .withAlpha(26)
                                                          : Colors.red
                                                              .withAlpha(26),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                    ),
                                                    child: Text(
                                                      teacher.isActive
                                                          ? 'Faol'
                                                          : 'Nofaol',
                                                      style: TextStyle(
                                                        color: teacher.isActive
                                                            ? Colors.green
                                                            : Colors.red,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      InkWell(
                                                        onTap: () =>
                                                            _showEditTeacherDialog(
                                                                teacher),
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
                                                      InkWell(
                                                        onTap: () =>
                                                            _showDeleteTeacherDialog(
                                                                teacher),
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
                                      '${_startIndex + 1}-$_endIndex / ${_filteredTeachers.length}',
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
  int get _endIndex => (_startIndex + _rowsPerPage) > _filteredTeachers.length
      ? _filteredTeachers.length
      : _startIndex + _rowsPerPage;
  bool get _hasNextPage => _endIndex < _filteredTeachers.length;
  int get _maxPage => (_filteredTeachers.length / _rowsPerPage).ceil() - 1;

  // Get paginated teachers
  List<Teacher> _getPaginatedTeachers() {
    if (_filteredTeachers.isEmpty) return [];
    return _filteredTeachers.sublist(_startIndex, _endIndex);
  }

  // Dialog functions
  void _showAddTeacherDialog() {
    showDialog(
      context: context,
      builder: (context) => AddTeacherDialog(
        onSave: (teacher) {
          setState(() {
            // Generate a new ID
            final newId = (_teachers.isEmpty)
                ? '1'
                : '${int.parse(_teachers.last.id) + 1}';

            // Add the new teacher with the generated ID
            final newTeacher = Teacher(
              id: newId,
              fullName: teacher.fullName,
              username: teacher.username,
              subjects: teacher.subjects,
              testsCount: 0,
              isActive: true,
            );

            _teachers.add(newTeacher);
            _filteredTeachers = List.from(_teachers);

            // Show success message
            SnackBarUtils.showSuccessSnackBar(
              context,
              '${newTeacher.fullName} muvaffaqiyatli qo\'shildi',
            );
          });
        },
      ),
    );
  }

  void _showEditTeacherDialog(Teacher teacher) {
    showDialog(
      context: context,
      builder: (context) => EditTeacherDialog(
        teacher: teacher,
        onSave: (updatedTeacher) {
          setState(() {
            // Find and update the teacher
            final index =
                _teachers.indexWhere((t) => t.id == updatedTeacher.id);
            if (index != -1) {
              _teachers[index] = updatedTeacher;
              _filteredTeachers = List.from(_teachers);

              // Show success message
              SnackBarUtils.showSuccessSnackBar(
                context,
                '${updatedTeacher.fullName} muvaffaqiyatli yangilandi',
              );
            }
          });
        },
      ),
    );
  }

  void _showDeleteTeacherDialog(Teacher teacher) {
    showDialog(
      context: context,
      builder: (context) => DeleteTeacherDialog(
        teacher: teacher,
        onDelete: () {
          setState(() {
            // Remove the teacher
            _teachers.removeWhere((t) => t.id == teacher.id);
            _filteredTeachers = List.from(_teachers);

            // Show success message
            SnackBarUtils.showSuccessSnackBar(
              context,
              '${teacher.fullName} muvaffaqiyatli o\'chirildi',
            );
          });
        },
      ),
    );
  }

  // Generate mock teachers
  List<Teacher> _generateMockTeachers(int count) {
    final firstNames = [
      'Alisher',
      'Dilshod',
      'Gulnora',
      'Zafar',
      'Malika',
      'Rustam',
      'Nodira',
      'Bekzod',
      'Feruza',
      'Jahongir',
    ];

    final lastNames = [
      'Rahimov',
      'Karimova',
      'Umarov',
      'Saidova',
      'Toshmatov',
      'Ergasheva',
      'Yusupov',
      'Alimova',
      'Qodirov',
      'Mirzayeva',
    ];

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

    return List.generate(count, (index) {
      final firstName = firstNames[index % firstNames.length];
      final lastName = lastNames[index % lastNames.length];
      final fullName = '$firstName $lastName';

      // Generate different numbers of subjects for variety
      final List<String> teacherSubjects = [];

      // Some teachers will have 0 subjects
      if (index % 7 != 0) {
        // 1-3 subjects
        final subjectsCount = (index % 3) + 1;
        for (int i = 0; i < subjectsCount; i++) {
          final subjectIndex = (index + i) % subjects.length;
          teacherSubjects.add(subjects[subjectIndex]);
        }
      }

      // Generate random test count between 0 and 50
      final testsCount = (index * 7) % 51;

      // Generate username
      final username =
          '${firstName.toLowerCase()}${lastName.toLowerCase().substring(0, 3)}${(index % 99) + 1}';

      return Teacher(
        id: '${index + 1}',
        fullName: fullName,
        username: username,
        subjects: teacherSubjects,
        testsCount: testsCount,

        isActive: index % 3 != 0, // 2/3 of teachers are active
      );
    });
  }
}
