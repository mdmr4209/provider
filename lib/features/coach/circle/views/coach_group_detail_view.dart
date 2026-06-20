import 'package:newproject/core/theme/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/background_widget.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/custom_input.dart';
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
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
appBar: AppBar(
          backgroundColor: AppColors.defaultColor,
          // These two lines prevent the color change / tinting when scrolling
          scrolledUnderElevation: 0,
          surfaceTintColor: AppColors.defaultColor,

          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.west, color: AppColors.coachColorFF5E7958, size: 24),
            onPressed: () => Navigator.pop(context),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
          ),
          title: Row(
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundImage: const NetworkImage(
                  'https://i.pravatar.cc/150?u=group',
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    groupName,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.coachColorFFF5F0E8,
                      fontSize: 16,
                      fontFamily: 'Georgia',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    members,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.coachColorFF838383,
                      fontSize: 10,
                      fontFamily: 'Segoe UI',
                      fontWeight: FontWeight.w400,
                      height: 1.60,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_horiz, color: AppColors.coachColorFF5E7958),
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
                  child: CustomInput(
                    height: 50,
                    hintText: "Share Your Thoughts in the group",
                    fontSize: 13,
hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.whiteColor.withAlpha(153),
                      fontSize: 14.sp,
                    ),
                    shadow: true,
borderWidth: 0.50,
leadingIcon: AppAssets.feather,
                    leadingColor: AppColors.whiteColor,
                    leadingPadding: EdgeInsets.only(left: 16.w, right: 8.w),
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
      ),
    );
  }

  Widget _buildPostCard(
    BuildContext context,
    String name,
    String time,
    String content,
    String likes,
    String comments,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.r),
      decoration: ShapeDecoration(
        color: AppColors.postCardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
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
                    backgroundImage: const NetworkImage(
                      'https://i.pravatar.cc/150?u=sarah',
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Column(
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
                        time,
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 11,
                        ),
                      ),
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
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.4,
            ),
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
                  const Icon(
                    Icons.share_outlined,
                    color: AppColors.coachColorFFC19E5F,
                    size: 18,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    "Share",
                    style: TextStyle(color: AppColors.coachColorFFC19E5F, fontSize: 12),
                  ),
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
          Icon(icon, color: AppColors.coachColorFFC19E5F, size: 16),
          SizedBox(width: 4.w),
          Text(
            count,
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
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
          child: ShimmerLoader(
            width: double.infinity,
            height: 48.h,
            borderRadius: 24.r,
          ),
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
                  color: Theme.of(context).extension<AppDesignSystem>()!.panelColor,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ShimmerLoader(
                          width: 40.r,
                          height: 40.r,
                          borderRadius: 20.r,
                        ),
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
                        ShimmerLoader(
                          width: 24.r,
                          height: 24.r,
                          borderRadius: 12.r,
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    ShimmerLoader(width: double.infinity, height: 14.h),
                    SizedBox(height: 4.h),
                    ShimmerLoader(width: 200.w, height: 14.h),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        ShimmerLoader(
                          width: 60.w,
                          height: 24.h,
                          borderRadius: 12.r,
                        ),
                        SizedBox(width: 16.w),
                        ShimmerLoader(
                          width: 60.w,
                          height: 24.h,
                          borderRadius: 12.r,
                        ),
                        const Spacer(),
                        ShimmerLoader(
                          width: 60.w,
                          height: 20.h,
                          borderRadius: 10.r,
                        ),
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
