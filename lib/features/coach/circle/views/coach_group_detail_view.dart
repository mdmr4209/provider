import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/background_widget.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/custom_loader.dart';

class CoachGroupDetailView extends StatelessWidget {
  final String groupName;
  final String members;

  const CoachGroupDetailView({
    super.key,
    required this.groupName,
    required this.members,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2D3D2A),
      appBar: AppBar(
        backgroundColor: Color(0xFF22331F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18.r,
              backgroundImage: const NetworkImage('https://i.pravatar.cc/150?u=group'),
            ),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(groupName, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                Text(members, style: const TextStyle(color: Colors.white38, fontSize: 11)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.white70),
            onPressed: () {},
          ),
        ],
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
          // ── Thought Input ───────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: const Color(0xFF20311D),
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Row(
                children: [
                  const Icon(Icons.edit_outlined, color: Color(0xFFC19E5F), size: 20),
                  SizedBox(width: 12.w),
                  const Text("Share Your Thoughts in the group", style: TextStyle(color: Colors.white38, fontSize: 14)),
                ],
              ),
            ),
          ),

          SizedBox(height: 24.h),

          // ── Post Feed ────────────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: 4,
              itemBuilder: (context, index) {
                return _buildPostCard(
                  context,
                  "Sarah M.",
                  "2 min ago",
                  "Day 14. Didn't reach out even though I wanted to. Proud of myself 💪",
                  "47",
                  "12",
                );
              },
            ),
          ),
        ],
          );
        },
      ),
    );
  }

  Widget _buildPostCard(BuildContext context, String name, String time, String content, String likes, String comments) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.r),
      decoration: ShapeDecoration(
        color: const Color(0xFF20311D),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20.r,
                    backgroundImage: const NetworkImage('https://i.pravatar.cc/150?u=sarah'),
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      Text(time, style: const TextStyle(color: Colors.white38, fontSize: 11)),
                    ],
                  ),
                ],
              ),
              const Icon(Icons.more_horiz, color: Colors.white38),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            content,
            style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              _buildInteractionItem(Icons.circle_outlined, likes),
              SizedBox(width: 16.w),
              _buildInteractionItem(Icons.chat_bubble_outline, comments),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.share_outlined, color: Color(0xFFC19E5F), size: 18),
                  SizedBox(width: 4.w),
                  const Text("Share", style: TextStyle(color: Color(0xFFC19E5F), fontSize: 12)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionItem(IconData icon, String count) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(13),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFC19E5F), size: 16),
          SizedBox(width: 4.w),
          Text(count, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return Column(
      children: [
        SizedBox(height: 20.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: ShimmerLoader(width: double.infinity, height: 48.h, borderRadius: 24.r),
        ),
        SizedBox(height: 24.h),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(bottom: 16.h),
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D3D2D),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ShimmerLoader(width: 40.r, height: 40.r, borderRadius: 20.r),
                        SizedBox(width: 12.w),
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
                        ShimmerLoader(width: 24.r, height: 24.r, borderRadius: 12.r),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    ShimmerLoader(width: double.infinity, height: 14.h),
                    SizedBox(height: 4.h),
                    ShimmerLoader(width: 200.w, height: 14.h),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        ShimmerLoader(width: 60.w, height: 24.h, borderRadius: 12.r),
                        SizedBox(width: 16.w),
                        ShimmerLoader(width: 60.w, height: 24.h, borderRadius: 12.r),
                        const Spacer(),
                        ShimmerLoader(width: 60.w, height: 20.h, borderRadius: 10.r),
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
