import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:variant_master/core/theme/app_colors.dart';
import 'package:variant_master/core/utils/snackbar_utils.dart';
import 'package:variant_master/features/admin/domain/entities/moderator.dart';

/// Moderator qo'shish dialog oynasi
class AddModeratorDialog extends StatefulWidget {
  final Function(Moderator) onSave;

  const AddModeratorDialog({
    super.key,
    required this.onSave,
  });

  @override
  State<AddModeratorDialog> createState() => _AddModeratorDialogState();
}

class _AddModeratorDialogState extends State<AddModeratorDialog> {
  final formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscurePassword = true;

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
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
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
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, Color.fromARGB(204, 37, 99, 235)],
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
                    'Moderator qo\'shish',
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
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // F.I.SH
                        const Text(
                          'F.I.SH',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: fullNameController,
                          decoration: InputDecoration(
                            hintText: 'Masalan: Alisher Rahimov',
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
                              return 'F.I.SH ni kiriting';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Username
                        const Text(
                          'Username',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: usernameController,
                          decoration: InputDecoration(
                            hintText: 'Masalan: alisher94',
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
                              return 'Username ni kiriting';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Password
                        const Text(
                          'Parol',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: 'Parolni kiriting',
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
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Parolni kiriting';
                            }
                            if (value.length < 6) {
                              return 'Parol kamida 6 ta belgidan iborat bo\'lishi kerak';
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
                        // Create new moderator
                        final newModerator = Moderator(
                          id: '', // ID will be set by the parent widget
                          fullName: fullNameController.text.trim(),
                          username: usernameController.text.trim(),
                          testsChecked: 0, // New moderator has 0 tests checked
                          isActive: true, // New moderator is active by default
                        );

                        // Call the callback
                        widget.onSave(newModerator);

                        // Close dialog
                        Navigator.pop(context);

                        // Show success message
                        SnackBarUtils.showSuccessSnackBar(
                          context,
                          'Moderator muvaffaqiyatli qo\'shildi',
                        );
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

/// Moderatorni tahrirlash dialog oynasi
class EditModeratorDialog extends StatefulWidget {
  final Moderator moderator;
  final Function(Moderator) onSave;

  const EditModeratorDialog({
    super.key,
    required this.moderator,
    required this.onSave,
  });

  @override
  State<EditModeratorDialog> createState() => _EditModeratorDialogState();
}

class _EditModeratorDialogState extends State<EditModeratorDialog> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController fullNameController;
  late final TextEditingController usernameController;
  final passwordController = TextEditingController(); // Empty for security
  bool _obscurePassword = true;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController(text: widget.moderator.fullName);
    usernameController = TextEditingController(text: widget.moderator.username);
    _isActive = widget.moderator.isActive;
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
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
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
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, Color.fromARGB(204, 37, 99, 235)],
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
                    'Moderatorni tahrirlash',
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
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // F.I.SH
                        const Text(
                          'F.I.SH',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: fullNameController,
                          decoration: InputDecoration(
                            hintText: 'Masalan: Alisher Rahimov',
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
                              return 'F.I.SH ni kiriting';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Username
                        const Text(
                          'Username',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: usernameController,
                          decoration: InputDecoration(
                            hintText: 'Masalan: alisher94',
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
                              return 'Username ni kiriting';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Password (optional for edit)
                        const Text(
                          'Parol (o\'zgartirish uchun to\'ldiring)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: 'Yangi parolni kiriting',
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
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value != null &&
                                value.isNotEmpty &&
                                value.length < 6) {
                              return 'Parol kamida 6 ta belgidan iborat bo\'lishi kerak';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Status
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            CupertinoSwitch(
                              value: _isActive,
                              activeTrackColor: Colors.green.shade300,
                              inactiveTrackColor: Colors.grey.shade300,
                              onChanged: (value) {
                                setState(() {
                                  _isActive = value;
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _isActive ? 'Faol' : 'Nofaol',
                              style: TextStyle(
                                color: _isActive ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
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
                        // Create updated moderator
                        final updatedModerator = Moderator(
                          id: widget.moderator.id,
                          fullName: fullNameController.text.trim(),
                          username: usernameController.text.trim(),
                          testsChecked: widget.moderator.testsChecked,
                          isActive: _isActive,
                          isDeleted: widget.moderator.isDeleted,
                        );

                        // Call the callback
                        widget.onSave(updatedModerator);

                        // Close dialog
                        Navigator.pop(context);

                        // Show success message
                        SnackBarUtils.showSuccessSnackBar(
                          context,
                          'Moderator muvaffaqiyatli yangilandi',
                        );
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

/// Moderatorni o'chirish dialog oynasi
class DeleteModeratorDialog extends StatelessWidget {
  final Moderator moderator;
  final VoidCallback onDelete;

  const DeleteModeratorDialog({
    super.key,
    required this.moderator,
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
          Text('Moderatorni o\'chirish'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Siz rostdan ham "${moderator.fullName}" moderatorini o\'chirmoqchimisiz?',
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

            // Show success message
            SnackBarUtils.showSuccessSnackBar(
              context,
              'Moderator muvaffaqiyatli o\'chirildi',
            );
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
