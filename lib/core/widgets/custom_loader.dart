import 'dart:math';
import 'dart:ui' show lerpDouble;

/// Custom circular loader
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';

class CustomLoader extends StatefulWidget {
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
  State<CustomLoader> createState() => _CustomLoaderState();
}

class _CustomLoaderState extends State<CustomLoader>
    with TickerProviderStateMixin {
  late AnimationController _rotateController;
  late AnimationController _pendulumController;
  late Animation<double> _pendulumAnim;

  @override
  void initState() {
    super.initState();

    // Continuous rotation
    _rotateController = AnimationController(
      vsync: this,
      duration: widget.rotateDuration,
    )..repeat();

    // Pendulum: 0 = collapsed (circle), 1 = expanded (water drop)
    _pendulumController = AnimationController(
      vsync: this,
      duration: widget.pendulumDuration,
    )..repeat(reverse: true);

    _pendulumAnim = CurvedAnimation(
      parent: _pendulumController,
      curve: Curves.easeInOutSine,
    );
  }

  @override
  void dispose() {
    _rotateController.dispose();
    _pendulumController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor = widget.color ?? Theme.of(context).primaryColor;

    return AnimatedBuilder(
      animation: Listenable.merge([_rotateController, _pendulumAnim]),
      builder: (context, child) {
        final double rotAngle = _rotateController.value * 2 * pi;
        final double morph = _pendulumAnim.value; // 0=circle, 1=drop
        final double maxOrbit = widget.size * 0.26;
        final double orbitRadius = maxOrbit * morph;
        final double dotRadius = widget.size * 0.14;
        final double center = widget.size / 2;
        // Paint area must fit the full teardrop (tip extends ~1.75x dotRadius)
        final double paintArea = dotRadius * 5.0;

        // Trailing dots fade out by opacity
        const List<double> opacities = [1.0, 0.72, 0.48, 0.26];

        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            children: List.generate(4, (i) {
              final double angle = rotAngle + i * pi / 2;
              final double dx = center + orbitRadius * cos(angle);
              final double dy = center + orbitRadius * sin(angle);

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
  }
}

class _WaterDropPainter extends CustomPainter {
  final double morph;

  /// The angle (in radians) pointing outward from the orbit center.
  /// The water drop tip will face this direction.
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
    // Move origin to center of paint area
    canvas.translate(size.width / 2, size.height / 2);
    // Rotate so the local tip (0, -tipR) points INWARD toward center.
    // Inward direction = outwardAngle + π (opposite of outward).
    // Derivation: rotating (0,-1) by θ gives (sin θ, -cos θ).
    // Setting that equal to (-cos α, -sin α): θ = π/2 + α + π = α - π/2.
    canvas.rotate(outwardAngle - pi / 2);

    // --- Soft glow ---
    final glowPaint = Paint()
      ..color = color.withAlpha((opacity * 89).round())
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, glowPaint);

    // --- Main fill ---
    final fillPaint = Paint()
      ..color = color.withAlpha((opacity * 255).round())
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    // --- Specular gloss highlight (liquid look) ---
    if (morph > 0.05) {
      final double tipR = lerpDouble(r, r * 1.30, morph)!;
      final highlightPaint = Paint()
        ..color = Colors.white.withAlpha((opacity * morph * 140).round())
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

  /// Builds a path that morphs between two cubic-bezier shapes:
  ///   morph = 0  →  2-bezier approximation of a circle (radius r)
  ///   morph = 1  →  water-drop / teardrop (tip at local -y, round base at +y)
  ///
  /// Both shapes use the same two-segment bezier skeleton so that every
  /// control point can be linearly interpolated, giving a smooth morph.
  Path _buildMorphPath(double r, double m) {
    // How far the tip extends above the circle's top
    final double tipR = lerpDouble(r, r * 1.30, m)!;

    // Control points – lerped from "circle" values to "teardrop" values.
    // c1 (near tip)  → stays narrow so the tip stays pointed.
    // c2 (near base) → pushed wide so the outer base stays circular.
    //
    // Circle (2-bezier semicircle approximation):
    //   top = (0, -r)
    //   c1  = (r*1.333, -r)    c2 = (r*1.333, r)   → (0, r)  [right half]
    //
    // Teardrop:
    //   top = (0, -tipR)
    //   c1  = (r*0.70, -tipR*0.25)   ← narrow/pointy shoulder
    //   c2  = (r*1.20,  r*0.70)      ← wide so base curves like a circle
    //   → (0, r)
    final double c1x = lerpDouble(
      r * 1.333,
      r * 0.70,
      m,
    )!; // tip shoulder – narrow
    final double c1y = lerpDouble(-r, -tipR * 0.25, m)!;
    final double c2x = lerpDouble(
      r * 1.333,
      r * 1.20,
      m,
    )!; // base shoulder – wide/circular
    final double c2y = lerpDouble(r, r * 0.70, m)!;

    final path = Path();
    path.moveTo(0, -tipR);
    // Right side: tip → base
    path.cubicTo(c1x, c1y, c2x, c2y, 0, r);
    // Left side: base → tip  (x-axis mirrored)
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

/// Full screen loader
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
                style: TextStyle(color: AppColors.textColor, fontSize: 14.sp),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Shimmer loading widget
class ShimmerLoader extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerLoader({
    Key? key,
    this.width = double.infinity,
    this.height = 100,
    this.borderRadius = 12,
  }) : super(key: key);

  @override
  State<ShimmerLoader> createState() => _ShimmerLoaderState();
}

class _ShimmerLoaderState extends State<ShimmerLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.1, 0.5, 0.9],
              colors: [
                AppColors.whiteColor.withValues(alpha: 0.05),
                AppColors.whiteColor.withValues(alpha: 0.15),
                AppColors.whiteColor.withValues(alpha: 0.05),
              ],
              transform: _SlidingGradientTransform(
                slidePercent: _animation.value,
              ),
            ),
          ),
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
