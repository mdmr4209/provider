import 'package:newproject/core/theme/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/background_widget.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_loader.dart';
import '../controllers/coach_profile_controller.dart';
import '../../../../core/constants/app_colors.dart';

class CoachProfileView extends StatelessWidget {
  const CoachProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<CoachProfileController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctrl = context.read<CoachProfileController>();
      if (!ctrl.hasFetched && !ctrl.isLoading && !ctrl.isRefreshing) {
        ctrl.fetchProfileData();
      }
    });

    return BackgroundWidget(
      imagePath: AppAssets.bgHome,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text("Coach Profile", style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined, color: AppColors.coachColorFFC19E5F),
              onPressed: () {},
            ),
          ],
        ),
        body: controller.isLoading
            ? _buildSkeletonLoader(context)
            : Stack(
                children: [
                  RefreshIndicator(
                    onRefresh: () => controller.fetchProfileData(isRefresh: true),
                    color: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    strokeWidth: 0,
                    elevation: 0,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        children: [
                          SizedBox(height: 20.h),
                          // ── Profile Image & Name ──────────────────────────────────
                          Center(
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 50.r,
                                      backgroundImage: const NetworkImage('https://i.pravatar.cc/150?u=coach_kamran'),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(color: AppColors.coachColorFFC19E5F, shape: BoxShape.circle),
                                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  "Md. Kamran",
                                  style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Relationship Specialist",
                                  style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.coachColorFFC19E5F, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 32.h),

                          // ── Stats Summary ───────────────────────────────────────────
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStat("5.0", "Rating", Icons.star),
                              _buildStat("310", "Reviews", Icons.reviews_outlined),
                              _buildStat("8+", "Exp. Years", Icons.work_outline),
                            ],
                          ),

                          SizedBox(height: 32.h),

                          // ── Details Sections ────────────────────────────────────────
                          _buildInfoSection(context, "About Me", "Helping individuals navigate complex relationship dynamics with over 8 years of experience. Specialized in No Contact strategy and emotional recovery."),
                          
                          SizedBox(height: 24.h),

                          _buildInfoSection(
                            context,
                            "Service Rates", 
                            controller.services.isNotEmpty 
                                ? controller.services.map((s) => "• ${s.duration}: ${s.price}").join('\n')
                                : "• 30 Minutes Session: \$75\n• 60 Minutes Session: \$150\n• Unlimited Monthly Chat: \$300"
                          ),

                          SizedBox(height: 32.h),

                          CustomButton(
                            onPress: () async {},
                            title: "Edit Profile",
                            linearGradient: true,
                          ),
                          
                          SizedBox(height: 12.h),
                          
                          CustomButton(
                            onPress: () async {},
                            title: "Logout",
                            buttonColor: Colors.black.withAlpha(51),
                            borderColor: Colors.white10,
                          ),

                          SizedBox(height: 100.h),
                        ],
                      ),
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
      ),
    );
  }

  Widget _buildStat(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.coachColorFFC19E5F, size: 24),
        SizedBox(height: 8.h),
        Text(value, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.white54, fontSize: 12)),
      ],
    );
  }

  Widget _buildInfoSection(BuildContext context, String title, String content) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Theme.of(context).extension<AppDesignSystem>()!.panelColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 12.h),
          Text(content, style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildSkeletonLoader(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          SizedBox(height: 20.h),
          // Avatar & Name
          Center(
            child: Column(
              children: [
                ShimmerLoader(width: 100.r, height: 100.r, borderRadius: 50.r),
                SizedBox(height: 16.h),
                ShimmerLoader(width: 150.w, height: 24.h),
                SizedBox(height: 8.h),
                ShimmerLoader(width: 180.w, height: 16.h),
              ],
            ),
          ),
          SizedBox(height: 32.h),
          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatSkeleton(),
              _buildStatSkeleton(),
              _buildStatSkeleton(),
            ],
          ),
          SizedBox(height: 32.h),
          // Details Sections
          ShimmerLoader(width: double.infinity, height: 120.h, borderRadius: 16.r),
          SizedBox(height: 24.h),
          ShimmerLoader(width: double.infinity, height: 160.h, borderRadius: 16.r),
          SizedBox(height: 32.h),
          // Buttons
          ShimmerLoader(width: double.infinity, height: 50.h, borderRadius: 25.r),
          SizedBox(height: 12.h),
          ShimmerLoader(width: double.infinity, height: 50.h, borderRadius: 25.r),
        ],
      ),
    );
  }

  Widget _buildStatSkeleton() {
    return Column(
      children: [
        ShimmerLoader(width: 24.r, height: 24.r, borderRadius: 12.r),
        SizedBox(height: 8.h),
        ShimmerLoader(width: 40.w, height: 18.h),
        SizedBox(height: 4.h),
        ShimmerLoader(width: 60.w, height: 12.h),
      ],
    );
  }
}
