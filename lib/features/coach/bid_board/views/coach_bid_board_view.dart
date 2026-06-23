import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newproject/core/constants/app_assets.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_input.dart';
import '../../../../core/widgets/custom_loader.dart';
import '../controllers/coach_bid_controller.dart';
import 'raffle_draw_view.dart';

class CoachBidBoardView extends StatelessWidget {
  const CoachBidBoardView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<CoachBidController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctrl = context.read<CoachBidController>();
      if (!ctrl.hasFetched && !ctrl.isLoading && !ctrl.isRefreshing) {
        ctrl.fetchBidData();
      }
    });

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
        automaticallyImplyLeading: false,
        title: Text(
          'Bid Board',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.coachColorFFF5F0E8,
            fontSize: 16,
            fontFamily: 'Georgia',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: controller.isLoading
          ? _buildSkeletonLoader(context)
          : Stack(
              children: [
                RefreshIndicator(
                  onRefresh: () => controller.fetchBidData(isRefresh: true),
                  color: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  strokeWidth: 0,
                  elevation: 0,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),
                        // ── Top Bidders List Banner ──────────────────────────────────
                        if (controller.topBiddersInfo != null)
                          _buildTopBiddersBanner(context,
                            controller.topBiddersInfo!['title'] ??
                                'Top Bidders List',
                            controller.topBiddersInfo!['description'] ?? '',
                          ),

                        SizedBox(height: 24.h),

                        Text(
                          'List of bidders',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.coachColorFFB8BCB7,
                            fontSize: 14,
                            fontFamily: 'Segoe UI',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 5.h),

                        // ── Slots List ───────────────────────────────────────────────
                        if (controller.slots.isEmpty)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            child: Center(
                              child: Text(
                                "No slots available",
                                style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.white54Color),
                              ),
                            ),
                          )
                        else
                          ...controller.slots.map(
                            (slot) => _buildSlotItem(context,
                              slot.rank,
                              slot.title,
                              slot.startingBid,
                              slot.topBid,
                            ),
                          ),

                        SizedBox(height: 20.h),

                        // ── Bid Form ─────────────────────────────────────────────────
                        _buildBidForm(context, controller),

                        SizedBox(height: 20.h),

                        // ── Bottom Banner (Raffle or Winner) ──────────────────────────
                        controller.hasWon
                            ? _buildWinnerBanner(context)
                            : _buildRaffleBanner(context),

                        SizedBox(height: 5.h),
                        Text(
                          'Day 14 of No Contact. It was really hard today today, I almost texted him when I saw his favorite song playing. But I stayed strong! almost\nDay 14 of No Contact. It was really hard today today, I almost texted him when I saw his favorite song playing. But I=',
                          textAlign: TextAlign.justify,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.coachColorFF868A85,
                            fontSize: 11.19,
                            fontFamily: 'Segoe UI',
                            fontWeight: FontWeight.w400,
                            height: 1.20,
                          ),
                        ),
                        SizedBox(height: 100.h),
                      ],
                    ),
                  ),
                ),
                if (controller.isRefreshing)
                  Positioned(
                    top: 16.h,
                    left: 0,
                    right: 0,
                    child: const Center(child: CustomLoader(size: 100)),
                  ),
              ],
            ),
    );
  }

  Widget _buildTopBiddersBanner(BuildContext context, title, String description) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: 16.h,
        left: 12.w,
        right: 11.w,
        bottom: 16.h,
      ),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.14, 1.55),
          end: Alignment(0.88, -0.49),
          colors: [AppColors.coachColorFF304C2B, AppColors.coachColorFF0D1E0D],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.white54Color,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          const Icon(
            Icons.emoji_events_outlined,
            color: AppColors.coachColorFFC19E5F,
            size: 60,
          ),
        ],
      ),
    );
  }

  Widget _buildSlotItem(
    BuildContext context,
    String rank,
    String title,
    String starting,
    String top,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 4.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: ShapeDecoration(
        color: AppColors.defaultColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
      ),
      child: Row(
        children: [
          _buildRankIcon(rank),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  starting,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.white38Color, fontSize: 11),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                top,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                "Top Bid",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.white38Color, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRankIcon(String rank) {
    return Column(
      children: [
        if (rank == "1") SvgPicture.asset(AppAssets.icon1),
        if (rank == "2") SvgPicture.asset(AppAssets.icon2),
        if (rank == "3") SvgPicture.asset(AppAssets.icon3),
        if (rank == "4") SvgPicture.asset(AppAssets.icon4),
        if (rank == "5") SvgPicture.asset(AppAssets.icon5),
      ],
    );
  }

  Widget _buildBidForm(BuildContext context, CoachBidController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 24.h),
      decoration: ShapeDecoration(
        color: AppColors.coachColorFF243521,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Slot',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.coachColorFFB9BBB0,
              fontSize: 14,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: AppColors.coachColorFF21321E,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.white10Color),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.selectedSlot,
                hint: Text(
                  "Select one",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.white38Color, fontSize: 14),
                ),
                isExpanded: true,
                dropdownColor: AppColors.coachColorFF21321E,
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.white54Color,
                ),
                items: ["Slot 1", "Slot 2", "Slot 3", "Slot 4", "Slot 5"].map((
                  String value,
                ) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.whiteColor),
                    ),
                  );
                }).toList(),
                onChanged: (v) => controller.setSlot(v),
              ),
            ),
          ),
          SizedBox(height: 13.h),
          Text(
            'Amount',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.coachColorFFB9BBB0,
              fontSize: 14,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(height: 8.h),
          CustomInput(
            height: 44,
            hintText: "Search by Client name",
            fontSize: 14,
hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.whiteColor.withAlpha(153),
              fontSize: 14,
            ),
            shadow: true,
borderRadius: 4,
            borderWidth: 0.50,
leadingIcon: AppAssets.search,
            leadingPadding: EdgeInsets.only(left: 16.w, right: 8.w),
          ),
          SizedBox(height: 25.h),
          CustomButton(
            onPress: () async => controller.confirmBid(context),
            title: "Confirm Bid →",
            buttonColor: AppColors.coachColorA5354C30,
            borderColor: AppColors.coachColor33434928,
            height: 40,
            radius: 4,
            fontSize: 14,
          ),
        ],
      ),
    );
  }

  Widget _buildRaffleBanner(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const RaffleDrawView()),
      ),
      child: Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: AppColors.defaultColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(AppAssets.dailyRaffle),
                SizedBox(width: 12.w),
                Text(
                  'Daily Raffle',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.whiteColor,
                    fontSize: 17,
                    fontFamily: 'Segoe UI',
                    fontWeight: FontWeight.w600,
                    height: 1.76,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
             Text(
              'Day 14 of No Contact. It was really hard today today, I almost texted him when I saw his favorite song playing. But I stayed strong!',
              textAlign: TextAlign.justify,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.coachColorFF868A85,
                fontSize: 10,
                fontFamily: 'Segoe UI',
                fontWeight: FontWeight.w400,
                height: 1.20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWinnerBanner(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const RaffleDrawView()),
      ),
      child: Container(
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Congratulations's",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    "You Win the Spot 5",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.white70Color, fontSize: 14),
                  ),
                ],
              ),
            ),
            Text(
              "View →",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.coachColorFFC19E5F, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonLoader(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          // Banner
          ShimmerLoader(
            width: double.infinity,
            height: 100.h,
            borderRadius: 16.r,
          ),
          SizedBox(height: 32.h),
          // List of bidders title
          ShimmerLoader(width: 120.w, height: 16.h),
          SizedBox(height: 16.h),
          // Slots List
          ...List.generate(
            5,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: ShimmerLoader(
                width: double.infinity,
                height: 60.h,
                borderRadius: 12.r,
              ),
            ),
          ),
          SizedBox(height: 32.h),
          // Bid Form
          ShimmerLoader(width: 80.w, height: 14.h),
          SizedBox(height: 8.h),
          ShimmerLoader(
            width: double.infinity,
            height: 48.h,
            borderRadius: 8.r,
          ),
          SizedBox(height: 16.h),
          ShimmerLoader(width: 60.w, height: 14.h),
          SizedBox(height: 8.h),
          ShimmerLoader(
            width: double.infinity,
            height: 48.h,
            borderRadius: 8.r,
          ),
          SizedBox(height: 24.h),
          ShimmerLoader(
            width: double.infinity,
            height: 48.h,
            borderRadius: 24.r,
          ),
          SizedBox(height: 32.h),
          // Bottom Banner
          ShimmerLoader(
            width: double.infinity,
            height: 80.h,
            borderRadius: 16.r,
          ),
          SizedBox(height: 100.h),
        ],
      ),
    );
  }
}
