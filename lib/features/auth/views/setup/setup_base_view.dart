import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newproject/core/constants/app_colors.dart';
import '../../../../core/widgets/background_widget.dart';
import '../../../../core/widgets/custom_button.dart';

class SetupBaseView extends StatelessWidget {
  final int currentStep; // 2 to 15
  final int totalSteps = 15;
  final Widget child;
  final VoidCallback? onBack;

  const SetupBaseView({
    super.key,
    required this.currentStep,
    required this.child,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    // Progress logic: Show progress for 11 pages (Step 2 to Step 12).
    // Step 2 is 1/11 (approx 9%), Step 12 is 11/11 (100%).
    double progress = 0.0;
    if (currentStep >= 2 && currentStep <= 12) {
      progress = (currentStep - 1) / 11;
    } else if (currentStep > 12) {
      progress = 1.0;
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

                // 2. AppBar with Custom Back Button and Page Number
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
                      Text(
                        "$currentStep/$totalSteps",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.iconColor,
                          fontSize: 16.sp,
                        ),
                      ),
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
