import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_input.dart';
import '../../../core/widgets/custom_button.dart';
import 'coach_profile_view.dart';

class FindCoachesView extends StatelessWidget {
  const FindCoachesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
              _buildHeroCoach(context),
              SizedBox(height: 24.h),
              // ── Book Again / Featured Sections ──────────────────────────
              _buildSectionHeader("BOOK AGAIN"),
              _buildCoachList(context),
              SizedBox(height: 24.h),
              _buildSectionHeader("FEATURED COACHES"),
              _buildCoachList(context),
              SizedBox(height: 24.h),
              _buildSectionHeader("TOP RATED"),
              _buildCoachList(context),
              SizedBox(height: 80.h), // Space for bottom nav
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroCoach(BuildContext context) {
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
              backgroundImage: const NetworkImage('https://i.pravatar.cc/300?u=coach_pearl'),
            ),
          ),
          SizedBox(height: 16.h),
          Text("Coach Pearl", style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold)),
          Text("Relationship Specialist · Communication Coach", style: TextStyle(color: Colors.white.withAlpha(128), fontSize: 12.sp)),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) => Icon(Icons.star, color: Colors.amber, size: 14.r)),
          ),
          SizedBox(height: 12.h),
          CustomButton(
            onPress: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CoachProfileView())),
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

  Widget _buildCoachList(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: 2,
      itemBuilder: (context, index) => _CoachCard(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CoachProfileView()))),
    );
  }
}

class _CoachCard extends StatelessWidget {
  final VoidCallback onTap;
  const _CoachCard({required this.onTap});

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
            backgroundImage: const NetworkImage('https://i.pravatar.cc/150?u=coach_sarah'),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Coach Sarah", style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold)),
                Text("Breakup Recovery · Mindset Coach", style: TextStyle(color: Colors.white.withAlpha(128), fontSize: 11.sp)),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 12.r),
                    Icon(Icons.star, color: Colors.amber, size: 12.r),
                    Icon(Icons.star, color: Colors.amber, size: 12.r),
                    Icon(Icons.star, color: Colors.amber, size: 12.r),
                    SizedBox(width: 4.w),
                    Text("4.9 (187)", style: TextStyle(color: Colors.white.withAlpha(128), fontSize: 10.sp)),
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
