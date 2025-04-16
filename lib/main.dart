import 'dart:io';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'app.dart'; // Yoki sizning asosiy vidjet faylingiz

Future<void> main() async { // <--- async bo'lishi SHART
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized(); // <--- await bo'lishi SHART

    WindowOptions windowOptions = const WindowOptions(
      size: Size(1280, 720),
      minimumSize: Size(1280, 720),
      center: true,
      title: 'Test Master',
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async { // <--- async callback
      await windowManager.show();
      await windowManager.focus();
      print('--- Setting prevent close ---'); // <-- DEBUG UCHUN PRINT
      await windowManager.setPreventClose(true); // <--- await va MUHIM!
      print('--- Prevent close set ---');   // <-- DEBUG UCHUN PRINT
    });
  }

  runApp(const App());
}