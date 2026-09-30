import 'package:flutter/material.dart';

enum AppThemeMode { light, dark, blue, pink }

/// 頂部 SliverAppBar 漸層配色結構
class HeaderColorSet {
  final Color primary;
  final Color secondary;

  const HeaderColorSet({
    required this.primary,
    required this.secondary,
  });
}

class AppTheme {
  static String getThemeName(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return '經典白';
      case AppThemeMode.dark:
        return '深邃黑';
      case AppThemeMode.blue:
        return '湛海洋';
      case AppThemeMode.pink:
        return '浪漫粉';
    }
  }

  static Color getThemePrimaryColor(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return const Color(0xFF087F5B);
      case AppThemeMode.dark:
        return const Color(0xFF20C997);
      case AppThemeMode.blue:
        return const Color(0xFF1971C2);
      case AppThemeMode.pink:
        return const Color(0xFFD6336C);
    }
  }

  /// 根據「主題」與「分頁索引 (0~4)」取得對應的 Header 漸層色彩
  static HeaderColorSet getHeaderColors(AppThemeMode mode, int tabIndex) {
    switch (mode) {
      case AppThemeMode.light:
        return _lightHeaderColors[tabIndex % 5];
      case AppThemeMode.pink:
        return _pinkHeaderColors[tabIndex % 5];
      case AppThemeMode.blue:
        return _blueHeaderColors[tabIndex % 5];
      case AppThemeMode.dark:
        return _darkHeaderColors[tabIndex % 5];
    }
  }

  // ⚪ 經典白配色 (生機綠 / 湛藍 / 活力橘 / 森林綠 / 紫羅蘭)
  static const List<HeaderColorSet> _lightHeaderColors = [
    HeaderColorSet(primary: Color(0xFF087F5B), secondary: Color(0xFF20C997)),
    HeaderColorSet(primary: Color(0xFF1971C2), secondary: Color(0xFF339AF0)),
    HeaderColorSet(primary: Color(0xFFE67700), secondary: Color(0xFFFFC107)),
    HeaderColorSet(primary: Color(0xFF2B8A3E), secondary: Color(0xFF69DB7C)),
    HeaderColorSet(primary: Color(0xFF7048E8), secondary: Color(0xFF9775FA)),
  ];
  
  // 🌑 深邃黑配色 (高對比霓虹黑夜漸層)
  static const List<HeaderColorSet> _darkHeaderColors = [
    HeaderColorSet(primary: Color(0xFF0CA678), secondary: Color(0xFF12B886)),
    HeaderColorSet(primary: Color(0xFF1C7ED6), secondary: Color(0xFF339AF0)),
    HeaderColorSet(primary: Color(0xFFF59F00), secondary: Color(0xFFFCC419)),
    HeaderColorSet(primary: Color(0xFF37B24D), secondary: Color(0xFF51CF66)),
    HeaderColorSet(primary: Color(0xFF7048E8), secondary: Color(0xFF845EF7)),
  ];

  // 🌸 浪漫粉配色 (櫻花粉 / 薰衣草紫 / 珊瑚金粉 / 莓果粉 / 優雅紫)
  static const List<HeaderColorSet> _pinkHeaderColors = [
    HeaderColorSet(primary: Color(0xFFE64980), secondary: Color(0xFFFF8787)),
    HeaderColorSet(primary: Color(0xFF9C36B5), secondary: Color(0xFFDA77F2)),
    HeaderColorSet(primary: Color(0xFFD6336C), secondary: Color(0xFFFCC2D7)),
    HeaderColorSet(primary: Color(0xFFAE3EC9), secondary: Color(0xFFF783AC)),
    HeaderColorSet(primary: Color(0xFF7048E8), secondary: Color(0xFFB197FC)),
  ];

  // 🟦 湛海洋配色 (湛藍 / 青碧藍 / 冰綠藍 / 深海藍 / 靛藍)
  static const List<HeaderColorSet> _blueHeaderColors = [
    HeaderColorSet(primary: Color(0xFF1971C2), secondary: Color(0xFF4DABF7)),
    HeaderColorSet(primary: Color(0xFF0C8599), secondary: Color(0xFF3BC9DB)),
    HeaderColorSet(primary: Color(0xFF1098AD), secondary: Color(0xFF66D9E8)),
    HeaderColorSet(primary: Color(0xFF0B7285), secondary: Color(0xFF15AABF)),
    HeaderColorSet(primary: Color(0xFF3B5BDB), secondary: Color(0xFF748FFC)),
  ];


  static ThemeData getThemeData(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return _buildTheme(
          brightness: Brightness.light,
          seedColor: const Color(0xFF087F5B),
          scaffoldBg: const Color(0xFFF7FAF8),
        );
      case AppThemeMode.dark:
        return _buildTheme(
          brightness: Brightness.dark,
          seedColor: const Color(0xFF20C997),
          scaffoldBg: const Color(0xFF121212),
        );
      case AppThemeMode.blue:
        return _buildTheme(
          brightness: Brightness.light,
          seedColor: const Color(0xFF1971C2),
          scaffoldBg: const Color(0xFFF0F4F8),
        );
      case AppThemeMode.pink:
        return _buildTheme(
          brightness: Brightness.light,
          seedColor: const Color(0xFFD6336C),
          scaffoldBg: const Color(0xFFFFF0F5),
        );
    }
  }

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color seedColor,
    required Color scaffoldBg,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBg,
      cardTheme: const CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide.none,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}