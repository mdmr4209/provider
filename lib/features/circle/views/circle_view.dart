import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:newproject/core/widgets/custom_button.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_input.dart';
import '../../../core/widgets/custom_loader.dart';
import '../../../routes/app_router.dart';
import '../controllers/circle_controller.dart';
import '../models/circle_post_model.dart';
import 'friends_view.dart';
import 'group_details_view.dart';
import 'groups_view.dart';
import '../widgets/circle_member_list.dart';
import '../widgets/circle_post_card.dart';

class CircleView extends StatefulWidget {
  const CircleView({super.key});

  @override
  State<CircleView> createState() => _CircleViewState();
}

class _CircleViewState extends State<CircleView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CircleController>().fetchCircleData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 10.h),
              const CircleMemberList(),

              // Search/Post Input Bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: GestureDetector(
                  onTap: () => context.push(AppRoutes.createPost),
                  child: AbsorbPointer(
                    child: CustomInput(
                      height: 50,
                      hintText: "Word Your Thoughts",
                      fontSize: 14,
                      hintColor: AppColors.greyColor,
                      hintStyle: Theme.of(context).textTheme.bodyLarge
                          ?.copyWith(
                            color: AppColors.whiteColor.withAlpha(153),
                            fontSize: 14.sp,
                          ),
                      shadow: true,
                      leadingIcon: AppAssets.feather,
                      leadingPadding: EdgeInsets.only(left: 16.w, right: 8.w),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 11.h),

              // Tabs and Groups Action
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Expanded(
                      child: TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        indicatorColor: AppColors.secondaryColorLight,
                        labelColor: AppColors.secondaryColorLight,
                        unselectedLabelColor: AppColors.whiteColor.withAlpha(
                          153,
                        ),
                        dividerColor: Colors.transparent,
                        tabAlignment: TabAlignment.start,
                        labelPadding: EdgeInsets.only(right: 24.w),
                        labelStyle: theme.textTheme.titleMedium?.copyWith(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        unselectedLabelStyle: theme.textTheme.titleMedium
                            ?.copyWith(fontSize: 18.sp),
                        tabs: [
                          const Tab(text: "Everyone"),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const FriendsView(),
                              ),
                            ),
                            child: const Tab(text: "Friends"),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const GroupsView()),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor.withAlpha(13),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          children: [
                            Text(
                              "My Groups",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.secondaryColorLight,
                                fontSize: 12.sp,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            SvgPicture.asset(
                              AppAssets.group,
                              colorFilter: const ColorFilter.mode(
                                AppColors.secondaryColorLight,
                                BlendMode.srcIn,
                              ),
                              width: 16.r,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    const _PostsList(),
                    Center(
                      child: Text(
                        "Friends Posts Coming Soon",
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: AppColors.whiteColor.withAlpha(179),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PostsList extends StatelessWidget {
  const _PostsList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<CircleController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            itemCount: 3,
            itemBuilder: (context, index) => const _PostShimmer(),
          );
        }

        if (controller.posts.isEmpty) {
          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: () => controller.fetchCircleData(isRefresh: true),
                color: Colors.transparent,
                backgroundColor: Colors.transparent,
                strokeWidth: 0,
                elevation: 0,
                child: ListView(
                  children: [
                    SizedBox(height: 100.h),
                    Center(
                      child: Text(
                        "No posts available",
                        style: TextStyle(
                          color: AppColors.whiteColor.withAlpha(128),
                        ),
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
          );
        }

        final bool showSuggestions = controller.posts.length >= 2;
        final int itemCount = showSuggestions
            ? controller.posts.length + 1
            : controller.posts.length;

        return Stack(
          children: [
            RefreshIndicator(
              onRefresh: () => controller.fetchCircleData(isRefresh: true),
              color: Colors.transparent,
              backgroundColor: Colors.transparent,
              strokeWidth: 0,
              elevation: 0,
              displacement: 20,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  if (showSuggestions && index == 2) {
                    return const _SuggestionsSection();
                  }

                  final int postIndex = (showSuggestions && index > 2)
                      ? index - 1
                      : index;

                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    child: CirclePostCard(post: controller.posts[postIndex]),
                  );
                },
              ),
            ),
            if (controller.isRefreshing)
              Positioned(
                top: 16.h,
                left: 0,
                right: 0,
                child: const Center(child: CustomLoader(size: 140)),
              ),
          ],
        );
      },
    );
  }
}

class _SuggestionsSection extends StatelessWidget {
  const _SuggestionsSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Suggestions",
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.whiteColor.withAlpha(230),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "View All",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.secondaryColorLight,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 150.h,
          child: Consumer<CircleController>(
            builder: (context, controller, child) {
              return ListView.builder(
                padding: EdgeInsets.only(left: 16.w, right: 8.w),
                scrollDirection: Axis.horizontal,
                itemCount: controller.members.length,
                itemBuilder: (context, index) {
                  return _SuggestionCard(suggestion: controller.members[index]);
                },
              );
            },
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  final SuggestionModel suggestion;
  const _SuggestionCard({required this.suggestion});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 125.w,
      margin: EdgeInsets.only(right: 8.w),
      padding: EdgeInsets.fromLTRB(8.w, 11.h, 8.w, 9.h),
      decoration: BoxDecoration(
        color: AppColors
            .postCardColor, // Dark green background matching the design
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.whiteColor.withAlpha(13)),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 55.04.w,
            height: 56.h,
            child: CircleAvatar(
              radius: 35.r,
              backgroundImage: NetworkImage(suggestion.avatar),
              backgroundColor: AppColors.whiteColor.withAlpha(26),
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            suggestion.name,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.whiteColor,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            "${suggestion.mutualFriends} mutual Friend",
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.whiteColor.withAlpha(128),
            ),
          ),
          const Spacer(),
          CustomButton(
            onPress: () async {},
            title: "Add Friend",
            fontWeight: FontWeight.w400,
            linearGradient: true,
            height: 23.h,
            borderColor: AppColors.postCardColor,
            radius: 4.r,
            horizontalPadding: 0,
          ),
        ],
      ),
    );
  }
}

class _PostShimmer extends StatelessWidget {
  const _PostShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.whiteColor.withAlpha(13),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ShimmerLoader(width: 40.r, height: 40.r, borderRadius: 20.r),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerLoader(
                      width: 100.w,
                      height: 12.h,
                      borderRadius: 4.r,
                    ),
                    SizedBox(height: 6.h),
                    ShimmerLoader(width: 60.w, height: 10.h, borderRadius: 4.r),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.h),
            ShimmerLoader(
              width: double.infinity,
              height: 14.h,
              borderRadius: 4.r,
            ),
            SizedBox(height: 8.h),
            ShimmerLoader(width: 200.w, height: 14.h, borderRadius: 4.r),
            SizedBox(height: 16.h),
            ShimmerLoader(
              width: double.infinity,
              height: 150.h,
              borderRadius: 12.r,
            ),
          ],
        ),
      ),
    );
  }
}
