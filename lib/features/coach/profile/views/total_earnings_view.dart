import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/background_widget.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_loader.dart';
import '../controllers/coach_profile_controller.dart';
import 'withdrawal_request_view.dart';
import '../../../../core/constants/app_colors.dart';

class TotalEarningsView extends StatelessWidget {
  const TotalEarningsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<CoachProfileController>();

    return BackgroundWidget(
      imagePath: AppAssets.bgMain,
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
            'Total Earnings',
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
                children: [
                  // --- Balance Card ---
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
                              'Balance',
                              style: theme.textTheme.bodyMedium?.copyWith(
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
                              controller.balance
                                  .toStringAsFixed(0)
                                  .padLeft(3, '0'),
                              style: theme.textTheme.bodyMedium?.copyWith(
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

                  SizedBox(height: 40.h),

                  CustomButton(
                    onPress: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const WithdrawalRequestView(),
                        ),
                      );
                    },
                    title: "Request Withdrawal",
                    linearGradient: true,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return Padding(
      padding: EdgeInsets.all(24.r),
      child: Column(
        children: [
          SizedBox(height: 20.h),
          ShimmerLoader(
            width: double.infinity,
            height: 110.h,
            borderRadius: 16.r,
          ),
          SizedBox(height: 40.h),
          ShimmerLoader(
            width: double.infinity,
            height: 50.h,
            borderRadius: 25.r,
          ),
        ],
      ),
    );
  }
}
