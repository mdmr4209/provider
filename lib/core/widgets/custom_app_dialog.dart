import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';
import '../constants/app_assets.dart';
import 'custom_button.dart';

class CustomAppDialog extends StatelessWidget {
  final String title;
  final String description;
  final String primaryText;
  final VoidCallback onPrimaryTap;
  final String? secondaryText;
  final VoidCallback? onSecondaryTap;
  final Widget? icon;
  final bool showLogo;

  const CustomAppDialog({
    super.key,
    required this.title,
    required this.description,
    required this.primaryText,
    required this.onPrimaryTap,
    this.secondaryText,
    this.onSecondaryTap,
    this.icon,
    this.showLogo = true,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        padding: EdgeInsets.all(24.r),
        decoration: BoxDecoration(
          color: AppColors.defaultColor,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: AppColors.colorFFD4AF37.withAlpha(102),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.blackColor.withAlpha(128),
              blurRadius: 40,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (showLogo) ...[
              Image.asset(
                AppAssets.sb1Logo,
                height: 60.h,
              ),
              SizedBox(height: 20.h),
            ] else if (icon != null) ...[
              icon!,
              SizedBox(height: 20.h),
            ],
            
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.whiteColor,
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Georgia',
                letterSpacing: 0.5,
                height: 1.2,
              ),
            ),
            
            SizedBox(height: 12.h),
            
            Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.whiteColor.withAlpha(217),
                fontSize: 15.sp,
                height: 1.5,
                fontFamily: 'Proxima Nova',
              ),
            ),
            
            SizedBox(height: 32.h),
            
            CustomButton(
              onPress: () async {
                Navigator.pop(context);
                onPrimaryTap();
              },
              title: primaryText,
              linearGradient: true,
              height: 52,
              fontSize: 16,
            ),
            
            if (secondaryText != null) ...[
              SizedBox(height: 12.h),
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
                      color: AppColors.iconColor.withAlpha(153),
                      width: 1.2,
                    ),
                  ),
                  child: Text(
                    secondaryText!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.whiteColor.withAlpha(242),
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

/// Helper function to show the custom app dialog
void showAppCustomDialog(
  BuildContext context, {
  required String title,
  required String description,
  required String primaryText,
  required VoidCallback onPrimaryTap,
  String? secondaryText,
  VoidCallback? onSecondaryTap,
  Widget? icon,
  bool showLogo = true,
}) {
  showDialog(
    context: context,
    // Solid barrier color using exact color from AppColors
    barrierColor: AppColors.defaultColor,
    builder: (context) => CustomAppDialog(
      title: title,
      description: description,
      primaryText: primaryText,
      onPrimaryTap: onPrimaryTap,
      secondaryText: secondaryText,
      onSecondaryTap: onSecondaryTap,
      icon: icon,
      showLogo: showLogo,
    ),
  );
}
