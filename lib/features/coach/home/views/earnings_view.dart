import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/background_widget.dart';
import '../../../../core/constants/app_assets.dart';

class EarningsView extends StatelessWidget {
  const EarningsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
          title: Text(
            "Earnings",
            style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              // ── Net Earnings Header ─────────────────────────────────────
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24.r),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2D3D2D), Color(0xFF1B2B1B)],
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Net Earnings", style: TextStyle(color: Colors.white70)),
                    SizedBox(height: 8.h),
                    Text(
                      "\$2,847.50",
                      style: theme.textTheme.headlineLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const Text("This month", style: TextStyle(color: Colors.white38)),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // ── Secondary Stats ──────────────────────────────────────────
              Row(
                children: [
                  Expanded(child: _buildSmallStatBox("Total Minutes Coached", "1200 min", Icons.phone_in_talk, const Color(0xFF64B5F6))),
                  SizedBox(width: 16.w),
                  Expanded(child: _buildSmallStatBox("Avg. Client Rating", "4.9 (187)", Icons.star, const Color(0xFFFBC02D))),
                ],
              ),

              SizedBox(height: 32.h),

              // ── Monthly Earning Header ──────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Monthly Earning", style: theme.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      _buildDropdown("April"),
                      SizedBox(width: 8.w),
                      _buildDropdown("2024"),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 16.h),
              const Text("Earing List", style: TextStyle(color: Colors.white54, fontSize: 12)),
              SizedBox(height: 16.h),

              // ── Earning List ────────────────────────────────────────────
              _buildEarningItem("Miles Esther", "12 April (9:30AM - 10:00AM)", "30 Minutes", "400\$"),
              _buildEarningItem("Miles Esther", "12 April (9:30AM - 10:00AM)", "30 Minutes", "400\$"),
              _buildEarningItem("Miles Esther", "12 April (9:30AM - 10:00AM)", "30 Minutes", "400\$"),
              _buildEarningItem("Miles Esther", "12 April (9:30AM - 10:00AM)", "30 Minutes", "400\$"),
              _buildEarningItem("Miles Esther", "12 April (9:30AM - 10:00AM)", "30 Minutes", "400\$"),

              const Divider(color: Colors.white10, height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total Earning", style: TextStyle(color: Colors.white, fontSize: 16)),
                  Text("1400\$", style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),

              SizedBox(height: 32.h),

              // ── BID Promotion ───────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D3D2D),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("BID To Become A Featured Coach", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8.h),
                    const Text(
                      "Day 14 of No Contact. It was really hard today today, I almost texted him when I saw his favorite song playing. But I stayed strong!",
                      style: TextStyle(color: Colors.white54, fontSize: 11),
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B4D3B),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                      ),
                      child: const Text("View all Bids", style: TextStyle(color: Colors.white70)),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 100.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmallStatBox(String label, String value, IconData icon, Color iconColor) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3D2D),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(icon, color: iconColor, size: 16),
              SizedBox(width: 8.w),
              Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3D2D),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
          const Icon(Icons.keyboard_arrow_down, color: Colors.white54, size: 16),
        ],
      ),
    );
  }

  Widget _buildEarningItem(String name, String dateTime, String duration, String amount) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20.r,
            backgroundImage: const NetworkImage('https://i.pravatar.cc/150?u=miles'),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text(dateTime, style: const TextStyle(color: Colors.white38, fontSize: 10)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(duration, style: const TextStyle(color: Colors.white38, fontSize: 10)),
              Text(amount, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
        ],
      ),
    );
  }
}
