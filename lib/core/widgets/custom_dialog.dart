import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';
import '../constants/app_assets.dart';
import 'custom_button.dart';

/// A premium, theme-consistent custom dialog for the Stronger By Two app.
class CustomDialog extends StatelessWidget {
  final String title;
  final String description;
  final String primaryText;
  final VoidCallback onPrimaryTap;
  final String? secondaryText;
  final VoidCallback? onSecondaryTap;
  final Widget? topWidget;
  final bool showLogo;

  const CustomDialog({
    super.key,
    required this.title,
    required this.description,
    required this.primaryText,
    required this.onPrimaryTap,
    this.secondaryText,
    this.onSecondaryTap,
    this.topWidget,
    this.showLogo = true,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.defaultColor,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
        side: BorderSide(
          color: const Color(0xFFD4AF37).withOpacity(0.4),
          width: 1.5,
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(24.r),
        decoration: BoxDecoration(
          color: AppColors.defaultColor,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 40,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header Image/Logo
            if (topWidget != null)
              topWidget!
            else if (showLogo)
              Image.asset(
                AppAssets.sb1Logo,
                height: 65.h,
              ),
            
            SizedBox(height: 20.h),

            /// TITLE
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Georgia',
                letterSpacing: 0.5,
              ),
            ),

            SizedBox(height: 12.h),

            /// DESCRIPTION
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 15.sp,
                height: 1.5,
                fontFamily: 'Proxima Nova',
              ),
            ),

            SizedBox(height: 32.h),

            /// PRIMARY BUTTON
            CustomButton(
              onPress: () async {
                Navigator.pop(context); // Close dialog
                onPrimaryTap();
              },
              title: primaryText,
              linearGradient: true,
              height: 52,
              fontSize: 16,
            ),

            if (secondaryText != null) ...[
              SizedBox(height: 14.h),
              /// SECONDARY BUTTON
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  onSecondaryTap?.call();
                },
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
                    secondaryText!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.95),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Utility function to show the CustomDialog
void showAppCustomDialog(
  BuildContext context, {
  required String title,
  required String description,
  required String primaryText,
  required VoidCallback onPrimaryTap,
  String? secondaryText,
  VoidCallback? onSecondaryTap,
  Widget? topWidget,
  bool showLogo = true,
  bool barrierDismissible = true,
}) {
  showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    // Solid barrier color using exact color (no alpha) as requested
    barrierColor: AppColors.defaultColor,
    builder: (context) => CustomDialog(
      title: title,
      description: description,
      primaryText: primaryText,
      onPrimaryTap: onPrimaryTap,
      secondaryText: secondaryText,
      onSecondaryTap: onSecondaryTap,
      topWidget: topWidget,
      showLogo: showLogo,
    ),
  );
}
