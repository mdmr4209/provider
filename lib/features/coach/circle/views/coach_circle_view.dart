import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/background_widget.dart';
import '../../../../core/widgets/custom_loader.dart';
import '../controllers/coach_circle_controller.dart';
import 'coach_group_detail_view.dart';

class CoachCircleView extends StatelessWidget {
  const CoachCircleView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<CoachCircleController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctrl = context.read<CoachCircleController>();
      if (!ctrl.hasFetched && !ctrl.isLoading && !ctrl.isRefreshing) {
        ctrl.fetchCircles();
      }
    });

    return Scaffold(
      backgroundColor: Color(0xFF2D3D2A),
      appBar: AppBar(
        backgroundColor: Color(0xFF22331F),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.groups_outlined, color: Color(0xFFC19E5F)),
            SizedBox(width: 8.w),
            Text(
              "Circles",
              style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: controller.isLoading
          ? _buildSkeletonLoader(context)
          : Stack(
              children: [
                RefreshIndicator(
                  onRefresh: () => controller.fetchCircles(isRefresh: true),
                  color: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  strokeWidth: 0,
                  elevation: 0,
                  child: Column(
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
                                    hintText: "Search groups",
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

                      // ── Group List ───────────────────────────────────────────────
                      Expanded(
                        child: controller.circles.isEmpty
                            ? ListView(
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.only(top: 50.0),
                                    child: Center(
                                      child: Text("No circles found", style: TextStyle(color: Colors.white54)),
                                    ),
                                  )
                                ],
                              )
                            : ListView.builder(
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                itemCount: controller.circles.length,
                                itemBuilder: (context, index) {
                                  final circle = controller.circles[index];
                                  return _buildGroupCard(
                                    context,
                                    controller,
                                    circle.id,
                                    circle.name,
                                    "${circle.memberCount} members",
                                    circle.description,
                                    circle.icon, // NetworkImage can be handled inside
                                    circle.isJoined,
                                  );
                                },
                              ),
                      ),
                    ],
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

  Widget _buildGroupCard(BuildContext context, CoachCircleController controller, String id, String name, String members, String description, String icon, bool isJoined) {
    return GestureDetector(
      onTap: () {
         Navigator.push(context, MaterialPageRoute(builder: (_) => CoachGroupDetailView(groupName: name, members: members)));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding:  EdgeInsets.symmetric(horizontal: 11.w, vertical: 15.h),
        decoration: ShapeDecoration(
          color: const Color(0xFF253523),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          shadows: [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 24.20,
              offset: Offset(0, 13),
              spreadRadius: 0,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24.r,
                  backgroundColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: icon.startsWith('http')
                        ? Image.network(icon, errorBuilder: (c, e, s) => const Icon(Icons.group, color: Colors.grey))
                        : Image.asset(icon),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(members, style: const TextStyle(color: Colors.white38, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              description,
              style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: isJoined
                  ? ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3A4D3A),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                      ),
                      child: const Text("Joined", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                    )
                  : OutlinedButton(
                      onPressed: () => controller.joinGroup(context, id),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFC19E5F)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                      ),
                      child: const Text("Join Now", style: TextStyle(color: Color(0xFFC19E5F), fontWeight: FontWeight.bold)),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonLoader(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: ShimmerLoader(width: double.infinity, height: 48.h, borderRadius: 24.r),
        ),
        SizedBox(height: 24.h),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(bottom: 16.h),
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D3D2D),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ShimmerLoader(width: 48.r, height: 48.r, borderRadius: 24.r),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ShimmerLoader(width: 150.w, height: 16.h),
                              SizedBox(height: 8.h),
                              ShimmerLoader(width: 80.w, height: 12.h),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    ShimmerLoader(width: double.infinity, height: 14.h),
                    SizedBox(height: 4.h),
                    ShimmerLoader(width: 200.w, height: 14.h),
                    SizedBox(height: 24.h),
                    ShimmerLoader(width: double.infinity, height: 48.h, borderRadius: 8.r),
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
