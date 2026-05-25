import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';

class GlassWidget extends StatelessWidget {
  final Widget child;
  final double height;
  final double width;

  const GlassWidget({
    super.key,
    required this.child,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          transform: GradientRotation(360 * 3),
          end: Alignment.bottomLeft,
          colors: [
            AppColors.blackLiteColor,
            AppColors.whiteLiteColor,
            AppColors.blackLiteColor,
          ],
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Container(
        width: width.w,
        height: height.h,
        margin: EdgeInsets.all(0.7.r),
        // Border thickness
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.center,
            end: Alignment.center,
            colors: [
              AppColors.blackLiteColor,
              AppColors.whiteLiteColor,
              AppColors.blackColor,
              AppColors.whiteLiteColor,
            ],
          ),
          borderRadius: BorderRadius.circular(12.r + 1.w),
        ),
        child: child,
      ),
    );
  }
}
