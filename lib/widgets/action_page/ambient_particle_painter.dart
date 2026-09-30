import 'dart:math';
import 'package:flutter/material.dart';

enum ActionThemeType { ocean, forest }

class AmbientParticlePainter extends CustomPainter {
  final double animationValue;
  final ActionThemeType themeType;
  final Color primaryColor;

  AmbientParticlePainter({
    required this.animationValue,
    required this.themeType,
    required this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = primaryColor.withValues(alpha: 0.22);

    final random = Random(42); // 固定種子確保粒子分佈自然

    for (int i = 0; i < 12; i++) {
      final xRatio = random.nextDouble();
      final yRatio = random.nextDouble();
      final speed = 0.4 + random.nextDouble() * 0.6;
      final radius = 3.0 + random.nextDouble() * 5.0;

      // 計算 Y 軸位移 (常駐向上飄浮循環)
      double yPos = ((yRatio - (animationValue * speed)) % 1.0) * size.height;
      if (yPos < 0) yPos += size.height;
      double xPos = (xRatio * size.width) + sin(animationValue * 2 * pi + i) * 6;

      if (themeType == ActionThemeType.ocean) {
        // 海洋主題：繪製空心與實心小水泡
        paint.style = i % 2 == 0 ? PaintingStyle.stroke : PaintingStyle.fill;
        paint.strokeWidth = 1.2;
        canvas.drawCircle(Offset(xPos, yPos), radius, paint);
      } else {
        // 森林主題：繪製輕柔的小落葉形狀
        paint.style = PaintingStyle.fill;
        final path = Path();
        path.moveTo(xPos, yPos - radius);
        path.quadraticBezierTo(xPos + radius * 1.5, yPos, xPos, yPos + radius);
        path.quadraticBezierTo(xPos - radius * 1.5, yPos, xPos, yPos - radius);
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant AmbientParticlePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.themeType != themeType ||
        oldDelegate.primaryColor != primaryColor;
  }
}