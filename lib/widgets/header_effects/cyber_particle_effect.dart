import 'dart:math' as math;
import 'package:flutter/material.dart';

class CyberParticleEffect extends StatefulWidget {
  const CyberParticleEffect({super.key});

  @override
  State<CyberParticleEffect> createState() => _CyberParticleEffectState();
}

class _CyberParticleEffectState extends State<CyberParticleEffect>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Stopwatch _stopwatch;
  late final List<_CyberParticle> _particles;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch()..start();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _particles = List.generate(28, (_) => _CyberParticle.random(_random));
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
          painter: _CyberPainter(
            elapsedTime: elapsedSeconds,
            particles: _particles,
          ),
        );
      },
    );
  }
}

class _CyberParticle {
  final double x;
  final double y;
  final double radius;
  final double pulseSpeed;
  final double phase;
  final Color color;

  _CyberParticle({
    required this.x,
    required this.y,
    required this.radius,
    required this.pulseSpeed,
    required this.phase,
    required this.color,
  });

  factory _CyberParticle.random(math.Random r) {
    final colors = [
      const Color(0xFF63E6BE),
      const Color(0xFF4DABF7),
      const Color(0xFFDA77F2),
      Colors.white,
    ];
    return _CyberParticle(
      x: r.nextDouble(),
      y: r.nextDouble(),
      radius: r.nextDouble() * 2.5 + 1.5,
      pulseSpeed: r.nextDouble() * 2.0 + 1.0,
      phase: r.nextDouble() * math.pi * 2,
      color: colors[r.nextInt(colors.length)],
    );
  }
}

class _CyberPainter extends CustomPainter {
  final double elapsedTime;
  final List<_CyberParticle> particles;

  _CyberPainter({
    required this.elapsedTime,
    required this.particles,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // 1. 繪製平滑脈動粒子
    for (final p in particles) {
      final pulse = (math.sin(elapsedTime * p.pulseSpeed + p.phase) + 1) / 2;
      final opacity = (0.2 + pulse * 0.65).clamp(0.0, 1.0);

      paint.color = p.color.withValues(alpha: opacity);
      paint.maskFilter = MaskFilter.blur(BlurStyle.normal, p.radius * 0.6);

      final offset = Offset(p.x * size.width, p.y * size.height);
      canvas.drawCircle(offset, p.radius * (0.85 + pulse * 0.35), paint);
    }

    // 2. 繪製連續劃過的流星軌跡
    final meteorCycle = (elapsedTime * 0.35) % 1.0; 
    final meteorProgress = meteorCycle / 0.7; // 前 70% 時間劃過，後 30% 隱藏間隔

    if (meteorProgress <= 1.0) {
      final startX = size.width * (meteorProgress * 1.4 - 0.2);
      final startY = size.height * (0.1 + meteorProgress * 0.2);
      final meteorLength = 90.0;

      final fadeAlpha = math.sin(meteorProgress * math.pi) * 0.85;

      final meteorPaint = Paint()
        ..shader = LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.0),
            const Color(0xFF63E6BE).withValues(alpha: fadeAlpha * 0.6),
            Colors.white.withValues(alpha: fadeAlpha),
          ],
        ).createShader(
          Rect.fromLTWH(startX, startY, meteorLength, 20),
        )
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(
        Offset(startX, startY),
        Offset(startX + meteorLength, startY + 25),
        meteorPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CyberPainter oldDelegate) => true;
}