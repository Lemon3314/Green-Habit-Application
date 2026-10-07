import 'dart:math' as math;
import 'package:flutter/material.dart';

class LeafWaveEffect extends StatefulWidget {
  const LeafWaveEffect({super.key});

  @override
  State<LeafWaveEffect> createState() => _LeafWaveEffectState();
}

class _LeafWaveEffectState extends State<LeafWaveEffect>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Stopwatch _stopwatch;
  late final List<_Leaf> _leaves;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch()..start();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _leaves = List.generate(15, (_) => _Leaf.random(_random));
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
          painter: _LeafWavePainter(
            elapsedTime: elapsedSeconds,
            leaves: _leaves,
          ),
        );
      },
    );
  }
}

class _Leaf {
  final double initialX;
  final double initialY;
  final double size;
  final double fallSpeed;
  final double rotationSpeed;

  _Leaf({
    required this.initialX,
    required this.initialY,
    required this.size,
    required this.fallSpeed,
    required this.rotationSpeed,
  });

  factory _Leaf.random(math.Random r) {
    return _Leaf(
      initialX: r.nextDouble(),
      initialY: r.nextDouble(),
      size: r.nextDouble() * 6 + 7,
      fallSpeed: r.nextDouble() * 0.07 + 0.04,
      rotationSpeed: (r.nextDouble() - 0.5) * 1.5,
    );
  }
}

class _LeafWavePainter extends CustomPainter {
  final double elapsedTime;
  final List<_Leaf> leaves;

  _LeafWavePainter({
    required this.elapsedTime,
    required this.leaves,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final wavePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.22)
      ..style = PaintingStyle.fill;

    // 1. 底層流暢雙波浪
    final path = Path()..moveTo(0, size.height);
    for (double i = 0; i <= size.width; i++) {
      final y = math.sin((i / size.width * 2 * math.pi) + (elapsedTime * 1.2)) * 9 +
          size.height * 0.78;
      path.lineTo(i, y);
    }
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, wavePaint);

    // 2. 綠葉無縫飄落
    final leafPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;

    const double padding = 20.0;
    final totalHeight = size.height + padding * 2;

    for (final leaf in leaves) {
      final rawY = (leaf.initialY + elapsedTime * leaf.fallSpeed) % 1.0;
      final currentY = -padding + rawY * totalHeight;
      final currentX = (leaf.initialX * size.width) +
          math.sin((elapsedTime * 1.2) + leaf.initialY) * 14;

      canvas.save();
      canvas.translate(currentX, currentY);
      canvas.rotate(elapsedTime * leaf.rotationSpeed);

      final leafPath = Path()
        ..moveTo(0, -leaf.size)
        ..quadraticBezierTo(leaf.size * 0.7, 0, 0, leaf.size)
        ..quadraticBezierTo(-leaf.size * 0.7, 0, 0, -leaf.size)
        ..close();

      canvas.drawPath(leafPath, leafPaint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _LeafWavePainter oldDelegate) => true;
}