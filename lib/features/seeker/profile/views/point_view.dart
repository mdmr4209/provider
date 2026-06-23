import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:newproject/core/constants/app_assets.dart';
import 'package:newproject/core/constants/app_colors.dart';
import 'package:newproject/core/widgets/background_widget.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_loader.dart';
import '../controllers/profile_controller.dart';

class PointView extends StatelessWidget {
  const PointView({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<ProfileController>();
      if (controller.history.isEmpty && !controller.isLoading) {
        controller.fetchPointHistory();
      }
    });

    return BackgroundWidget(
      imagePath: AppAssets.bgMain,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.west,
              color: AppColors.coachColorFF5E7958,
              size: 24,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Credit Balance',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.coachColorFFF5F0E8,
              fontSize: 16,
              fontFamily: 'Georgia',
              fontWeight: FontWeight.w400,
            ),
          ),
          centerTitle: true,
        ),
        body: Consumer<ProfileController>(
          builder: (context, controller, child) {
            if (controller.isLoading && controller.history.isEmpty) {
              return const SafeArea(child: _PointShimmer());
            }

            final pointsDigits = controller.currentPoints
                .toString()
                .padLeft(3, '0')
                .split('');
            final pointsStr = pointsDigits.join(' ');

            return Stack(
              children: [
                RefreshIndicator(
                  onRefresh: () =>
                      controller.fetchPointHistory(isRefresh: true),
                  color: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  strokeWidth: 0,
                  elevation: 0,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(20.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Credit Balance Card ────────────────────────────────────────
                        Container(
                          width: double.infinity,
                          clipBehavior: Clip.antiAlias,
                          padding: EdgeInsets.only(
                            left: 20.w,
                            top: 16.h,
                            right: 21.w,
                            bottom: 14.h,
                          ),
                          decoration: ShapeDecoration(
                            gradient: LinearGradient(
                              begin: Alignment(0.03, 0.86),
                              end: Alignment(0.97, 0.14),
                              colors: [
                                AppColors.coachColorFF193115,
                                AppColors.coachColorFF486244,
                              ],
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Credits Balance',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: AppColors.whiteColor,
                                          fontSize: 14,
                                          fontFamily: 'Segoe UI',
                                          fontWeight: FontWeight.w400,
                                          height: 1.50,
                                          letterSpacing: 0.56,
                                        ),
                                  ),
                                  SizedBox(height: 9.h),
                                  Text(
                                    pointsStr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: AppColors.whiteColor,
                                          fontSize: 20,
                                          fontFamily: 'Segoe UI',
                                          fontWeight: FontWeight.w400,
                                          height: 1.05,
                                          letterSpacing: 3.60,
                                        ),
                                  ),
                                ],
                              ),
                              // Mock overlapping circles
                              SvgPicture.asset(AppAssets.balance),
                            ],
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Text(
                          "Valid Until 23 April 2026",
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppColors.whiteColor.withAlpha(128),
                                fontSize: 13.sp,
                              ),
                        ),
                        SizedBox(height: 16.h),
                        const Divider(color: AppColors.white12Color),
                        SizedBox(height: 24.h),
                        // ── Instructions ────────────────────────────────────────────────
                        _buildNumberedText(context, 
                          "1.",
                          "Welcome to Ai. By using our services, you agree to abide by the terms and conditions outlined below. These terms govern your access to and",
                        ),
                        _buildNumberedText(context, 
                          "2.",
                          "use of Ai tools and services, so please review them carefully before proceeding.",
                        ),
                        _buildNumberedText(context, 
                          "3.",
                          "Ai provides innovative tools designed to enhance how you capture and manage voice recordings. Our services include voice-to-text transcription and AI-driven summarization, which are intended",
                        ),
                        _buildNumberedText(context, 
                          "4.",
                          "for lawful, ethical purposes only. You must ensure compliance with applicable laws, including obtaining consent from all participants when recording conversations. CleverTalk disclaims liability for any misuse of its tools.",
                        ),
                        SizedBox(height: 40.h),
                      ],
                    ),
                  ),
                ),
                if (controller.isRefreshing)
                  Positioned(
                    top: 16.h,
                    left: 0,
                    right: 0,
                    child: const Center(child: CustomLoader(size: 150)),
                  ),
              ],
            );
          },
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(20.r),
          child: CustomButton(
            onPress: () async {
              // Handle buy more credits
            },
            title: "Buy More Credits",
            linearGradient: true,
          ),
        ),
      ),
    );
  }

  // Widget _buildCircle(double size) {
  //   return Container(
  //     width: size.r,
  //     height: size.r,
  //     decoration: const BoxDecoration(
  //       color: AppColors.whiteColor,
  //       shape: BoxShape.circle,
  //     ),
  //   );
  // }

  Widget _buildNumberedText(BuildContext context, String number, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24.w,
            child: Text(
              number,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.whiteColor.withAlpha(179),
                fontSize: 14.sp,
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.whiteColor.withAlpha(179),
                fontSize: 14.sp,
                height: 1.8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PointShimmer extends StatelessWidget {
  const _PointShimmer();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerLoader(
            width: double.infinity,
            height: 120.h,
            borderRadius: 16.r,
          ),
          SizedBox(height: 24.h),
          ShimmerLoader(width: 150.w, height: 16.h, borderRadius: 4.r),
          SizedBox(height: 16.h),
          const Divider(color: AppColors.white12Color),
          SizedBox(height: 24.h),
          Column(
            children: List.generate(
              3,
              (index) => Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: Row(
                  children: [
                    ShimmerLoader(width: 24.w, height: 20.h, borderRadius: 4.r),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ShimmerLoader(height: 40.h, borderRadius: 4.r),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
