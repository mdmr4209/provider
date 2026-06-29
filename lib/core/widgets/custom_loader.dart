import 'dart:math';
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';

class _LoaderState {
  final ValueNotifier<double> rotateTarget;
  final ValueNotifier<double> pendulumTarget;
  _LoaderState()
    : rotateTarget = ValueNotifier<double>(1.0),
      pendulumTarget = ValueNotifier<double>(1.0);
}

class CustomLoader extends StatelessWidget {
  final double size;
  final Color? color;
  final Duration rotateDuration;
  final Duration pendulumDuration;

  const CustomLoader({
    super.key,
    this.size = 80.0,
    this.color,
    this.rotateDuration = const Duration(milliseconds: 1400),
    this.pendulumDuration = const Duration(milliseconds: 900),
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).primaryColor;

    return FormField<_LoaderState>(
      initialValue: _LoaderState(),
      builder: (fieldState) {
        final state = fieldState.value!;

        return ValueListenableBuilder<double>(
          valueListenable: state.rotateTarget,
          builder: (context, rotateTarget, _) {
            return TweenAnimationBuilder<double>(
              tween: Tween<double>(
                begin: rotateTarget - 1.0,
                end: rotateTarget,
              ),
              duration: rotateDuration,
              onEnd: () {
                state.rotateTarget.value = rotateTarget + 1.0;
              },
              builder: (context, rotateVal, _) {
                return ValueListenableBuilder<double>(
                  valueListenable: state.pendulumTarget,
                  builder: (context, pendulumTarget, _) {
                    return TweenAnimationBuilder<double>(
                      tween: Tween<double>(
                        begin: pendulumTarget == 1.0 ? 0.0 : 1.0,
                        end: pendulumTarget,
                      ),
                      duration: pendulumDuration,
                      curve: Curves.easeInOutSine,
                      onEnd: () {
                        state.pendulumTarget.value = pendulumTarget == 1.0
                            ? 0.0
                            : 1.0;
                      },
                      builder: (context, pendulumVal, _) {
                        final double rotAngle = rotateVal * 2 * pi;
                        final double morph = pendulumVal; // 0=circle, 1=drop
                        final double maxOrbit = size * 0.26;
                        final double orbitRadius = maxOrbit * morph;
                        final double dotRadius = size * 0.14;
                        final double center = size / 2;
                        final double paintArea = dotRadius * 5.0;

                        const List<double> opacities = [1.0, 0.72, 0.48, 0.26];

                        return SizedBox(
                          width: size,
                          height: size,
                          child: Stack(
                            children: List.generate(4, (i) {
                              final double angle = rotAngle + i * pi / 2;
                              final double dx =
                                  center + orbitRadius * cos(angle);
                              final double dy =
                                  center + orbitRadius * sin(angle);

                              return Positioned(
                                left: dx - paintArea / 2,
                                top: dy - paintArea / 2,
                                child: CustomPaint(
                                  size: Size(paintArea, paintArea),
                                  painter: _WaterDropPainter(
                                    morph: morph,
                                    outwardAngle: angle,
                                    color: effectiveColor,
                                    opacity: opacities[i],
                                    dotRadius: dotRadius,
                                  ),
                                ),
                              );
                            }),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}

class _WaterDropPainter extends CustomPainter {
  final double morph;
  final double outwardAngle;
  final Color color;
  final double opacity;
  final double dotRadius;

  const _WaterDropPainter({
    required this.morph,
    required this.outwardAngle,
    required this.color,
    required this.opacity,
    required this.dotRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double r = dotRadius;
    final path = _buildMorphPath(r, morph);

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(outwardAngle - pi / 2);

    // Glow
    final glowPaint = Paint()
      ..color = color.withAlpha((opacity * 89).round())
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, glowPaint);

    // Main fill
    final fillPaint = Paint()
      ..color = color.withAlpha((opacity * 255).round())
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    // Highlight
    if (morph > 0.05) {
      final double tipR = lerpDouble(r, r * 1.30, morph)!;
      final highlightPaint = Paint()
        ..color = AppColors.whiteColor.withAlpha(
          (opacity * morph * 140).round(),
        )
        ..style = PaintingStyle.fill;
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(r * 0.20, -(tipR * 0.58)),
          width: r * 0.28 * morph,
          height: r * 0.44 * morph,
        ),
        highlightPaint,
      );
    }

    canvas.restore();
  }

  Path _buildMorphPath(double r, double m) {
    final double tipR = lerpDouble(r, r * 1.30, m)!;

    final double c1x = lerpDouble(r * 1.333, r * 0.70, m)!;
    final double c1y = lerpDouble(-r, -tipR * 0.25, m)!;
    final double c2x = lerpDouble(r * 1.333, r * 1.20, m)!;
    final double c2y = lerpDouble(r, r * 0.70, m)!;

    final path = Path();
    path.moveTo(0, -tipR);
    path.cubicTo(c1x, c1y, c2x, c2y, 0, r);
    path.cubicTo(-c2x, c2y, -c1x, c1y, 0, -tipR);
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(_WaterDropPainter old) =>
      old.morph != morph ||
      old.outwardAngle != outwardAngle ||
      old.color != color ||
      old.opacity != opacity;
}

class FullScreenLoader extends StatelessWidget {
  final String? message;

  const FullScreenLoader({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.withValues(alpha: 0.8),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CustomLoader(size: 60),
            if (message != null) ...[
              SizedBox(height: 16.h),
              Text(
                message!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textColor,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ShimmerState {
  final ValueNotifier<double> target;
  _ShimmerState() : target = ValueNotifier<double>(1.0);
}

class ShimmerLoader extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerLoader({
    super.key,
    this.width = double.infinity,
    this.height = 100,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<_ShimmerState>(
      initialValue: _ShimmerState(),
      builder: (fieldState) {
        final state = fieldState.value!;
        return ValueListenableBuilder<double>(
          valueListenable: state.target,
          builder: (context, target, _) {
            return TweenAnimationBuilder<double>(
              key: ValueKey(target),
              tween: Tween<double>(begin: -2.0, end: 2.0),
              duration: const Duration(milliseconds: 1500),
              onEnd: () {
                state.target.value = target + 1.0;
              },
              builder: (context, value, _) {
                return Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: const [0.1, 0.5, 0.9],
                      colors: [
                        AppColors.whiteColor.withValues(alpha: 0.05),
                        AppColors.whiteColor.withValues(alpha: 0.15),
                        AppColors.whiteColor.withValues(alpha: 0.05),
                      ],
                      transform: _SlidingGradientTransform(slidePercent: value),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({required this.slidePercent});

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}
