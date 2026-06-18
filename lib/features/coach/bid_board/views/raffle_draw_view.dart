import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/background_widget.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_loader.dart';
import '../controllers/coach_bid_controller.dart';
import 'buy_tickets_view.dart';

class RaffleDrawView extends StatelessWidget {
  const RaffleDrawView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CoachBidController>();

    return Scaffold(
      backgroundColor: Color(0xFF2D3D2A),
      appBar: AppBar(
        backgroundColor: Color(0xFF22331F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Raffle Draw",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                // ── Top Banner (Raffle or Win) ───────────────────────────────
                controller.hasWon ? _buildWinnerBanner() : _buildRaffleBanner(),

                SizedBox(height: 20.h),

                // ── Terms and Conditions ─────────────────────────────────────
                ...List.generate(
                  3,
                  (index) => Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: Text(
                      "${index + 1}. Welcome to Ai. By using our services, you agree to abide by the terms and conditions outlined below. These terms govern your access to and use of Ai tools and services, so please review them carefully before proceeding.",
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 25.h),

                // ── Raffle Summary Card ──────────────────────────────────────
                _buildSummaryCard(controller),


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

  Widget _buildRaffleBanner() {
    return Container(
      width: double.infinity,
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
          const Icon(
            Icons.emoji_events_outlined,
            color: Color(0xFFC19E5F),
            size: 50,
          ),
          SizedBox(width: 16.w),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Daily Raffle",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Day 14 of No Contact. It was really hard today today, I almost texted him when I saw his favorite song playing. But I stayed strong!",
                  style: TextStyle(
                    color: Colors.white54,
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

  Widget _buildWinnerBanner() {
    return Container(
      width: double.infinity,
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
          const Icon(
            Icons.emoji_events_outlined,
            color: Color(0xFFC19E5F),
            size: 60,
          ),
          SizedBox(width: 16.w),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Congratulations's",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              Text(
                "You Win the Spot 5",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(CoachBidController controller) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3D2D),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          const Text(
            "My Raffle Summary",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  "My Ticket",
                  controller.myTickets.toString(),
                ),
              ),
              Container(width: 1, height: 40, color: Colors.white12),
              Expanded(
                child: _buildSummaryItem(
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

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.confirmation_number_outlined,
              color: Color(0xFFC19E5F),
              size: 18,
            ),
            SizedBox(width: 8.w),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
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
          SizedBox(height: 32.h),
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
          SizedBox(height: 32.h),
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
