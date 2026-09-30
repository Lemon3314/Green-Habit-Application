import 'dart:math' as math;

import 'package:flutter/material.dart';

class WaveHeader extends StatefulWidget {
  final Color color;

  const WaveHeader({
    super.key,
    this.color = Colors.white,
  });

  @override
  State<WaveHeader> createState() => _WaveHeaderState();
}

class _WaveHeaderState extends State<WaveHeader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: _WavePainter(
                progress: _controller.value,
                color: widget.color,
              ),
              child: child,
            );
          },
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  final double progress;
  final Color color;

  _WavePainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final waveConfigs = [
      _WaveConfig(
        amplitude: 15,
        wavelength: 110,
        speed: 1.0,
        opacity: 0.18,
        strokeWidth: 2,
        verticalPosition: 0.70,
      ),
      _WaveConfig(
        amplitude: 11,
        wavelength: 90,
        speed: 1.35,
        opacity: 0.12,
        strokeWidth: 1.7,
        verticalPosition: 0.80,
      ),
      _WaveConfig(
        amplitude: 18,
        wavelength: 135,
        speed: 0.75,
        opacity: 0.09,
        strokeWidth: 2.5,
        verticalPosition: 0.91,
      ),
    ];

    for (final config in waveConfigs) {
      paint
        ..color = color.withValues(alpha: config.opacity)
        ..strokeWidth = config.strokeWidth;

      final path = Path();

      final centerY = size.height * config.verticalPosition;

      for (double x = 0; x <= size.width; x += 2) {
        final angle =
            (x / config.wavelength * math.pi * 2) +
            (progress * math.pi * 2 * config.speed);

        final y = centerY + math.sin(angle) * config.amplitude;

        if (x == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color;
  }
}

class _WaveConfig {
  final double amplitude;
  final double wavelength;
  final double speed;
  final double opacity;
  final double strokeWidth;
  final double verticalPosition;

  const _WaveConfig({
    required this.amplitude,
    required this.wavelength,
    required this.speed,
    required this.opacity,
    required this.strokeWidth,
    required this.verticalPosition,
  });
}