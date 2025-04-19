import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:variant_master/core/theme/app_colors.dart';
import 'package:variant_master/core/utils/snackbar_utils.dart';
import 'package:variant_master/features/admin/domain/entities/app_settings.dart';
import 'package:variant_master/features/admin/presentation/widgets/app_drawer.dart';
import 'package:variant_master/features/auth/bloc/auth_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Form key
  final _formKey = GlobalKey<FormState>();

  // Settings
  late AppSettings _settings;

  // Controllers
  final _organizationNameController = TextEditingController();
  final _sessionTimeoutController = TextEditingController();

  // Selected values
  String _selectedLanguage = 'O\'zbek';
  PasswordDifficulty _selectedDifficulty = PasswordDifficulty.medium;

  @override
  void initState() {
    super.initState();
    _settings = AppSettings.defaultSettings();
    _loadSettings();
  }

  @override
  void dispose() {
    _organizationNameController.dispose();
    _sessionTimeoutController.dispose();
    super.dispose();
  }

  // Load settings
  void _loadSettings() {
    // In a real app, this would load from a repository
    _organizationNameController.text = _settings.organizationName;
    _sessionTimeoutController.text = _settings.sessionTimeout.toString();
    _selectedLanguage = _settings.defaultLanguage;
    _selectedDifficulty = _settings.passwordDifficulty;
  }

  // Save settings
  void _saveSettings() {
    if (_formKey.currentState?.validate() ?? false) {
      // Update settings
      _settings = _settings.copyWith(
        organizationName: _organizationNameController.text,
        defaultLanguage: _selectedLanguage,
        passwordDifficulty: _selectedDifficulty,
        sessionTimeout: int.tryParse(_sessionTimeoutController.text) ?? 60,
      );

      // In a real app, this would save to a repository

      // Show success message
      SnackBarUtils.showSuccessSnackBar(
        context,
        'Sozlamalar muvaffaqiyatli saqlandi',
      );
    }
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
              const AppDrawer(currentRoute: '/settings'),

              // Main content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      const Text(
                        'Sozlamalar',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Settings form
                      Expanded(
                        child: Form(
                          key: _formKey,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Umumiy sozlamalar
                              Expanded(
                                child: Card(
                                  color: Colors.white,
                                  elevation: 0,
                                  margin: const EdgeInsets.only(right: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Section title
                                        const Text(
                                          'Umumiy',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1F2937),
                                          ),
                                        ),
                                        const SizedBox(height: 24),

                                        // Tashkilot nomi
                                        const Text(
                                          'Tashkilot Nomi',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF1F2937),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        TextFormField(
                                          controller:
                                              _organizationNameController,
                                          decoration: InputDecoration(
                                            hintText: 'Profi University',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: const BorderSide(
                                                  color: Color(0xFFE5E7EB)),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: const BorderSide(
                                                  color: Color(0xFFE5E7EB)),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: const BorderSide(
                                                  color: AppColors.primary,
                                                  width: 2),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 12),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Tashkilot nomini kiriting';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 24),

                                        // Tizim logotipi
                                        const Text(
                                          'Tizim Logotipi',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF1F2937),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          height: 48,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: const Color(0xFFE5E7EB)),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16),
                                                  child: Text(
                                                    _settings.logoPath.isEmpty
                                                        ? 'Logo tanlanmagan'
                                                        : _settings.logoPath,
                                                    style: TextStyle(
                                                      color: _settings
                                                              .logoPath.isEmpty
                                                          ? const Color(
                                                              0xFF9CA3AF)
                                                          : const Color(
                                                              0xFF1F2937),
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 48,
                                                decoration: const BoxDecoration(
                                                  border: Border(
                                                    left: BorderSide(
                                                        color:
                                                            Color(0xFFE5E7EB)),
                                                  ),
                                                ),
                                                child: IconButton(
                                                  icon: const Icon(
                                                      Icons.upload_file,
                                                      color: AppColors.primary),
                                                  onPressed: () {
                                                    // Logo tanlash
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 24),

                                        // Standart til
                                        const Text(
                                          'Standart Til',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF1F2937),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: const Color(0xFFE5E7EB)),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child:
                                              DropdownButtonFormField<String>(
                                            value: _selectedLanguage,
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 12),
                                            ),
                                            items: const [
                                              DropdownMenuItem(
                                                  value: 'O\'zbek',
                                                  child: Text('O\'zbek')),
                                              DropdownMenuItem(
                                                  value: 'Русский',
                                                  child: Text('Русский')),
                                              DropdownMenuItem(
                                                  value: 'English',
                                                  child: Text('English')),
                                            ],
                                            onChanged: (value) {
                                              if (value != null) {
                                                setState(() {
                                                  _selectedLanguage = value;
                                                });
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // Xavfsizlik sozlamalari
                              Expanded(
                                child: Card(
                                  color: Colors.white,
                                  elevation: 0,
                                  margin: const EdgeInsets.only(left: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Section title
                                        const Text(
                                          'Xavfsizlik',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1F2937),
                                          ),
                                        ),
                                        const SizedBox(height: 24),

                                        // Parol murakkabligi
                                        const Text(
                                          'Parol Murakkabligi',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF1F2937),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: const Color(0xFFE5E7EB)),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: DropdownButtonFormField<
                                              PasswordDifficulty>(
                                            value: _selectedDifficulty,
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 12),
                                            ),
                                            items: PasswordDifficulty.values
                                                .map((difficulty) {
                                              return DropdownMenuItem<
                                                  PasswordDifficulty>(
                                                value: difficulty,
                                                child: Text(
                                                    difficulty.displayName),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              if (value != null) {
                                                setState(() {
                                                  _selectedDifficulty = value;
                                                });
                                              }
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 24),

                                        // Sessiya muddati
                                        const Text(
                                          'Sessiya Muddati (daqiqa)',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF1F2937),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        TextFormField(
                                          controller: _sessionTimeoutController,
                                          decoration: InputDecoration(
                                            hintText: '60',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: const BorderSide(
                                                  color: Color(0xFFE5E7EB)),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: const BorderSide(
                                                  color: Color(0xFFE5E7EB)),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: const BorderSide(
                                                  color: AppColors.primary,
                                                  width: 2),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 12),
                                          ),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Sessiya muddatini kiriting';
                                            }
                                            final timeout = int.tryParse(value);
                                            if (timeout == null ||
                                                timeout <= 0) {
                                              return 'Noto\'g\'ri qiymat';
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Buttons
                      Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Bekor qilish
                            OutlinedButton(
                              onPressed: () {
                                // Reset form
                                _loadSettings();
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                side:
                                    const BorderSide(color: Color(0xFFE5E7EB)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Bekor qilish'),
                            ),
                            const SizedBox(width: 16),

                            // Saqlash
                            ElevatedButton(
                              onPressed: _saveSettings,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
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
              ),
            ],
          ),
        );
      },
    );
  }
}
