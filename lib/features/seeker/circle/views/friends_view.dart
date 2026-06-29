import 'package:newproject/core/widgets/background_widget.dart';

import 'find_friends_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_input.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_loader.dart';
import '../controllers/circle_controller.dart';
import 'user_profile_view.dart';

class FriendsView extends StatelessWidget {
  const FriendsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Fetch lists
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<CircleController>();
      if (controller.friends.isEmpty && !controller.isLoading) {
        controller.fetchSocialLists();
      }
    });

    return DefaultTabController(
      length: 4,
      child: Builder(
        builder: (context) {
          final tabController = DefaultTabController.of(context);
          return AnimatedBuilder(
            animation: tabController,
            builder: (context, _) {
              return BackgroundWidget(
                imagePath: AppAssets.bgMain,
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.whiteColor,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          AppAssets.clap,
                          width: 28.r,
                          colorFilter: const ColorFilter.mode(
                            AppColors.iconColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          "Friends",
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    centerTitle: true,
                    actions: [
                      Padding(
                        padding: EdgeInsets.only(right: 16.w),
                        child: Center(
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const FindFriendsView(),
                              ),
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor.withAlpha(13),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "Add",
                                    style: Theme.of(context).textTheme.bodyMedium
                                        ?.copyWith(
                                          color: AppColors.whiteColor.withAlpha(
                                            204,
                                          ),
                                          fontSize: 13.sp,
                                        ),
                                  ),
                                  SizedBox(width: 4.w),
                                  Icon(
                                    Icons.add,
                                    color: AppColors.secondaryColorLight,
                                    size: 16.r,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  body: Consumer<CircleController>(
                    builder: (context, controller, child) {
                      return Column(
                        children: [
                          SizedBox(height: 16.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: CustomInput(
                              height: 44,
                              hintText: _getSearchHint(tabController.index),
                              fontSize: 14,
                              hintColor: AppColors.greyColor,
                              hintStyle: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: AppColors.whiteColor.withAlpha(153),
                                    fontSize: 14.sp,
                                  ),
                              shadow: true,
                              leadingIcon: AppAssets.search,
                              leadingPadding: EdgeInsets.only(
                                left: 16.w,
                                right: 8.w,
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          TabBar(
                            isScrollable: true,
                            indicatorColor: AppColors.secondaryColorLight,
                            labelColor: AppColors.secondaryColorLight,
                            unselectedLabelColor: AppColors.whiteColor.withAlpha(
                              128,
                            ),
                            dividerColor: AppColors.whiteColor.withAlpha(13),
                            tabAlignment: TabAlignment.start,
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            labelPadding: EdgeInsets.only(right: 24.w),
                            tabs: const [
                              Tab(text: "Friends"),
                              Tab(text: "Friend Request"),
                              Tab(text: "Followers"),
                              Tab(text: "Following"),
                            ],
                          ),
                          Expanded(
                            child: controller.isLoading
                                ? ListView.builder(
                                    padding: EdgeInsets.all(16.w),
                                    itemCount: 4,
                                    itemBuilder: (context, index) => Padding(
                                      padding: EdgeInsets.only(bottom: 12.h),
                                      child: ShimmerLoader(
                                        width: double.infinity,
                                        height: 72.h,
                                        borderRadius: 12.r,
                                      ),
                                    ),
                                  )
                                : TabBarView(
                                    children: [
                                      _buildFriendsList(context, controller),
                                      _buildRequestsList(context, controller),
                                      _buildFollowersList(context, controller),
                                      _buildFollowingList(context, controller),
                                    ],
                                  ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _getSearchHint(int index) {
    switch (index) {
      case 1:
        return "Search Request";
      case 2:
        return "Search Follower";
      case 3:
        return "Search Following";
      default:
        return "Search Friends";
    }
  }

  Widget _buildFriendsList(BuildContext context, CircleController controller) {
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () => controller.fetchSocialLists(isRefresh: true),
          color: Colors.transparent,
          backgroundColor: Colors.transparent,
          strokeWidth: 0,
          elevation: 0,
          child: controller.friends.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: 100.h),
                    Center(
                      child: Text(
                        "No friends found",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.whiteColor.withAlpha(128),
                        ),
                      ),
                    ),
                  ],
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: controller.friends.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) => _SocialTile(
                    type: SocialTileType.friend,
                    data: controller.friends[index],
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
  }

  Widget _buildRequestsList(BuildContext context, CircleController controller) {
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () => controller.fetchSocialLists(isRefresh: true),
          color: Colors.transparent,
          backgroundColor: Colors.transparent,
          strokeWidth: 0,
          elevation: 0,
          child: controller.friendRequests.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: 100.h),
                    Center(
                      child: Text(
                        "No friend requests",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.whiteColor.withAlpha(128),
                        ),
                      ),
                    ),
                  ],
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: controller.friendRequests.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) => _SocialTile(
                    type: SocialTileType.request,
                    data: controller.friendRequests[index],
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
  }

  Widget _buildFollowersList(
    BuildContext context,
    CircleController controller,
  ) {
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () => controller.fetchSocialLists(isRefresh: true),
          color: Colors.transparent,
          backgroundColor: Colors.transparent,
          strokeWidth: 0,
          elevation: 0,
          child: controller.followers.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: 100.h),
                    Center(
                      child: Text(
                        "No followers yet",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.whiteColor.withAlpha(128),
                        ),
                      ),
                    ),
                  ],
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: controller.followers.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) => _SocialTile(
                    type: SocialTileType.follower,
                    data: controller.followers[index],
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
  }

  Widget _buildFollowingList(
    BuildContext context,
    CircleController controller,
  ) {
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () => controller.fetchSocialLists(isRefresh: true),
          color: Colors.transparent,
          backgroundColor: Colors.transparent,
          strokeWidth: 0,
          elevation: 0,
          child: controller.following.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: 100.h),
                    Center(
                      child: Text(
                        "Not following anyone",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.whiteColor.withAlpha(128),
                        ),
                      ),
                    ),
                  ],
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: controller.following.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) => _SocialTile(
                    type: SocialTileType.following,
                    data: controller.following[index],
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
  }
}

enum SocialTileType { friend, request, follower, following }

class _SocialTile extends StatelessWidget {
  final SocialTileType type;
  final Map<String, dynamic> data;

  const _SocialTile({required this.type, required this.data});

  @override
  Widget build(BuildContext context) {
    final name = type == SocialTileType.request
        ? (data['userName'] ?? '')
        : (data['name'] ?? '');
    final avatar = data['avatar'] ?? '';
    final userId = data['userId'] ?? data['id'] ?? '';

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => UserProfileView(userId: userId, userName: name),
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: AppColors.defaultColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.whiteColor.withAlpha(13)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24.r,
              backgroundImage: NetworkImage(
                avatar.isNotEmpty
                    ? avatar
                    : 'https://i.pravatar.cc/150?u=$userId',
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.whiteColor,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _getSubTitle(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.whiteColor.withAlpha(128),
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            _buildTrailingAction(context),
          ],
        ),
      ),
    );
  }

  String _getSubTitle() {
    switch (type) {
      case SocialTileType.request:
        final mutual = data['mutualFriends'] ?? 0;
        return "$mutual mutual Friend";
      default:
        final last = data['lastActive'] ?? 'Online';
        return last;
    }
  }

  Widget _buildTrailingAction(BuildContext context) {
    switch (type) {
      case SocialTileType.friend:
        final unread = data['unreadCount'] ?? 0;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              data['lastActive'] ?? "09:30 PM",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.whiteColor.withAlpha(102),
                fontSize: 11.sp,
              ),
            ),
            if (unread > 0) ...[
              SizedBox(height: 4.h),
              CircleAvatar(
                radius: 8.r,
                backgroundColor: AppColors.greenColor,
                child: Text(
                  unread.toString(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.whiteColor,
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ],
          ],
        );
      case SocialTileType.request:
        return Row(
          children: [
            CustomButton(
              onPress: () async {},
              title: "Accept",
              width: 80,
              height: 32,
              fontSize: 10,
              linearGradient: true,
              radius: 4,
            ),
            SizedBox(width: 8.w),
            CustomButton(
              onPress: () async {},
              title: "Decline",
              width: 80,
              height: 32,
              fontSize: 10,
              buttonColor: AppColors.coachColorA5354C30,
              borderColor: AppColors.coachColorA5354C30,
              radius: 4,
            ),
          ],
        );
      case SocialTileType.follower:
        return CustomButton(
          onPress: () async {},
          title: "Remove Follower",
          width: 120,
          height: 32,
          fontSize: 10,
          horizontalPadding: 0,
          buttonColor: AppColors.coachColorA5354C30,
          borderColor: AppColors.coachColorA5354C30,
          radius: 4,
        );
      case SocialTileType.following:
        return CustomButton(
          onPress: () async {},
          title: "Unfollow",
          width: 100,
          height: 32,
          fontSize: 10,
          buttonColor: AppColors.coachColorA5354C30,
          borderColor: AppColors.coachColorA5354C30,
          radius: 4,
        );
    }
  }
}
