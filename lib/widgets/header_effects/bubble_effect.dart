import 'dart:math' as math;
import 'package:flutter/material.dart';

class BubbleEffect extends StatefulWidget {
  const BubbleEffect({super.key});

  @override
  State<BubbleEffect> createState() => _BubbleEffectState();
}

class _BubbleEffectState extends State<BubbleEffect>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Stopwatch _stopwatch;
  late final List<_Bubble> _bubbles;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch()..start();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _bubbles = List.generate(20, (_) => _Bubble.random(_random));
  }

  @override
  void dispose() {
    _stopwatch.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final elapsedSeconds = _stopwatch.elapsedMicroseconds / 1000000.0;
        return CustomPaint(
          painter: _BubblePainter(
            elapsedTime: elapsedSeconds,
            bubbles: _bubbles,
          ),
        );
      },
    );
  }
}

class _Bubble {
  final double initialX;
  final double initialY;
  final double radius;
  final double riseSpeed;
  final double wobbleSpeed;
  final double wobblePhase;

  _Bubble({
    required this.initialX,
    required this.initialY,
    required this.radius,
    required this.riseSpeed,
    required this.wobbleSpeed,
    required this.wobblePhase,
  });

  factory _Bubble.random(math.Random r) {
    return _Bubble(
      initialX: r.nextDouble(),
      initialY: r.nextDouble(),
      radius: r.nextDouble() * 6 + 4,
      riseSpeed: r.nextDouble() * 0.08 + 0.04, // 螢幕高度/秒
      wobbleSpeed: r.nextDouble() * 1.5 + 0.8,
      wobblePhase: r.nextDouble() * math.pi * 2,
    );
  }
}

class _BubblePainter extends CustomPainter {
  final double elapsedTime;
  final List<_Bubble> bubbles;

  _BubblePainter({
    required this.elapsedTime,
    required this.bubbles,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    const double padding = 20.0;
    final totalHeight = size.height + padding * 2;

    for (final b in bubbles) {
      // 1. 氣泡無縫上升 (由下至上)
      final rawY = 1.0 - ((b.initialY + elapsedTime * b.riseSpeed) % 1.0);
      final currentY = -padding + rawY * totalHeight;

      // 2. 水平微幅搖擺
      final currentX = (b.initialX * size.width) +
          math.sin(elapsedTime * b.wobbleSpeed + b.wobblePhase) * 8;

      final center = Offset(currentX, currentY);

      fillPaint.color = Colors.white.withValues(alpha: 0.12);
      strokePaint.color = Colors.white.withValues(alpha: 0.38);

      canvas.drawCircle(center, b.radius, fillPaint);
      canvas.drawCircle(center, b.radius, strokePaint);

      // 高光小點
      final highlightPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.6)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(currentX - b.radius * 0.3, currentY - b.radius * 0.3),
        b.radius * 0.25,
        highlightPaint,
      );
    }

    // 3. 底部動態流暢海浪
    final wavePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.18)
      ..style = PaintingStyle.fill;

    final path = Path()..moveTo(0, size.height);
    for (double i = 0; i <= size.width; i++) {
      final y = math.sin((i / size.width * 2 * math.pi) + (elapsedTime * 1.5)) * 7 +
          size.height * 0.83;
      path.lineTo(i, y);
    }
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, wavePaint);
  }

  @override
  bool shouldRepaint(covariant _BubblePainter oldDelegate) => true;
}