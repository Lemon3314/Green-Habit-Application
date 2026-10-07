import 'dart:math' as math;
import 'package:flutter/material.dart';

class SakuraEffect extends StatefulWidget {
  const SakuraEffect({super.key});

  @override
  State<SakuraEffect> createState() => _SakuraEffectState();
}

class _SakuraEffectState extends State<SakuraEffect>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Stopwatch _stopwatch;
  late final List<_Petal> _petals;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch()..start();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _petals = List.generate(28, (_) => _Petal.random(_random));
  }

  @override
  void dispose() {
    _stopwatch.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final elapsedSeconds = _stopwatch.elapsedMicroseconds / 1000000.0;
            return CustomPaint(
              size: Size(constraints.maxWidth, constraints.maxHeight),
              painter: _SakuraPainter(
                elapsedTime: elapsedSeconds,
                petals: _petals,
              ),
            );
          },
        );
      },
    );
  }
}

class _Petal {
  final double initialX;
  final double initialY;
  final double size;
  final double fallSpeed;
  final double windSpeed;
  final double swayAmplitude;
  final double swayFrequency;
  final double swayPhase;
  final double rotationSpeed;
  final double opacity;

  _Petal({
    required this.initialX,
    required this.initialY,
    required this.size,
    required this.fallSpeed,
    required this.windSpeed,
    required this.swayAmplitude,
    required this.swayFrequency,
    required this.swayPhase,
    required this.rotationSpeed,
    required this.opacity,
  });

  factory _Petal.random(math.Random r) {
    return _Petal(
      initialX: r.nextDouble(),
      initialY: r.nextDouble(),
      size: r.nextDouble() * 7 + 6,
      fallSpeed: r.nextDouble() * 0.08 + 0.04,
      windSpeed: r.nextDouble() * 0.06 + 0.03,
      swayAmplitude: r.nextDouble() * 22 + 10,
      swayFrequency: r.nextDouble() * 1.8 + 0.8,
      swayPhase: r.nextDouble() * math.pi * 2,
      rotationSpeed: (r.nextDouble() - 0.5) * 2.5,
      opacity: r.nextDouble() * 0.45 + 0.4,
    );
  }
}

class _SakuraPainter extends CustomPainter {
  final double elapsedTime;
  final List<_Petal> petals;

  _SakuraPainter({
    required this.elapsedTime,
    required this.petals,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final paint = Paint()..style = PaintingStyle.fill;

    const double paddingX = 40.0;
    const double paddingY = 25.0;
    final totalWidth = size.width + paddingX * 2;
    final totalHeight = size.height + paddingY * 2;

    for (final petal in petals) {
      final rawY = (petal.initialY + elapsedTime * petal.fallSpeed) % 1.0;
      final currentY = -paddingY + (rawY * totalHeight);

      final rawX = (petal.initialX + elapsedTime * petal.windSpeed) % 1.0;
      final sway = math.sin((elapsedTime * petal.swayFrequency) + petal.swayPhase) *
          petal.swayAmplitude;
      final currentX = -paddingX + (rawX * totalWidth) + sway;

      final currentRotation = elapsedTime * petal.rotationSpeed;

      canvas.save();
      canvas.translate(currentX, currentY);
      canvas.rotate(currentRotation);

      paint.color = Colors.white.withValues(alpha: petal.opacity);

      final path = Path()
        ..moveTo(0, -petal.size)
        ..quadraticBezierTo(
          petal.size * 0.8,
          -petal.size * 0.3,
          petal.size * 0.5,
          petal.size * 0.8,
        )
        ..quadraticBezierTo(
          0,
          petal.size * 0.5,
          -petal.size * 0.5,
          petal.size * 0.8,
        )
        ..quadraticBezierTo(
          -petal.size * 0.8,
          -petal.size * 0.3,
          0,
          -petal.size,
        )
        ..close();

      canvas.drawPath(path, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _SakuraPainter oldDelegate) => true;
}