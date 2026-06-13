import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newproject/core/constants/app_colors.dart';

import '../../../../../../core/widgets/background_widget.dart';
import '../../../../../../core/widgets/custom_button.dart';

class SeekerSetupBaseView extends StatelessWidget {
  final int currentStep; // 2 to 15
  final int totalSteps;
  final Widget child;
  final VoidCallback? onBack;
  final String? title;

  const SeekerSetupBaseView({
    super.key,
    required this.currentStep,
    this.totalSteps = 15,
    required this.child,
    this.onBack,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    // Progress logic: Show progress for 11 pages (Step 2 to Step 12).
    // Step 2 is 1/11 (approx 9%), Step 12 is 11/11 (100%).
    double progress = 0.0;
    if (totalSteps == 15) {
      if (currentStep >= 2 && currentStep <= 12) {
        progress = (currentStep - 1) / 11;
      } else if (currentStep > 12) {
        progress = 1.0;
      }
    } else {
      if (totalSteps > 1) {
        progress = (currentStep - 1) / (totalSteps - 1);
      }
    }

    return BackgroundWidget(
      imagePath: 'assets/images/bg.png',
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(130.h),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 1. Progress Bar (Shown for Step 2 and above)
                if (currentStep >= 2)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 12.h,
                    ),
                    child: Container(
                      height: 3.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.iconColor.withAlpha(40),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: progress.clamp(0.0, 1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.iconColor,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                      ),
                    ),
                  ),

                // 2. AppBar with Custom Back Button and Page Number/Title
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 85.w,
                        child: CustomButton(
                          radius: 25,
                          height: 26.h,
                          buttonColor: Colors.transparent,
                          borderColor: AppColors.iconColor,
                          onPress: () async {
                            if (onBack != null) {
                              onBack!();
                            } else {
                              Navigator.pop(context);
                            }
                          },

                          title: '←Back',
                          textColor: AppColors.iconColor,
                          fontSize: 13,
                        ),
                      ),
                      if (title != null)
                        Expanded(
                          child: Text(
                            title!,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.whiteColor,
                              fontSize: 16.sp,
                            ),
                          ),
                        )
                      else
                        Text(
                          "$currentStep/$totalSteps",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.iconColor,
                            fontSize: 16.sp,
                          ),
                        ),
                      if (title != null)
                        SizedBox(width: 85.w), // Balance out the back button width
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: child,
      ),
    );
  }
}
