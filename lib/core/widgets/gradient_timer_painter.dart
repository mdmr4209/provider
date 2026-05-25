import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GradientTimerPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;

  GradientTimerPainter({required this.progress, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final sweepAngle = 2 * math.pi * progress;

    // Background track
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = const Color(0xFF1B2C1A)
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke,
    );

    // Draw arc as 150 tiny segments, each with interpolated color
    const int segments = 150;
    final double segAngle = sweepAngle / segments;

    for (int i = 0; i < segments; i++) {
      final double t = i / (segments - 1); // 0.0 = tail, 1.0 = head

      // Transparent for first 40%, then fade in cream, bright white at tip
      final Color color;
      if (t < 0.4) {
        color = const Color(0x00000000);
      } else if (t < 0.75) {
        final double fade = (t - 0.4) / 0.35;
        color = Color.fromARGB(
          (fade * 160).round(),
          230, 219, 201, // 0xFFE6DBC9
        );
      } else {
        final double fade = (t - 0.75) / 0.25;
        color = Color.lerp(
          const Color(0xA0E6DBC9),
          Colors.white,
          fade,
        )!;
      }

      canvas.drawArc(
        rect,
        -math.pi / 2 + i * segAngle,
        segAngle + 0.005, // tiny overlap to avoid gaps
        false,
        Paint()
          ..color = color
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.butt,
      );
    }

    // Glowing white dot at leading tip
    final tipAngle = -math.pi / 2 + sweepAngle;
    final tip = Offset(
      center.dx + radius * math.cos(tipAngle),
      center.dy + radius * math.sin(tipAngle),
    );

    canvas.drawCircle(
      tip,
      strokeWidth * 0.7,
      Paint()
        ..color = const Color(0x44FFFFFF)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    canvas.drawCircle(tip, strokeWidth * 0.45, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant GradientTimerPainter old) =>
      old.progress != progress;
}
