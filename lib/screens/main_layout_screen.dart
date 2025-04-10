import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'dashboard_screen.dart';

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  // Track the selected navigation index
  int _selectedIndex = 0;

  // NavigationRail is always extended
  final bool _isExtended = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            // University logo
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(Icons.school, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            // University name
            const Text(
              'Profi University',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(width: 48),
            // Current page title
            Text(
              AppConstants.navigationItems[_selectedIndex].label,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
            ),
          ],
        ),
        actions: [
          // User profile button with dropdown
          PopupMenuButton<String>(
            offset: const Offset(0, 50),
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Admin', style: TextStyle(fontSize: 14)),
                    Text(
                      'Administrator',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout),
                        SizedBox(width: 8),
                        Text('Chiqish'),
                      ],
                    ),
                  ),
                ],
            onSelected: (value) {
              if (value == 'logout') {
                // Navigate back to login screen
                Navigator.of(
                  context,
                ).pushReplacementNamed(AppConstants.loginRoute);
              }
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Row(
        children: [
          // Navigation Rail for desktop
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(25),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(1, 0),
                ),
              ],
            ),
            child: _CustomNavigationRail(
              extended: _isExtended,
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              items: AppConstants.navigationItems,
            ),
          ),

          // Main content area
          Expanded(
            child: Container(
              color: const Color(0xFFF5F7FA),
              child: _buildPageContent(_selectedIndex),
            ),
          ),
        ],
      ),
    );
  }

  // Build the content for the selected page
  Widget _buildPageContent(int index) {
    final navigationItem = AppConstants.navigationItems[index];

    // Return the appropriate screen based on the selected index
    switch (index) {
      case 0: // Boshqaruv Paneli
        return const DashboardScreen();
      default:
        // For other screens, display a placeholder
        return Card(
          elevation: 2,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  navigationItem.icon,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Sahifa: ${navigationItem.label}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 24),
                Text(
                  'Bu yerda ${navigationItem.label.toLowerCase()} ma\'lumotlari ko\'rsatiladi',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        );
    }
  }
}

// Custom Navigation Rail with blue background for selected item
class _CustomNavigationRail extends StatelessWidget {
  final bool extended; // Always true now, but keeping for future flexibility
  final int selectedIndex;
  final Function(int) onDestinationSelected;
  final List<NavigationItem> items;

  const _CustomNavigationRail({
    required this.extended,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240, // Fixed width since menu is always extended
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Navigation items
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = index == selectedIndex;

                return InkWell(
                  onTap: () => onDestinationSelected(index),
                  child: Container(
                    height: 44,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected ? Color(0xFF2563EB) : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Icon
                        Icon(
                          item.icon,
                          color:
                              isSelected ? Colors.white : Colors.grey.shade600,
                        ),
                        const SizedBox(width: 16),
                        // Label
                        Text(
                          item.label,
                          style: TextStyle(
                            color:
                                isSelected
                                    ? Colors.white
                                    : Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
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
