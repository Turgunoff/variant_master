import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:variant_master/core/theme/app_colors.dart';
import 'package:variant_master/features/auth/bloc/auth_bloc.dart';
import 'package:variant_master/features/auth/domain/entities/user.dart';
import 'package:variant_master/features/admin/presentation/widgets/app_drawer.dart';
import 'package:variant_master/features/admin/domain/entities/direction.dart';
import 'package:variant_master/features/admin/presentation/widgets/direction_dialogs.dart';

class DirectionsScreen extends StatefulWidget {
  const DirectionsScreen({super.key});

  @override
  State<DirectionsScreen> createState() => _DirectionsScreenState();
}

class _DirectionsScreenState extends State<DirectionsScreen> {
  // Mock data
  late List<Direction> _directions;
  late List<Direction> _filteredDirections;

  // Track the next available ID
  int _nextId = 1;

  // Pagination variables will be implemented later

  @override
  void initState() {
    super.initState();
    _directions = _generateMockDirections(10); // Generate 10 mock directions
    // Filter out deleted directions for the initial display
    _filteredDirections =
        _directions.where((direction) => !direction.isDeleted).toList();

    // Apply initial sorting by ID (1,2,3,...)
    _filteredDirections
        .sort((a, b) => int.parse(a.id).compareTo(int.parse(b.id)));

    // Find the highest ID in the mock data and set _nextId accordingly
    if (_directions.isNotEmpty) {
      final highestId = _directions
          .map((direction) => int.tryParse(direction.id) ?? 0)
          .reduce((value, element) => value > element ? value : element);
      _nextId = highestId + 1;
    }
  }

  void _filterDirections(String query) {
    setState(() {
      // First filter out deleted directions
      final activeDirections =
          _directions.where((direction) => !direction.isDeleted).toList();

      if (query.isEmpty) {
        _filteredDirections = List.from(activeDirections);
      } else {
        _filteredDirections = activeDirections
            .where((direction) =>
                direction.name.toLowerCase().contains(query.toLowerCase()) ||
                direction.code.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }

      // Default sorting by ID (1,2,3,...)
      _filteredDirections
          .sort((a, b) => int.parse(a.id).compareTo(int.parse(b.id)));
    });
  }

  // Generate mock directions data
  List<Direction> _generateMockDirections(int count) {
    final directionNames = [
      'Axborot tizimlari',
      'Dasturiy injiniring',
      'Kompyuter injiniringi',
      'Sun\'iy intellekt',
      'Telekommunikatsiya',
      'Kiberxavfsizlik',
      'Raqamli iqtisodiyot',
      'Elektron tijorat',
      'Mobil ilovalar',
      'Veb-texnologiyalar',
    ];

    // Define subjects for each direction
    final directionSubjects = {
      'Axborot tizimlari': ['Matematika', 'Fizika', 'Informatika'],
      'Dasturiy injiniring': ['Matematika', 'Fizika', 'Dasturlash'],
      'Kompyuter injiniringi': ['Matematika', 'Fizika', 'Elektronika'],
      'Sun\'iy intellekt': ['Matematika', 'Statistika', 'Machine Learning'],
      'Telekommunikatsiya': ['Fizika', 'Elektronika', 'Tarmoqlar'],
      'Kiberxavfsizlik': ['Kriptografiya', 'Tarmoqlar', 'Dasturlash'],
      'Raqamli iqtisodiyot': ['Iqtisod', 'Statistika', 'Moliya'],
      'Elektron tijorat': ['Marketing', 'Iqtisod', 'Veb-dasturlash'],
      'Mobil ilovalar': ['Dasturlash', 'UX/UI Dizayn', 'Mobil texnologiyalar'],
      'Veb-texnologiyalar': [
        'HTML/CSS',
        'JavaScript',
        'Backend texnologiyalar'
      ],
    };

    return List.generate(count, (index) {
      final name = directionNames[index % directionNames.length];
      final code = '${10000 + index * 123}';
      final subjects = directionSubjects[name] ?? [];

      return Direction(
        id: '${index + 1}',
        name: name,
        code: code,
        subjects: subjects,
        isDeleted: false,
      );
    });
  }

  // Show add direction dialog
  void _showAddDirectionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AddDirectionDialog(
        onSave: (newDirection) {
          // Add to list and update state
          setState(() {
            // Set the ID
            final direction = Direction(
              id: _nextId.toString(),
              name: newDirection.name,
              code: newDirection.code,
              subjects: newDirection.subjects,
            );

            _directions.add(direction);
            _filteredDirections =
                _directions.where((direction) => !direction.isDeleted).toList();
            _nextId++;
          });

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
                        '${newDirection.name} yo\'nalishi muvaffaqiyatli qo\'shildi',
                        style: const TextStyle(fontSize: 16),
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
        },
      ),
    );
  }

  // Show edit direction dialog
  void _showEditDirectionDialog(BuildContext context, Direction direction) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => EditDirectionDialog(
        direction: direction,
        onSave: (updatedDirection) {
          // Update the parent widget's state
          setState(() {
            // Find and update the direction in the list
            final index = _directions.indexWhere((d) => d.id == direction.id);
            if (index != -1) {
              _directions[index] = updatedDirection;
            }

            // Update filtered directions
            _filteredDirections =
                _directions.where((d) => !d.isDeleted).toList();
            // Sort by ID
            _filteredDirections
                .sort((a, b) => int.parse(a.id).compareTo(int.parse(b.id)));
          });

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
                        '${updatedDirection.name} yo\'nalishi muvaffaqiyatli yangilandi',
                        style: const TextStyle(fontSize: 16),
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
        },
      ),
    );
  }

  // Show delete confirmation dialog
  void _showDeleteConfirmationDialog(
      BuildContext context, Direction direction) {
    showDialog(
      context: context,
      builder: (context) => DeleteDirectionDialog(
        direction: direction,
        onDelete: () {
          // Mark as deleted (logical deletion)
          setState(() {
            final index = _directions.indexWhere((d) => d.id == direction.id);
            if (index != -1) {
              // Create a new direction with isDeleted set to true
              _directions[index] = Direction(
                id: direction.id,
                name: direction.name,
                code: direction.code,
                subjects: direction.subjects,
                isDeleted: true,
              );

              // Update filtered list
              _filteredDirections =
                  _directions.where((d) => !d.isDeleted).toList();
            }
          });

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${direction.name} yo\'nalishi muvaffaqiyatli o\'chirildi',
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
        },
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
              const AppDrawer(currentRoute: '/directions'),

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
                            'Yo\'nalishlar',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => _showAddDirectionDialog(context),
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
                                color: Colors.black.withAlpha(13),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: 'Yo\'nalish nomini qidirish...',
                              hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
                              prefixIcon:
                                  Icon(Icons.search, color: Color(0xFF6B7280)),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 16),
                            ),
                            style: const TextStyle(fontSize: 15),
                            onChanged: _filterDirections,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                // color: Colors.red,
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
                                        vertical: 14, horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withAlpha(13),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color:
                                              AppColors.primary.withAlpha(25)),
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
                                            'Yo\'nalish nomi',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1F2937),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            'Yo\'nalish kodi',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1F2937),
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

                                  // Table content
                                  Expanded(
                                    child: _filteredDirections.isEmpty
                                        ? Center(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.search_off,
                                                    size: 64,
                                                    color:
                                                        Colors.grey.shade400),
                                                const SizedBox(height: 16),
                                                Text(
                                                  'Yo\'nalishlar topilmadi',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color:
                                                          Colors.grey.shade600),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  'Yangi yo\'nalish qo\'shish uchun + tugmasini bosing',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                          Colors.grey.shade500),
                                                ),
                                              ],
                                            ),
                                          )
                                        : ListView.builder(
                                            itemCount:
                                                _filteredDirections.length,
                                            itemBuilder: (context, index) {
                                              final direction =
                                                  _filteredDirections[index];
                                              return Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 8),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12,
                                                        horizontal: 16),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                      color: const Color(
                                                          0xFFE5E7EB)),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        '${index + 1}',
                                                        style: const TextStyle(
                                                          color:
                                                              Color(0xFF1F2937),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Text(
                                                        direction.name,
                                                        style: const TextStyle(
                                                          color:
                                                              Color(0xFF1F2937),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        direction.code,
                                                        style: const TextStyle(
                                                          color:
                                                              Color(0xFF1F2937),
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
                                                            direction.subjects
                                                                    .isEmpty
                                                                ? 'Fan qo\'shilmagan'
                                                                : '${direction.subjectsCount} ta fan',
                                                            style:
                                                                const TextStyle(
                                                              color: Color(
                                                                  0xFF1F2937),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 13,
                                                            ),
                                                          ),
                                                          if (direction.subjects
                                                              .isNotEmpty)
                                                            Text(
                                                              direction.subjects
                                                                  .join(', '),
                                                              style:
                                                                  const TextStyle(
                                                                color: Color(
                                                                    0xFF6B7280),
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
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
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          InkWell(
                                                            onTap: () =>
                                                                _showEditDirectionDialog(
                                                                    context,
                                                                    direction),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                            child:
                                                                const Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(4.0),
                                                              child: Icon(
                                                                Icons.edit,
                                                                color: AppColors
                                                                    .primary,
                                                                size: 18,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 4),
                                                          InkWell(
                                                            onTap: () =>
                                                                _showDeleteConfirmationDialog(
                                                                    context,
                                                                    direction),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                            child:
                                                                const Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(4.0),
                                                              child: Icon(
                                                                Icons.delete,
                                                                color:
                                                                    Colors.red,
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
                                          '1-${_filteredDirections.length} / ${_filteredDirections.length}',
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
                                                  value: 10,
                                                  underline: Container(),
                                                  items: [5, 10, 20, 50]
                                                      .map((count) =>
                                                          DropdownMenuItem<int>(
                                                            value: count,
                                                            child:
                                                                Text('$count'),
                                                          ))
                                                      .toList(),
                                                  onChanged: (value) {
                                                    // Pagination functionality will be implemented later
                                                  },
                                                ),
                                              ],
                                            ),
                                            const SizedBox(width: 16),
                                            // Pagination controls
                                            const IconButton(
                                              icon: Icon(Icons.first_page),
                                              onPressed:
                                                  null, // Will be implemented later
                                              color: Color(0xFFD1D5DB),
                                            ),
                                            const IconButton(
                                              icon: Icon(Icons.chevron_left),
                                              onPressed:
                                                  null, // Will be implemented later
                                              color: Color(0xFFD1D5DB),
                                            ),
                                            const IconButton(
                                              icon: Icon(Icons.chevron_right),
                                              onPressed:
                                                  null, // Will be implemented later
                                              color: Color(0xFFD1D5DB),
                                            ),
                                            const IconButton(
                                              icon: Icon(Icons.last_page),
                                              onPressed:
                                                  null, // Will be implemented later
                                              color: Color(0xFFD1D5DB),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ))),
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
}
