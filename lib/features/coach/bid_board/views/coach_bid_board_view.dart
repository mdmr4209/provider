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
    final controller = context.watch<CoachBidController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctrl = context.read<CoachBidController>();
      if (!ctrl.hasFetched && !ctrl.isLoading && !ctrl.isRefreshing) {
        ctrl.fetchBidData();
      }
    });

    return Scaffold(
      backgroundColor: Color(0xFF2D3D2A),
      appBar: AppBar(
        backgroundColor: Color(0xFF22331F),
        // These two lines prevent the color change / tinting when scrolling
        scrolledUnderElevation: 0,
        surfaceTintColor: const Color(0xFF22331F),

        elevation: 0,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
        ),
        automaticallyImplyLeading: false,
        title: Text(
          'Bid Board',
          style: TextStyle(
            color: const Color(0xFFF5F0E8),
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
                          _buildTopBiddersBanner(
                            controller.topBiddersInfo!['title'] ??
                                'Top Bidders List',
                            controller.topBiddersInfo!['description'] ?? '',
                          ),

                        SizedBox(height: 24.h),

                        Text(
                          'List of bidders',
                          style: TextStyle(
                            color: const Color(0xFFB8BCB7),
                            fontSize: 14,
                            fontFamily: 'Segoe UI',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 5.h),

                        // ── Slots List ───────────────────────────────────────────────
                        if (controller.slots.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            child: Center(
                              child: Text(
                                "No slots available",
                                style: TextStyle(color: Colors.white54),
                              ),
                            ),
                          )
                        else
                          ...controller.slots.map(
                            (slot) => _buildSlotItem(
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
                          style: TextStyle(
                            color: const Color(0xFF868A85),
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

  Widget _buildTopBiddersBanner(String title, String description) {
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
          colors: [const Color(0xFF304C2B), const Color(0xFF0D1E0D)],
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white54,
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
            color: Color(0xFFC19E5F),
            size: 60,
          ),
        ],
      ),
    );
  }

  Widget _buildSlotItem(
    String rank,
    String title,
    String starting,
    String top,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 4.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: ShapeDecoration(
        color: const Color(0xFF22331F),
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  starting,
                  style: const TextStyle(color: Colors.white38, fontSize: 11),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                top,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Text(
                "Top Bid",
                style: TextStyle(color: Colors.white38, fontSize: 10),
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
        color: const Color(0xFF243521),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Slot',
            style: TextStyle(
              color: const Color(0xFFB9BBB0),
              fontSize: 14,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: const Color(0xFF21321E),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.white10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.selectedSlot,
                hint: const Text(
                  "Select one",
                  style: TextStyle(color: Colors.white38, fontSize: 14),
                ),
                isExpanded: true,
                dropdownColor: const Color(0xFF21321E),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white54,
                ),
                items: ["Slot 1", "Slot 2", "Slot 3", "Slot 4", "Slot 5"].map((
                  String value,
                ) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(color: Colors.white),
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
            style: TextStyle(
              color: const Color(0xFFB9BBB0),
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
            hintColor: AppColors.greyColor,
            hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.whiteColor.withAlpha(153),
              fontSize: 14,
            ),
            shadow: true,
            shadowColor: Color(0xFF2E4429),
            backgroundColor: Color(0xFF21321E),
            borderRadius: 4,
            borderWidth: 0.50,
            borderColor: Color(0xFF334B2F),
            leadingIcon: AppAssets.search,
            leadingPadding: EdgeInsets.only(left: 16.w, right: 8.w),
          ),
          SizedBox(height: 25.h),
          CustomButton(
            onPress: () async => controller.confirmBid(context),
            title: "Confirm Bid →",
            buttonColor: Color(0xA5354C30),
            borderColor: Color(0x33434928),
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
          color: const Color(0xFF22331F),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(AppAssets.dailyRaffle),
                SizedBox(width: 12.w),
                const Text(
                  'Daily Raffle',
                  style: TextStyle(
                    color: Colors.white,
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
              style: TextStyle(
                color: const Color(0xFF868A85),
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
            colors: [const Color(0xFF102710), const Color(0xFF2F432B)],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Row(
          children: [
            Image.asset(AppAssets.win),
            SizedBox(width: 16.w),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Congratulations's",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    "You Win the Spot 5",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            const Text(
              "View →",
              style: TextStyle(color: Color(0xFFC19E5F), fontSize: 12),
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
