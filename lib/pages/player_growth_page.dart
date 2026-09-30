import 'package:flutter/material.dart';

import '../models/green_action.dart';

class PlayerGrowthPage extends StatelessWidget {
  final List<GreenAction> logs;

  const PlayerGrowthPage({
    super.key,
    required this.logs,
  });

  int get totalPoints {
    return logs.fold(
      0,
      (sum, log) => sum + log.earnedPoints,
    );
  }

  int get playerLevel {
    return (totalPoints ~/ 100) + 1;
  }

  @override
  Widget build(BuildContext context) {
    final currentLevelXP = totalPoints % 100;
    final progress = currentLevelXP / 100;

    return CustomScrollView(
      key: const PageStorageKey('player-page'),
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          sliver: SliverToBoxAdapter(
            child: _PlayerHero(
              level: playerLevel,
              totalPoints: totalPoints,
              progress: progress,
            ),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          sliver: SliverGrid(
            delegate: SliverChildListDelegate([
              _StatCard(
                icon: Icons.star_rounded,
                value: '$totalPoints',
                label: '總積分',
                color: Colors.amber,
              ),
              _StatCard(
                icon: Icons.eco_rounded,
                value: '${logs.length}',
                label: '完成行動',
                color: Colors.green,
              ),
            ]),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.25,
            ),
          ),
        ),

        const SliverPadding(
          padding: EdgeInsets.only(top: 28),
          sliver: SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '📖 歷史紀錄',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),

        if (logs.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  '目前還沒有紀錄，開始你的第一個環保行動吧！',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _HistoryCard(
                      log: logs[index],
                    ),
                  );
                },
                childCount: logs.length,
              ),
            ),
          ),
      ],
    );
  }
}

class _PlayerHero extends StatelessWidget {
  final int level;
  final int totalPoints;
  final double progress;

  const _PlayerHero({
    required this.level,
    required this.totalPoints,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF7048E8),
            Color(0xFF9775FA),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 36,
            backgroundColor: Colors.white24,
            child: Icon(
              Icons.person_rounded,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'PLAYER',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Level $level',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$totalPoints XP',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(
                      begin: 0,
                      end: progress,
                    ),
                    duration:
                        const Duration(milliseconds: 900),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return LinearProgressIndicator(
                        value: value,
                        minHeight: 7,
                        backgroundColor: Colors.white24,
                        color: Colors.white,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 28,
              color: color,
            ),
            const SizedBox(height: 7),
            Text(
              value,
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final GreenAction log;

  const _HistoryCard({
    required this.log,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),
        leading: const CircleAvatar(
          backgroundColor: Colors.green,
          child: Icon(
            Icons.eco_rounded,
            color: Colors.white,
          ),
        ),
        title: Text(
          log.action,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            '${log.emotion}\n'
            '${log.timestamp.year}/'
            '${log.timestamp.month}/'
            '${log.timestamp.day}\n'
            '${log.reflection}',
          ),
        ),
        trailing: Text(
          '+${log.earnedPoints} XP',
          style: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.w800,
          ),
        ),
        isThreeLine: true,
      ),
    );
  }
}