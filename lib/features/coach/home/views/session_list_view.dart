import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/background_widget.dart';
import '../../../../core/constants/app_assets.dart';
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
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "Session List",
            style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
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
                          hintStyle: TextStyle(color: Colors.white38, fontSize: 14),
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
                  const Text("All Sessions (4)", style: TextStyle(color: Colors.white70)),
                  Row(
                    children: [
                      const Text("Date", style: TextStyle(color: Colors.white70, fontSize: 12)),
                      const Icon(Icons.keyboard_arrow_down, color: Colors.white70, size: 16),
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
                  return _buildSessionCard(context, coachHome, "Session ${index + 1}", "Mon, Mar 27", "01:00 PM - 01:03 PM (30Min)", "Miles Esther", "20\$");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionCard(BuildContext context, CoachHomeController controller, String title, String date, String time, String name, String rate) {
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
}
