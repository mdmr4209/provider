import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newproject/core/constants/app_colors.dart';
import '../../../../core/widgets/background_widget.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/custom_loader.dart';

class EarningsView extends StatelessWidget {
  const EarningsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
          icon: const Icon(Icons.west, color: AppColors.coachColorFF5E7958, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Earnings",
          style: theme.textTheme.titleLarge?.copyWith(
            color: AppColors.coachColorFFF4F6F0,
            fontWeight: FontWeight.w500,
            fontSize: 16.sp,
          ),
        ),
      ),
      body: FutureBuilder(
        future: Future.delayed(const Duration(milliseconds: 1500)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildSkeletonLoader();
          }
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12.h),
                // ── Net Earnings Header ─────────────────────────────────────
                Container(
                  width: double.infinity,
                  height: 124.h,
                  padding: EdgeInsets.only(
                    top: 16.h,
                    left: 12.w,
                    right: 11.w,
                    bottom: 16.h,
                  ),
                  decoration: ShapeDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.coachColorFF0D1E0D,
                        AppColors.coachColorFF304C2B,
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Net Earnings",
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "\$2,847.50",
                        style: theme.textTheme.headlineLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "This month",
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white38),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 12.h),

                // ── Secondary Stats ──────────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: _buildSmallStatBox(
                        "Total Minutes Coached",
                        "1200 min",
                        Icons.phone_in_talk,
                        AppColors.coachColorFF64B5F6,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: _buildSmallStatBox(
                        "Avg. Client Rating",
                        "4.9 (187)",
                        Icons.star,
                        AppColors.coachColorFFFBC02D,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 25.h),

                // ── Monthly Earning Header ──────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Monthly Earning",
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        _buildDropdown("April"),
                        SizedBox(width: 8.w),
                        _buildDropdown("2024"),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 10.h),
                Text(
                  'Earing List',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.coachColorFFB8BCB7,
                    fontSize: 14.r,
                    fontFamily: 'Segoe UI',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 7.h),

                // ── Earning List ────────────────────────────────────────────
                _buildEarningItem(
                  "Miles Esther",
                  "12 April (9:30AM - 10:00AM)",
                  "30 Minutes",
                  "400\$",
                ),
                _buildEarningItem(
                  "Miles Esther",
                  "12 April (9:30AM - 10:00AM)",
                  "30 Minutes",
                  "400\$",
                ),
                _buildEarningItem(
                  "Miles Esther",
                  "12 April (9:30AM - 10:00AM)",
                  "30 Minutes",
                  "400\$",
                ),
                _buildEarningItem(
                  "Miles Esther",
                  "12 April (9:30AM - 10:00AM)",
                  "30 Minutes",
                  "400\$",
                ),
                _buildEarningItem(
                  "Miles Esther",
                  "12 April (9:30AM - 10:00AM)",
                  "30 Minutes",
                  "400\$",
                ),

                Divider(color: AppColors.defaultColor, height: 24.r),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 7),
                  decoration: ShapeDecoration(
                    color: AppColors.coachColorFF243521,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Earning',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.coachColorFFB8BCB7,
                          fontSize: 14,
                          fontFamily: 'Segoe UI',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        "1400\$",
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 13.h),

                // ── BID Promotion ───────────────────────────────────────────
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.r),
                  decoration: ShapeDecoration(
                    color: AppColors.coachColorFF263523,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    shadows: [
                      BoxShadow(
                        color: AppColors.coachColor0F000000,
                        blurRadius: 24.20,
                        offset: Offset(0, 13),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'BID to become a featured Coach',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 13.34,
                          fontFamily: 'Segoe UI',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Day 14 of No Contact. It was really hard today today, I almost texted him when I saw his favorite song playing. But I stayed strong!',
                        textAlign: TextAlign.justify,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.coachColorFFD1D1D1,
                          fontSize: 10,
                          fontFamily: 'Segoe UI',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.coachColorFF354C30,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        child: Text(
                          "View all Bids",
                          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 100.h),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSmallStatBox(
    String label,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    return Container(
      height: 66.h,
      padding: EdgeInsets.all(12.r),
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: Alignment(1.00, -0.22),
          end: Alignment(0.47, 0.45),
          colors: [AppColors.coachColorFF22391E, AppColors.coachColorFF192915],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.white70, fontSize: 10.r),
          ),
          Row(
            children: [
              Container(
                width: 18.r,
                height: 18.r,
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: AppColors.coachColorFF253921,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9.r),
                  ),
                ),
                child: Icon(icon, color: iconColor, size: 16.r),
              ),
              SizedBox(width: 8.w),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: ShapeDecoration(
        color: AppColors.coachColorFF2C4728,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 0.50.r, color: AppColors.coachColorFF42673C),
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: Row(
        children: [
          Text(text, style: TextStyle(color: Colors.white, fontSize: 12)),
          const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.white54,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildEarningItem(
    String name,
    String dateTime,
    String duration,
    String amount,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Container(
        height: 68.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: ShapeDecoration(
          color: AppColors.defaultColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20.r,
              backgroundImage: const NetworkImage(
                'https://i.pravatar.cc/150?u=miles',
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    dateTime,
                    style: TextStyle(color: Colors.white38, fontSize: 10),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  duration,
                  style: TextStyle(color: Colors.white38, fontSize: 10),
                ),
                Text(
                  amount,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
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
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(
                child: ShimmerLoader(height: 90.h, borderRadius: 12.r),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: ShimmerLoader(height: 90.h, borderRadius: 12.r),
              ),
            ],
          ),
          SizedBox(height: 32.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerLoader(width: 150.w, height: 24.h),
              ShimmerLoader(width: 80.w, height: 24.h),
            ],
          ),
          SizedBox(height: 16.h),
          ShimmerLoader(width: 100.w, height: 16.h),
          SizedBox(height: 16.h),
          ...List.generate(
            5,
            (_) => Padding(
              padding: EdgeInsets.only(bottom: 24.h),
              child: Row(
                children: [
                  ShimmerLoader(width: 40.r, height: 40.r, borderRadius: 20.r),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerLoader(width: 120.w, height: 16.h),
                        SizedBox(height: 4.h),
                        ShimmerLoader(width: 80.w, height: 12.h),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ShimmerLoader(width: 60.w, height: 12.h),
                      SizedBox(height: 4.h),
                      ShimmerLoader(width: 50.w, height: 18.h),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
