import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/main_screen.dart';
import 'theme/app_theme.dart';

// 全域主題狀態控制器 (免套件)
final ValueNotifier<AppThemeMode> currentThemeNotifier =
    ValueNotifier<AppThemeMode>(AppThemeMode.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 讀取持久化儲存的主題
  final prefs = await SharedPreferences.getInstance();
  final savedThemeIndex = prefs.getInt('app_theme_mode_v1') ?? 0;
  if (savedThemeIndex < AppThemeMode.values.length) {
    currentThemeNotifier.value = AppThemeMode.values[savedThemeIndex];
  }

  runApp(const OctalysisGreenApp());
}

class OctalysisGreenApp extends StatelessWidget {
  const OctalysisGreenApp({super.key});

  static Future<void> changeTheme(AppThemeMode mode) async {
    currentThemeNotifier.value = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('app_theme_mode_v1', mode.index);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeMode>(
      valueListenable: currentThemeNotifier,
      builder: (context, themeMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.getThemeData(themeMode),
          home: const MainScreen(),
        );
      },
    );
  }
}