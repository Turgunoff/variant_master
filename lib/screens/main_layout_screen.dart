import 'package:flutter/material.dart';
import '../utils/constants.dart';

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  // Track the selected navigation index
  int _selectedIndex = 0;

  // Control whether the NavigationRail is extended
  bool _isExtended = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.navigationItems[_selectedIndex].label),
        actions: [
          // Toggle for NavigationRail extension
          IconButton(
            icon: Icon(_isExtended ? Icons.menu_open : Icons.menu),
            onPressed: () {
              setState(() {
                _isExtended = !_isExtended;
              });
            },
            tooltip: _isExtended ? 'Menyuni yig\'ish' : 'Menyuni kengaytirish',
          ),

          // User profile button
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // Show user profile or logout options
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Profil'),
                      content: const Text('Tizimdan chiqishni xohlaysizmi?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Yo\'q'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate back to login screen
                            Navigator.pop(context);
                            Navigator.of(
                              context,
                            ).pushReplacementNamed(AppConstants.loginRoute);
                          },
                          child: const Text('Chiqish'),
                        ),
                      ],
                    ),
              );
            },
            tooltip: 'Profil',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(
        children: [
          // Navigation Rail for desktop
          NavigationRail(
            extended: _isExtended,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            minExtendedWidth: 200,
            destinations:
                AppConstants.navigationItems
                    .map(
                      (item) => NavigationRailDestination(
                        icon: Icon(item.icon),
                        label: Text(item.label),
                      ),
                    )
                    .toList(),
          ),

          // Main content area
          Expanded(
            child: Container(
              color: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withAlpha(25),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildPageContent(_selectedIndex),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build the content for the selected page
  Widget _buildPageContent(int index) {
    final navigationItem = AppConstants.navigationItems[index];

    // For now, just display a placeholder with the page name
    // In a real app, you would return different widgets based on the index
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
