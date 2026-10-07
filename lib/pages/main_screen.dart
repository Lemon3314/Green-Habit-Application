import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../models/green_action.dart';
import '../theme/app_theme.dart';
import '../widgets/header_effects/dynamic_header_effect.dart';
import '../widgets/settings_dialog.dart';

import 'action_page.dart';
import 'community_page.dart';
import 'achievements_page.dart';
import 'pet_page.dart';
import 'player_growth_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final List<GreenAction> _logs = [];

  String? _selectedAction;
  String? _selectedEmotion;

  bool _isRestart = false;
  bool _isAnonymous = false;

  final TextEditingController _reflectionController =
      TextEditingController();

  final List<String> _actions = [
    '使用循環杯 (減少垃圾)',
    '永續餐盤/惜食 (減少剩食)',
    '落實垃圾分類 (資源再利用)',
  ];

  final List<String> _emotions = [
    'Proud (自豪)',
    'Frustrated (挫折)',
    'Calm (平靜)',
    'Motivated (充滿動力)',
  ];

  int _currentTab = 0;

  final List<_HeaderInfo> _headerInfos = const [
    _HeaderInfo(
      icon: Icons.eco_rounded,
      title: '今日綠色行動',
      subtitle: '每一個小小行動，都正在改變地球。',
    ),
    _HeaderInfo(
      icon: Icons.water_drop_rounded,
      title: '班級共好任務',
      subtitle: '一起累積綠色能量，完成班級史詩任務。',
    ),
    _HeaderInfo(
      icon: Icons.emoji_events_rounded,
      title: '成就收藏',
      subtitle: '解鎖你的每一個綠色里程碑。',
    ),
    _HeaderInfo(
      icon: Icons.pets_rounded,
      title: '我的綠色夥伴',
      subtitle: '你的每一次行動，都讓牠逐漸成長。',
    ),
    _HeaderInfo(
      icon: Icons.star_rounded,
      title: '玩家成長',
      subtitle: '累積 XP，提升你的永續等級。',
    ),
  ];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 5,
      vsync: this,
    );

    _tabController.addListener(_handleTabChanged);
    _loadLogs();
  }

  void _handleTabChanged() {
    if (_currentTab != _tabController.index) {
      setState(() {
        _currentTab = _tabController.index;
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChanged);
    _tabController.dispose();
    _reflectionController.dispose();
    super.dispose();
  }

  Future<void> _loadLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? logsString = prefs.getString('green_logs_v1');

    if (logsString == null) return;

    final List<dynamic> decodedList = jsonDecode(logsString);

    if (!mounted) return;

    setState(() {
      _logs.addAll(
        decodedList.map((e) => GreenAction.fromJson(e)).toList(),
      );
    });
  }

  Future<void> _saveLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedList = jsonEncode(
      _logs.map((e) => e.toJson()).toList(),
    );
    await prefs.setString('green_logs_v1', encodedList);
  }

  int get totalPoints {
    return _logs.fold(0, (sum, log) => sum + log.earnedPoints);
  }

  void _submitAction() {
    if (_selectedAction == null ||
        _selectedEmotion == null ||
        _reflectionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: const Text('⚠️ 請完成行動選擇、情緒覺察與反思筆記！'),
        ),
      );
      return;
    }

    int points = 10;

    if (_reflectionController.text.trim().isNotEmpty) {
      points += 5;
    }

    if (_isRestart) {
      points += 15;
    }

    setState(() {
      _logs.insert(
        0,
        GreenAction(
          action: _selectedAction!,
          emotion: _selectedEmotion!,
          reflection: _reflectionController.text.trim(),
          isAnonymous: _isAnonymous,
          earnedPoints: points,
          timestamp: DateTime.now(),
        ),
      );

      _selectedAction = null;
      _selectedEmotion = null;
      _reflectionController.clear();
      _isRestart = false;
      _isAnonymous = false;
    });

    _saveLogs();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Text('🌱 紀錄成功！獲得 $points XP'),
      ),
    );

    _showSurpriseFeedback(points);
  }

  void _showSurpriseFeedback(int earnedPoints) {
    final List<String> facts = [
      '你知道嗎？你今天省下的一個塑膠杯，需要 400 年才能分解！',
      '太棒了！你的行動讓海洋少了一點負擔，海龜感謝你 🐢。',
      '承認失敗並重新開始，這就是心理韌性！為你的勇敢鼓掌！',
      '每一個微小的綠色行動，都在為未來的地球投票！',
      '你的反思讓這次行動變得更有意義，繼續保持覺察喔！',
    ];

    final randomFact = facts[Random().nextInt(facts.length)];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          title: Text('解鎖綠色成就 🎁 +$earnedPoints XP'),
          content: Text(
            randomFact,
            style: const TextStyle(height: 1.6),
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('繼續保持'),
            ),
          ],
        );
      },
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return SettingsDialog(
          currentMode: currentThemeNotifier.value,
          onThemeSelected: (newMode) {
            OctalysisGreenApp.changeTheme(newMode);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentThemeMode = currentThemeNotifier.value;
    final headerInfo = _headerInfos[_currentTab];
    final colorSet = AppTheme.getHeaderColors(currentThemeMode, _currentTab);

    return Scaffold(
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 240,
              toolbarHeight: 60,
              pinned: true,
              floating: false,
              elevation: 0,
              scrolledUnderElevation: 0,
              // 1. 修復關鍵：賦予收合時穩定的背景顏色，避免穿透崩塌
              backgroundColor: colorSet.primary,
              surfaceTintColor: Colors.transparent,
              automaticallyImplyLeading: false,
              titleSpacing: 20,
              title: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: Row(
                  key: ValueKey(_currentTab),
                  children: [
                    Icon(
                      headerInfo.icon,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'SDGs 永續習慣養成',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: IconButton.filledTonal(
                    onPressed: _showSettingsDialog,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.22),
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.settings_outlined, size: 22),
                    tooltip: '設定與使用說明',
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: _buildHeader(headerInfo, colorSet, currentThemeMode),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(58),
                child: _buildTabBar(),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            ActionPage(
              logs: _logs,
              totalPoints: totalPoints,
              actions: _actions,
              emotions: _emotions,
              selectedAction: _selectedAction,
              selectedEmotion: _selectedEmotion,
              isRestart: _isRestart,
              isAnonymous: _isAnonymous,
              reflectionController: _reflectionController,
              onActionChanged: (value) => setState(() => _selectedAction = value),
              onEmotionChanged: (value) => setState(() => _selectedEmotion = value),
              onRestartChanged: (value) => setState(() => _isRestart = value),
              onAnonymousChanged: (value) => setState(() => _isAnonymous = value),
              onSubmit: _submitAction,
            ),
            CommunityPage(logs: _logs),
            AchievementsPage(logs: _logs),
            PetPage(logs: _logs),
            PlayerGrowthPage(logs: _logs),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    _HeaderInfo headerInfo,
    HeaderColorSet colorSet,
    AppThemeMode currentThemeMode,
  ) {
    // 2. 修復關鍵：使用 ClipRect 確保收合高度減少時，內容不會超出或強行壓縮擠爆
    return ClipRect(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 動態漸層底色
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorSet.primary,
                  colorSet.secondary,
                ],
              ),
            ),
          ),

          // 特效層
          Positioned.fill(
            child: DynamicHeaderEffect(
              themeMode: currentThemeMode,
            ),
          ),

          // 上層標題與內文 (邊界與收合保護)
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 68),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 450),
                    child: _buildHeaderContent(headerInfo),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderContent(_HeaderInfo headerInfo) {
    return Column(
      key: ValueKey(headerInfo.title),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                headerInfo.icon,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              headerInfo.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          headerInfo.subtitle,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.88),
            fontSize: 13,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 10),
        _buildHeaderXP(),
      ],
    );
  }

  Widget _buildHeaderXP() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star_rounded,
            color: Colors.amber,
            size: 18,
          ),
          const SizedBox(width: 5),
          Text(
            '$totalPoints XP',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.center,
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
        indicator: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        labelColor: Theme.of(context).colorScheme.onPrimaryContainer,
        unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        tabs: const [
          Tab(icon: Icon(Icons.eco_rounded, size: 21), text: '行動'),
          Tab(icon: Icon(Icons.forum_rounded, size: 21), text: '共好牆'),
          Tab(icon: Icon(Icons.emoji_events_rounded, size: 21), text: '成就'),
          Tab(icon: Icon(Icons.pets_rounded, size: 21), text: '寵物'),
          Tab(icon: Icon(Icons.star_rounded, size: 21), text: '玩家'),
        ],
      ),
    );
  }
}

class _HeaderInfo {
  final IconData icon;
  final String title;
  final String subtitle;

  const _HeaderInfo({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}