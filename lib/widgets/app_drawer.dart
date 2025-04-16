import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/auth_provider.dart';
import '../core/theme/app_colors.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute;

  const AppDrawer({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    if (user == null) {
      return const Drawer(
        child: Center(
          child: Text('User not authenticated'),
        ),
      );
    }

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Drawer header with university logo
          _buildDrawerHeader(context, user),

          // Drawer items based on user role
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: _buildMenuItems(context, user),
            ),
          ),

          // Logout button at the bottom
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context, User user) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // University logo and name
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF6B00), // Orange color for logo
                ),
              ),
              const SizedBox(width: 8),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  Text(
                    'University',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  List<Widget> _buildMenuItems(BuildContext context, User user) {
    final menuItems = <Widget>[];

    // Common menu items for all roles
    menuItems.addAll([
      _buildMenuItem(
        context,
        title: 'Bosh sahifa',
        icon: Icons.home,
        route: '/dashboard',
      ),
    ]);

    // Role-specific menu items
    if (user.role == UserRole.admin) {
      menuItems.addAll([
        _buildMenuItem(
          context,
          title: 'Moderatorlar',
          icon: Icons.verified_user,
          route: '/moderators',
        ),
        _buildMenuItem(
          context,
          title: 'O\'qituvchilar',
          icon: Icons.school,
          route: '/teachers',
        ),
        _buildMenuItem(
          context,
          title: 'Yo\'nalishlar',
          icon: Icons.directions,
          route: '/directions',
        ),
        _buildMenuItem(
          context,
          title: 'Fanlar',
          icon: Icons.book,
          route: '/subjects',
        ),
        _buildMenuItem(
          context,
          title: 'Testlar',
          icon: Icons.quiz,
          route: '/tests',
        ),
        _buildMenuItem(
          context,
          title: 'Variant yaratish',
          icon: Icons.create,
          route: '/create-variant',
        ),
        _buildMenuItem(
          context,
          title: 'Sozlamalar',
          icon: Icons.settings,
          route: '/settings',
        ),
      ]);
    } else if (user.role == UserRole.moderator) {
      menuItems.addAll([
        _buildMenuItem(
          context,
          title: 'Test tekshirish',
          icon: Icons.check_circle,
          route: '/test-review',
        ),
        _buildMenuItem(
          context,
          title: 'O\'qituvchilar',
          icon: Icons.school,
          route: '/teachers',
        ),
        _buildMenuItem(
          context,
          title: 'Testlar',
          icon: Icons.quiz,
          route: '/tests',
        ),
        _buildMenuItem(
          context,
          title: 'Sozlamalar',
          icon: Icons.settings,
          route: '/settings',
        ),
      ]);
    } else if (user.role == UserRole.teacher) {
      menuItems.addAll([
        _buildMenuItem(
          context,
          title: 'Testlar',
          icon: Icons.quiz,
          route: '/tests',
        ),
        _buildMenuItem(
          context,
          title: 'Variant yaratish',
          icon: Icons.create,
          route: '/create-variant',
        ),
        _buildMenuItem(
          context,
          title: 'Sozlamalar',
          icon: Icons.settings,
          route: '/settings',
        ),
      ]);
    }

    return menuItems;
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String route,
  }) {
    final isSelected = currentRoute == route;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        dense: true,
        visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
        leading: Icon(
          icon,
          color: isSelected ? Colors.white : const Color(0xFF6B7280),
          size: 20,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF1F2937),
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
        selected: isSelected,
        onTap: () {
          if (currentRoute != route) {
            Navigator.of(context).pushReplacementNamed(route);
          }
          // Drawer yopilmasligi uchun Navigator.pop() qismini olib tashladik
        },
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          const Divider(),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
            child: ListTile(
              dense: true,
              visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
              leading: const Icon(
                Icons.logout,
                color: Colors.red,
                size: 20,
              ),
              title: const Text(
                'Chiqish',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Tizimdan chiqish'),
                    content: const Text(
                      'Haqiqatan ham tizimdan chiqmoqchimisiz?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Bekor qilish'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Dialog oynasini yopish
                          Navigator.of(context).pop();

                          // Logout qilish va login sahifasiga o'tish
                          final navigator = Navigator.of(context);
                          Provider.of<AuthProvider>(context, listen: false)
                              .logout()
                              .then((_) {
                            navigator.pushReplacementNamed('/login');
                          });
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: const Text('Chiqish'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
