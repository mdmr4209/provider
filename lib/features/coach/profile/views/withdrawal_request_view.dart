import 'package:newproject/core/theme/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/background_widget.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_loader.dart';
import '../controllers/coach_profile_controller.dart';
import '../../../../core/constants/app_colors.dart';

class WithdrawalRequestView extends StatelessWidget {
  const WithdrawalRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<CoachProfileController>();

    return BackgroundWidget(
      imagePath: AppAssets.bgHome,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.white70Color),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "Request Withdrawal",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.whiteColor,
              fontWeight: FontWeight.bold,
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
            return SingleChildScrollView(
              padding: EdgeInsets.all(24.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel(context, "Card Holder Name"),
                  _buildTextField(
                    context,
                    controller.cardHolderNameController,
                    "Prabal Pratap Singh",
                  ),

                  SizedBox(height: 24.h),

                  _buildLabel(context, "Card Number"),
                  _buildTextField(
                    context,
                    controller.cardNumberController,
                    "5296 7820 4820 9637",
                  ),

                  SizedBox(height: 24.h),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel(context, "MM/YY"),
                            _buildTextField(
                              context,
                              controller.expiryDateController,
                              "12/24",
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel(context, "CVC"),
                            _buildTextField(
                              context,
                              controller.cvcController,
                              "****",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 24.h),

                  _buildLabel(context, "Request Amount"),
                  _buildTextField(
                    context,
                    controller.withdrawalAmountController,
                    "Enter here",
                  ),

                  SizedBox(height: 100.h),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 40.h),
          child: CustomButton(
            onPress: () async {
              Navigator.pop(context); // From Request
              Navigator.pop(context); // From Total Earnings
              // Show success message
            },
            title: "Confirm Request",
            linearGradient: true,
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h, left: 4.w),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.white70Color,
          fontSize: 14.sp,
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context,
    TextEditingController controller,
    String hint,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).extension<AppDesignSystem>()!.panelColor.withAlpha(150),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextField(
        controller: controller,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: AppColors.whiteColor),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.white24Color,
            fontSize: 14,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(24.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerLoader(width: 120.w, height: 16.h),
          SizedBox(height: 12.h),
          ShimmerLoader(
            width: double.infinity,
            height: 50.h,
            borderRadius: 12.r,
          ),
          SizedBox(height: 24.h),
          ShimmerLoader(width: 100.w, height: 16.h),
          SizedBox(height: 12.h),
          ShimmerLoader(
            width: double.infinity,
            height: 50.h,
            borderRadius: 12.r,
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerLoader(width: 60.w, height: 16.h),
                    SizedBox(height: 12.h),
                    ShimmerLoader(
                      width: double.infinity,
                      height: 50.h,
                      borderRadius: 12.r,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerLoader(width: 40.w, height: 16.h),
                    SizedBox(height: 12.h),
                    ShimmerLoader(
                      width: double.infinity,
                      height: 50.h,
                      borderRadius: 12.r,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          ShimmerLoader(width: 120.w, height: 16.h),
          SizedBox(height: 12.h),
          ShimmerLoader(
            width: double.infinity,
            height: 50.h,
            borderRadius: 12.r,
          ),
        ],
      ),
    );
  }
}
