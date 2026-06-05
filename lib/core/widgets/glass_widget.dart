import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/design_system.dart';

class GlassWidget extends StatelessWidget {
  final Widget child;
  final double? height;
  final double? width;
  final double? borderRadius;
  final double? blur;
  final double? opacity;
  final double? borderOpacity;

  const GlassWidget({
    super.key,
    required this.child,
    this.height,
    this.width,
    this.borderRadius,
    this.blur,
    this.opacity,
    this.borderOpacity,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final designSystem = theme.extension<AppDesignSystem>();

    final effectiveRadius = borderRadius ?? 12.r;
    final effectiveBlur = blur ?? designSystem?.glassBlur ?? 15.0;
    final effectiveOpacity = opacity ?? designSystem?.glassOpacity ?? 0.15;
    final effectiveBorderOpacity = borderOpacity ?? designSystem?.glassBorderOpacity ?? 0.2;

    return ClipRRect(
      borderRadius: BorderRadius.circular(effectiveRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: effectiveBlur, sigmaY: effectiveBlur),
        child: Container(
          width: width?.w,
          height: height?.h,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha((effectiveOpacity * 255).toInt()),
            borderRadius: BorderRadius.circular(effectiveRadius),
            border: Border.all(
              color: Colors.white.withAlpha((effectiveBorderOpacity * 255).toInt()),
              width: 1.5.w,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
