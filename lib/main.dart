import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'theme.dart';
import 'screens/splash_screen.dart';
import 'services/settings_service.dart';

import '../game_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await gameController.init();

  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      size: Size(800, 600),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  await SettingsService.instance.init();

  runApp(const DuchessApp());
}

class DuchessApp extends StatelessWidget {
  const DuchessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lady in Training: 7 Days to Tea',
      debugShowCheckedModeBanner: false,
      theme: DuchessTheme.themeData,
      home: const SplashScreen(),
    );
  }
}
