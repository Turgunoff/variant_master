import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_manager/window_manager.dart';

import 'package:variant_master/core/di/injection.dart';
import 'package:variant_master/core/router/app_router.dart'; // AppRouter importi
import 'package:variant_master/features/auth/bloc/auth_bloc.dart';

// main funksiyasi avvalgidek qoladi...
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure dependencies
  await configureDependencies();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();

    const WindowOptions windowOptions = WindowOptions(
      size: Size(1280, 720),
      minimumSize: Size(1280, 720),
      center: true,
      title: 'Test Master',
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
      await windowManager.setPreventClose(true);
    });
  }

  runApp(const MyApp());
}

// MyApp ni StatefulWidget ga o'zgartiramiz
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

// State klassiga WindowListener mixin'ini qo'shamiz
class _MyAppState extends State<MyApp> with WindowListener {
  // AppRouter instance'ini State ichida saqlaymiz
  late final AppRouter _appRouter;
  // AuthBloc'ni ham olish qulay bo'lishi uchun
  late final AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = getIt<AuthBloc>()..add(const AuthCheckRequested());
    _appRouter = AppRouter(_authBloc); // Routerni shu yerda yaratamiz

    // Listenerni qo'shamiz (faqat desktop uchun)
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      windowManager.addListener(this);
    }
  }

  @override
  void dispose() {
    // Listenerni olib tashlaymiz (faqat desktop uchun)
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      windowManager.removeListener(this);
    }
    _authBloc.close(); // BLoC'ni yopish yaxshi amaliyot
    super.dispose();
  }

  // Oyna yopilish hodisasi (logika shu yerga ko'chirildi)
  @override
  void onWindowClose() async {
    // Routerdan navigator contextini olamiz
    final context =
        _appRouter.router.routerDelegate.navigatorKey.currentContext;

    if (context != null && context.mounted) {
      final bool shouldClose = await showDialog<bool>(
            // <bool> ni qo'shish yaxshi
            context: context, // To'g'ri context ishlatildi
            builder: (context) => AlertDialog(
              title: const Text('Ilovadan chiqish'),
              content: const Text('Haqiqatan ham ilovadan chiqmoqchimisiz?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Bekor qilish'), // Yoki "Yo'q"
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: TextButton.styleFrom(
                    foregroundColor:
                        Colors.red, // Qizil rang yaxshi ajralib turadi
                  ),
                  child: const Text('Chiqish'), // Yoki "Ha"
                ),
              ],
            ),
          ) ??
          false; // Null qaytsa false deb olamiz

      if (shouldClose) {
        // Chiqish paytida foydalanuvchini tizimdan chiqaramiz
        _authBloc.add(const AuthLogoutRequested());
        await windowManager.destroy();
      }
    } else {
      if (kDebugMode) {
        print('Could not get context to show exit dialog.');
      }
      // Context topilmasa, balki to'g'ridan to'g'ri yopish kerakdir
      // await windowManager.destroy();
    }
  }

  @override
  Widget build(BuildContext context) {
    // AuthBloc allaqachon initState da yaratilgan, shuning uchun BlocProvider.value ishlatamiz
    // yoki MultiBlocProvider ni umuman olib tashlab, BlocProvider ni faqat kerak joyda ishlatamiz.
    // Hozircha MultiBlocProvider qoldiramiz, lekin create o'rniga .value yaxshiroq bo'lishi mumkin.
    // Yoki initState da yaratilgan _authBloc ni ishlatmasdan, avvalgidek qoldirish ham mumkin.
    // Keling, avvalgi kodga o'xshash qoldiramiz (garchi initState da yaratish samaraliroq):

    return MultiBlocProvider(
      providers: [
        // AuthBloc'ni initState'da yaratganimiz uchun, bu yerda qayta yaratish shart emas.
        // Lekin GoRouter'ga berish uchun context.read kerak bo'lishi mumkin.
        // Eng yaxshisi BlocProvider'ni MaterialApp ichiga qo'yish yoki Provider.value ishlatish.
        // Hozircha soddalik uchun avvalgi holatda qoldiramiz:
        BlocProvider<AuthBloc>.value(
          value: _authBloc, // initState da yaratilgan instance'ni beramiz
        ),
        // Agar boshqa global Bloclar bo'lsa, shu yerga qo'shiladi
      ],
      // Builder endi shart emas, chunki _appRouter State'da mavjud
      child: MaterialApp.router(
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
        // Router konfiguratsiyasini _appRouter'dan olamiz
        routerConfig: _appRouter.router,
      ),
    );
  }
}

// Alohida WindowManagerListener klassi endi kerak emas va olib tashlanishi mumkin.
// class WindowManagerListener extends WindowListener { ... } // BU KERAK EMAS
