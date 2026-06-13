import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/background_widget.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_loader.dart';
import '../controllers/coach_profile_controller.dart';

class CoachProfileView extends StatefulWidget {
  const CoachProfileView({super.key});

  @override
  State<CoachProfileView> createState() => _CoachProfileViewState();
}

class _CoachProfileViewState extends State<CoachProfileView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CoachProfileController>().fetchProfileData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<CoachProfileController>();

    return BackgroundWidget(
      imagePath: AppAssets.bgHome,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text("Coach Profile", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined, color: Color(0xFFC19E5F)),
              onPressed: () {},
            ),
          ],
        ),
        body: controller.isLoading
            ? const Center(child: ShimmerLoader())
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
                                        decoration: const BoxDecoration(color: Color(0xFFC19E5F), shape: BoxShape.circle),
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
                                const Text(
                                  "Relationship Specialist",
                                  style: TextStyle(color: Color(0xFFC19E5F), fontWeight: FontWeight.w500),
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
                          _buildInfoSection("About Me", "Helping individuals navigate complex relationship dynamics with over 8 years of experience. Specialized in No Contact strategy and emotional recovery."),
                          
                          SizedBox(height: 24.h),

                          _buildInfoSection(
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

  Widget _buildStat(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFFC19E5F), size: 24),
        SizedBox(height: 8.h),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
      ],
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3D2D),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 12.h),
          Text(content, style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5)),
        ],
      ),
    );
  }
}
