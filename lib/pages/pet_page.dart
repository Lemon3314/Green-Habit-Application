import 'package:flutter/material.dart';

import '../models/green_action.dart';

class PetPage extends StatefulWidget {
  final List<GreenAction> logs;

  const PetPage({
    super.key,
    required this.logs,
  });

  @override
  State<PetPage> createState() => _PetPageState();
}

class _PetPageState extends State<PetPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  int get totalPoints {
    return widget.logs.fold(
      0,
      (sum, log) => sum + log.earnedPoints,
    );
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int level = 1;
    String petName = '海龜卵';
    String message = '繼續完成環保行動，等待孵化！';
    IconData petIcon = Icons.egg_rounded;
    Color petColor = Colors.grey;
    int nextLevelPoints = 30;

    if (totalPoints >= 300) {
      level = 4;
      petName = '海洋守護者';
      message = '你已經成為真正的海洋守護者！';
      petIcon = Icons.shield_rounded;
      petColor = Colors.deepPurple;
      nextLevelPoints = 300;
    } else if (totalPoints >= 100) {
      level = 3;
      petName = '健康海龜';
      message = '海龜已經能在潔淨海洋中遨遊！';
      petIcon = Icons.pets_rounded;
      petColor = Colors.blue;
      nextLevelPoints = 300;
    } else if (totalPoints >= 30) {
      level = 2;
      petName = '小海龜';
      message = '小海龜正在茁壯成長！';
      petIcon = Icons.pets_rounded;
      petColor = Colors.green;
      nextLevelPoints = 100;
    }

    double progress;

    if (level == 4) {
      progress = 1;
    } else if (level == 1) {
      progress = totalPoints / 30;
    } else if (level == 2) {
      progress = (totalPoints - 30) / 70;
    } else {
      progress = (totalPoints - 100) / 200;
    }

    progress = progress.clamp(0.0, 1.0);

    return CustomScrollView(
      key: const PageStorageKey('pet-page'),
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          sliver: SliverToBoxAdapter(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final scale =
                    1 + (_controller.value * 0.025);

                return Transform.scale(
                  scale: scale,
                  child: child,
                );
              },
              child: _PetHero(
                petIcon: petIcon,
                petColor: petColor,
                petName: petName,
                message: message,
                level: level,
              ),
            ),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          sliver: SliverToBoxAdapter(
            child: _GrowthCard(
              progress: progress,
              totalPoints: totalPoints,
              nextLevelPoints: nextLevelPoints,
              level: level,
              color: petColor,
            ),
          ),
        ),

        const SliverPadding(
          padding: EdgeInsets.only(top: 24),
          sliver: SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '🌱 如何培養寵物？',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const _GuideCard(
                icon: Icons.eco_rounded,
                color: Colors.green,
                title: '完成環保行動',
                subtitle: '每次行動可以獲得經驗值。',
              ),
              const _GuideCard(
                icon: Icons.edit_note_rounded,
                color: Colors.blue,
                title: '完成反思紀錄',
                subtitle: '透過反思獲得額外積分。',
              ),
              const _GuideCard(
                icon: Icons.emoji_events_rounded,
                color: Colors.amber,
                title: '解鎖成就',
                subtitle: '持續累積成就，成為地球守護者。',
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

class _PetHero extends StatelessWidget {
  final IconData petIcon;
  final Color petColor;
  final String petName;
  final String message;
  final int level;

  const _PetHero({
    required this.petIcon,
    required this.petColor,
    required this.petName,
    required this.message,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            petColor.withValues(alpha: 0.16),
            petColor.withValues(alpha: 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 70,
            backgroundColor:
                petColor.withValues(alpha: 0.14),
            child: Icon(
              petIcon,
              size: 80,
              color: petColor,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            petName,
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.w900,
              color: petColor,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'LEVEL $level',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _GrowthCard extends StatelessWidget {
  final double progress;
  final int totalPoints;
  final int nextLevelPoints;
  final int level;
  final Color color;

  const _GrowthCard({
    required this.progress,
    required this.totalPoints,
    required this.nextLevelPoints,
    required this.level,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context)
          .colorScheme
          .surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '寵物成長進度',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 18),
            TweenAnimationBuilder<double>(
              tween: Tween(
                begin: 0,
                end: progress,
              ),
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: value,
                    minHeight: 12,
                    color: color,
                    backgroundColor:
                        color.withValues(alpha: 0.12),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            Text(
              '$totalPoints XP',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              level == 4
                  ? '🎉 已達到最高階段！'
                  : '下一階段目標：$nextLevelPoints 點',
            ),
          ],
        ),
      ),
    );
  }
}

class _GuideCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  const _GuideCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 5,
        ),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.12),
          child: Icon(
            icon,
            color: color,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
      ),
    );
  }
}