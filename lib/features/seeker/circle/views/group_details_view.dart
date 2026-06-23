import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_input.dart';
import '../../../../core/widgets/custom_loader.dart';
import '../controllers/group_controller.dart';
import '../models/circle_post_model.dart';
import '../widgets/circle_post_card.dart';
import 'create_group_post_view.dart';
import 'group_reports_view.dart';
import 'invite_friends_view.dart';

class GroupDetailsView extends StatelessWidget {
  final String groupId;
  final bool isAdmin;
  const GroupDetailsView({super.key, required this.groupId, this.isAdmin = false});

  @override
  Widget build(BuildContext context) {
    // Fetch details
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GroupController>().fetchGroupDetails(groupId);
    });

    return Scaffold(
      body: Consumer<GroupController>(
        builder: (context, controller, child) {
          final details = controller.activeGroupDetails;

          if (controller.isLoading || details == null) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.whiteColor),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Row(
                  children: [
                    ShimmerLoader(width: 36.r, height: 36.r, borderRadius: 18.r),
                    SizedBox(width: 10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerLoader(width: 120.w, height: 14.h, borderRadius: 4.r),
                        SizedBox(height: 6.h),
                        ShimmerLoader(width: 60.w, height: 10.h, borderRadius: 4.r),
                      ],
                    ),
                  ],
                ),
              ),
              body: const SafeArea(child: _GroupDetailsShimmer()),
            );
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.whiteColor),
                onPressed: () => Navigator.pop(context),
              ),
              title: Row(
                children: [
                  CircleAvatar(
                    radius: 18.r,
                    backgroundImage: NetworkImage(details.icon),
                  ),
                  SizedBox(width: 10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        details.name,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.whiteColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${details.memberCount} members",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.whiteColor.withAlpha(128),
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [_buildMenuButton(context)],
            ),
            body: Stack(
              children: [
                RefreshIndicator(
                  onRefresh: () => controller.fetchGroupDetails(groupId, isRefresh: true),
                  color: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  strokeWidth: 0,
                  elevation: 0,
                  child: Column(
                    children: [
                      SizedBox(height: 16.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: CustomInput(
                          height: 48,
                          hintText: "Share Your Thoughts in the group",
                          leadingIcon: AppAssets.feather,
                          backgroundColor: AppColors.whiteColor.withAlpha(13),
                          borderRadius: 24,
                          shadow: false,
                          readOnly: true,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CreateGroupPostView(groupId: details.id),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Expanded(
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          itemCount: CirclePostModel.dummyPosts.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: CirclePostCard(
                                post: CirclePostModel.dummyPosts[index],
                              ),
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
                    child: const Center(child: CustomLoader(size: 150)),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_horiz, color: AppColors.whiteColor),
      color: AppColors.postCardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      onSelected: (value) {
        if (value == "Invite Friends") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const InviteFriendsView()),
          );
        } else if (value == "Report to Platform") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const GroupReportsView()),
          );
        }
      },
      itemBuilder: (context) {
        if (isAdmin) {
          return [
            _buildMenuItem(context, "Share link", Icons.share_outlined),
            _buildMenuItem(context, "Invite Friends", Icons.person_add_outlined),
            _buildMenuItem(context, "Edit Group", Icons.edit_outlined),
            _buildMenuItem(context, "Report to Platform", Icons.remove_red_eye_outlined),
            _buildMenuItem(
              context,
              "Delete Group",
              Icons.delete_outline,
              isDestructive: true,
            ),
          ];
        } else {
          return [
            _buildMenuItem(context, "Share link", Icons.share_outlined),
            _buildMenuItem(context, "Invite Friends", Icons.person_add_outlined),
            _buildMenuItem(context, "Report to admin", Icons.analytics_outlined),
            _buildMenuItem(
              context,
              "Leave Group",
              Icons.logout_outlined,
              isDestructive: true,
            ),
          ];
        }
      },
    );
  }

  PopupMenuItem<String> _buildMenuItem(
    BuildContext context,
    String title,
    IconData icon, {
    bool isDestructive = false,
  }) {
    return PopupMenuItem(
      value: title,
      child: Row(
        children: [
          Icon(
            icon,
            color: isDestructive ? AppColors.redColor : AppColors.whiteColor.withAlpha(200),
            size: 20.r,
          ),
          SizedBox(width: 12.w),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDestructive ? AppColors.redColor : AppColors.whiteColor.withAlpha(200),
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupDetailsShimmer extends StatelessWidget {
  const _GroupDetailsShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: ShimmerLoader(
            width: double.infinity,
            height: 48.h,
            borderRadius: 24.r,
          ),
        ),
        SizedBox(height: 16.h),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: 3,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: ShimmerLoader(
                width: double.infinity,
                height: 150.h,
                borderRadius: 16.r,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

