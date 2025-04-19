import 'package:flutter/material.dart';
import 'package:variant_master/core/theme/app_colors.dart';
import 'package:variant_master/features/admin/domain/entities/direction.dart';

/// Yo'nalish qo'shish dialog oynasi
class AddDirectionDialog extends StatefulWidget {
  final Function(Direction) onSave;

  const AddDirectionDialog({
    super.key,
    required this.onSave,
  });

  @override
  State<AddDirectionDialog> createState() => _AddDirectionDialogState();
}

class _AddDirectionDialogState extends State<AddDirectionDialog> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final codeController = TextEditingController();

  // Available subjects
  final List<String> _availableSubjects = [
    'Matematika',
    'Fizika',
    'Informatika',
    'Dasturlash',
    'Elektronika',
    'Statistika',
    'Machine Learning',
    'Tarmoqlar',
    'Kriptografiya',
    'Iqtisod',
    'Moliya',
    'Marketing',
    'Veb-dasturlash',
    'UX/UI Dizayn',
    'Mobil texnologiyalar',
    'HTML/CSS',
    'JavaScript',
    'Backend texnologiyalar',
  ];

  // Selected subjects
  final List<String> _selectedSubjects = [];

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    const Color.fromARGB(204, 37, 99, 235)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Yo\'nalish qo\'shish',
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
                    // Yo'nalish nomi
                    const Text(
                      'Yo\'nalish nomi',
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
                        hintText: 'Masalan: Dasturiy injiniring',
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
                          return 'Yo\'nalish nomini kiriting';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Yo'nalish kodi
                    const Text(
                      'Yo\'nalish kodi',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: codeController,
                      decoration: InputDecoration(
                        hintText: 'Masalan: 60540100',
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
                          return 'Yo\'nalish kodini kiriting';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Fanlar
                    const Text(
                      'Fanlar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
                      height: 200,
                      child: Scrollbar(
                        thumbVisibility: true,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: _availableSubjects.length,
                          itemBuilder: (context, index) {
                            final subject = _availableSubjects[index];
                            return CheckboxListTile(
                              title: Text(subject),
                              value: _selectedSubjects.contains(subject),
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    _selectedSubjects.add(subject);
                                  } else {
                                    _selectedSubjects.remove(subject);
                                  }
                                });
                              },
                              activeColor: AppColors.primary,
                              dense: true,
                              controlAffinity: ListTileControlAffinity.leading,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Actions
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                        // Create new direction with selected subjects
                        final newDirection = Direction(
                          id: '', // ID will be set by the parent widget
                          name: nameController.text.trim(),
                          code: codeController.text.trim(),
                          subjects: _selectedSubjects,
                        );

                        // Call the callback
                        widget.onSave(newDirection);

                        // Close dialog
                        Navigator.pop(context);
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
  }
}

/// Yo'nalishni tahrirlash dialog oynasi
class EditDirectionDialog extends StatefulWidget {
  final Direction direction;
  final Function(Direction) onSave;

  const EditDirectionDialog({
    super.key,
    required this.direction,
    required this.onSave,
  });

  @override
  State<EditDirectionDialog> createState() => _EditDirectionDialogState();
}

class _EditDirectionDialogState extends State<EditDirectionDialog> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController codeController;

  // Available subjects
  final List<String> _availableSubjects = [
    'Matematika',
    'Fizika',
    'Informatika',
    'Dasturlash',
    'Elektronika',
    'Statistika',
    'Machine Learning',
    'Tarmoqlar',
    'Kriptografiya',
    'Iqtisod',
    'Moliya',
    'Marketing',
    'Veb-dasturlash',
    'UX/UI Dizayn',
    'Mobil texnologiyalar',
    'HTML/CSS',
    'JavaScript',
    'Backend texnologiyalar',
  ];

  // Selected subjects
  late List<String> _selectedSubjects;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.direction.name);
    codeController = TextEditingController(text: widget.direction.code);
    _selectedSubjects = List.from(widget.direction.subjects);
  }

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    const Color.fromARGB(204, 37, 99, 235)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Yo\'nalishni tahrirlash',
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
                    // Yo'nalish nomi
                    const Text(
                      'Yo\'nalish nomi',
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
                        hintText: 'Masalan: Dasturiy injiniring',
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
                          return 'Yo\'nalish nomini kiriting';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Yo'nalish kodi
                    const Text(
                      'Yo\'nalish kodi',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: codeController,
                      decoration: InputDecoration(
                        hintText: 'Masalan: 60540100',
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
                          return 'Yo\'nalish kodini kiriting';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Fanlar
                    const Text(
                      'Fanlar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
                      height: 200,
                      child: Scrollbar(
                        thumbVisibility: true,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: _availableSubjects.length,
                          itemBuilder: (context, index) {
                            final subject = _availableSubjects[index];
                            return CheckboxListTile(
                              title: Text(subject),
                              value: _selectedSubjects.contains(subject),
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    _selectedSubjects.add(subject);
                                  } else {
                                    _selectedSubjects.remove(subject);
                                  }
                                });
                              },
                              activeColor: AppColors.primary,
                              dense: true,
                              controlAffinity: ListTileControlAffinity.leading,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Actions
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                        // Create updated direction with selected subjects
                        final updatedDirection = Direction(
                          id: widget.direction.id,
                          name: nameController.text.trim(),
                          code: codeController.text.trim(),
                          subjects: _selectedSubjects,
                          isDeleted: widget.direction
                              .isDeleted, // Preserve the isDeleted flag
                        );

                        // Call the callback
                        widget.onSave(updatedDirection);

                        // Close dialog
                        Navigator.pop(context);
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
  }
}

/// Yo'nalishni o'chirish dialog oynasi
class DeleteDirectionDialog extends StatelessWidget {
  final Direction direction;
  final VoidCallback onDelete;

  const DeleteDirectionDialog({
    super.key,
    required this.direction,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: const Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
          SizedBox(width: 8),
          Text('Yo\'nalishni o\'chirish'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Siz rostdan ham "${direction.name}" yo\'nalishini o\'chirmoqchimisiz?',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 12),
          const Text(
            'Bu amalni ortga qaytarib bo\'lmaydi.',
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Bekor qilish'),
        ),
        ElevatedButton(
          onPressed: () {
            // Call the callback
            onDelete();

            // Close dialog
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: const Text('O\'chirish'),
        ),
      ],
    );
  }
}
