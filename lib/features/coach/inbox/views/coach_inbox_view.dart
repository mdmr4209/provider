import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_input.dart';
import '../../../../core/widgets/background_widget.dart';
import '../../../../core/widgets/custom_loader.dart';
import '../controllers/coach_inbox_controller.dart';
import '../../../../routes/app_router.dart';
import 'coach_find_friends_view.dart';

class CoachInboxView extends StatelessWidget {
  const CoachInboxView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<CoachInboxController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctrl = context.read<CoachInboxController>();
      if (!ctrl.hasFetched && !ctrl.isLoading && !ctrl.isRefreshing) {
        ctrl.fetchInboxData();
      }
    });

    return BackgroundWidget(
      imagePath: AppAssets.bgMain,
      child: DefaultTabController(
        length: 4,
        initialIndex: controller.selectedTabIndex,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              children: [
                // ── Header: Title, Toggle, Credits ──────────────────────────
                Padding(
                  padding: EdgeInsets.only(left: 16.w, top: 24.h, bottom: 17.h),
                  child: Row(
                    children: [
                      Text(
                        'Inbox',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.coachColorFFF5F0E8,
                          fontSize: 18,
                          fontFamily: 'Georgia',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Spacer(),
                      _buildContextToggle(context, controller),
                      const Spacer(),
                      if (controller.selectedContext == 1)
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CoachFindFriendsView(),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.add,
                                color: AppColors.coachColorFFC19E5F,
                                size: 20,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                "Add",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.coachColorFFC19E5F,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        _buildCreditsBadge(context, controller.credits),
                    ],
                  ),
                ),

                Expanded(
                  child: controller.isLoading
                      ? _buildSkeletonLoader(context)
                      : Stack(
                          children: [
                            RefreshIndicator(
                              onRefresh: () =>
                                  controller.fetchInboxData(isRefresh: true),
                              color: Colors.transparent,
                              backgroundColor: Colors.transparent,
                              strokeWidth: 0,
                              elevation: 0,
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // ── Stories Section ──────────────────────────────────────────
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 16.w,
                                        top: 10.h,
                                        bottom: 8.h,
                                      ),
                                      child: Text(
                                        'Stories',
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color:
                                                  AppColors.coachColorFFB9BBB0,
                                              fontSize: 12.03,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                              height: 1.50,
                                            ),
                                      ),
                                    ),
                                    _buildStoriesRow(controller),

                                    // ── Search Bar ──────────────────────────────────────────────
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                      ),
                                      child: AbsorbPointer(
                                        child: CustomInput(
                                          height: 50,
                                          hintText: "Search by Client name",
                                          fontSize: 14,
                                          hintStyle: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                color: AppColors.whiteColor
                                                    .withAlpha(153),
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
                                    ),

                                    SizedBox(height: 20.h),

                                    if (controller.selectedContext == 0) ...[
                                      // ── Tabs ───────────────────────────────────────────────────
                                      TabBar(
                                        isScrollable: true,
                                        indicatorColor: Colors.transparent,
                                        dividerColor: Colors.transparent,
                                        tabAlignment: TabAlignment.start,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16.w,
                                        ),
                                        labelPadding: EdgeInsets.only(
                                          right: 12.w,
                                        ),
                                        onTap: (index) =>
                                            controller.setSelectedTab(index),
                                        tabs: [
                                          _buildTab(
                                            context,
                                            "Messages",
                                            0,
                                            controller,
                                          ),
                                          _buildTab(
                                            context,
                                            "Missed call",
                                            1,
                                            controller,
                                          ),
                                          _buildTab(
                                            context,
                                            "Call Back",
                                            2,
                                            controller,
                                          ),
                                          _buildTab(
                                            context,
                                            "Clients",
                                            3,
                                            controller,
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: 13.h),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16.w,
                                        ),
                                        child: Divider(
                                          height: .5,
                                          thickness: .5,
                                          color: AppColors.coachColorFF1D311A,
                                        ),
                                      ),
                                      SizedBox(height: 7.5.h),
                                    ],

                                    // ── Content Area ────────────────────────────────────────────
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                      ),
                                      child: _buildTabContent(
                                        context,
                                        controller,
                                      ),
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
                                  child: CustomLoader(size: 100),
                                ),
                              ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContextToggle(
    BuildContext context,
    CoachInboxController controller,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.coachColorFF182617,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleItem(context, "Clients", 0, controller),
          _buildToggleItem(context, "Friends", 1, controller),
        ],
      ),
    );
  }

  Widget _buildToggleItem(
    BuildContext context,
    String label,
    int index,
    CoachInboxController controller,
  ) {
    final isSelected = controller.selectedContext == index;
    return GestureDetector(
      onTap: () => controller.setSelectedContext(index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.coachColorFF3E5E39
              : AppColors.coachColorFF182617,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isSelected ? AppColors.whiteColor : AppColors.white54Color,
            fontSize: 13.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildCreditsBadge(BuildContext context, int credits) {
    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: ShapeDecoration(
        color: AppColors.coachColorFF355530,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            bottomLeft: Radius.circular(12),
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            "$credits",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.coachColorFFC19E5F,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            "Credits",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.white70Color,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoriesRow(CoachInboxController controller) {
    return SizedBox(
      height: 100.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: controller.stories.length,
        itemBuilder: (context, index) {
          final story = controller.stories[index];
          if (story.isMine) return _buildAddStory(context, story.name);
          return _buildStoryItem(context, story.name, story.avatar);
        },
      ),
    );
  }

  Widget _buildAddStory(BuildContext context, String name) {
    return Container(
      width: 70.w,
      margin: EdgeInsets.only(right: 12.w),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 28.r,
                backgroundColor: AppColors.whiteColor.withAlpha(13),
                child: const Icon(
                  Icons.add,
                  color: AppColors.whiteColor,
                  size: 24,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: AppColors.whiteColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 12,
                    color: AppColors.blackColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            name,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.whiteColor,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryItem(BuildContext context, String name, String avatar) {
    return Container(
      width: 70.w,
      margin: EdgeInsets.only(right: 12.w),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.coachColorFFC19E5F,
                width: 1.5,
              ),
            ),
            child: CircleAvatar(
              radius: 26.r,
              backgroundImage: NetworkImage(avatar),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            name,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.whiteColor,
              fontSize: 10,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildTab(
    BuildContext context,
    String label,
    int index,
    CoachInboxController controller,
  ) {
    final isSelected = controller.selectedTabIndex == index;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: ShapeDecoration(
        color: isSelected ? AppColors.coachColorFF355530 : Colors.transparent,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1.r,
            color: !isSelected
                ? Colors.transparent
                : AppColors.coachColorFF4F9445,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: isSelected ? AppColors.whiteColor : AppColors.white54Color,
          fontSize: 12.sp,
        ),
      ),
    );
  }

  Widget _buildTabContent(
    BuildContext context,
    CoachInboxController controller,
  ) {
    switch (controller.selectedTabIndex) {
      case 0:
        return _buildMessagesList(context, controller);
      case 1:
        return _buildMissedCallsList(context, controller);
      case 2:
        return _buildCallBackList(context, controller);
      case 3:
        return _buildClientsList(context, controller);
      default:
        return const SizedBox();
    }
  }

  Widget _buildMessagesList(
    BuildContext context,
    CoachInboxController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Chats List",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.whiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 8.h),
        if (controller.messages.isEmpty)
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              "No messages",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.white54Color),
            ),
          )
        else
          ...controller.messages.map(
            (msg) => _buildChatTile(
              context,
              msg.name,
              msg.isOnline ? "Online" : "Offline",
              msg.time,
              msg.unreadCount.toString(),
              msg.avatar,
            ),
          ),
      ],
    );
  }

  Widget _buildClientsList(
    BuildContext context,
    CoachInboxController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "My Clients",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.whiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 7.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 14.h),
          decoration: ShapeDecoration(
            color: AppColors.coachColorFF263523,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
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
              Text(
                'Day 14 of No Contact. It was really hard today today, I almost texted him when I saw his favorite song playing. But I stayed strong!',
                textAlign: TextAlign.justify,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.coachColorFFD1D1D1,
                  fontSize: 10,
                  fontFamily: 'Segoe UI',
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 10.h),
              CustomButton(
                onPress: () async {},
                title: "Find New Client",
                width: 115,
                height: 31,
                fontSize: 10,
                buttonColor: AppColors.coachColorFF354C30,
                borderColor: AppColors.coachColor33434928,
                radius: 4,
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
        SizedBox(height: 7.h),
        if (controller.clients.isEmpty)
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              "No clients",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.white54Color),
            ),
          )
        else
          ...controller.clients.map(
            (c) => _buildChatTile(
              context,
              c.name,
              c.status,
              c.time,
              c.unreadCount,
              c.avatar,
            ),
          ),
      ],
    );
  }

  Widget _buildChatTile(
    BuildContext context,
    String name,
    String status,
    String time,
    String count,
    String avatar,
  ) {
    return GestureDetector(
      onTap: () {
        context.push(
          AppRoutes.chat,
          extra: {
            'name': name,
            'avatar': avatar,
            'isCoach': false, // Coach is talking to a client/friend
          },
        );
      },
      child: Container(
        padding: EdgeInsets.all(12.r),
        child: Row(
          children: [
            CircleAvatar(radius: 24.r, backgroundImage: NetworkImage(avatar)),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    status,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.coachColorFF81C784,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.white38Color,
                    fontSize: 10,
                  ),
                ),
                SizedBox(height: 4.h),
                if (count != "0")
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.coachColorFF81C784,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      count,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.whiteColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMissedCallsList(
    BuildContext context,
    CoachInboxController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Missed Calls",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.whiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 8.h),
        if (controller.missedCalls.isEmpty)
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              "No missed calls",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.white54Color),
            ),
          )
        else
          ...controller.missedCalls.map(
            (m) => _buildMissedCallTile(
              context,
              m.name,
              m.timeRequested,
              m.avatar,
            ),
          ),
      ],
    );
  }

  Widget _buildMissedCallTile(
    BuildContext context,
    String name,
    String time,
    String avatar,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.defaultColor,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 24.r, backgroundImage: NetworkImage(avatar)),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    SvgPicture.asset(AppAssets.missedCall),
                    Text(
                      " $time",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.white38Color,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          CustomButton(
            onPress: () async {},
            title: "Notify I'm Available",
            width: 140,
            height: 28,
            fontSize: 10,
            buttonColor: AppColors.coachColorFF273B23,
            borderColor: AppColors.coachColorFF425F3D,
            radius: 2,
            fontWeight: FontWeight.w400,
            horizontalPadding: 0,
            leadingPadding: EdgeInsets.only(right: 4),
            leadingWidget: SvgPicture.asset(AppAssets.availableNotify),
          ),
        ],
      ),
    );
  }

  Widget _buildCallBackList(
    BuildContext context,
    CoachInboxController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Call Back Request List",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.whiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 8.h),
        if (controller.callbacks.isEmpty)
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              "No call back requests",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.white54Color),
            ),
          )
        else
          ...controller.callbacks.map(
            (c) =>
                _buildCallBackTile(context, c.name, c.timeRequested, c.avatar),
          ),
      ],
    );
  }

  Widget _buildCallBackTile(
    BuildContext context,
    String name,
    String time,
    String avatar,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.defaultColor,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(radius: 24.r, backgroundImage: NetworkImage(avatar)),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "Requested: $time",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.white38Color,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  onPress: () async {},
                  title: "Notify I'm Available",
                  width: 140,
                  height: 28,
                  fontSize: 10,
                  buttonColor: AppColors.coachColorFF273B23,
                  borderColor: AppColors.coachColorFF425F3D,
                  radius: 2,
                  fontWeight: FontWeight.w400,
                  horizontalPadding: 0,
                  leadingPadding: EdgeInsets.only(right: 4),
                  leadingWidget: SvgPicture.asset(AppAssets.availableNotify),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: CustomButton(
                  onPress: () async {
                    context.push(
                      AppRoutes.call,
                      extra: {
                        'name': name,
                        'avatar': avatar,
                        'rate': 'Free', // or specific rate
                      },
                    );
                  },
                  title: "Call Back",
                  height: 28,
                  fontSize: 10,
                  linearGradient: true,
                  radius: 8,
                  leadingWidget: const Icon(
                    Icons.call_outlined,
                    color: AppColors.whiteColor,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonLoader(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.w, top: 10.h, bottom: 8.h),
            child: ShimmerLoader(width: 80.w, height: 14.h),
          ),
          SizedBox(
            height: 100.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  width: 70.w,
                  margin: EdgeInsets.only(right: 12.w),
                  child: Column(
                    children: [
                      ShimmerLoader(
                        width: 52.r,
                        height: 52.r,
                        borderRadius: 26.r,
                      ),
                      SizedBox(height: 8.h),
                      ShimmerLoader(width: 50.w, height: 10.h),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: ShimmerLoader(
              width: double.infinity,
              height: 48.h,
              borderRadius: 24.r,
            ),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: List.generate(
                4,
                (index) => Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: ShimmerLoader(
                    width: 80.w,
                    height: 30.h,
                    borderRadius: 15.r,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerLoader(width: 120.w, height: 20.h),
                SizedBox(height: 16.h),
                ...List.generate(
                  5,
                  (_) => Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: Row(
                      children: [
                        ShimmerLoader(
                          width: 48.r,
                          height: 48.r,
                          borderRadius: 24.r,
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ShimmerLoader(width: 40.w, height: 10.h),
                            SizedBox(height: 4.h),
                            ShimmerLoader(
                              width: 20.r,
                              height: 20.r,
                              borderRadius: 10.r,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
