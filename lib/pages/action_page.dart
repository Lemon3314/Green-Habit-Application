import 'package:flutter/material.dart';

import '../models/green_action.dart';

class ActionPage extends StatelessWidget {
  final List<GreenAction> logs;
  final int totalPoints;

  final List<String> actions;
  final List<String> emotions;

  final String? selectedAction;
  final String? selectedEmotion;

  final bool isRestart;
  final bool isAnonymous;

  final TextEditingController reflectionController;

  final ValueChanged<String?> onActionChanged;
  final ValueChanged<String?> onEmotionChanged;
  final ValueChanged<bool> onRestartChanged;
  final ValueChanged<bool> onAnonymousChanged;

  final VoidCallback onSubmit;

  const ActionPage({
    super.key,
    required this.logs,
    required this.totalPoints,
    required this.actions,
    required this.emotions,
    required this.selectedAction,
    required this.selectedEmotion,
    required this.isRestart,
    required this.isAnonymous,
    required this.reflectionController,
    required this.onActionChanged,
    required this.onEmotionChanged,
    required this.onRestartChanged,
    required this.onAnonymousChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      key: const PageStorageKey('action-page'),
      physics: const BouncingScrollPhysics(),
      slivers: [
        const SliverPadding(
          padding: EdgeInsets.only(top: 18),
          sliver: SliverToBoxAdapter(
            child: _SectionTitle(
              title: '我的永續羈絆',
              subtitle: '今天也讓你的綠色夥伴成長一點點。',
              icon: Icons.pets_rounded,
            ),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          sliver: SliverToBoxAdapter(
            child: _PetCard(totalPoints: totalPoints),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
          sliver: SliverToBoxAdapter(
            child: _buildActionCard(context),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          sliver: SliverToBoxAdapter(
            child: _buildEmotionCard(context),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          sliver: SliverToBoxAdapter(
            child: _buildReflectionCard(context),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          sliver: SliverToBoxAdapter(
            child: _buildOptionsCard(context),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
          sliver: SliverToBoxAdapter(
            child: SizedBox(
              height: 56,
              child: FilledButton.icon(
                onPressed: onSubmit,
                icon: const Icon(Icons.rocket_launch_rounded),
                label: const Text(
                  '記錄行動，守護地球！',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context) {
    return _ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardHeader(
            icon: Icons.eco_rounded,
            title: '今日永續行動',
            subtitle: '選擇你今天完成的綠色行動',
          ),
          const SizedBox(height: 18),
          DropdownButtonFormField<String>(
            initialValue: selectedAction,
            items: actions
                .map(
                  (action) => DropdownMenuItem(
                    value: action,
                    child: Text(action),
                  ),
                )
                .toList(),
            onChanged: onActionChanged,
            decoration: InputDecoration(
              hintText: '選擇一項行動...',
              filled: true,
              fillColor: Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest
                  .withValues(alpha: 0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          //const SizedBox(height: 18)
        ],
      ),
    );
  }

  Widget _buildEmotionCard(BuildContext context) {
    return _ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardHeader(
            icon: Icons.mood_rounded,
            title: '情緒覺察',
            subtitle: '記錄完成行動時的感受',
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: emotions.map((emotion) {
              final selected = selectedEmotion == emotion;

              return ChoiceChip(
                label: Text(emotion),
                selected: selected,
                onSelected: (value) {
                  if (value) {
                    onEmotionChanged(emotion);
                  }
                },
                avatar: Icon(
                  selected
                      ? Icons.check_rounded
                      : Icons.mood_rounded,
                  size: 18,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildReflectionCard(BuildContext context) {
    return _ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardHeader(
            icon: Icons.edit_note_rounded,
            title: '策略與反思',
            subtitle: '寫下今天的心得，讓行動變得更有意義',
          ),
          const SizedBox(height: 16),
          TextField(
            controller: reflectionController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: '遇到什麼困難？下次可以怎麼做？',
              filled: true,
              fillColor: Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest
                  .withValues(alpha: 0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsCard(BuildContext context) {
    return _ModernCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          SwitchListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 4,
            ),
            secondary: const CircleAvatar(
              child: Icon(Icons.restart_alt_rounded),
            ),
            title: const Text(
              '重新開始',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text(
              '承認失敗並重新出發，獲得韌性加分',
            ),
            value: isRestart,
            onChanged: onRestartChanged,
          ),
          const Divider(height: 1),
          SwitchListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 4,
            ),
            secondary: const CircleAvatar(
              child: Icon(Icons.visibility_off_rounded),
            ),
            title: const Text(
              '匿名分享',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text(
              '匿名分享至班級共好牆',
            ),
            value: isAnonymous,
            onChanged: onAnonymousChanged,
          ),
        ],
      ),
    );
  }
}

class _PetCard extends StatelessWidget {
  final int totalPoints;

  const _PetCard({
    required this.totalPoints,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    String stage;
    String message;

    if (totalPoints < 30) {
      icon = Icons.egg_rounded;
      color = Colors.grey;
      stage = '海龜卵';
      message = '還差一點點就能孵化囉！';
    } else if (totalPoints < 100) {
      icon = Icons.pets_rounded;
      color = Colors.green;
      stage = '小海龜';
      message = '小海龜正在因你的行動而茁壯！';
    } else {
      icon = Icons.pets_rounded;
      color = Colors.blue;
      stage = '健康海龜';
      message = '太棒了！你養育了一隻健康海龜！';
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.14),
            color.withValues(alpha: 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: color.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 38,
            backgroundColor: color.withValues(alpha: 0.15),
            child: Icon(
              icon,
              size: 42,
              color: color,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stage,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w800,
                    fontSize: 19,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$totalPoints XP',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
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

class _ModernCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _ModernCard({
    required this.child,
    this.padding = const EdgeInsets.all(18),
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _CardHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 21,
          child: Icon(icon, size: 21),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _SectionTitle({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant,
                    fontSize: 12,
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