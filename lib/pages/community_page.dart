import 'package:flutter/material.dart';

import '../models/green_action.dart';

class CommunityPage extends StatelessWidget {
  final List<GreenAction> logs;

  const CommunityPage({
    super.key,
    required this.logs,
  });

  @override
  Widget build(BuildContext context) {
    final localPoints = logs.fold<int>(
      0,
      (sum, log) => sum + log.earnedPoints,
    );

    final simulatedClassPoints = 0 + localPoints;

    return CustomScrollView(
      key: const PageStorageKey('community-page'),
      physics: const BouncingScrollPhysics(),
      slivers: [
        const SliverPadding(
          padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
          sliver: SliverToBoxAdapter(
            child: Text(
              '🌊 班級共好牆',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverToBoxAdapter(
            child: _MissionCard(
              points: simulatedClassPoints,
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
                  '🌱 目前尚未有行動紀錄\n來成為第一個改變的人！',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final log = logs[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _CommunityCard(log: log),
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

class _MissionCard extends StatelessWidget {
  final int points;

  const _MissionCard({
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    const target = 1000;
    final progress = (points / target).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade50,
            Colors.cyan.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.water_drop_rounded,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  '班級史詩任務：淨化海洋',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '$points / $target XP',
            style: TextStyle(
              color: Colors.blue.shade800,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return LinearProgressIndicator(
                  value: value,
                  minHeight: 12,
                  backgroundColor: Colors.blue.shade100,
                  color: Colors.blue,
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Text(
            progress >= 1
                ? '🎉 恭喜全班！我們成功解鎖健康的海洋生態！'
                : '每一個人的紀錄，都在幫助我們更接近目標。',
            style: TextStyle(
              fontSize: 12,
              color: Colors.blueGrey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

class _CommunityCard extends StatelessWidget {
  final GreenAction log;

  const _CommunityCard({
    required this.log,
  });

  @override
  Widget build(BuildContext context) {
    final author = log.isAnonymous
        ? '🌱 匿名夥伴'
        : '綠色行動者';

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              child: Icon(
                log.isAnonymous
                    ? Icons.masks_rounded
                    : Icons.person_rounded,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$author · ${log.emotion}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    log.action,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '「${log.reflection}」',
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '+${log.earnedPoints}',
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}