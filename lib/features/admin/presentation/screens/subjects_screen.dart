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

  // Track the next available ID
  int _nextId = 1;

  @override
  void initState() {
    super.initState();
    _subjects = _generateMockSubjects(30); // Generate 30 mock subjects
    // Filter out deleted subjects for the initial display
    _filteredSubjects =
        _subjects.where((subject) => !subject.isDeleted).toList();

    // Apply initial sorting by ID (1,2,3,...)
    _filteredSubjects
        .sort((a, b) => int.parse(a.id).compareTo(int.parse(b.id)));

    // Find the highest ID in the mock data and set _nextId accordingly
    if (_subjects.isNotEmpty) {
      final highestId = _subjects
          .map((subject) => int.tryParse(subject.id) ?? 0)
          .reduce((value, element) => value > element ? value : element);
      _nextId = highestId + 1;
    }
  }

  void _filterSubjects(String query) {
    setState(() {
      // First filter out deleted subjects
      final activeSubjects =
          _subjects.where((subject) => !subject.isDeleted).toList();

      if (query.isEmpty) {
        _filteredSubjects = List.from(activeSubjects);
      } else {
        _filteredSubjects = activeSubjects
            .where((subject) =>
                subject.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }

      // Default sorting by ID (1,2,3,...)
      _filteredSubjects
          .sort((a, b) => int.parse(a.id).compareTo(int.parse(b.id)));

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
                              _showAddSubjectDialog(context);
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
                                color: Colors.black.withOpacity(0.05),
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
                            // color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
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
                                    vertical: 14, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color:
                                          AppColors.primary.withOpacity(0.1)),
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
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        'Fan nomi',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1F2937),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Testlar soni',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1F2937),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        'Mavzular',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1F2937),
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
                                    ? Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.search_off,
                                                size: 64,
                                                color: Colors.grey.shade400),
                                            const SizedBox(height: 16),
                                            Text(
                                              'Fanlar topilmadi',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.grey.shade600),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Yangi fan qo\'shish uchun + tugmasini bosing',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey.shade500),
                                            ),
                                          ],
                                        ),
                                      )
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
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    subject.id,
                                                    style: const TextStyle(
                                                      color: Color(0xFF1F2937),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Text(
                                                    subject.name,
                                                    style: const TextStyle(
                                                      color: Color(0xFF1F2937),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    '${subject.testsCount}',
                                                    style: const TextStyle(
                                                      color: Color(0xFF1F2937),
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
                                                          _showEditSubjectDialog(
                                                              context, subject);
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
                                                          _showDeleteConfirmationDialog(
                                                              context, subject);
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

  // Show add subject dialog
  void _showAddSubjectDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final topicsController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by clicking outside
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              width: 500,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with gradient background
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          Color.fromARGB(204, 37, 99, 235)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Fan qo\'shish',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),

                  // Content
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Fan nomi
                          const Text(
                            'Fan nomi',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              hintText: 'Masalan: Matematika',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: Color(0xFFE5E7EB)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: Color(0xFFE5E7EB)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: AppColors.primary, width: 2),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Fan nomini kiriting';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),

                          // Mavzular
                          const Text(
                            'Mavzular (ixtiyoriy)',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Mavzular - vergul bilan ajratilgan
                          TextFormField(
                            controller: topicsController,
                            decoration: InputDecoration(
                              hintText:
                                  'Mavzularni vergul bilan ajrating. Masalan: Algebra, Geometriya, Trigonometriya',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: Color(0xFFE5E7EB)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: Color(0xFFE5E7EB)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: AppColors.primary, width: 2),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Actions
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF6B7280),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                          ),
                          child: const Text('Bekor qilish'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState?.validate() ?? false) {
                              // Parse comma-separated topics
                              final topics = topicsController.text
                                  .split(',')
                                  .map((topic) => topic.trim())
                                  .where((topic) => topic.isNotEmpty)
                                  .toList();

                              // Create new subject with the next available ID
                              final newSubject = Subject(
                                id: _nextId.toString(),
                                name: nameController.text.trim(),
                                testsCount: 0, // New subject has no tests yet
                                topics: topics,
                              );

                              // Increment the next ID
                              _nextId++;

                              // Add to list and update state
                              // First update the parent state
                              _subjects.add(newSubject);
                              _filteredSubjects = List.from(_subjects);

                              // Close dialog and dispose controllers
                              Navigator.pop(context);

                              // Update UI after dialog is closed
                              setState(() {});

                              // Show success message after dialog is closed
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        const Icon(Icons.check_circle,
                                            color: Colors.white),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            '${newSubject.name} fani muvaffaqiyatli qo\'shildi',
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                    backgroundColor: Colors.green.shade600,
                                    duration: const Duration(seconds: 3),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    margin: const EdgeInsets.all(16),
                                  ),
                                );
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Saqlash'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Show edit subject dialog
  void _showEditSubjectDialog(BuildContext context, Subject subject) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: subject.name);
    final topicsController =
        TextEditingController(text: subject.topics.join(', '));

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by clicking outside
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              width: 500,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with gradient background
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          Color.fromARGB(204, 37, 99, 235)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Fanni tahrirlash',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),

                  // Content
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Fan nomi
                          const Text(
                            'Fan nomi',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              hintText: 'Masalan: Matematika',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: Color(0xFFE5E7EB)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: Color(0xFFE5E7EB)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: AppColors.primary, width: 2),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Fan nomini kiriting';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),

                          // Mavzular
                          const Text(
                            'Mavzular (ixtiyoriy)',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Mavzular - vergul bilan ajratilgan
                          TextFormField(
                            controller: topicsController,
                            decoration: InputDecoration(
                              hintText:
                                  'Mavzularni vergul bilan ajrating. Masalan: Algebra, Geometriya, Trigonometriya',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: Color(0xFFE5E7EB)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: Color(0xFFE5E7EB)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: AppColors.primary, width: 2),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Actions
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF6B7280),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                          ),
                          child: const Text('Bekor qilish'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState?.validate() ?? false) {
                              // Parse comma-separated topics
                              final topics = topicsController.text
                                  .split(',')
                                  .map((topic) => topic.trim())
                                  .where((topic) => topic.isNotEmpty)
                                  .toList();

                              // Create updated subject (preserve isDeleted flag)
                              final updatedSubject = Subject(
                                id: subject.id,
                                name: nameController.text.trim(),
                                testsCount: subject.testsCount,
                                topics: topics,
                                isDeleted: subject
                                    .isDeleted, // Preserve the isDeleted flag
                              );

                              // Close dialog first to avoid context issues
                              Navigator.pop(context);

                              // Update the parent widget's state
                              this.setState(() {
                                // Find and update the subject in the list
                                final index = _subjects
                                    .indexWhere((s) => s.id == subject.id);
                                if (index != -1) {
                                  _subjects[index] = updatedSubject;
                                }

                                // Update filtered subjects
                                _filteredSubjects = _subjects
                                    .where((s) => !s.isDeleted)
                                    .toList();
                              });

                              // Show success message
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        const Icon(Icons.check_circle,
                                            color: Colors.white),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            '${updatedSubject.name} fani muvaffaqiyatli yangilandi',
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                    backgroundColor: Colors.green.shade600,
                                    duration: const Duration(seconds: 3),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    margin: const EdgeInsets.all(16),
                                  ),
                                );
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Saqlash'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Show delete confirmation dialog
  void _showDeleteConfirmationDialog(BuildContext context, Subject subject) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
            SizedBox(width: 8),
            Text('Fanni o\'chirish'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Siz haqiqatan ham "${subject.name}" fanini o\'chirmoqchimisiz?',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            const Text(
              'Diqqat: Bu amalni ortga qaytarib bo\'lmaydi.',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF6B7280),
            ),
            child: const Text('Bekor qilish'),
          ),
          ElevatedButton(
            onPressed: () {
              // Mark subject as deleted instead of removing it
              setState(() {
                final index = _subjects.indexWhere((s) => s.id == subject.id);
                if (index != -1) {
                  // Create a new subject with isDeleted = true
                  final deletedSubject = Subject(
                    id: subject.id,
                    name: subject.name,
                    testsCount: subject.testsCount,
                    topics: subject.topics,
                    isDeleted: true,
                  );

                  // Replace the subject with the deleted version
                  _subjects[index] = deletedSubject;

                  // Update filtered subjects to exclude deleted ones
                  _filteredSubjects =
                      _subjects.where((s) => !s.isDeleted).toList();
                }
              });

              // Close dialog
              Navigator.pop(context);

              // Show success message
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.white),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '${subject.name} fani muvaffaqiyatli o\'chirildi',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.red.shade600,
                    duration: const Duration(seconds: 3),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    margin: const EdgeInsets.all(16),
                  ),
                );
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('O\'chirish'),
          ),
        ],
      ),
    );
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
        id: '${index + 1}', // ID is sequential and unique
        name: subjectName,
        testsCount: (index + 1) * 5,
        topics: selectedTopics,
        isDeleted: false, // All mock subjects are active by default
      );
    });
  }
}
