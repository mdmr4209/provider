import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_loader.dart';
import '../controllers/circle_controller.dart';
import '../models/circle_post_model.dart';
import '../widgets/circle_post_card.dart';
import 'package:go_router/go_router.dart';
import '../../../../routes/app_router.dart';

enum RelationshipStatus { none, friend, requestSent, requestReceived }

class UserProfileView extends StatelessWidget {
  final String userId;
  final String? userName;
  final String? userAvatar;

  const UserProfileView({
    super.key,
    required this.userId,
    this.userName,
    this.userAvatar,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<CircleController>();
      if (controller.selectedUserProfile?.id != userId &&
          !controller.isLoading) {
        controller.fetchUserProfile(userId);
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "User Profile",
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontFamily: 'Georgia',
            fontSize: 20.sp,
          ),
        ),
        centerTitle: true,
        actions: [_buildMoreMenu(context)],
      ),
      body: Consumer<CircleController>(
        builder: (context, controller, child) {
          final profile = controller.selectedUserProfile;

          if (controller.isLoading || profile == null || profile.id != userId) {
            return const SafeArea(child: _UserProfileShimmer());
          }

          RelationshipStatus currentStatus;
          switch (profile.relationshipStatus) {
            case 'friend':
              currentStatus = RelationshipStatus.friend;
              break;
            case 'request_sent':
              currentStatus = RelationshipStatus.requestSent;
              break;
            case 'request_received':
              currentStatus = RelationshipStatus.requestReceived;
              break;
            case 'none':
            default:
              currentStatus = RelationshipStatus.none;
              break;
          }

          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: () =>
                    controller.fetchUserProfile(userId, isRefresh: true),
                color: Colors.transparent,
                backgroundColor: Colors.transparent,
                strokeWidth: 0,
                elevation: 0,
                child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  // ── Header Section ──────────────────────────────────────────────
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2.r),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withAlpha(26),
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 45.r,
                            backgroundImage: NetworkImage(
                              profile.avatar.isNotEmpty
                                  ? profile.avatar
                                  : (userAvatar ??
                                        'https://i.pravatar.cc/150?u=$userId'),
                            ),
                            backgroundColor: Colors.white.withAlpha(26),
                          ),
                        ),
                        SizedBox(width: 20.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile.name.isNotEmpty
                                    ? profile.name
                                    : (userName ?? "Mike Tyson"),
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 12.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildRelationshipButton(
                                      controller,
                                      currentStatus,
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: CustomButton(
                                      onPress: () async {
                                        context.push(
                                          AppRoutes.chat,
                                          extra: {
                                            'name': profile.name.isNotEmpty
                                                ? profile.name
                                                : (userName ?? 'User'),
                                            'avatar': profile.avatar.isNotEmpty
                                                ? profile.avatar
                                                : (userAvatar ??
                                                      'https://i.pravatar.cc/150?u=$userId'),
                                            'isCoach': false,
                                          },
                                        );
                                      },
                                      title: "Message",
                                      buttonColor: Colors.white.withAlpha(13),
                                      borderColor: Colors.transparent,
                                      height: 36,
                                      fontSize: 13,
                                      radius: 8,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  // ── Stats Section ───────────────────────────────────────────────
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatItem(
                          profile.postsCount.toString().padLeft(2, '0'),
                          "Post",
                        ),
                        _buildStatDivider(),
                        _buildStatItem(
                          profile.friendsCount.toString(),
                          "Friends",
                        ),
                        _buildStatDivider(),
                        _buildStatItem(
                          profile.followersCount.toString(),
                          "Followers",
                        ),
                        _buildStatDivider(),
                        _buildStatItem(
                          profile.followingCount.toString(),
                          "Following",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.h),
                  // ── Bio Section ────────────────────────────────────────────────
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Bio",
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          profile.bio,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withAlpha(179),
                            height: 1.5,
                            fontSize: 13.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  // ── Media Preview ─────────────────────────────────────────────
                  SizedBox(
                    height: 100.h,
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      scrollDirection: Axis.horizontal,
                      itemCount: profile.media.length,
                      itemBuilder: (context, index) => Container(
                        width: 100.w,
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          image: DecorationImage(
                            image: NetworkImage(profile.media[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 32.h),
                  // ── Post Feed ────────────────────────────────────────────────
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: profile.posts.length,
                    itemBuilder: (context, index) => Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: CirclePostCard(post: profile.posts[index]),
                    ),
                  ),
                  SizedBox(height: 40.h),
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
);
}

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            color: AppColors.secondaryColorLight,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(color: Colors.white.withAlpha(128), fontSize: 12.sp),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(height: 30.h, width: 1, color: Colors.white.withAlpha(26));
  }

  Widget _buildRelationshipButton(
    CircleController controller,
    RelationshipStatus currentStatus,
  ) {
    String title;
    bool gradient = false;

    switch (currentStatus) {
      case RelationshipStatus.none:
        title = "Add Friend";
        gradient = true;
        break;
      case RelationshipStatus.friend:
        title = "Unfriend";
        gradient = true;
        break;
      case RelationshipStatus.requestSent:
        title = "Request Sent";
        break;
      case RelationshipStatus.requestReceived:
        title = "Accept Request";
        gradient = true;
        break;
    }

    return CustomButton(
      onPress: () async {
        if (currentStatus == RelationshipStatus.none) {
          controller.updateRelationshipStatus(userId, 'request_sent');
        } else if (currentStatus == RelationshipStatus.requestSent) {
          controller.updateRelationshipStatus(userId, 'none');
        } else if (currentStatus == RelationshipStatus.requestReceived) {
          controller.updateRelationshipStatus(userId, 'friend');
        } else if (currentStatus == RelationshipStatus.friend) {
          controller.updateRelationshipStatus(userId, 'none');
        }
      },
      title: title,
      linearGradient: gradient,
      buttonColor: gradient
          ? AppColors.buttonColor
          : Colors.white.withAlpha(13),
      borderColor: Colors.transparent,
      height: 36,
      fontSize: 13,
      radius: 8,
    );
  }

  Widget _buildMoreMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_horiz, color: Colors.white),
      color: AppColors.postCardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      offset: const Offset(0, 45),
      onSelected: (value) {
        if (value == "Report") {
          context.push(AppRoutes.reportToAdmin);
        } else if (value == "Block") {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('User blocked')));
        }
      },
      itemBuilder: (context) => [
        _buildPopupItem("Remove Follower", Icons.person_remove_outlined),
        _buildPopupItem("Report", Icons.report_gmailerrorred_outlined),
        _buildPopupItem("Block", Icons.block_outlined),
        _buildPopupItem("Unfollow", Icons.person_off_outlined),
      ],
    );
  }

  PopupMenuItem<String> _buildPopupItem(String title, IconData icon) {
    return PopupMenuItem(
      value: title,
      child: Row(
        children: [
          Icon(icon, color: Colors.white.withAlpha(128), size: 20.r),
          SizedBox(width: 12.w),
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }
}

class _UserProfileShimmer extends StatelessWidget {
  const _UserProfileShimmer();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          // Header shimmer
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                ShimmerLoader(width: 90.r, height: 90.r, borderRadius: 45.r),
                SizedBox(width: 20.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerLoader(width: 150.w, height: 20.h, borderRadius: 4.r),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Expanded(
                            child: ShimmerLoader(height: 36.h, borderRadius: 8.r),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: ShimmerLoader(height: 36.h, borderRadius: 8.r),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          // Stats shimmer
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(4, (index) => Column(
                children: [
                  ShimmerLoader(width: 40.w, height: 18.h, borderRadius: 4.r),
                  SizedBox(height: 6.h),
                  ShimmerLoader(width: 50.w, height: 12.h, borderRadius: 4.r),
                ],
              )),
            ),
          ),
          SizedBox(height: 32.h),
          // Bio shimmer
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerLoader(width: 60.w, height: 16.h, borderRadius: 4.r),
                SizedBox(height: 12.h),
                ShimmerLoader(width: double.infinity, height: 14.h, borderRadius: 4.r),
                SizedBox(height: 6.h),
                ShimmerLoader(width: 250.w, height: 14.h, borderRadius: 4.r),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          // Media preview shimmer
          SizedBox(
            height: 100.h,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) => Container(
                width: 100.w,
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                child: ShimmerLoader(width: 100.w, height: 100.h, borderRadius: 12.r),
              ),
            ),
          ),
          SizedBox(height: 32.h),
          // Post feed shimmer
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: 2,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: ShimmerLoader(width: double.infinity, height: 150.h, borderRadius: 16.r),
            ),
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}

