import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_input.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_loader.dart';
import '../controllers/coach_controller.dart';
import '../models/coach_model.dart';
import 'coach_profile_view.dart';

class FindCoachesView extends StatelessWidget {
  const FindCoachesView({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<CoachController>();
      if (controller.heroCoach == null && !controller.isLoading) {
        controller.fetchCoachesDiscover();
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Consumer<CoachController>(
          builder: (context, controller, child) {
            if (controller.isLoading && controller.heroCoach == null) {
              return const _FindCoachesShimmer();
            }

            final hero = controller.heroCoach;
            final featured = controller.featuredCoaches;
            final topRated = controller.topRatedCoaches;

            return Stack(
              children: [
                RefreshIndicator(
                  onRefresh: () => controller.fetchCoachesDiscover(isRefresh: true),
                  color: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  strokeWidth: 0,
                  elevation: 0,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Search Bar ────────────────────────────────────────────────
                        Padding(
                          padding: EdgeInsets.all(16.w),
                          child: CustomInput(
                            height: 48,
                            hintText: "Search Coach",
                            backgroundColor: Colors.white.withAlpha(13),
                            borderRadius: 24,
                            shadow: false,
                          ),
                        ),
                        // ── Hero Coach Section ────────────────────────────────────────
                        if (hero != null) _buildHeroCoach(context, hero),
                        SizedBox(height: 24.h),
                        // ── Book Again / Featured Sections ──────────────────────────
                        _buildSectionHeader("BOOK AGAIN"),
                        _buildCoachList(context, topRated),
                        SizedBox(height: 24.h),
                        _buildSectionHeader("FEATURED COACHES"),
                        _buildCoachList(context, featured),
                        SizedBox(height: 24.h),
                        _buildSectionHeader("TOP RATED"),
                        _buildCoachList(context, topRated),
                        SizedBox(height: 80.h), // Space for bottom nav
                      ],
                    ),
                  ),
                ),
                if (controller.isRefreshing)
                  Positioned(
                    top: 16.h,
                    left: 0,
                    right: 0,
                    child: const Center(child: CustomLoader(size: 150)),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeroCoach(BuildContext context, CoachModel coach) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 30.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFC19E5F).withAlpha(51),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(3.r),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [Color(0xFFC19E5F), Color(0xFFE5CE8E)]),
            ),
            child: CircleAvatar(
              radius: 60.r,
              backgroundImage: NetworkImage(coach.avatar),
            ),
          ),
          SizedBox(height: 16.h),
          Text(coach.name, style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold)),
          Text(coach.title, style: TextStyle(color: Colors.white.withAlpha(128), fontSize: 12.sp)),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              coach.rating.round(),
              (index) => Icon(Icons.star, color: Colors.amber, size: 14.r),
            ),
          ),
          SizedBox(height: 12.h),
          CustomButton(
            onPress: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CoachProfileView(coach: coach)),
            ),
            title: "Book Now",
            width: 140,
            height: 36,
            linearGradient: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Divider(color: Colors.white.withAlpha(26))),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(title, style: TextStyle(color: const Color(0xFFC19E5F), fontSize: 11.sp, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          ),
          Expanded(child: Divider(color: Colors.white.withAlpha(26))),
        ],
      ),
    );
  }

  Widget _buildCoachList(BuildContext context, List<CoachModel> coaches) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: coaches.length,
      itemBuilder: (context, index) {
        final coach = coaches[index];
        return _CoachCard(
          coach: coach,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CoachProfileView(coach: coach)),
          ),
        );
      },
    );
  }
}

class _CoachCard extends StatelessWidget {
  final CoachModel coach;
  final VoidCallback onTap;
  const _CoachCard({required this.coach, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.postCardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withAlpha(13)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24.r,
            backgroundImage: NetworkImage(coach.avatar),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(coach.name, style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold)),
                Text(coach.title, style: TextStyle(color: Colors.white.withAlpha(128), fontSize: 11.sp)),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 12.r),
                    SizedBox(width: 4.w),
                    Text(
                      "${coach.rating} (${coach.reviews})",
                      style: TextStyle(color: Colors.white.withAlpha(128), fontSize: 10.sp),
                    ),
                  ],
                ),
              ],
            ),
          ),
          CustomButton(
            onPress: () async => onTap(),
            title: "View",
            width: 70,
            height: 32,
            fontSize: 12,
            linearGradient: true,
            radius: 8,
          ),
        ],
      ),
    );
  }
}

class _FindCoachesShimmer extends StatelessWidget {
  const _FindCoachesShimmer();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: ShimmerLoader(width: double.infinity, height: 48.h, borderRadius: 24.r),
          ),
          // Hero shimmer
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 30.h),
            child: Column(
              children: [
                ShimmerLoader(width: 120.r, height: 120.r, borderRadius: 60.r),
                SizedBox(height: 16.h),
                ShimmerLoader(width: 150.w, height: 18.h, borderRadius: 4.r),
                SizedBox(height: 8.h),
                ShimmerLoader(width: 100.w, height: 12.h, borderRadius: 4.r),
                SizedBox(height: 12.h),
                ShimmerLoader(width: 140.w, height: 36.h, borderRadius: 18.r),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: ShimmerLoader(width: 100.w, height: 12.h, borderRadius: 4.r),
          ),
          SizedBox(height: 16.h),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: 2,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: ShimmerLoader(width: double.infinity, height: 72.h, borderRadius: 16.r),
            ),
          ),
        ],
      ),
    );
  }
}
