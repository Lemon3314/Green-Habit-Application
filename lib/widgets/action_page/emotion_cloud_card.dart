import 'package:flutter/material.dart';

class EmotionCloudCard extends StatelessWidget {
  final List<String> emotions;
  final String? selectedEmotion;
  final ValueChanged<String> onEmotionSelected;

  const EmotionCloudCard({
    super.key,
    required this.emotions,
    required this.selectedEmotion,
    required this.onEmotionSelected,
  });

  IconData _getEmotionIcon(String emotion) {
    if (emotion.contains('Proud') || emotion.contains('自豪')) return Icons.stars_rounded;
    if (emotion.contains('Frustrated') || emotion.contains('挫折')) return Icons.sentiment_dissatisfied_rounded;
    if (emotion.contains('Calm') || emotion.contains('平靜')) return Icons.spa_rounded;
    if (emotion.contains('Motivated') || emotion.contains('動力')) return Icons.local_fire_department_rounded;
    return Icons.mood_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: colorScheme.primaryContainer.withValues(alpha: 0.6),
                child: Icon(Icons.psychology_rounded, size: 18, color: colorScheme.primary),
              ),
              const SizedBox(width: 10),
              const Text(
                '情緒覺察覺知',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: emotions.map((emotion) {
              final isSelected = selectedEmotion == emotion;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                child: FilterChip(
                  showCheckmark: false,
                  avatar: Icon(
                    _getEmotionIcon(emotion),
                    size: 16,
                    color: isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                  ),
                  label: Text(emotion),
                  selected: isSelected,
                  selectedColor: colorScheme.primary,
                  backgroundColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  side: BorderSide(
                    color: isSelected ? colorScheme.primary : colorScheme.outlineVariant.withValues(alpha: 0.3),
                  ),
                  onSelected: (_) => onEmotionSelected(emotion),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}