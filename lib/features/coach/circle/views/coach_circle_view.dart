import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/background_widget.dart';
import '../../../../core/widgets/custom_loader.dart';
import '../controllers/coach_circle_controller.dart';
import 'coach_group_detail_view.dart';

class CoachCircleView extends StatefulWidget {
  const CoachCircleView({super.key});

  @override
  State<CoachCircleView> createState() => _CoachCircleViewState();
}

class _CoachCircleViewState extends State<CoachCircleView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CoachCircleController>().fetchCircles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<CoachCircleController>();

    return BackgroundWidget(
      imagePath: AppAssets.bgHome,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
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
            ? const Center(child: ShimmerLoader())
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
                    Positioned.fill(
                      child: Container(
                        color: Colors.black26,
                        child: const Center(child: CustomLoader()),
                      ),
                    ),
                ],
              ),
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
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: const Color(0xFF2D3D2D),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.white10),
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
}
