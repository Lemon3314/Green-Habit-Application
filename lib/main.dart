import 'package:flutter/material.dart';
import 'pages/main_screen.dart';

void main() {
  runApp(const OctalysisGreenApp());
}

class OctalysisGreenApp extends StatelessWidget {
  const OctalysisGreenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: ThemeData(
    useMaterial3: true,

    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF087F5B),
      brightness: Brightness.light,
    ),

    scaffoldBackgroundColor:
        const Color(0xFFF7FAF8),

    cardTheme: const CardThemeData(
      elevation: 0,
      margin: EdgeInsets.zero,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
        borderSide: BorderSide.none,
      ),
    ),

    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  ),

  home: const MainScreen(),
);
  }
}