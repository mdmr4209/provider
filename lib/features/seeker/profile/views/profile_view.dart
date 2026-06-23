import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_loader.dart';
import '../../../../../routes/app_router.dart';
import '../../circle/models/circle_post_model.dart';
import '../../circle/widgets/circle_post_card.dart';
import '../controllers/profile_controller.dart';
import '../models/profile_details_model.dart';
import 'create_story_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<ProfileController>();
      if (controller.profileDetails == null && !controller.isLoading) {
        controller.fetchProfileDetails();
      }
    });

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Consumer<ProfileController>(
            builder: (context, controller, child) {
              final details = controller.profileDetails;

              if (controller.isLoading && details == null) {
                return const SafeArea(child: _ProfileShimmer());
              }

              final user = details?.user;

              return Stack(
                children: [
                  RefreshIndicator(
                    onRefresh: () =>
                        controller.fetchProfileDetails(isRefresh: true),
                    color: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    strokeWidth: 0,
                    elevation: 0,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Header: Name & Settings Icon ──────────────────────────────
                          Padding(
                            padding: EdgeInsets.all(20.r),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () =>
                                          context.push(AppRoutes.editProfile),
                                      child: Row(
                                        children: [
                                          Text(
                                            user?.name ?? "Rahim Rehman",
                                            style: theme.textTheme.headlineSmall
                                                ?.copyWith(
                                                  color: AppColors.whiteColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          SizedBox(width: 8.w),
                                          Icon(
                                            Icons.edit_outlined,
                                            color: AppColors.whiteColor
                                                .withAlpha(128),
                                            size: 18.r,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      user?.bio ?? "Healing Journey Day 14",
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: AppColors.whiteColor.withAlpha(
                                          128,
                                        ),
                                        fontSize: 13.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.settings_outlined,
                                    color: AppColors.coachColorFFC19E5F,
                                    size: 28.r,
                                  ),
                                  onPressed: () =>
                                      context.push(AppRoutes.settings),
                                ),
                              ],
                            ),
                          ),
                          // ── Stats Section ───────────────────────────────────────────────
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildStatItem(context, 
                                  user != null
                                      ? user.stats.posts.toString().padLeft(
                                          2,
                                          '0',
                                        )
                                      : "07",
                                  "Post",
                                ),
                                _buildStatDivider(),
                                _buildStatItem(context, 
                                  user != null
                                      ? user.stats.friends.toString()
                                      : "128",
                                  "Friends",
                                ),
                                _buildStatDivider(),
                                _buildStatItem(context, 
                                  user != null
                                      ? user.stats.followers.toString()
                                      : "220",
                                  "Followers",
                                ),
                                _buildStatDivider(),
                                _buildStatItem(context, 
                                  user != null
                                      ? user.stats.following.toString()
                                      : "14",
                                  "Following",
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24.h),
                          // ── Status Sharing ──────────────────────────────────────────────
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 24.r,
                                  backgroundImage: NetworkImage(
                                    user?.avatar ??
                                        'https://i.pravatar.cc/150?u=me',
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 12.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.whiteColor.withAlpha(13),
                                      borderRadius: BorderRadius.circular(24.r),
                                    ),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          AppAssets.feather,
                                          width: 16.r,
                                          colorFilter: const ColorFilter.mode(
                                            AppColors.greyColor,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          "Share Your Status.....",
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: AppColors.whiteColor
                                                .withAlpha(77),
                                            fontSize: 13.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24.h),
                          // ── Stories / Media Preview ──────────────────────────────────────
                          SizedBox(
                            height: 100.h,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              itemCount: (user?.media.length ?? 0) + 1,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return _buildAddStoryButton(context);
                                }
                                final mediaUrl = user!.media[index - 1];
                                return _buildMediaItem(mediaUrl);
                              },
                            ),
                          ),
                          SizedBox(height: 24.h),
                          // ── Tabs: Post / Journal ────────────────────────────────────────
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TabBar(
                                    isScrollable: true,
                                    indicatorColor:
                                        AppColors.secondaryColorLight,
                                    labelColor: AppColors.secondaryColorLight,
                                    unselectedLabelColor: AppColors.whiteColor
                                        .withAlpha(128),
                                    dividerColor: Colors.transparent,
                                    tabAlignment: TabAlignment.start,
                                    labelPadding: EdgeInsets.only(right: 24.w),
                                    tabs: [
                                      const Tab(text: "Post"),
                                      Tab(
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.lock_outline,
                                              size: 14,
                                            ),
                                            SizedBox(width: 4.w),
                                            const Text("Journal"),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => _showCreatePostSheet(context),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Create",
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: AppColors.coachColorFFC19E5F,
                                          fontSize: 13.sp,
                                        ),
                                      ),
                                      Icon(
                                        Icons.add,
                                        color: AppColors.coachColorFFC19E5F,
                                        size: 18.r,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // ── Tab View Content ───────────────────────────────────────────
                          SizedBox(
                            height: 500.h,
                            child: TabBarView(
                              children: [
                                _buildPostList(),
                                _buildJournalList(context, user?.journals ?? []),
                              ],
                            ),
                          ),
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
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.secondaryColorLight,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.whiteColor.withAlpha(128),
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      height: 30.h,
      width: 1,
      color: AppColors.whiteColor.withAlpha(26),
    );
  }

  Widget _buildAddStoryButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CreateStoryView()),
      ),
      child: Container(
        width: 80.w,
        margin: EdgeInsets.only(right: 8.w),
        decoration: BoxDecoration(
          color: AppColors.whiteColor.withAlpha(13),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.whiteColor.withAlpha(26)),
        ),
        child: Center(
          child: Icon(
            Icons.add,
            color: AppColors.whiteColor.withAlpha(128),
            size: 30.r,
          ),
        ),
      ),
    );
  }

  Widget _buildMediaItem(String url) {
    return Container(
      width: 80.w,
      margin: EdgeInsets.only(right: 8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildPostList() {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: 3,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(bottom: 16.h),
        child: CirclePostCard(
          post: CirclePostModel
              .dummyPosts[index % CirclePostModel.dummyPosts.length],
        ),
      ),
    );
  }

  Widget _buildJournalList(BuildContext context, List<ProfileJournal> journals) {
    if (journals.isEmpty) {
      return Center(
        child: Text(
          "No journal entries yet.",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.whiteColor.withAlpha(128)),
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: journals.length,
      itemBuilder: (context, index) {
        final journal = journals[index];
        return _JournalCard(journal: journal);
      },
    );
  }

  void _showCreatePostSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(24.r),
        decoration: BoxDecoration(
          color: AppColors.popupBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.whiteColor.withAlpha(51),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              "Create Post",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.whiteColor,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              "Join unlimited groups, connect with more people, and access exclusive communities with Premium.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.whiteColor.withAlpha(128),
                fontSize: 13.sp,
              ),
            ),
            SizedBox(height: 32.h),
            CustomButton(
              onPress: () async => Navigator.pop(context),
              title: "Public Post",
              linearGradient: true,
            ),
            SizedBox(height: 12.h),
            CustomButton(
              onPress: () async => Navigator.pop(context),
              title: "Journal",
              buttonColor: AppColors.blackColor.withAlpha(51),
              borderColor: AppColors.whiteColor.withAlpha(26),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}

class _JournalCard extends StatelessWidget {
  final ProfileJournal journal;
  const _JournalCard({required this.journal});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.postCardColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.edit_note,
                    color: AppColors.coachColorFFC19E5F,
                    size: 24.r,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    journal.title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.whiteColor,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.more_horiz,
                color: AppColors.whiteColor.withAlpha(128),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            journal.content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.whiteColor.withAlpha(204),
              fontSize: 14.sp,
              height: 1.4,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                journal.date,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.whiteColor.withAlpha(102),
                  fontSize: 11.sp,
                ),
              ),
              Text(
                journal.isPrivate ? "Private" : "Public",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.whiteColor.withAlpha(102),
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileShimmer extends StatelessWidget {
  const _ProfileShimmer();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerLoader(
                      width: 150.w,
                      height: 20.h,
                      borderRadius: 4.r,
                    ),
                    SizedBox(height: 6.h),
                    ShimmerLoader(
                      width: 100.w,
                      height: 12.h,
                      borderRadius: 4.r,
                    ),
                  ],
                ),
                ShimmerLoader(width: 40.r, height: 40.r, borderRadius: 20.r),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                4,
                (index) => Column(
                  children: [
                    ShimmerLoader(width: 40.w, height: 18.h, borderRadius: 4.r),
                    SizedBox(height: 6.h),
                    ShimmerLoader(width: 50.w, height: 12.h, borderRadius: 4.r),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                ShimmerLoader(width: 48.r, height: 48.r, borderRadius: 24.r),
                SizedBox(width: 12.w),
                Expanded(
                  child: ShimmerLoader(height: 48.h, borderRadius: 24.r),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          SizedBox(
            height: 100.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: 4,
              itemBuilder: (context, index) => Container(
                width: 80.w,
                margin: EdgeInsets.only(right: 8.w),
                child: ShimmerLoader(
                  width: 80.w,
                  height: 100.h,
                  borderRadius: 12.r,
                ),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerLoader(width: 120.w, height: 24.h, borderRadius: 4.r),
                ShimmerLoader(width: 60.w, height: 18.h, borderRadius: 4.r),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
