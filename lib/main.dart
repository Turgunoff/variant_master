import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:variant_master/pages/tests_list_page.dart';
import 'models/test_model.dart';
import 'models/variant_model.dart';
import 'pages/add_test_page.dart';
import 'pages/create_variant_page.dart';
import 'pages/saved_variants_page.dart';
import 'pages/settings_page.dart';
import 'pages/about_page.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TestModelAdapter());
  Hive.registerAdapter(VariantModelAdapter());
  await Hive.openBox<TestModel>('tests');
  await Hive.openBox<VariantModel>('variants');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Variant Master',
      theme: ThemeData(
        brightness: Brightness.light, // Dark mode
        primarySwatch: Colors.blue,
        useMaterial3: true,
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
    "Bosh sahifa",
    "Yangi test qo'shish",
    "Testlar ro'yxati",
    "Variant yaratish",
    "Saqlangan variantlar",
    "Sozlamalar",
    "Ilova haqida (Variant Master)",
  ];

  void _onDrawerItemTap(int index) {
    setState(() {
      _selectedIndex = index;
      Navigator.pop(context); // Drawer'ni yopish
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_selectedIndex])),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Center(
                child: Image.asset(
                  color: Colors.white,
                  'assets/logo/logo.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Bosh sahifa"),
              onTap: () => _onDrawerItemTap(0),
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text("Yangi test qo'shish"),
              onTap: () => _onDrawerItemTap(1),
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text("Testlar ro'yxati"),
              onTap: () => _onDrawerItemTap(2),
            ),
            ListTile(
              leading: const Icon(Icons.shuffle),
              title: const Text("Variant yaratish"),
              onTap: () => _onDrawerItemTap(3),
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text("Saqlangan variantlar"),
              onTap: () => _onDrawerItemTap(4),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Sozlamalar"),
              onTap: () => _onDrawerItemTap(5),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text("Ilova haqida"),
              onTap: () => _onDrawerItemTap(6),
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
