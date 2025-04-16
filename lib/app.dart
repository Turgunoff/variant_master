import 'dart:io'; // Platform uchun
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:flutter/services.dart'; // Bu kerak emas, chunki window_manager.destroy() ishlatamiz
import 'package:window_manager/window_manager.dart'; // WindowManager ni import qiling

import 'providers/auth_provider.dart';
import 'screens/dashboard_screen.dart';
import 'screens/login_screen.dart';
import 'screens/moderators_screen.dart';
import 'screens/teachers_screen.dart';
import 'screens/tests_screen.dart';
import 'screens/test_review_screen.dart';
import 'screens/directions_screen.dart';
import 'screens/subjects_screen.dart';
import 'screens/create_variant_screen.dart';
import 'screens/settings_screen.dart';

// Global navigator key MaterialApp va dialog uchun
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// App ni StatefulWidget ga o'zgartiramiz
class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

// State klassiga WindowListener ni qo'shamiz
class _AppState extends State<App> with WindowListener {
  @override
  void initState() {
    super.initState();
    // Faqat desktop platformalarda listener qo'shamiz
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      windowManager.addListener(this);
      // main.dart da setPreventClose(true) qilinganligiga ishonch hosil qiling
    }
  }

  @override
  void dispose() {
    // Listenerni olib tashlash
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      windowManager.removeListener(this);
    }
    super.dispose();
  }

  // Oyna yopilish hodisasi uchun metod (TO'G'RILANGAN QISM)
  @override
  void onWindowClose() async {
    // Navigator contextini olishga harakat qilamiz
    final navigatorContext = navigatorKey.currentContext;

    // Context mavjud va aktiv ekanligini tekshiramiz
    if (navigatorContext != null && navigatorContext.mounted) {
      final isConfirmed = await _showExitDialog(navigatorContext); // Dialog'ni NAVIGATOR contexti bilan chaqiramiz
      if (isConfirmed) {
        await windowManager.destroy(); // Ilovani yopamiz
      }
    } else {
      // Agar biror sabab bilan navigator contexti topilmasa
      print('Error: Could not get navigator context to show exit dialog.');
      // Bu yerda, masalan, ilovani baribir yopish mumkin:
      // await windowManager.destroy();
    }
  }

  // Ilovadan chiqish dialogini ko'rsatish funksiyasi (o'zgarishsiz)
  Future<bool> _showExitDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Ilovadan chiqish'),
            content: const Text('Haqiqatan ham ilovadan chiqmoqchimisiz?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false), // false qaytaradi
                child: const Text('Yo\'q'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true), // true qaytaradi
                child: const Text('Ha'),
              ),
            ],
          ),
        ) ??
        false; // Agar dialog biror sabab bilan yopilsa, false qaytaradi
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          // PopScope endi bu yerda kerak emas (avvalgi javobga ko'ra olib tashlangan)
          return MaterialApp(
            title: 'Test Master',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: const Color(0xFF2563EB),
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF2563EB),
                primary: const Color(0xFF2563EB),
                brightness: Brightness.light,
              ),
              useMaterial3: true,
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF2563EB),
                foregroundColor: Colors.white,
                elevation: 0,
                iconTheme: IconThemeData(opacity: 0.0),
              ),
              brightness: Brightness.light,
            ),
            initialRoute:
                authProvider.isAuthenticated ? '/dashboard' : '/login',
            navigatorKey: navigatorKey, // <<< Bu muhim, context olish uchun
            routes: {
              '/login': (context) => const LoginScreen(),
              '/dashboard': (context) => const DashboardScreen(),
              '/moderators': (context) => const ModeratorsScreen(),
              '/teachers': (context) => const TeachersScreen(),
              '/tests': (context) => const TestsScreen(),
              '/test-review': (context) => const TestReviewScreen(),
              '/directions': (context) => const DirectionsScreen(),
              '/subjects': (context) => const SubjectsScreen(),
              '/create-variant': (context) => const CreateVariantScreen(),
              '/settings': (context) => const SettingsScreen(),
            },
            onGenerateRoute: (settings) {
              // Handle unknown routes
              return MaterialPageRoute(
                builder: (context) => Scaffold(
                  appBar: AppBar(
                    title: const Text('Sahifa topilmadi'),
                  ),
                  body: const Center(
                    child: Text('Kechirasiz, so\'ralgan sahifa mavjud emas.'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}