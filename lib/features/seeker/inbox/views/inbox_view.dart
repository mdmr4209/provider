import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_input.dart';
import '../../../../core/widgets/custom_loader.dart';
import '../controllers/inbox_controller.dart';
import '../models/inbox_model.dart';
import 'package:go_router/go_router.dart';
import '../../../../routes/app_router.dart';

class InboxView extends StatelessWidget {
  const InboxView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedContextIndex = ValueNotifier<int>(0);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<InboxController>();
      if (controller.chats.isEmpty && !controller.isLoading) {
        controller.fetchInboxData();
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
              return ValueListenableBuilder<int>(
                valueListenable: selectedContextIndex,
                builder: (context, currentContextIndex, _) {
                  final isCoachContext = currentContextIndex == 0;
                  return Scaffold(
                    body: SafeArea(
                      child: Consumer<InboxController>(
                        builder: (context, controller, child) {
                          final allChats = controller.chats;
                          final filteredChats = allChats.where((chat) {
                            // Filter by Coach vs Friend
                            if (isCoachContext != chat.isCoach) return false;

                            // Filter by Tabs
                            if (tabController.index == 1) {
                              return chat.unreadCount > 0;
                            }
                            return true;
                          }).toList();

                          return Column(
                            children: [
                              // ── Header: Title, Toggle, Calendar ──────────────────────────
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 10.h,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "Inbox",
                                      style: theme.textTheme.headlineSmall
                                          ?.copyWith(
                                            color: AppColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Georgia',
                                          ),
                                    ),
                                    const Spacer(),
                                    _buildContextToggle(
                                      context,
                                      selectedContextIndex,
                                      currentContextIndex,
                                    ),
                                    const Spacer(),
                                    currentContextIndex == 1
                                        ? GestureDetector(
                                            onTap: () => context.push(
                                              AppRoutes.findFriends,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 8.w,
                                                vertical: 4.h,
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.add,
                                                    color: AppColors
                                                        .secondaryColorLight,
                                                    size: 20.r,
                                                  ),
                                                  SizedBox(width: 4.w),
                                                  Text(
                                                    "Add",
                                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                      color: AppColors
                                                          .secondaryColorLight,
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : IconButton(
                                            icon: Icon(
                                              Icons.calendar_today_outlined,
                                              color: AppColors.amberColor,
                                              size: 24.r,
                                            ),
                                            onPressed: () {
                                              context.push(AppRoutes.bookings);
                                            },
                                          ),
                                  ],
                                ),
                              ),

                              Expanded(
                                child: Stack(
                                  children: [
                                    RefreshIndicator(
                                      onRefresh: () => controller
                                          .fetchInboxData(isRefresh: true),
                                      color: Colors.transparent,
                                      backgroundColor: Colors.transparent,
                                      strokeWidth: 0,
                                      elevation: 0,
                                      child: SingleChildScrollView(
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // ── Stories Section ──────────────────────────────────────────
                                            Padding(
                                              padding: EdgeInsets.only(
                                                left: 16.w,
                                                top: 10.h,
                                                bottom: 8.h,
                                              ),
                                              child: Text(
                                                "Stories",
                                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                  color: AppColors.whiteColor
                                                      .withAlpha(128),
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                            ),
                                            if (controller.isLoading &&
                                                controller.stories.isEmpty)
                                              SizedBox(
                                                height: 100.h,
                                                child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 16.w,
                                                  ),
                                                  itemCount: 4,
                                                  itemBuilder:
                                                      (
                                                        context,
                                                        index,
                                                      ) => Container(
                                                        width: 70.w,
                                                        margin: EdgeInsets.only(
                                                          right: 12.w,
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            ShimmerLoader(
                                                              width: 56.r,
                                                              height: 56.r,
                                                              borderRadius:
                                                                  28.r,
                                                            ),
                                                            SizedBox(
                                                              height: 8.h,
                                                            ),
                                                            ShimmerLoader(
                                                              width: 40.w,
                                                              height: 10.h,
                                                              borderRadius: 4.r,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                ),
                                              )
                                            else
                                              SizedBox(
                                                height: 100.h,
                                                child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 16.w,
                                                  ),
                                                  itemCount:
                                                      controller.stories.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                        final story = controller
                                                            .stories[index];
                                                        return _buildStoryItem(context, 
                                                          story.name,
                                                          story.avatar,
                                                          isMine: story.isMine,
                                                        );
                                                      },
                                                ),
                                              ),

                                            SizedBox(height: 20.h),

                                            // ── Search Bar ──────────────────────────────────────────────
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 16.w,
                                              ),
                                              child: CustomInput(
                                                height: 48,
                                                hintText: "Search name",
                                                backgroundColor: AppColors
                                                    .whiteColor
                                                    .withAlpha(13),
                                                borderRadius: 24,
                                                shadow: false,
                                                leadingIcon: AppAssets.search,
                                              ),
                                            ),

                                            SizedBox(height: 20.h),

                                            // ── Tabs ───────────────────────────────────────────────────
                                            TabBar(
                                              isScrollable: true,
                                              indicatorColor:
                                                  Colors.transparent,
                                              dividerColor: Colors.transparent,
                                              tabAlignment: TabAlignment.start,
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 16.w,
                                              ),
                                              labelPadding: EdgeInsets.only(
                                                right: 12.w,
                                              ),
                                              tabs: [
                                                _buildTab(context, 
                                                  "Messages",
                                                  0,
                                                  tabController.index,
                                                ),
                                                _buildTab(context, 
                                                  "Unread Messages",
                                                  1,
                                                  tabController.index,
                                                ),
                                                _buildTab(context, 
                                                  "Missed calls",
                                                  2,
                                                  tabController.index,
                                                ),
                                                _buildTab(context, 
                                                  "Call Back",
                                                  3,
                                                  tabController.index,
                                                ),
                                              ],
                                            ),

                                            SizedBox(height: 16.h),

                                            // ── Message List ────────────────────────────────────────────
                                            if (controller.isLoading &&
                                                controller.chats.isEmpty)
                                              ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 16.w,
                                                ),
                                                itemCount: 3,
                                                itemBuilder: (context, index) =>
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                        bottom: 12.h,
                                                      ),
                                                      child: ShimmerLoader(
                                                        width: double.infinity,
                                                        height: 72.h,
                                                        borderRadius: 12.r,
                                                      ),
                                                    ),
                                              )
                                            else if (filteredChats.isEmpty)
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 40.h,
                                                  horizontal: 20.w,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "No chats available in this section.",
                                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                      color: AppColors
                                                          .whiteColor
                                                          .withAlpha(128),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            else
                                              ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 16.w,
                                                ),
                                                itemCount: filteredChats.length,
                                                itemBuilder: (context, idx) {
                                                  final chat =
                                                      filteredChats[idx];
                                                  return _buildInboxTile(
                                                    context,
                                                    chat,
                                                    tabController.index,
                                                    isCoachContext,
                                                  );
                                                },
                                              ),
                                            SizedBox(height: 20.h),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (controller.isRefreshing)
                                      Positioned(
                                        top: 16.h,
                                        left: 0,
                                        right: 0,
                                        child: const Center(
                                          child: CustomLoader(size: 150),
                                        ),
                                      ),
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
          );
        },
      ),
    );
  }

  Widget _buildContextToggle(
    BuildContext context,
    ValueNotifier<int> selectedNotifier,
    int selectedIndex,
  ) {
    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: AppColors.whiteColor.withAlpha(26),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleItem(context, "Coach", 0, selectedNotifier, selectedIndex),
          _buildToggleItem(context, "Friends", 1, selectedNotifier, selectedIndex),
        ],
      ),
    );
  }

  Widget _buildToggleItem(
    BuildContext context, String label,
    int index,
    ValueNotifier<int> selectedNotifier,
    int selectedIndex,
  ) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => selectedNotifier.value = index,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.coachColorFF334B2F : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isSelected
                ? AppColors.whiteColor
                : AppColors.whiteColor.withAlpha(128),
            fontSize: 13.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildStoryItem(BuildContext context, String name, String avatar, {bool isMine = false}) {
    return Container(
      width: 70.w,
      margin: EdgeInsets.only(right: 12.w),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: EdgeInsets.all(2.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isMine
                        ? AppColors.whiteColor.withAlpha(51)
                        : AppColors.greenColor,
                    width: 2.r,
                  ),
                ),
                child: CircleAvatar(
                  radius: 28.r,
                  backgroundImage: NetworkImage(avatar),
                ),
              ),
              if (isMine)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(2.r),
                    decoration: const BoxDecoration(
                      color: AppColors.whiteColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.add,
                      size: 14.r,
                      color: AppColors.blackColor,
                    ),
                  ),
                )
              else
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    width: 12.r,
                    height: 12.r,
                    decoration: BoxDecoration(
                      color: AppColors.greenColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.blackColor,
                        width: 2.r,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            name,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.whiteColor, fontSize: 11.sp),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildTab(BuildContext context, String label, int index, int selectedIndex) {
    final isSelected = selectedIndex == index;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: isSelected
              ? AppColors.greenColor
              : AppColors.whiteColor.withAlpha(26),
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: isSelected
              ? AppColors.whiteColor
              : AppColors.whiteColor.withAlpha(128),
          fontSize: 12.sp,
        ),
      ),
    );
  }

  Widget _buildInboxTile(
    BuildContext context,
    ChatSummaryModel chat,
    int filterIndex,
    bool isCoachContext,
  ) {
    return GestureDetector(
      onTap: () {
        context.push(
          AppRoutes.chat,
          extra: {
            'name': chat.name,
            'avatar': chat.avatar,
            'isCoach': isCoachContext,
          },
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: AppColors.postCardColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.whiteColor.withAlpha(13)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 24.r,
                      backgroundImage: NetworkImage(chat.avatar),
                    ),
                    if (chat.isOnline)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 10.r,
                          height: 10.r,
                          decoration: BoxDecoration(
                            color: AppColors.greenColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.blackColor,
                              width: 1.5.r,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chat.name,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.whiteColor,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        filterIndex == 2
                            ? "12 April, 1:30AM"
                            : filterIndex == 3
                            ? "Requested: Today at 3:00 PM"
                            : chat.lastMessage.isNotEmpty
                            ? chat.lastMessage
                            : (chat.isOnline ? "Online" : "Offline"),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: filterIndex == 2
                              ? AppColors.redColor.withAlpha(204)
                              : AppColors.whiteColor.withAlpha(128),
                          fontSize: 12.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (filterIndex < 2)
                  Text(
                    chat.time,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.whiteColor.withAlpha(102),
                      fontSize: 11.sp,
                    ),
                  ),
              ],
            ),
            if (filterIndex == 2) ...[
              SizedBox(height: 12.h),
              Align(
                alignment: Alignment.centerRight,
                child: CustomButton(
                  onPress: () async {},
                  title: "Notify I'm Available",
                  width: 160,
                  height: 28,
                  fontSize: 10,
                  buttonColor: AppColors.whiteColor.withAlpha(13),
                  borderColor: Colors.transparent,
                  radius: 8,
                  horizontalPadding: 0,
                  leadingWidget: Icon(
                    Icons.notifications_none,
                    color: AppColors.amberColor,
                    size: 16.r,
                  ),
                ),
              ),
            ],
            if (filterIndex == 3) ...[
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomButton(
                    onPress: () async {},
                    title: "Notify I'm Available",
                    width: 154,
                    height: 28,
                    fontSize: 10,
                    buttonColor: AppColors.whiteColor.withAlpha(13),
                    borderColor: Colors.transparent,
                    radius: 4,
                    leadingWidget: Icon(
                      Icons.notifications_none,
                      color: AppColors.amberColor,
                      size: 16.r,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  CustomButton(
                    onPress: () async {
                      context.push(
                        AppRoutes.call,
                        extra: {
                          'name': chat.name,
                          'avatar': chat.avatar,
                          'rate': isCoachContext ? '2\$/Min' : 'Free',
                        },
                      );
                    },
                    title: "Call Back",
                    width: 154,
                    height: 28,
                    fontSize: 10,
                    linearGradient: true,
                    radius: 4,
                    leadingWidget: Icon(
                      Icons.call_outlined,
                      color: AppColors.whiteColor,
                      size: 16.r,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
