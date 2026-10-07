import 'package:flutter/material.dart';

class InstructionPage extends StatelessWidget {
  const InstructionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('使用說明與指南'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        physics: const BouncingScrollPhysics(),
        children: [
          _buildBannerCard(context),
          const SizedBox(height: 16),
          _buildInstructionCard(
            context,
            icon: Icons.star_rounded,
            iconColor: Colors.amber,
            title: '🌱 如何獲得 XP 經驗值',
            subtitle: '多種獎勵機制，鼓勵你踏出永續第一步',
            items: [
              _RuleItem(
                title: '基本行動紀錄',
                score: '+10 XP',
                description: '只要完成一次綠色行動（如使用循環杯、惜食等）即可獲得基礎經驗。',
              ),
              _RuleItem(
                title: '反思筆記加分',
                score: '+5 XP',
                description: '紀錄時填寫反思筆記與情緒覺察，深化行動意義即可獲得額外獎勵。',
              ),
              _RuleItem(
                title: '心理韌性重來加分',
                score: '+15 XP',
                description: '勾選「重新開始/失敗再嘗試」，展現面對挫折的勇敢韌性，給予高額鼓勵！',
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInstructionCard(
            context,
            icon: Icons.pets_rounded,
            iconColor: const Color(0xFF2B8A3E),
            title: '🐶 培養綠色夥伴 (寵物成長)',
            subtitle: '每一次的永續行動，都是寵物成長的養分',
            items: [
              _RuleItem(
                title: '累積 XP 升級',
                score: '提升 Level',
                description: '獲得的 XP 經驗值會同步挹注給你的綠色夥伴，幫助牠提升等級。',
              ),
              _RuleItem(
                title: '解鎖外貌與對話',
                score: '里程碑解鎖',
                description: '隨著等級提升，寵物會產生階段性成長變化，並解鎖專屬的陪伴互動對話。',
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInstructionCard(
            context,
            icon: Icons.water_drop_rounded,
            iconColor: const Color(0xFF1971C2),
            title: '🤝 班級共好任務',
            subtitle: '凝聚團體力量，一起完成史詩級願景',
            items: [
              _RuleItem(
                title: '全班經驗累計',
                score: '團體共好',
                description: '所有同學的行動 XP 都會匯入班級總能量池，共同邁向全班里程碑。',
              ),
              _RuleItem(
                title: '解鎖集體成就',
                score: '史詩稱號',
                description: '達成班級目標後，全班將獲得專屬的共好徽章與獎勵展現。',
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInstructionCard(
            context,
            icon: Icons.emoji_events_rounded,
            iconColor: const Color(0xFFE67700),
            title: '🏆 成就收藏系統',
            subtitle: '見證你的永續習慣養成之路',
            items: [
              _RuleItem(
                title: '個人里程碑徽章',
                score: '榮譽解鎖',
                description: '累積特定行動次數、反思篇數或總 XP 門檻，即可解鎖精美的個人成就徽章。',
              ),
              _RuleItem(
                title: '持續天數獎勵',
                score: '習慣養成',
                description: '保持持續紀錄的習慣，解鎖高階特殊勳章！',
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInstructionCard(
            context,
            icon: Icons.psychology_rounded,
            iconColor: const Color(0xFF7048E8),
            title: '🎭 情緒覺察與共好牆',
            subtitle: '內在覺察與社群正向互動',
            items: [
              _RuleItem(
                title: '紀錄當下情緒',
                score: '自我覺察',
                description: '在行動時記錄你的心情（自豪、挫折、平靜等），建立正向的心理習慣。',
              ),
              _RuleItem(
                title: '匿名/公開分享',
                score: '社群交流',
                description: '可選擇匿名發布至班級共好牆，互相給予靈感與鼓勵！',
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildBannerCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: colorScheme.primaryContainer.withValues(alpha: 0.5),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: colorScheme.primary,
              child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '歡迎來到 SDGs 永續習慣養成',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '透過每日小小的永續行動，積少成多，一起為地球與自己帶來正向改變！',
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required List<_RuleItem> items,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1),
            ),
            Column(
              children: items.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  item.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.secondaryContainer,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    item.score,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onSecondaryContainer,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.description,
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.35,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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

class _RuleItem {
  final String title;
  final String score;
  final String description;

  const _RuleItem({
    required this.title,
    required this.score,
    required this.description,
  });
}