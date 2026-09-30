import 'package:flutter/material.dart';
import '../models/green_action.dart'; //[cite: 2]
import '../widgets/action_page/ambient_particle_painter.dart';
import '../widgets/action_page/pet_bento_card.dart';
import '../widgets/action_page/emotion_cloud_card.dart';

class ActionPage extends StatefulWidget {
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
  State<ActionPage> createState() => _ActionPageState();
}

class _ActionPageState extends State<ActionPage> {
  // A+B 主題狀態 (預設海洋 Ocean 🐢)
  ActionThemeType _currentTheme = ActionThemeType.ocean;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CustomScrollView(
      key: const PageStorageKey('action-page'),
      physics: const BouncingScrollPhysics(),
      slivers: [
        // 頂部列：章節標題 + A/B 主題切換按鈕 (Theme Switcher Pill)
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          sliver: SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '永續綠色基地',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                    ),
                    Text(
                      '培育你的專屬綠色夥伴',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),

                // 主題切換軟膠囊按鈕 (A+B 切換)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      _ThemeToggleButton(
                        icon: Icons.water_drop_rounded,
                        label: '海洋',
                        isSelected: _currentTheme == ActionThemeType.ocean,
                        activeColor: const Color(0xFF1971C2),
                        onTap: () => setState(() => _currentTheme = ActionThemeType.ocean),
                      ),
                      _ThemeToggleButton(
                        icon: Icons.eco_rounded,
                        label: '森林',
                        isSelected: _currentTheme == ActionThemeType.forest,
                        activeColor: const Color(0xFF2B8A3E),
                        onTap: () => setState(() => _currentTheme = ActionThemeType.forest),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // 1. Bento Grid Hero 主卡片 (寵物狀態 + 常駐粒子)
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverToBoxAdapter(
            child: PetBentoCard(
              totalPoints: widget.totalPoints,
              currentTheme: _currentTheme,
            ),
          ),
        ),

        // 2. Bento Grid 非對稱雙格 (行動選擇 + 快速連霸統計)
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          sliver: SliverToBoxAdapter(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 行動下拉選擇 (占 1.8 比例)
                Expanded(
                  flex: 18,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: colorScheme.outlineVariant.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.eco_rounded, size: 18, color: colorScheme.primary),
                            const SizedBox(width: 6),
                            const Text(
                              '今日行動',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: widget.selectedAction,
                          isExpanded: true,
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          icon: Icon(Icons.keyboard_arrow_down_rounded, color: colorScheme.primary),
                          dropdownColor: colorScheme.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(16),
                          items: widget.actions
                              .map(
                                (action) => DropdownMenuItem(
                                  value: action,
                                  child: Text(action, overflow: TextOverflow.ellipsis),
                                ),
                              )
                              .toList(),
                          onChanged: widget.onActionChanged,
                          decoration: InputDecoration(
                            hintText: '點擊選擇...',
                            hintStyle: const TextStyle(fontSize: 12),
                            filled: true,
                            fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // 快速連霸統計 (占 1 比例)
                Expanded(
                  flex: 10,
                  child: Container(
                    height: 118,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.tertiaryContainer.withValues(alpha: 0.4),
                          colorScheme.surfaceContainerLow,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: colorScheme.tertiary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.local_fire_department_rounded, color: colorScheme.tertiary, size: 28),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.logs.length} 天',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: colorScheme.tertiary,
                          ),
                        ),
                        Text(
                          '連續打卡紀錄',
                          style: TextStyle(fontSize: 10, color: colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // 3. Bento Grid: 情緒覺察雲組件
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          sliver: SliverToBoxAdapter(
            child: EmotionCloudCard(
              emotions: widget.emotions,
              selectedEmotion: widget.selectedEmotion,
              onEmotionSelected: (val) => widget.onEmotionChanged(val),
            ),
          ),
        ),

        // 4. 反思框與開關選項整合卡片
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          sliver: SliverToBoxAdapter(
            child: Container(
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
                        child: Icon(Icons.edit_note_rounded, size: 18, color: colorScheme.primary),
                      ),
                      const SizedBox(width: 10),
                      const Text('策略筆記與分享', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: widget.reflectionController,
                    maxLines: 2,
                    style: const TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: '寫下今天的收穫或挑戰...',
                      hintStyle: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                      contentPadding: const EdgeInsets.all(14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: const Text('承認失敗並重新出發', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    subtitle: const Text('獲得韌性加分 (+15 XP)', style: TextStyle(fontSize: 11)),
                    value: widget.isRestart,
                    onChanged: widget.onRestartChanged,
                  ),
                  Divider(height: 1, color: colorScheme.outlineVariant.withValues(alpha: 0.2)),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: const Text('匿名分享至班級共好牆', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    value: widget.isAnonymous,
                    onChanged: widget.onAnonymousChanged,
                  ),
                ],
              ),
            ),
          ),
        ),

        // 5. 提交按鈕
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
          sliver: SliverToBoxAdapter(
            child: SizedBox(
              height: 54,
              child: FilledButton.icon(
                onPressed: widget.onSubmit,
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 2,
                ),
                icon: const Icon(Icons.rocket_launch_rounded),
                label: const Text('記錄行動，守護地球！', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// 主題切換按鈕小組件
class _ThemeToggleButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final Color activeColor;
  final VoidCallback onTap;

  const _ThemeToggleButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: isSelected ? Colors.white : Colors.grey),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}