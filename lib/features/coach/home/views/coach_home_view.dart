import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/background_widget.dart';
import '../../../../core/widgets/glass_widget.dart';
import '../controllers/coach_home_controller.dart';
import '../../../../routes/app_router.dart';

class CoachHomeView extends StatelessWidget {
  const CoachHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final coachHome = context.watch<CoachHomeController>();

    return BackgroundWidget(
      imagePath: AppAssets.bgHome,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: EdgeInsets.only(left: 16.w),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18.r,
                  backgroundColor: const Color(0xFFC19E5F),
                  child: Image.asset(AppAssets.sb2Logo, width: 24.r),
                ),
                SizedBox(width: 8.w),
                Text(
                  "Strong@ack2",
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
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              // ── Profile Header ──────────────────────────────────────────
              Row(
                children: [
                  CircleAvatar(
                    radius: 35.r,
                    backgroundImage: const NetworkImage('https://i.pravatar.cc/150?u=coach_kamran'),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Md. Kamran",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Coach",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        "Active",
                        style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
                      ),
                      Switch(
                        value: coachHome.isActive,
                        onChanged: (_) => coachHome.toggleActive(context),
                        activeColor: const Color(0xFFC19E5F),
                        activeTrackColor: const Color(0xFFC19E5F).withAlpha(100),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              // ── Stats Row ───────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatBox("Call Back Requests", "08", Icons.phone_callback, const Color(0xFF64B5F6)),
                  _buildStatBox("New Messages", "08", Icons.chat_bubble_outline, const Color(0xFF81C784)),
                  _buildStatBox("Missed Calls", "08", Icons.phone_missed, const Color(0xFFE57373)),
                ],
              ),

              SizedBox(height: 24.h),

              // ── Earnings Card ───────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24.r),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2D3D2D), Color(0xFF1B2B1B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Net Earnings",
                      style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "\$2,847.50",
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.push('/coach-earnings'),
                          child: Row(
                            children: [
                              Text(
                                "View",
                                style: theme.textTheme.bodyMedium?.copyWith(color: const Color(0xFFC19E5F)),
                              ),
                              const Icon(Icons.arrow_forward, color: Color(0xFFC19E5F), size: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "This month",
                      style: theme.textTheme.bodySmall?.copyWith(color: Colors.white38),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32.h),

              // ── Upcoming Sessions Header ────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Upcoming Sessions",
                    style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () => context.push('/coach-sessions'),
                    child: const Text("See All", style: TextStyle(color: Colors.white54)),
                  ),
                ],
              ),

              // ── Session List ────────────────────────────────────────────
              _buildSessionCard(context, coachHome, "Session 1", "Mon, Mar 27", "01:00 PM - 01:03 PM (30Min)", "Miles Esther", "20\$"),
              _buildSessionCard(context, coachHome, "Session 2", "Mon, Mar 27", "01:10 PM - 01:13 PM (30Min)", "Miles Esther", "20\$"),

              SizedBox(height: 24.h),

              // ── Bid Banner ──────────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D3D2D),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.emoji_events_outlined, color: Color(0xFFC19E5F), size: 40),
                        SizedBox(width: 16.w),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Add a BID to become a featured Coach",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Increase your visibility and get more bookings by bidding for a featured spot.",
                                style: TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    const Text(
                      "Day 14 of No Contact. It was really hard today today, I almost texted him when I saw his favorite song playing. But I stayed strong!",
                      style: TextStyle(color: Colors.white54, fontSize: 11, fontStyle: FontStyle.italic),
                    ),
                    SizedBox(height: 16.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFC19E5F),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                        ),
                        child: const Text("Place a Bid Now", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // ── New Messages ────────────────────────────────────────────
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.chat_bubble_outline, color: Color(0xFF81C784), size: 18),
                      SizedBox(width: 8.w),
                      Text(
                        "New Text Messages",
                        style: theme.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text("See All", style: TextStyle(color: Color(0xFFC19E5F))),
                  ),
                ],
              ),
              _buildMessageCard("Miles Esther", "Online", "09:30 PM", "2"),
              _buildMessageCard("Miles Esther", "Online", "09:30 PM", "2"),

              SizedBox(height: 100.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatBox(String label, String value, IconData icon, Color iconColor) {
    return Container(
      width: 105.w,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3D2D),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.white70, fontSize: 10.sp)),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(icon, color: iconColor, size: 18.r),
              SizedBox(width: 8.w),
              Text(value, style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSessionCard(BuildContext context, CoachHomeController controller, String title, String date, String time, String name, String rate) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
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
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: () => controller.cancelSession(context, "1"),
                child: Row(
                  children: [
                    const Icon(Icons.cancel_outlined, color: Color(0xFFE57373), size: 16),
                    SizedBox(width: 4.w),
                    const Text("Cancel", style: TextStyle(color: Color(0xFFE57373), fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              const Icon(Icons.calendar_today, color: Colors.white54, size: 14),
              SizedBox(width: 8.w),
              Text(date, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              const Icon(Icons.access_time, color: Colors.white54, size: 14),
              SizedBox(width: 8.w),
              Text(time, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              CircleAvatar(
                radius: 15.r,
                backgroundImage: const NetworkImage('https://i.pravatar.cc/150?u=miles'),
              ),
              SizedBox(width: 12.w),
              Text(name, style: const TextStyle(color: Colors.white)),
              const Spacer(),
              Text(rate, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageCard(String name, String status, String time, String count) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3D2D),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20.r,
            backgroundImage: const NetworkImage('https://i.pravatar.cc/150?u=miles'),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text(status, style: const TextStyle(color: Color(0xFF81C784), fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(time, style: const TextStyle(color: Colors.white38, fontSize: 10)),
              SizedBox(height: 4.h),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: Color(0xFF81C784), shape: BoxShape.circle),
                child: Text(count, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
