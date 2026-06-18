import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newproject/core/widgets/custom_input.dart';
import 'package:newproject/core/widgets/input_text_widget.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/background_widget.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/custom_loader.dart';
import '../controllers/coach_home_controller.dart';

class SessionListView extends StatelessWidget {
  const SessionListView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final coachHome = context.watch<CoachHomeController>();

    return BackgroundWidget(
      imagePath: AppAssets.bgHome,
      child: Scaffold(
        backgroundColor: Color(0xFF2D3D2A),
        appBar: AppBar(
          backgroundColor: const Color(0xFF22331F),
          // These two lines prevent the color change / tinting when scrolling
          scrolledUnderElevation: 0,
          surfaceTintColor: const Color(0xFF22331F),

          elevation: 0,
          centerTitle: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
          ),
          leading: IconButton(
            icon: const Icon(Icons.west, color: Color(0xFF5E7958), size: 24),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "Session List",
            style: theme.textTheme.titleLarge?.copyWith(
              color: const Color(0xFFF4F6F0),
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
            return Column(
              children: [
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: AbsorbPointer(
                    child: CustomInput(
                      height: 50,
                      hintText: "Word Your Thoughts",
                      fontSize: 14,
                      hintColor: AppColors.greyColor,
                      hintStyle: Theme.of(context).textTheme.bodyLarge
                          ?.copyWith(
                        color: AppColors.whiteColor.withAlpha(153),
                        fontSize: 14.sp,
                      ),
                      shadow: true,
                      backgroundColor: AppColors.backgroundColor,
                      leadingIcon: AppAssets.feather,
                      leadingPadding: EdgeInsets.only(left: 16.w, right: 8.w),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),Container(
                  width: 342.46,
                  height: 44,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF21321E),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 0.50,
                        color: const Color(0xFF334B2F),
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0xFF2E4429),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                InputTextWidget(backgroundColor: AppColors.backgroundColor,),
                SizedBox(height: 20.h),
                // ── Search Bar ──────────────────────────────────────────────
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D3D2D),
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.white38),
                        SizedBox(width: 8.w),
                        const Expanded(
                          child: TextField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Search by Client name",
                              hintStyle: TextStyle(
                                color: Colors.white38,
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 24.h),

                // ── Session Filter Header ─────────────────────────────────────
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "All Sessions (4)",
                        style: TextStyle(color: Colors.white70),
                      ),
                      Row(
                        children: [
                          const Text(
                            "Date",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white70,
                            size: 16,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16.h),

                // ── Scrollable Session List ───────────────────────────────────
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return _buildSessionCard(
                        context,
                        coachHome,
                        "Session ${index + 1}",
                        "Mon, Mar 27",
                        "01:00 PM - 01:03 PM (30Min)",
                        "Miles Esther",
                        "20\$",
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSessionCard(
    BuildContext context,
    CoachHomeController controller,
    String title,
    String date,
    String time,
    String name,
    String rate,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2B19),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () => controller.cancelSession(context, "1"),
                child: Container(
                  width: 68.w,
                  height: 24.h,
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.91.w,
                    vertical: 2.45.h,
                  ),
                  decoration: ShapeDecoration(
                    color: const Color(0xFF263424),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.h),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.cancel_outlined,
                        color: Color(0xFFE57373),
                        size: 16,
                      ),
                      SizedBox(width: 4.w),
                      const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Color(0xFFE57373),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              const Icon(Icons.calendar_today, color: Colors.white54, size: 14),
              SizedBox(width: 8.w),
              Text(
                date,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              const Icon(Icons.access_time, color: Colors.white54, size: 14),
              SizedBox(width: 8.w),
              Text(
                time,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            height: 63.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: ShapeDecoration(
              color: const Color(0xFF263523),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 15.r,
                  backgroundImage: const NetworkImage(
                    'https://i.pravatar.cc/150?u=miles',
                  ),
                ),
                SizedBox(width: 12.w),
                Text(name, style: const TextStyle(color: Colors.white)),
                const Spacer(),
                Text(
                  rate,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return Column(
      children: [
        SizedBox(height: 20.h),
        // Search Bar Skeleton
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: ShimmerLoader(
            width: double.infinity,
            height: 48.h,
            borderRadius: 24.r,
          ),
        ),
        SizedBox(height: 24.h),
        // Filter Header Skeleton
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerLoader(width: 120.w, height: 20.h),
              ShimmerLoader(width: 60.w, height: 20.h),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        // Session List Skeleton
        Expanded(
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: 4,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(bottom: 16.h),
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D3D2D),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ShimmerLoader(width: 150.w, height: 20.h),
                        ShimmerLoader(width: 60.w, height: 16.h),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        ShimmerLoader(
                          width: 14.r,
                          height: 14.r,
                          borderRadius: 7.r,
                        ),
                        SizedBox(width: 8.w),
                        ShimmerLoader(width: 100.w, height: 14.h),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        ShimmerLoader(
                          width: 14.r,
                          height: 14.r,
                          borderRadius: 7.r,
                        ),
                        SizedBox(width: 8.w),
                        ShimmerLoader(width: 120.w, height: 14.h),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        ShimmerLoader(
                          width: 30.r,
                          height: 30.r,
                          borderRadius: 15.r,
                        ),
                        SizedBox(width: 12.w),
                        ShimmerLoader(width: 100.w, height: 16.h),
                        const Spacer(),
                        ShimmerLoader(width: 40.w, height: 16.h),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
