import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:variant_master/core/theme/app_colors.dart';
import 'package:variant_master/core/utils/snackbar_utils.dart';
import 'package:variant_master/features/auth/bloc/auth_bloc.dart';
import 'package:variant_master/features/auth/domain/entities/user.dart';
import 'package:variant_master/features/admin/presentation/widgets/app_drawer.dart';
import 'package:variant_master/features/admin/domain/entities/moderator.dart';
import 'package:variant_master/features/admin/presentation/widgets/moderator_dialogs.dart';

class ModeratorsScreen extends StatefulWidget {
  const ModeratorsScreen({super.key});

  @override
  State<ModeratorsScreen> createState() => _ModeratorsScreenState();
}

class _ModeratorsScreenState extends State<ModeratorsScreen> {
  // Pagination variables
  int _rowsPerPage = 10;
  int _currentPage = 0;

  // Mock data
  late List<Moderator> _moderators;
  late List<Moderator> _filteredModerators;

  @override
  void initState() {
    super.initState();
    _moderators = _generateMockModerators(30); // Generate 30 mock moderators
    _filteredModerators = List.from(_moderators);
  }

  void _filterModerators(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredModerators = List.from(_moderators);
      } else {
        _filteredModerators = _moderators
            .where((moderator) =>
                moderator.fullName
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                moderator.username.toLowerCase().contains(query.toLowerCase()))
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
              const AppDrawer(currentRoute: '/moderators'),

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
                            'Moderatorlar',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: _showAddModeratorDialog,
                            icon: const Icon(Icons.add),
                            label: const Text('Moderator qo\'shish'),
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
                              hintText: 'Moderator nomini qidirish...',
                              hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
                              prefixIcon:
                                  Icon(Icons.search, color: Color(0xFF6B7280)),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 16),
                            ),
                            style: const TextStyle(fontSize: 15),
                            onChanged: _filterModerators,
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
                                      flex: 2,
                                      child: Text(
                                        'Tekshirgan testlari',
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
                                child: _filteredModerators.isEmpty
                                    ? const Center(
                                        child: Text('Ma\'lumot topilmadi'))
                                    : ListView.builder(
                                        itemCount:
                                            _getPaginatedModerators().length,
                                        itemBuilder: (context, index) {
                                          final moderator =
                                              _getPaginatedModerators()[index];
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
                                                    moderator.fullName,
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
                                                    moderator.username,
                                                    style: const TextStyle(
                                                      color: Color(0xFF1F2937),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                // Tekshirgan testlari soni
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    '${moderator.testsChecked}',
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
                                                      color: moderator.isActive
                                                          ? Colors.green
                                                              .withAlpha(26)
                                                          : Colors.red
                                                              .withAlpha(26),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                    ),
                                                    child: Text(
                                                      moderator.isActive
                                                          ? 'Faol'
                                                          : 'Nofaol',
                                                      style: TextStyle(
                                                        color:
                                                            moderator.isActive
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
                                                            _showEditModeratorDialog(
                                                                moderator),
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
                                                            _showDeleteModeratorDialog(
                                                                moderator),
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
                                      '${_startIndex + 1}-$_endIndex / ${_filteredModerators.length}',
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

  // Dialog functions
  void _showAddModeratorDialog() {
    showDialog(
      context: context,
      builder: (context) => AddModeratorDialog(
        onSave: (moderator) {
          setState(() {
            // Generate a new ID
            final newId = (_moderators.isEmpty)
                ? '1'
                : '${int.parse(_moderators.last.id) + 1}';

            // Add the new moderator with the generated ID
            final newModerator = Moderator(
              id: newId,
              fullName: moderator.fullName,
              username: moderator.username,
              testsChecked: 0,
              isActive: true,
            );

            _moderators.add(newModerator);
            _filteredModerators = List.from(_moderators);

            // Show success message
            SnackBarUtils.showSuccessSnackBar(
              context,
              '${newModerator.fullName} muvaffaqiyatli qo\'shildi',
            );
          });
        },
      ),
    );
  }

  void _showEditModeratorDialog(Moderator moderator) {
    showDialog(
      context: context,
      builder: (context) => EditModeratorDialog(
        moderator: moderator,
        onSave: (updatedModerator) {
          setState(() {
            // Find and update the moderator
            final index =
                _moderators.indexWhere((t) => t.id == updatedModerator.id);
            if (index != -1) {
              _moderators[index] = updatedModerator;
              _filteredModerators = List.from(_moderators);

              // Show success message
              SnackBarUtils.showSuccessSnackBar(
                context,
                '${updatedModerator.fullName} muvaffaqiyatli yangilandi',
              );
            }
          });
        },
      ),
    );
  }

  void _showDeleteModeratorDialog(Moderator moderator) {
    showDialog(
      context: context,
      builder: (context) => DeleteModeratorDialog(
        moderator: moderator,
        onDelete: () {
          setState(() {
            // Remove the moderator
            _moderators.removeWhere((t) => t.id == moderator.id);
            _filteredModerators = List.from(_moderators);

            // Show success message
            SnackBarUtils.showSuccessSnackBar(
              context,
              '${moderator.fullName} muvaffaqiyatli o\'chirildi',
            );
          });
        },
      ),
    );
  }

  // Pagination helpers
  int get _startIndex => _currentPage * _rowsPerPage;
  int get _endIndex => (_startIndex + _rowsPerPage) > _filteredModerators.length
      ? _filteredModerators.length
      : _startIndex + _rowsPerPage;
  bool get _hasNextPage => _endIndex < _filteredModerators.length;
  int get _maxPage => (_filteredModerators.length / _rowsPerPage).ceil() - 1;

  // Get paginated moderators
  List<Moderator> _getPaginatedModerators() {
    if (_filteredModerators.isEmpty) return [];
    return _filteredModerators.sublist(_startIndex, _endIndex);
  }

  // Generate mock moderators
  List<Moderator> _generateMockModerators(int count) {
    final firstNames = [
      'Alisher',
      'Dilshod',
      'Gulnora',
      'Aziza',
      'Bobur',
      'Kamola',
      'Rustam',
      'Nodira',
      'Jahongir',
      'Malika',
    ];
    final lastNames = [
      'Rahimov',
      'Karimova',
      'Umarov',
      'Saidova',
      'Toshmatov',
      'Ergasheva',
      'Yusupov',
      'Akbarova',
      'Ismoilov',
      'Zokirova',
    ];

    return List.generate(count, (index) {
      final firstName = firstNames[index % firstNames.length];
      final lastName = lastNames[index % lastNames.length];
      final fullName = '$firstName $lastName';
      final username = '${firstName.toLowerCase()}${index + 1}';

      return Moderator(
        id: '${index + 1}',
        fullName: fullName,
        username: username,
        testsChecked: (index * 5) % 100, // Random number of tests checked
        isActive: index % 3 != 0, // 2/3 are active
      );
    });
  }
}
