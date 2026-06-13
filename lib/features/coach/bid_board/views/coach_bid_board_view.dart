import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/background_widget.dart';
import '../../../../core/widgets/custom_button.dart';
import '../controllers/coach_bid_controller.dart';
import 'raffle_draw_view.dart';

class CoachBidBoardView extends StatelessWidget {
  const CoachBidBoardView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<CoachBidController>();

    return BackgroundWidget(
      imagePath: AppAssets.bgHome,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text("Bid Board", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              // ── Top Bidders List Banner ──────────────────────────────────
              _buildTopBiddersBanner(),

              SizedBox(height: 32.h),

              const Text("List of bidders", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
              SizedBox(height: 16.h),

              // ── Slots List ───────────────────────────────────────────────
              _buildSlotItem("1", "Slot 1", "Starting Bid : \$25", "\$400", const Color(0xFFC19E5F)),
              _buildSlotItem("2", "Slot 2", "Starting Bid : \$25", "\$400", Colors.white54),
              _buildSlotItem("3", "Slot 3", "Starting Bid : \$25", "\$400", const Color(0xFFE57373)),
              _buildSlotItem("4", "Slot 4", "Starting Bid : \$25", "\$400", const Color(0xFFFB8C00)),
              _buildSlotItem("5", "Slot 5", "Depend on Raffle", "\$400", const Color(0xFFC19E5F)),

              SizedBox(height: 32.h),

              // ── Bid Form ─────────────────────────────────────────────────
              _buildBidForm(context, controller),

              SizedBox(height: 32.h),

              // ── Bottom Banner (Raffle or Winner) ──────────────────────────
              controller.hasWon ? _buildWinnerBanner(context) : _buildRaffleBanner(context),

              SizedBox(height: 100.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBiddersBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3D2D),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Top Bidders List", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 8),
                Text(
                  "Day 14 of No Contact. It was really hard today today, I almost texted him when I saw his favorite song playing. But I stayed strong!",
                  style: TextStyle(color: Colors.white54, fontSize: 11, height: 1.4),
                ),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          const Icon(Icons.emoji_events_outlined, color: Color(0xFFC19E5F), size: 60),
        ],
      ),
    );
  }

  Widget _buildSlotItem(String rank, String title, String starting, String top, Color rankColor) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3D2D),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          _buildRankIcon(rank, rankColor),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                Text(starting, style: const TextStyle(color: Colors.white38, fontSize: 11)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(top, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              const Text("Top Bid", style: TextStyle(color: Colors.white38, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRankIcon(String rank, Color color) {
    return Container(
      width: 32.r,
      height: 32.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 1),
      ),
      child: Center(
        child: Text(rank, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
      ),
    );
  }

  Widget _buildBidForm(BuildContext context, CoachBidController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Select Slot", style: TextStyle(color: Colors.white70, fontSize: 13)),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: const Color(0xFF2D3D2D),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.white10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: controller.selectedSlot,
              hint: const Text("Select one", style: TextStyle(color: Colors.white38, fontSize: 14)),
              isExpanded: true,
              dropdownColor: const Color(0xFF1B2B1B),
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white54),
              items: ["Slot 1", "Slot 2", "Slot 3", "Slot 4", "Slot 5"].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: (v) => controller.setSlot(v),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        const Text("Amount", style: TextStyle(color: Colors.white70, fontSize: 13)),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: const Color(0xFF2D3D2D),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.white10),
          ),
          child: TextField(
            controller: controller.amountController,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "Enter your bid amount",
              hintStyle: TextStyle(color: Colors.white38, fontSize: 14),
              border: InputBorder.none,
            ),
          ),
        ),
        SizedBox(height: 24.h),
        CustomButton(
          onPress: () async => controller.confirmBid(context),
          title: "Confirm Bid →",
          linearGradient: true,
        ),
      ],
    );
  }

  Widget _buildRaffleBanner(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RaffleDrawView())),
      child: Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: const Color(0xFF2D3D2D),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.emoji_events_outlined, color: Color(0xFFC19E5F), size: 32),
                SizedBox(width: 12.w),
                const Text("Daily Raffle", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            SizedBox(height: 8.h),
            const Text(
              "Day 14 of No Contact. It was really hard today today, I almost texted him when I saw his favorite song playing. But I stayed strong!",
              style: TextStyle(color: Colors.white54, fontSize: 11, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWinnerBanner(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RaffleDrawView())),
      child: Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: const Color(0xFF2D3D2D),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            const Icon(Icons.emoji_events_outlined, color: Color(0xFFC19E5F), size: 40),
            SizedBox(width: 16.w),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Congratulations's", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                  Text("You Win the Spot 5", style: TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ),
            const Text("View →", style: TextStyle(color: Color(0xFFC19E5F), fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
