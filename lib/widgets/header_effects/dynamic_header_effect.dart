import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'bubble_effect.dart';
import 'cyber_particle_effect.dart';
import 'leaf_wave_effect.dart';
import 'sakura_effect.dart';

class DynamicHeaderEffect extends StatelessWidget {
  final AppThemeMode themeMode;

  const DynamicHeaderEffect({
    super.key,
    required this.themeMode,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
        return Stack(
          fit: StackFit.expand,
          children: <Widget>[
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        );
      },
      child: _buildEffectWidget(),
    );
  }

  Widget _buildEffectWidget() {
    switch (themeMode) {
      case AppThemeMode.pink:
        return const SakuraEffect(key: ValueKey('pink_sakura'));
      case AppThemeMode.dark:
        return const CyberParticleEffect(key: ValueKey('dark_cyber'));
      case AppThemeMode.blue:
        return const BubbleEffect(key: ValueKey('blue_bubble'));
      case AppThemeMode.light:
        return const LeafWaveEffect(key: ValueKey('light_leaf'));
    }
  }
}