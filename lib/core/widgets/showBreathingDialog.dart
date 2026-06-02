import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newproject/core/constants/app_colors.dart';
import 'package:newproject/core/constants/app_assets.dart';
import 'package:newproject/core/widgets/custom_button.dart';

/// Shows a beautiful solid breathing dialog with centered content and branding.
/// Uses exact solid colors for background and barrier as per preference.
void showBreathingDialog(
  BuildContext context, {
   bool isBreathing=false,
  required String title,
  required String? description,
  required String primaryButtonText,
  required VoidCallback onPrimaryTap,
}) {
  showDialog(
    context: context,
    // Solid barrier color using exact color from AppColors (no alpha)
    barrierColor: AppColors.defaultColor.withAlpha(177),
    builder: (dialogContext) {
      return Dialog(
        // Solid dialog background
        backgroundColor: AppColors.defaultColor,
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(24.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            color: AppColors.defaultColor, // Exact solid color
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 40,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo at the top
              if (isBreathing)
              Image.asset(
                AppAssets.sb1Logo,
                height: 65.h,
              ),

              if (isBreathing)
              SizedBox(height: 24.h),

              /// TITLE
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Georgia',
                  letterSpacing: 0.5,
                  height: 1.2,
                ),
              ),

              if (description != null)
              SizedBox(height: 16.h),

              /// DESCRIPTION
              if (description != null)
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.85),
                  fontSize: 13.sp,
                  height: 1.5,
                  fontFamily: 'Proxima Nova',
                ),
              ),

              SizedBox(height: 32.h),

              /// PRIMARY BUTTON
              CustomButton(
                onPress: () async {
                  Navigator.pop(dialogContext); // Close dialog
                  onPrimaryTap();
                },
                title: primaryButtonText,
                linearGradient: true,
                height: 54,
                fontSize: 16,
              ),

              SizedBox(height: 14.h),

              /// SECONDARY BUTTON (Outline style)
              GestureDetector(
                onTap: () => Navigator.pop(dialogContext),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColors.iconColor.withOpacity(0.6),
                      width: 1.2,
                    ),
                  ),
                  child: Text(
                    '"No, I\'m okay for now."',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.95),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20.h),

            ],
          ),
        ),
      );
    },
  );
}
