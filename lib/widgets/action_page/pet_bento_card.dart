import 'package:flutter/material.dart';
import 'ambient_particle_painter.dart';
import 'dart:math' as math;

class PetBentoCard extends StatefulWidget {
  final int totalPoints;
  final ActionThemeType currentTheme;

  const PetBentoCard({
    super.key,
    required this.totalPoints,
    required this.currentTheme,
  });

  @override
  State<PetBentoCard> createState() => _PetBentoCardState();
}

class _PetBentoCardState extends State<PetBentoCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ambientController;

  @override
  void initState() {
    super.initState();
    // 常駐粒子與呼吸脈動控制器
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _ambientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // A+B 主題細節對應
    final isOcean = widget.currentTheme == ActionThemeType.ocean;
    final primaryColor = isOcean ? const Color(0xFF1971C2) : const Color(0xFF2B8A3E);
    final secondaryColor = isOcean ? const Color(0xFF4DABF7) : const Color(0xFF69DB7C);

    // 夥伴狀態計算
    IconData petIcon;
    String petStage;
    String petQuote;
    double progress;

    if (widget.totalPoints < 30) {
      petIcon = isOcean ? Icons.egg_rounded : Icons.spa_rounded;
      petStage = isOcean ? '海龜卵孵化中' : '綠意幼苗萌芽中';
      petQuote = '今天的心意是最好營養！';
      progress = (widget.totalPoints / 30.0).clamp(0.0, 1.0);
    } else if (widget.totalPoints < 100) {
      petIcon = isOcean ? Icons.pets_rounded : Icons.forest_rounded;
      petStage = isOcean ? '小海龜茁壯中' : '小綠樹滋長中';
      petQuote = '感受到了！地球因你變得更好！';
      progress = ((widget.totalPoints - 30) / 70.0).clamp(0.0, 1.0);
    } else {
      petIcon = isOcean ? Icons.pets_rounded : Icons.park_rounded;
      petStage = isOcean ? '守護大海龜 👑' : '永續大樹 👑';
      petQuote = '太了不起了！你是永續大師！';
      progress = 1.0;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              primaryColor.withValues(alpha: 0.15),
              secondaryColor.withValues(alpha: 0.08),
            ],
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: primaryColor.withValues(alpha: 0.25),
            width: 1.5,
          ),
        ),
        child: Stack(
          children: [
            // 常駐背景粒子繪製器
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _ambientController,
                builder: (context, child) {
                  return CustomPainterWidget(
                    painter: AmbientParticlePainter(
                      animationValue: _ambientController.value,
                      themeType: widget.currentTheme,
                      primaryColor: primaryColor,
                    ),
                  );
                },
              ),
            ),

            // 卡片主要內容
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      // 常駐呼吸光暈圈頭像
                      AnimatedBuilder(
                        animation: _ambientController,
                        builder: (context, child) {
                          final breathScale =
                              1.0 + (0.05 * (1 + (0.5 - (0.5 - (0.5 * math.sin(_ambientController.value * 2 * math.pi))))));
                          return Transform.scale(
                            scale: breathScale,
                            child: Container(
                              width: 76,
                              height: 76,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colorScheme.surface,
                                boxShadow: [
                                  BoxShadow(
                                    color: primaryColor.withValues(alpha: 0.3),
                                    blurRadius: 16,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Icon(
                                petIcon,
                                size: 40,
                                color: primaryColor,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: Text(
                                petStage,
                                key: ValueKey('$petStage-${widget.currentTheme}'),
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 19,
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              petQuote,
                              style: TextStyle(
                                fontSize: 13,
                                color: colorScheme.onSurfaceVariant,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // 現代動態進度條
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '能量累積',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            '${widget.totalPoints} XP',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeOutCubic,
                          tween: Tween<double>(begin: 0, end: progress),
                          builder: (context, val, child) {
                            return LinearProgressIndicator(
                              value: val,
                              minHeight: 10,
                              backgroundColor: colorScheme.surface,
                              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomPainterWidget extends StatelessWidget {
  final CustomPainter painter;

  const CustomPainterWidget({super.key, required this.painter});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: painter);
  }
}