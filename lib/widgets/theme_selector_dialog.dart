import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ThemeSelectorDialog extends StatelessWidget {
  final AppThemeMode currentMode;
  final ValueChanged<AppThemeMode> onThemeSelected;

  const ThemeSelectorDialog({
    super.key,
    required this.currentMode,
    required this.onThemeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: colorScheme.primaryContainer,
                  child: Icon(Icons.palette_rounded, size: 20, color: colorScheme.primary),
                ),
                const SizedBox(width: 12),
                const Text(
                  '選擇 App 主題風格',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.2,
              physics: const NeverScrollableScrollPhysics(),
              children: AppThemeMode.values.map((mode) {
                final isSelected = currentMode == mode;
                final themeColor = AppTheme.getThemePrimaryColor(mode);

                return InkWell(
                  onTap: () {
                    onThemeSelected(mode);
                    Navigator.pop(context);
                  },
                  borderRadius: BorderRadius.circular(18),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? themeColor.withValues(alpha: 0.15)
                          : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isSelected ? themeColor : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: themeColor,
                            shape: BoxShape.circle,
                          ),
                          child: isSelected
                              ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                              : null,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            AppTheme.getThemeName(mode),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isSelected ? themeColor : colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}