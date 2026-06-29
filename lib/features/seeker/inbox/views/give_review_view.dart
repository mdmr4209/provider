import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newproject/core/widgets/custom_input.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';

class ReviewController extends ChangeNotifier {
  int _rating = 0;
  final TextEditingController commentController = TextEditingController();
  bool _isSubmitted = false;

  int get rating => _rating;
  bool get isSubmitted => _isSubmitted;

  void setRating(int val) {
    _rating = val;
    notifyListeners();
  }

  void submit() {
    _isSubmitted = true;
    notifyListeners();
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }
}

class GiveReviewView extends StatelessWidget {
  final String coachName;
  final String coachAvatar;

  const GiveReviewView({
    super.key,
    this.coachName = "Coach Pearl",
    this.coachAvatar = "https://i.pravatar.cc/150?u=coach_pearl",
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ReviewController>(
      create: (_) => ReviewController(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor.withAlpha(70),
        body: Center(
          child: SingleChildScrollView(
            child: Consumer<ReviewController>(
              builder: (context, controller, _) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: controller.isSubmitted
                      ? _buildDoneState(context, controller)
                      : _buildReviewState(context, controller),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReviewState(BuildContext context, ReviewController controller) {
    return Container(
      key: const ValueKey('review_state'),
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.only(top: 20.r),
      decoration: BoxDecoration(
        color: AppColors.coachColorFF2A3E27,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.primaryColor.withAlpha(51),
          width: 1,
        ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Close button at top right
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.close,
                  color: AppColors.whiteColor.withAlpha(128),
                  size: 20.r,
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              "Review",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontFamily: 'Georgia',
                color: AppColors.whiteColor,
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          SizedBox(height: 20.h),

          // Coach Info Row
          Container(
            color: AppColors.defaultColor,
            padding: EdgeInsets.only(top: 9.h,right: 12.w,left: 12.w,bottom: 24.h),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20.r,
                      backgroundImage: NetworkImage(coachAvatar),
                      backgroundColor: AppColors.whiteColor.withAlpha(26),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      coachName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.whiteColor,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                // Star ratings input
                Padding(
                  padding: EdgeInsets.only(left: 12.w,),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(5, (index) {
                          final starIndex = index + 1;
                          return GestureDetector(
                            onTap: () => controller.setRating(starIndex),
                            child: Padding(
                              padding: EdgeInsets.only(right: 12.w),
                              child: Icon(
                                controller.rating >= starIndex
                                    ? Icons.star
                                    : Icons.star_border,
                                color: AppColors.amberColor,
                                size: 32.r,
                              ),
                            ),
                          );
                        }),
                      ),

                      SizedBox(height: 20.h),

                      // Comment box
                      CustomInput(
                        backgroundColor: AppColors.coachColorFF2A3E27,
                        controller: controller.commentController,
                        maxLines: 4,
                        hintStyle: Theme.of(context).textTheme.bodyMedium
                            ?.copyWith(
                            color: AppColors.whiteColor.withAlpha(77),
                            fontSize: 14.sp),
                        hintText: "Enter your Comment",
                        borderRadius: 8,
                      ),

                      SizedBox(height: 24.h),

                      // Say it button
                      CustomButton(
                        onPress: () async {
                          if (controller.rating == 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select a rating star'),
                              ),
                            );
                            return;
                          }
                          controller.submit();
                        },
                        title: "Say it!",
                        linearGradient: true,
                        height: 48,
                        radius: 8,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoneState(BuildContext context, ReviewController controller) {
    return Container(
      key: const ValueKey('done_state'),
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: AppColors.coachColorFF2A3E27,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.primaryColor.withAlpha(51),
          width: 1,
        ),
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
        children: [
          // Circular Checkmark Icon
          Container(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(
              color: AppColors.whiteColor.withAlpha(13),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.whiteColor.withAlpha(26),
                width: 1.5.r,
              ),
            ),
            child: Icon(Icons.check, color: AppColors.whiteColor, size: 24.r),
          ),

          SizedBox(height: 20.h),

          Text(
            "Done!",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontFamily: 'Georgia',
              color: AppColors.whiteColor,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 8.h),

          Text(
            "Thank you for your review",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.whiteColor.withAlpha(153),
              fontSize: 14.sp,
            ),
          ),

          SizedBox(height: 24.h),

          // Star ratings display
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starIndex = index + 1;
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Icon(
                  controller.rating >= starIndex
                      ? Icons.star
                      : Icons.star_border,
                  color: AppColors.amberColor,
                  size: 32.r,
                ),
              );
            }),
          ),

          SizedBox(height: 32.h),

          // Close/Dismiss button
          CustomButton(
            onPress: () async {
              Navigator.pop(context);
            },
            title: "Close",
            linearGradient: true,
            height: 48,
            radius: 8,
          ),
        ],
      ),
    );
  }
}
