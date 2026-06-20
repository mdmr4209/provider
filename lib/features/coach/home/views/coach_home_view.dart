import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:newproject/core/constants/app_colors.dart';
import 'package:newproject/core/widgets/glass_widget.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/custom_loader.dart';
import '../controllers/coach_home_controller.dart';

class CoachHomeView extends StatelessWidget {
  const CoachHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      final controller = context.read<CoachHomeController>();
      if (controller.stats == null && !controller.isLoading) {
        controller.fetchHomeData();
      }
    });

    final theme = Theme.of(context);
    final coachHome = context.watch<CoachHomeController>();

    return Scaffold(
appBar: AppBar(
        scrolledUnderElevation: 0,
elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: Colors.transparent,
                child: Image.asset(AppAssets.sb2Logo),
              ),
              SizedBox(width: 8.w),
              Text(
                "StrongBack2",
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        leadingWidth: 200.w,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: SvgPicture.asset(AppAssets.notify, width: 24.r),
          ),
        ],
      ),
      body: coachHome.isLoading
          ? _buildSkeletonLoader(context)
          : Stack(
              children: [
                RefreshIndicator(
                  onRefresh: () => coachHome.fetchHomeData(isRefresh: true),
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
                        // ── Profile Header ──────────────────────────────────────────
                        Container(
                          padding: EdgeInsets.all(16.92.r),
                          decoration: ShapeDecoration(
                            color: AppColors.coachColorFF21321D,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 35.r,
                                backgroundImage: const NetworkImage(
                                  'https://i.pravatar.cc/150?u=coach_kamran',
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Md. Kamran",
                                      style: theme.textTheme.headlineSmall
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    Text(
                                      "Coach",
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(color: Colors.white70),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    "Active",
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.white70,
                                    ),
                                  ),
                                  Switch(
                                    value: coachHome.isActive,
                                    onChanged: (_) =>
                                        coachHome.toggleActive(context),
                                    activeThumbColor: AppColors.whiteColor,
                                    activeTrackColor: AppColors.iconColor,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 24.h),

                        // ── Stats Row ───────────────────────────────────────────────
                        if (coachHome.stats != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildStatBox(
                                "Call Back Requests",
                                coachHome.stats!.callBackRequests,
                                Icons.phone_callback,
                                AppColors.coachColorFF64B5F6,
                              ),
                              _buildStatBox(
                                "New Messages",
                                coachHome.stats!.newMessages,
                                Icons.chat_bubble_outline,
                                AppColors.coachColorFF81C784,
                              ),
                              _buildStatBox(
                                "Missed Calls",
                                coachHome.stats!.missedCalls,
                                Icons.phone_missed,
                                AppColors.coachColorFFE57373,
                              ),
                            ],
                          ),

                        SizedBox(height: 24.h),

                        // ── Earnings Card ───────────────────────────────────────────
                        if (coachHome.stats != null)
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Net Earnings",
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(color: Colors.white70),
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      coachHome.stats!.netEarnings,
                                      style: theme.textTheme.headlineMedium
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      coachHome.stats!.earningsPeriod,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(color: Colors.white38),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () => context.push('/coach-earnings'),
                                  child: Row(
                                    children: [
                                      Text(
                                        "View",
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color: AppColors.iconColor,
                                            ),
                                      ),
                                      const Icon(
                                        Icons.arrow_forward,
                                        color: AppColors.iconColor,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                        SizedBox(height: 13.h),

                        // ── Upcoming Sessions Header ────────────────────────────────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Upcoming Sessions",
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () => context.push('/coach-sessions'),
                              child: Text(
                                "See All",
                                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white54),
                              ),
                            ),
                          ],
                        ),

                        // ── Session List ────────────────────────────────────────────
                        if (coachHome.sessions.isEmpty)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: Center(
                              child: Text(
                                "No upcoming sessions",
                                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white54),
                              ),
                            ),
                          )
                        else
                          ...coachHome.sessions.map(
                            (session) => _buildSessionCard(
                              context,
                              coachHome,
                              session.title,
                              session.date,
                              session.time,
                              session.clientName,
                              session.rate,
                              session.clientAvatar,
                            ),
                          ),

                        SizedBox(height: 24.h),

                        // ── Bid Banner ──────────────────────────────────────────────
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 13.h,
                          ),
                          decoration: ShapeDecoration(
                            color: AppColors.coachColorFF263523,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            shadows: [
                              BoxShadow(
                                color: AppColors.coachColor0F000000,
                                blurRadius: 24.20,
                                offset: Offset(0, 13),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 321.w,
                                padding: EdgeInsets.all(11.44.r),
                                decoration: ShapeDecoration(
                                  color: AppColors.coachColorFF21321D,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      width: 0.95.r,
                                      color: AppColors.coachColorFF354C30,
                                    ),
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(AppAssets.addBid),
                                    SizedBox(width: 16.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Add a BID to become a featured Coach",
                                            style: theme.textTheme.bodyMedium?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13.r,
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            "Increase your visibility and get more bookings by bidding for a featured spot.",
                                            style: theme.textTheme.bodyMedium?.copyWith(
                                              color: Colors.white70,
                                              fontSize: 10.r,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'Day 14 of No Contact. It was really hard today today, I almost texted him when I saw his favorite song playing. But I stayed strong!',
                                textAlign: TextAlign.justify,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.coachColorFFD1D1D1,
                                  fontSize: 12,
                                  fontFamily: 'Segoe UI',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              GlassWidget(
                                color: AppColors.coachColorFF263523,
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 44.r,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Place a Bid Now',
                                        textAlign: TextAlign.center,
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: AppColors.coachColorFFEFC348,
                                          fontSize: 14,
                                          fontFamily: 'Segoe UI',
                                          fontWeight: FontWeight.w400,
                                          height: 1.50,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 24.h),

                        // ── New Messages ────────────────────────────────────────────
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          decoration: ShapeDecoration(
                            color: AppColors.coachColorFF1D2A1A,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12.r),
                                topRight: Radius.circular(12.r),
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.chat_bubble_outline,
                                    color: AppColors.coachColorFF81C784,
                                    size: 18,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    "New Text Messages",
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  "See All",
                                  style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.iconColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            top: 15.h,
                            left: 11.w,
                            right: 11.w,
                            bottom: 12.h,
                          ),
                          decoration: ShapeDecoration(
                            color: AppColors.coachColorFF253523,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(12.r),
                                bottomRight: Radius.circular(12.r),
                              ),
                            ),
                            shadows: [
                              BoxShadow(
                                color: AppColors.coachColor0F000000,
                                blurRadius: 24.20,
                                offset: Offset(0, 13),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              if (coachHome.messages.isEmpty)
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20.h),
                                  child: Center(
                                    child: Text(
                                      "No new messages",
                                      style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white54),
                                    ),
                                  ),
                                )
                              else
                                ...coachHome.messages.map(
                                  (msg) => _buildMessageCard(
                                    msg.senderName,
                                    msg.status,
                                    msg.time,
                                    msg.unreadCount,
                                    msg.senderAvatar,
                                  ),
                                ),
                            ],
                          ),
                        ),

                        SizedBox(height: 100.h),
                      ],
                    ),
                  ),
                ),
                if (coachHome.isRefreshing)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black26,
                      child: const Center(child: CustomLoader()),
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _buildStatBox(
    String label,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    return Container(
      width: 109.w,
      padding: EdgeInsets.only(top: 12.28.h, left: 12.28.w, bottom: 12.28.h),
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
            style: TextStyle(color: Colors.white70, fontSize: 10.sp),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Container(
                width: 28.r,
                height: 28.r,
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: AppColors.coachColorFF253921,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Icon(icon, color: iconColor, size: 18.r),
              ),
              SizedBox(width: 8.w),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
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
    String avatar,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.coachColorFF1C2B19,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
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
                    color: AppColors.coachColorFF263424,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.h),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.cancel_outlined,
                        color: AppColors.coachColorFFE57373,
                        size: 16,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "Cancel",
                        style: TextStyle(
                          color: AppColors.coachColorFFE57373,
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
                style: TextStyle(color: Colors.white70, fontSize: 12),
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
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            height: 63.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: ShapeDecoration(
              color: AppColors.coachColorFF263523,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 15.r,
                  backgroundImage: NetworkImage(avatar),
                ),
                SizedBox(width: 12.w),
                Text(name, style: TextStyle(color: Colors.white)),
                const Spacer(),
                Text(
                  rate,
                  style: TextStyle(
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

  Widget _buildMessageCard(
    String name,
    String status,
    String time,
    String count,
    String avatar,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.only(
        top: 11.h,
        left: 12.w,
        right: 16.w,
        bottom: 16.h,
      ),
      decoration: ShapeDecoration(
        color: AppColors.coachColorFF2B3C28,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 20.r, backgroundImage: NetworkImage(avatar)),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  status,
                  style: TextStyle(
                    color: AppColors.coachColorFF81C784,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: TextStyle(color: Colors.white38, fontSize: 10),
              ),
              SizedBox(height: 4.h),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.coachColorFF81C784,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  count,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
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
          // Profile Header
          Row(
            children: [
              ShimmerLoader(width: 70.r, height: 70.r, borderRadius: 35.r),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerLoader(width: 150.w, height: 24.h),
                    SizedBox(height: 8.h),
                    ShimmerLoader(width: 100.w, height: 16.h),
                  ],
                ),
              ),
              ShimmerLoader(
                width: 50.w,
                height: 30.h,
                borderRadius: 15.r,
              ), // Switch
            ],
          ),
          SizedBox(height: 24.h),
          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerLoader(width: 105.w, height: 90.h, borderRadius: 12.r),
              ShimmerLoader(width: 105.w, height: 90.h, borderRadius: 12.r),
              ShimmerLoader(width: 105.w, height: 90.h, borderRadius: 12.r),
            ],
          ),
          SizedBox(height: 24.h),
          // Earnings Card
          ShimmerLoader(
            width: double.infinity,
            height: 110.h,
            borderRadius: 16.r,
          ),
          SizedBox(height: 32.h),
          // Upcoming Sessions Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerLoader(width: 160.w, height: 24.h),
              ShimmerLoader(width: 60.w, height: 16.h),
            ],
          ),
          SizedBox(height: 16.h),
          // Session List
          ShimmerLoader(
            width: double.infinity,
            height: 120.h,
            borderRadius: 12.r,
          ),
          SizedBox(height: 12.h),
          ShimmerLoader(
            width: double.infinity,
            height: 120.h,
            borderRadius: 12.r,
          ),
        ],
      ),
    );
  }
}
