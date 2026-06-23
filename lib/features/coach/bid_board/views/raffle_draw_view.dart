import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_loader.dart';
import '../controllers/coach_bid_controller.dart';
import 'buy_tickets_view.dart';

class RaffleDrawView extends StatelessWidget {
  const RaffleDrawView({super.key});

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
                // ── Top Banner (Raffle or Win) ───────────────────────────────
                controller.hasWon
                    ? _buildWinnerBanner(context)
                    : _buildRaffleBanner(context),

                SizedBox(height: 20.h),

                // ── Terms and Conditions ─────────────────────────────────────
                ...List.generate(
                  3,
                  (index) => Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: Text(
                      "${index + 1}. Welcome to Ai. By using our services, you agree to abide by the terms and conditions outlined below. ",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.white54Color,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 25.h),

                // ── Raffle Summary Card ──────────────────────────────────────
                _buildSummaryCard(context, controller),

                SizedBox(height: 25.h),

                CustomButton(
                  onPress: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const BuyTicketsView()),
                    );
                  },
                  title: "Buy more ticket",
                  linearGradient: true,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRaffleBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: Alignment(-0.00, 0.94),
          end: Alignment(1.42, -0.62),
          colors: [AppColors.coachColorFF102710, AppColors.coachColorFF2F432B],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: Row(
        children: [
          SvgPicture.asset(AppAssets.dailyRaffle),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Daily Raffle",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Day 14 of No Contact. It was really hard today today, I almost texted him when I saw his favorite song playing. But I stayed strong!",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.white54Color,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWinnerBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: Alignment(-0.00, 0.94),
          end: Alignment(1.42, -0.62),
          colors: [AppColors.coachColorFF102710, AppColors.coachColorFF2F432B],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: Row(
        children: [
          Image.asset(AppAssets.win),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Congratulations's",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              Text(
                "You Win the Spot 5",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.white70Color,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    CoachBidController controller,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
      decoration: ShapeDecoration(
        color: AppColors.coachColorFF243521,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Column(
        children: [
          Text(
            'My Raffle Summary',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.whiteColor,
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              height: 1.07,
            ),
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  context,
                  "My Ticket",
                  controller.myTickets.toString(),
                ),
              ),
              Container(width: 1, height: 40, color: AppColors.white12Color),
              Expanded(
                child: _buildSummaryItem(
                  context,
                  "Total Coaches",
                  controller.totalCoaches.toString(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.coachColorFF868A85,
            fontSize: 10,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            height: 1.50,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.confirmation_number_outlined,
              color: AppColors.coachColorFFC19E5F,
              size: 18,
            ),
            SizedBox(width: 8.w),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.whiteColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
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
            height: 120.h,
            borderRadius: 16.r,
          ),
          SizedBox(height: 25.h),
          ...List.generate(
            3,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: ShimmerLoader(
                width: double.infinity,
                height: 60.h,
                borderRadius: 8.r,
              ),
            ),
          ),
          SizedBox(height: 25.h),
          ShimmerLoader(
            width: double.infinity,
            height: 120.h,
            borderRadius: 16.r,
          ),
          const Spacer(),
          ShimmerLoader(
            width: double.infinity,
            height: 50.h,
            borderRadius: 25.r,
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}
