import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:variant_master/pages/tests_list_page.dart';
import 'models/test_model.dart';
import 'models/variant_model.dart';
import 'pages/add_test_page.dart';
import 'pages/create_variant_page.dart';
import 'pages/saved_variants_page.dart';
import 'pages/settings_page.dart';
import 'pages/about_page.dart';
import 'pages/home_page.dart';
import 'database/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Настройка статус бара
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Инициализация базы данных
  await DatabaseHelper().database;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Мастер Тестов',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.green,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
      ),
      home: const App(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/add_test': (context) => const AddTestPage(),
        '/test_list': (context) => const TestsListPage(),
        '/create_variant': (context) => const CreateVariantPage(),
        '/saved_variants': (context) => const SavedVariantsPage(),
        '/settings': (context) => const SettingsPage(),
        '/about': (context) => const AboutPage(),
      },
    );
  }
}

class App extends StatefulWidget {
  const App({super.key});
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _pages = const [
    HomePage(),
    AddTestPage(),
    TestsListPage(),
    CreateVariantPage(),
    SavedVariantsPage(),
    SettingsPage(),
    AboutPage(),
  ];

  final List<String> _titles = [
    "Главная страница",
    "Добавить новый тест",
    "Список тестов",
    "Создать вариант",
    "Сохраненные варианты",
    "Настройки",
    "О приложении",
  ];

  void _onDrawerItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Закрываем drawer
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: _selectedIndex == 0 ? false : true,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            // Простой и элегантный header
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 12,
                bottom: 16,
                left: 16,
                right: 16,
              ),
              child: Row(
                children: [
                  // Иконка приложения
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.quiz,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Информация о приложении
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Мастер Тестов',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Создавайте тесты легко',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Разделитель
            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              color: Colors.grey.shade200,
            ),
            // Остальное содержимое drawer
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildDrawerItem(
                    icon: Icons.home_outlined,
                    selectedIcon: Icons.home,
                    title: "Главная страница",
                    isSelected: _selectedIndex == 0,
                    onTap: () => _onDrawerItemTap(0),
                  ),
                  _buildDrawerItem(
                    icon: Icons.add_circle_outline,
                    selectedIcon: Icons.add_circle,
                    title: "Добавить новый тест",
                    isSelected: _selectedIndex == 1,
                    onTap: () => _onDrawerItemTap(1),
                  ),
                  _buildDrawerItem(
                    icon: Icons.list_alt_outlined,
                    selectedIcon: Icons.list_alt,
                    title: "Список тестов",
                    isSelected: _selectedIndex == 2,
                    onTap: () => _onDrawerItemTap(2),
                  ),
                  _buildDrawerItem(
                    icon: Icons.shuffle_outlined,
                    selectedIcon: Icons.shuffle,
                    title: "Создать вариант",
                    isSelected: _selectedIndex == 3,
                    onTap: () => _onDrawerItemTap(3),
                  ),
                  _buildDrawerItem(
                    icon: Icons.picture_as_pdf_outlined,
                    selectedIcon: Icons.picture_as_pdf,
                    title: "Сохраненные варианты",
                    isSelected: _selectedIndex == 4,
                    onTap: () => _onDrawerItemTap(4),
                  ),
                  const Divider(height: 32, thickness: 1),
                  _buildDrawerItem(
                    icon: Icons.settings_outlined,
                    selectedIcon: Icons.settings,
                    title: "Настройки",
                    isSelected: _selectedIndex == 5,
                    onTap: () => _onDrawerItemTap(5),
                  ),
                  _buildDrawerItem(
                    icon: Icons.info_outline,
                    selectedIcon: Icons.info,
                    title: "О приложении",
                    isSelected: _selectedIndex == 6,
                    onTap: () => _onDrawerItemTap(6),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required IconData selectedIcon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      decoration: BoxDecoration(
        color: isSelected ? Colors.green.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(
          isSelected ? selectedIcon : icon,
          color: isSelected ? Colors.green : Colors.grey.shade600,
          size: 22,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.green : Colors.grey.shade800,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        minLeadingWidth: 32,
        horizontalTitleGap: 8,
      ),
    );
  }
}
