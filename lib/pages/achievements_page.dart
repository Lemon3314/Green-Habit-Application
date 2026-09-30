import 'package:flutter/material.dart';

import '../models/green_action.dart';

class AchievementsPage extends StatelessWidget {
  final List<GreenAction> logs;

  const AchievementsPage({
    super.key,
    required this.logs,
  });

  int get totalPoints {
    return logs.fold(
      0,
      (sum, log) => sum + log.earnedPoints,
    );
  }

  @override
  Widget build(BuildContext context) {
    final achievements = [
      (
        title: '綠色新手',
        description: '完成第一次環保行動',
        icon: Icons.eco_rounded,
        unlocked: logs.isNotEmpty,
      ),
      (
        title: '環保小尖兵',
        description: '累積獲得 50 點',
        icon: Icons.star_rounded,
        unlocked: totalPoints >= 50,
      ),
      (
        title: '永續達人',
        description: '累積獲得 100 點',
        icon: Icons.emoji_events_rounded,
        unlocked: totalPoints >= 100,
      ),
      (
        title: '行動派',
        description: '完成 5 次環保行動',
        icon: Icons.directions_run_rounded,
        unlocked: logs.length >= 5,
      ),
      (
        title: '環保專家',
        description: '完成 10 次環保行動',
        icon: Icons.workspace_premium_rounded,
        unlocked: logs.length >= 10,
      ),
      (
        title: '地球守護者',
        description: '累積獲得 500 點',
        icon: Icons.public_rounded,
        unlocked: totalPoints >= 500,
      ),
    ];

    final unlockedCount =
        achievements.where((e) => e.unlocked).length;

    return CustomScrollView(
      key: const PageStorageKey('achievement-page'),
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    '🏆 我的成就',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  '$unlockedCount / ${achievements.length}',
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
          sliver: SliverToBoxAdapter(
            child: Text(
              '持續累積綠色行動，解鎖更多里程碑。',
              style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant,
              ),
            ),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final achievement = achievements[index];

                return _AchievementCard(
                  title: achievement.title,
                  description: achievement.description,
                  icon: achievement.icon,
                  unlocked: achievement.unlocked,
                );
              },
              childCount: achievements.length,
            ),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.82,
            ),
          ),
        ),

        const SliverPadding(
          padding: EdgeInsets.only(bottom: 40),
        ),
      ],
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool unlocked;

  const _AchievementCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.unlocked,
  });

  @override
  Widget build(BuildContext context) {
    final color = unlocked
        ? Colors.amber.shade700
        : Colors.grey;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: unlocked
            ? Colors.amber.withValues(alpha: 0.09)
            : Theme.of(context)
                .colorScheme
                .surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: unlocked
              ? Colors.amber.withValues(alpha: 0.25)
              : Theme.of(context)
                  .colorScheme
                  .outlineVariant
                  .withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedScale(
            scale: unlocked ? 1 : 0.85,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutBack,
            child: CircleAvatar(
              radius: 32,
              backgroundColor: color.withValues(alpha: 0.12),
              child: Icon(
                unlocked
                    ? icon
                    : Icons.lock_rounded,
                size: 34,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            unlocked ? '✓ 已解鎖' : '尚未解鎖',
            style: TextStyle(
              color: unlocked
                  ? Colors.green
                  : Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}