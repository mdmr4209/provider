import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newproject/core/widgets/custom_input.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_loader.dart';
import '../controllers/coach_bid_controller.dart';
import 'payment_success_view.dart';

class BuyTicketsView extends StatelessWidget {
  const BuyTicketsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<CoachBidController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.defaultColor,
        // These two lines prevent the color change / tinting when scrolling
        scrolledUnderElevation: 0,
        surfaceTintColor: AppColors.defaultColor,

        elevation: 0,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.west,
            color: AppColors.coachColorFF5E7958,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Raffle Draw',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.coachColorFFF5F0E8,
            fontSize: 16,
            fontFamily: 'Georgia',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: FutureBuilder(
        future: Future.delayed(const Duration(milliseconds: 1500)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildSkeletonLoader();
          }
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                // ── Price Card ─────────────────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: ShapeDecoration(
                    color: AppColors.coachColorFF243521,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Daily Raffle Update',
                            textAlign: TextAlign.justify,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.coachColorFF868A85,
                              fontSize: 13,
                              fontFamily: 'Segoe UI',
                              fontWeight: FontWeight.w400,
                              height: 1.20,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            spacing: 4.w,
                            children: [
                              Text(
                                '\$5.00',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.whiteColor,
                                  fontSize: 32,
                                  fontFamily: 'Segoe UI',
                                  fontWeight: FontWeight.w700,
                                  height: 1.50,
                                ),
                              ),

                              Text(
                                '/Ticket',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.whiteColor,
                                  fontSize: 12.07,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  height: 1.50,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SvgPicture.asset(AppAssets.ticket),
                    ],
                  ),
                ),

                SizedBox(height: 18.h),

                Text(
                  'Preffered Times',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.coachColorFFB9BBB0,
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(height: 8.h),

                // ── Quantity Input ──────────────────────────────────────────
                CustomInput(
                  height: 44,
                  hintText: "Enter amount of tickets",
                  fontSize: 14,
                  hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.whiteColor.withAlpha(153),
                    fontSize: 14,
                  ),
                  shadow: true,
                  borderRadius: 4,
                  borderWidth: 0.50,
                ),

                const Spacer(),

                CustomButton(
                  onPress: () async {
                    controller.buyTickets(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PaymentSuccessView(),
                      ),
                    );
                  },
                  title: "Pay Now",
                  linearGradient: true,
                ),

                SizedBox(height: 40.h),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          ShimmerLoader(
            width: double.infinity,
            height: 100.h,
            borderRadius: 16.r,
          ),
          SizedBox(height: 32.h),
          ShimmerLoader(width: 120.w, height: 16.h),
          SizedBox(height: 12.h),
          ShimmerLoader(
            width: double.infinity,
            height: 48.h,
            borderRadius: 12.r,
          ),
          const Spacer(),
          ShimmerLoader(
            width: double.infinity,
            height: 48.h,
            borderRadius: 24.r,
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}
