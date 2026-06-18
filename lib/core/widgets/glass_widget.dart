import 'dart:ui';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../theme/design_system.dart';

class GlassWidget extends StatelessWidget {
  final Widget child;
  final double? height;
  final double? width;
  final double? borderRadius;
  final double? blur;
  final double? opacity;
  final double? borderOpacity;
  final Color? color;

  const GlassWidget({
    super.key,
    required this.child,
    this.height = 44,
    this.width = double.infinity,
    this.borderRadius,
    this.blur,
    this.opacity,
    this.borderOpacity,
    this.color = AppColors.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final designSystem = theme.extension<AppDesignSystem>();

    // These variables safely hold your fallbacks
    final effectiveRadius = borderRadius ?? 12.0;
    final effectiveBlur = blur ?? designSystem?.glassBlur ?? 15.0;
    // Note: You can optionally utilize effectiveOpacity and effectiveBorderOpacity
    // down in your gradients/decorations if you want them to be dynamic too!

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          transform: const GradientRotation(360 * 3),
          end: Alignment.bottomLeft,
          colors: [
            AppColors.backgroundColor,
            AppColors.whiteLiteColor,
            AppColors.backgroundColor,
          ],
        ),
        borderRadius: BorderRadius.circular(
          12.r,
        ), // Added .r here for consistency
      ),
      child: Container(
        margin: EdgeInsets.all(0.7.r),
        height: height
            ?.h, // Changed from height! to height? to safely allow null double.infinity handling
        width: width == double.infinity ? double.infinity : width?.w,
        padding: EdgeInsets.all(.5.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.center,
            end: Alignment.center,
            colors: [
              AppColors.backgroundColor,
              AppColors.whiteLiteColor,
              AppColors.blackColor,
              AppColors.whiteLiteColor,
            ],
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.r),
            bottomRight: Radius.circular(12.r),
            bottomLeft: Radius.circular(4.r + .5.w),
            topRight: Radius.circular(4.r + .5.w),
          ),
        ),
        child: ClipRRect(
          // FIX: Swapped out 'borderRadius!.r' for your safe 'effectiveRadius' variable
          borderRadius: BorderRadius.circular(effectiveRadius.r),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(
              sigmaX: effectiveBlur,
              sigmaY: effectiveBlur,
            ), // Used effectiveBlur here
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  effectiveRadius.r,
                ), // Fixed here too
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
