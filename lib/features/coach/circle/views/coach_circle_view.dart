import 'package:newproject/core/theme/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:newproject/core/widgets/custom_button.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/background_widget.dart';
import '../../../../core/widgets/custom_input.dart';
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

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
appBar: AppBar(
          backgroundColor: AppColors.defaultColor,
          scrolledUnderElevation: 0,
          surfaceTintColor: AppColors.defaultColor,
          elevation: 0,
          centerTitle: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(AppAssets.circleIcon),
              SizedBox(width: 8.w),
              Text(
                "Circles",
                style: theme.textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Georgia',
                ),
              ),
            ],
          ),
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
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: CustomInput(
                            height: 50,
                            hintText: "Search groups",
                            fontSize: 14,
hintStyle: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: AppColors.whiteColor.withAlpha(153),
                                  fontSize: 14.sp,
                                ),
                            shadow: true,
borderRadius: 24,
                            borderWidth: 0.50,
leadingIcon: AppAssets.search,
                            leadingPadding: EdgeInsets.only(
                              left: 16.w,
                              right: 8.w,
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // ── Group List ───────────────────────────────────────────────
                        Expanded(
                          child: controller.circles.isEmpty
                              ? ListView(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 50.0),
                                      child: Center(
                                        child: Text(
                                          "No circles found",
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            color: Colors.white54,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : ListView.builder(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                  ),
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
                                      circle
                                          .icon, // NetworkImage can be handled inside
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
      ),
    );
  }

  Widget _buildGroupCard(
    BuildContext context,
    CoachCircleController controller,
    String id,
    String name,
    String members,
    String description,
    String icon,
    bool isJoined,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                CoachGroupDetailView(groupName: name, members: members),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 15.h),
        decoration: ShapeDecoration(
          color: AppColors.coachColorFF253523,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          shadows: [
            BoxShadow(
              color: AppColors.coachColor0F000000,
              blurRadius: 24.20,
              offset: Offset(0, 13),
              spreadRadius: 0,
            ),
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
                        ? Image.network(
                            icon,
                            errorBuilder: (c, e, s) =>
                                const Icon(Icons.group, color: Colors.grey),
                          )
                        : Image.asset(icon),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        members,
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              description,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                height: 1.4,
              ),
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              height: 44.h,
              child: isJoined
                  ? CustomButton(
                      height: 44,
                      onPress: null,
                      title: "Joined",
                      buttonColor: AppColors.coachColorFF4C6D45,
                      borderColor: AppColors.coachColorFF4C6D45,
                      borderWidth: .5,
                      radius: 8,
                    )
                  : CustomButton(
                      height: 44,
                      onPress: () async => controller.joinGroup(context, id),
                      title: "Join Now",
                      buttonColor: AppColors.coachColor33434928,
                      borderColor: AppColors.coachColorF2C9A84C,
                      borderWidth: .5,
                      radius: 8,
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
          child: ShimmerLoader(
            width: double.infinity,
            height: 48.h,
            borderRadius: 24.r,
          ),
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
                  color: Theme.of(context).extension<AppDesignSystem>()!.panelColor,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ShimmerLoader(
                          width: 48.r,
                          height: 48.r,
                          borderRadius: 24.r,
                        ),
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
                    ShimmerLoader(
                      width: double.infinity,
                      height: 48.h,
                      borderRadius: 8.r,
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
