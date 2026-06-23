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
    final theme = Theme.of(context);
    final dialogTheme = theme.dialogTheme;

    return Dialog(
      backgroundColor: dialogTheme.backgroundColor,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      shape: dialogTheme.shape,
      surfaceTintColor: dialogTheme.surfaceTintColor,
      child: Container(
        padding: EdgeInsets.all(24.r),
        decoration: BoxDecoration(
          color: dialogTheme.backgroundColor,
          borderRadius:
              (dialogTheme.shape as RoundedRectangleBorder).borderRadius,
          boxShadow: [
            BoxShadow(
              color: AppColors.blackColor.withAlpha(102),
              blurRadius: 30,
              offset: const Offset(0, 10),
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
              Image.asset(AppAssets.sb1Logo, height: 65.h),

            SizedBox(height: 20.h),

            /// TITLE
            Text(
              title,
              textAlign: TextAlign.center,
              style: dialogTheme.titleTextStyle,
            ),

            SizedBox(height: 12.h),

            /// DESCRIPTION
            Text(
              description,
              textAlign: TextAlign.center,
              style: dialogTheme.contentTextStyle,
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
                      color: AppColors.iconColor.withAlpha(102),
                      width: 1.2,
                    ),
                  ),
                  child: Text(
                    secondaryText!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: dialogTheme.contentTextStyle?.color?.withAlpha(
                        230,
                      ),
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
    barrierColor: AppColors.blackColor.withAlpha(166),
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
