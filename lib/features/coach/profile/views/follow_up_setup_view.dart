import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/background_widget.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_input.dart';
import '../../../../core/widgets/custom_loader.dart';
import '../controllers/coach_profile_controller.dart';

class FollowUpSetupView extends StatelessWidget {
  const FollowUpSetupView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<CoachProfileController>();

    final intervals = [
      "7 Days",
      "60 Days",
      "30 Days",
      "90 Days",
      "6 Months",
      "12 Months",
      "14 Months",
    ];

    return BackgroundWidget(
      imagePath: AppAssets.bgMain,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.west, color: AppColors.coachColorFF5E7958, size: 24),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Follow Up Set Up',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.coachColorFFF5F0E8,
              fontSize: 16,
              fontFamily: 'Georgia',
              fontWeight: FontWeight.w400,
            ),
          ),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: Future.delayed(const Duration(milliseconds: 1500)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildSkeletonLoader();
            }
            return Padding(
              padding: EdgeInsets.all(24.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Follow Up Text',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Segoe UI',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    'Set automated Follow Up Text to send your clients',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.coachColorFF99A1AF,
                      fontSize: 12,
                      fontFamily: 'Segoe UI',
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  SizedBox(height: 16.h),

                  CustomInput(
                    height: 180,
                    hintText: "Enter here",
                    fontSize: 12,
hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.whiteColor.withAlpha(153),
                      fontSize: 12.sp,
                    ),
                    maxLines: 10,
                    shadow: true,
borderRadius: 8,
                    borderWidth: 0.50,
),
                  SizedBox(height: 32.h),

                  Text(
                    "Follow Up Message Set Up",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  SizedBox(height: 16.h),

                  Wrap(
                    spacing: 24.w,
                    runSpacing: 16.h,
                    children: intervals
                        .map((interval) => _buildCheckbox(controller, interval))
                        .toList(),
                  ),

                  const Spacer(),

                  CustomButton(
                    onPress: () async {},
                    title: "Save Follow Up Set Up",
                    linearGradient: true,
                  ),

                  SizedBox(height: 20.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCheckbox(CoachProfileController controller, String title) {
    final bool isSelected = controller.selectedFollowUpInterval == title;

    return InkWell(
      onTap: () => controller.setFollowUpInterval(title),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 18.r,
            height: 18.r,
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? AppColors.coachColorFFC19E5F : Colors.white38,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(4.r),
              color: isSelected ? AppColors.coachColorFFC19E5F : Colors.transparent,
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white, size: 12)
                : null,
          ),
          SizedBox(width: 10.w),
          Text(
            title,
            style: TextStyle(
              color: isSelected ? AppColors.coachColorFFC19E5F : Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return Padding(
      padding: EdgeInsets.all(24.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerLoader(width: 150.w, height: 20.h),
          SizedBox(height: 4.h),
          ShimmerLoader(width: 250.w, height: 14.h),
          SizedBox(height: 16.h),
          ShimmerLoader(
            width: double.infinity,
            height: 180.h,
            borderRadius: 12.r,
          ),
          SizedBox(height: 32.h),
          ShimmerLoader(width: 200.w, height: 20.h),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 24.w,
            runSpacing: 16.h,
            children: List.generate(
              7,
              (_) => ShimmerLoader(width: 80.w, height: 20.h),
            ),
          ),
          const Spacer(),
          ShimmerLoader(
            width: double.infinity,
            height: 50.h,
            borderRadius: 25.r,
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
