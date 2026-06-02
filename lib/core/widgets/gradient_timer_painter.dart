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

    // Proportions based on the SfRadialGauge configuration (245 total width, 14 stroke, 200 inner)
    final double radius = (size.width - strokeWidth) / 2;
    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    // 1. Draw the decorative inner circle (Matches GaugeAnnotation)
    // Scale 200/245 of the total available width
    final double innerCircleRadius = (size.width * (200 / 245)) / 2;
    final Paint innerPaint = Paint()
      ..color = const Color(0xFF44523A)
      ..style = PaintingStyle.fill;

    final Paint innerBorderPaint = Paint()
      ..color = const Color(0xFFFEEF8E)
      ..strokeWidth = 1.r
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, innerCircleRadius, innerPaint);
    canvas.drawCircle(center, innerCircleRadius, innerBorderPaint);

    // 2. Draw the background track (Matches AxisLineStyle)
    final Paint trackPaint = Paint()
      ..color = const Color(0xFF41503C)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, trackPaint);

    // 3. Draw the progress arc with gradient (Matches RangePointer)
    if (progress > 0) {
      final Paint progressPaint = Paint()
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round; // Matches CornerStyle.bothCurve

      // Matches the SweepGradient colors and behavior from the snippet
      final SweepGradient sweepGradient = SweepGradient(
        startAngle: -math.pi / 2, // Starts at 270 degrees
        endAngle: (-math.pi / 2) + (2 * math.pi),
        colors: const [
          Color(0x55E6DBC9),
          Color(0xAAE6DBC9),
          Color(0xFFE6DBC9),
          Color(0xFFFFFFFF),
        ],
        stops: const [0.0, 0.35, 0.7, 1.0],
      );

      progressPaint.shader = sweepGradient.createShader(rect);

      // Draw the arc starting from the top (-pi/2)
      canvas.drawArc(
        rect,
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant GradientTimerPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
