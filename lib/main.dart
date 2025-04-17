import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_manager/window_manager.dart';

import 'package:variant_master/core/di/injection.dart';
import 'package:variant_master/core/router/app_router.dart';
import 'package:variant_master/features/auth/bloc/auth_bloc.dart';

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) =>
              getIt<AuthBloc>()..add(const AuthCheckRequested()),
        ),
      ],
      child: Builder(
        builder: (context) {
          final appRouter = AppRouter(context.read<AuthBloc>());
          return MaterialApp.router(
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
            routerConfig: appRouter.router,
          );
        },
      ),
    );
  }
}

// WindowManager listener for handling close events
class WindowManagerListener extends WindowListener {
  final BuildContext context;

  WindowManagerListener(this.context);

  @override
  void onWindowClose() async {
    final bool isPreventClose = await windowManager.isPreventClose();
    if (isPreventClose && context.mounted) {
      final bool shouldClose = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Ilovadan chiqish'),
          content: const Text('Haqiqatan ham ilovadan chiqmoqchimisiz?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Bekor qilish'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Chiqish'),
            ),
          ],
        ),
      );
      if (shouldClose) {
        await windowManager.destroy();
      }
    }
  }
}
