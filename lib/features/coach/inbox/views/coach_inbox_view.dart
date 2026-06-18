import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_input.dart';
import '../../../../core/widgets/background_widget.dart';
import '../../../../core/widgets/custom_loader.dart';
import '../controllers/coach_inbox_controller.dart';
import '../../../../routes/app_router.dart';

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
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: Row(
                  children: [
                    Text(
                      "Inbox",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    _buildContextToggle(controller),
                    const Spacer(),
                    _buildCreditsBadge(controller.credits),
                  ],
                ),
              ),

              Expanded(
                child: controller.isLoading
                    ? _buildSkeletonLoader(context)
                    : Stack(
                        children: [
                          RefreshIndicator(
                            onRefresh: () => controller.fetchInboxData(isRefresh: true),
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
                                    padding: EdgeInsets.only(left: 16.w, top: 10.h, bottom: 8.h),
                                    child: const Text("Stories", style: TextStyle(color: Colors.white54, fontSize: 14)),
                                  ),
                                  _buildStoriesRow(controller),

                                  SizedBox(height: 20.h),

                                  // ── Search Bar ──────────────────────────────────────────────
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                                    child: CustomInput(
                                      height: 48,
                                      hintText: "Search name",
                                      backgroundColor: Colors.white.withAlpha(13),
                                      borderRadius: 24,
                                      shadow: false,
                                      leadingIcon: AppAssets.search,
                                    ),
                                  ),

                                  SizedBox(height: 20.h),

                                  // ── Tabs ───────────────────────────────────────────────────
                                  TabBar(
                                    isScrollable: true,
                                    indicatorColor: Colors.transparent,
                                    dividerColor: Colors.transparent,
                                    tabAlignment: TabAlignment.start,
                                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                                    labelPadding: EdgeInsets.only(right: 12.w),
                                    onTap: (index) => controller.setSelectedTab(index),
                                    tabs: [
                                      _buildTab("Messages", 0, controller),
                                      _buildTab("Missed call", 1, controller),
                                      _buildTab("Call Back", 2, controller),
                                      _buildTab("Clients", 3, controller),
                                    ],
                                  ),

                                  SizedBox(height: 16.h),

                                  // ── Content Area ────────────────────────────────────────────
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                                    child: _buildTabContent(context, controller),
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
                              child: const Center(child: CustomLoader(size: 100)),
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

  Widget _buildContextToggle(CoachInboxController controller) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF182617),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleItem("Clients", 0, controller),
          _buildToggleItem("Friends", 1, controller),
        ],
      ),
    );
  }

  Widget _buildToggleItem(String label, int index, CoachInboxController controller) {
    final isSelected = controller.selectedContext == index;
    return GestureDetector(
      onTap: () => controller.setSelectedContext(index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3E5E39) :const Color(0xFF182617),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white54,
            fontSize: 13.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildCreditsBadge(int credits) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3D2D),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Text("$credits", style: const TextStyle(color: Color(0xFFC19E5F), fontWeight: FontWeight.bold)),
          SizedBox(width: 4.w),
          const Text("Credits", style: TextStyle(color: Colors.white70, fontSize: 11)),
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
          if (story.isMine) return _buildAddStory(story.name);
          return _buildStoryItem(story.name, story.avatar);
        },
      ),
    );
  }

  Widget _buildAddStory(String name) {
    return Container(
      width: 70.w,
      margin: EdgeInsets.only(right: 12.w),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 28.r,
                backgroundColor: Colors.white.withAlpha(13),
                child: const Icon(Icons.add, color: Colors.white, size: 24),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: const Icon(Icons.add, size: 12, color: Colors.black),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(name, style: const TextStyle(color: Colors.white, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildStoryItem(String name, String avatar) {
    return Container(
      width: 70.w,
      margin: EdgeInsets.only(right: 12.w),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFC19E5F), width: 1.5),
            ),
            child: CircleAvatar(
              radius: 26.r,
              backgroundImage: NetworkImage(avatar),
            ),
          ),
          SizedBox(height: 4.h),
          Text(name, style: const TextStyle(color: Colors.white, fontSize: 10), overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index, CoachInboxController controller) {
    final isSelected = controller.selectedTabIndex == index;
    return Container(
      padding:  EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: ShapeDecoration(
        color: isSelected ? const Color(0xFF355530) : Colors.transparent,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1.r,
            color: !isSelected ? Colors.transparent : const Color(0xFF4F9445),
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white54,
          fontSize: 12.sp,
        ),
      ),
    );
  }

  Widget _buildTabContent(BuildContext context, CoachInboxController controller) {
    switch (controller.selectedTabIndex) {
      case 0: return _buildMessagesList(context, controller);
      case 1: return _buildMissedCallsList(controller);
      case 2: return _buildCallBackList(context, controller);
      case 3: return _buildClientsList(context, controller);
      default: return const SizedBox();
    }
  }

  Widget _buildMessagesList(BuildContext context, CoachInboxController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Chats List", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 16.h),
        if (controller.messages.isEmpty)
          const Padding(padding: EdgeInsets.only(top: 20), child: Text("No messages", style: TextStyle(color: Colors.white54)))
        else
          ...controller.messages.map((msg) => _buildChatTile(context, msg.name, msg.isOnline ? "Online" : "Offline", msg.time, msg.unreadCount.toString(), msg.avatar)),
      ],
    );
  }

  Widget _buildClientsList(BuildContext context, CoachInboxController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("My Clients", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 16.h),
        if (controller.clients.isEmpty)
          const Padding(padding: EdgeInsets.only(top: 20), child: Text("No clients", style: TextStyle(color: Colors.white54)))
        else
          ...controller.clients.map((c) => _buildChatTile(context, c.name, c.status, c.time, c.unreadCount, c.avatar)),
      ],
    );
  }

  Widget _buildChatTile(BuildContext context, String name, String status, String time, String count, String avatar) {
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
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: const Color(0xFF22331F),
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24.r,
              backgroundImage: NetworkImage(avatar),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Text(status, style: const TextStyle(color: Color(0xFF81C784), fontSize: 12)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(time, style: const TextStyle(color: Colors.white38, fontSize: 10)),
                SizedBox(height: 4.h),
                if (count != "0")
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Color(0xFF81C784), shape: BoxShape.circle),
                    child: Text(count, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMissedCallsList(CoachInboxController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Missed Calls", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 16.h),
        if (controller.missedCalls.isEmpty)
          const Padding(padding: EdgeInsets.only(top: 20), child: Text("No missed calls", style: TextStyle(color: Colors.white54)))
        else
          ...controller.missedCalls.map((m) => _buildMissedCallTile(m.name, m.timeRequested, m.avatar)),
      ],
    );
  }

  Widget _buildMissedCallTile(String name, String time, String avatar) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3D2D),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24.r,
            backgroundImage: NetworkImage(avatar),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text("Requested: $time", style: const TextStyle(color: Colors.white38, fontSize: 12)),
              ],
            ),
          ),
          CustomButton(
            onPress: () async {},
            title: "Notify I'm Available",
            width: 140,
            height: 32,
            fontSize: 10,
            buttonColor: Colors.white.withAlpha(13),
            borderColor: Colors.transparent,
            radius: 8,
            leadingWidget: const Icon(Icons.notifications_none, color: Colors.amber, size: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildCallBackList(BuildContext context, CoachInboxController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Call Back Request List", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 16.h),
        if (controller.callbacks.isEmpty)
          const Padding(padding: EdgeInsets.only(top: 20), child: Text("No call back requests", style: TextStyle(color: Colors.white54)))
        else
          ...controller.callbacks.map((c) => _buildCallBackTile(context, c.name, c.timeRequested, c.avatar)),
      ],
    );
  }

  Widget _buildCallBackTile(BuildContext context, String name, String time, String avatar) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3D2D),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24.r,
                backgroundImage: NetworkImage(avatar),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(time, style: const TextStyle(color: Colors.white38, fontSize: 12)),
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
                  height: 36,
                  fontSize: 11,
                  buttonColor: Colors.white.withAlpha(13),
                  borderColor: Colors.transparent,
                  radius: 8,
                  leadingWidget: const Icon(Icons.notifications_none, color: Colors.amber, size: 18),
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
                  height: 36,
                  fontSize: 11,
                  linearGradient: true,
                  radius: 8,
                  leadingWidget: const Icon(Icons.call_outlined, color: Colors.white, size: 18),
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
                      ShimmerLoader(width: 52.r, height: 52.r, borderRadius: 26.r),
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
            child: ShimmerLoader(width: double.infinity, height: 48.h, borderRadius: 24.r),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: List.generate(4, (index) => Padding(
                padding: EdgeInsets.only(right: 12.w),
                child: ShimmerLoader(width: 80.w, height: 30.h, borderRadius: 15.r),
              )),
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
                ...List.generate(5, (_) => Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Row(
                    children: [
                      ShimmerLoader(width: 48.r, height: 48.r, borderRadius: 24.r),
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
                          ShimmerLoader(width: 20.r, height: 20.r, borderRadius: 10.r),
                        ],
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
