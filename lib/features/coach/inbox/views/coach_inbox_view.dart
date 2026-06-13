import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

class CoachInboxView extends StatefulWidget {
  const CoachInboxView({super.key});

  @override
  State<CoachInboxView> createState() => _CoachInboxViewState();
}

class _CoachInboxViewState extends State<CoachInboxView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedContext = 0; // 0: Clients, 1: Friends

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CoachInboxController>().fetchInboxData();
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
    final controller = context.watch<CoachInboxController>();

    return BackgroundWidget(
      imagePath: AppAssets.bgHome,
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
                    _buildContextToggle(),
                    const Spacer(),
                    _buildCreditsBadge(controller.credits),
                  ],
                ),
              ),

              Expanded(
                child: controller.isLoading
                    ? const Center(child: ShimmerLoader())
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
                                    controller: _tabController,
                                    isScrollable: true,
                                    indicatorColor: Colors.transparent,
                                    dividerColor: Colors.transparent,
                                    tabAlignment: TabAlignment.start,
                                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                                    labelPadding: EdgeInsets.only(right: 12.w),
                                    onTap: (index) => setState(() {}),
                                    tabs: [
                                      _buildTab("Messages", 0),
                                      _buildTab("Missed call", 1),
                                      _buildTab("Call Back", 2),
                                      _buildTab("Clients", 3),
                                    ],
                                  ),

                                  SizedBox(height: 16.h),

                                  // ── Content Area ────────────────────────────────────────────
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                                    child: _buildTabContent(controller),
                                  ),
                                  
                                  SizedBox(height: 20.h),
                                ],
                              ),
                            ),
                          ),
                          if (controller.isRefreshing)
                            Positioned.fill(
                              child: const Center(child: CustomLoader()),
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

  Widget _buildContextToggle() {
    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(26),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleItem("Clients", 0),
          _buildToggleItem("Friends", 1),
        ],
      ),
    );
  }

  Widget _buildToggleItem(String label, int index) {
    final isSelected = _selectedContext == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedContext = index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF334B2F) : Colors.transparent,
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

  Widget _buildTab(String label, int index) {
    final isSelected = _tabController.index == index;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF334B2F) : Colors.transparent,
        border: Border.all(color: isSelected ? Colors.transparent : Colors.white10),
        borderRadius: BorderRadius.circular(20.r),
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

  Widget _buildTabContent(CoachInboxController controller) {
    switch (_tabController.index) {
      case 0: return _buildMessagesList(controller);
      case 1: return _buildMissedCallsList(controller);
      case 2: return _buildCallBackList(controller);
      case 3: return _buildClientsList(controller);
      default: return const SizedBox();
    }
  }

  Widget _buildMessagesList(CoachInboxController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Chats List", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 16.h),
        if (controller.messages.isEmpty)
          const Padding(padding: EdgeInsets.only(top: 20), child: Text("No messages", style: TextStyle(color: Colors.white54)))
        else
          ...controller.messages.map((msg) => _buildChatTile(msg.name, msg.isOnline ? "Online" : "Offline", msg.time, msg.unreadCount.toString(), msg.avatar)),
      ],
    );
  }

  Widget _buildClientsList(CoachInboxController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("My Clients", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 16.h),
        if (controller.clients.isEmpty)
          const Padding(padding: EdgeInsets.only(top: 20), child: Text("No clients", style: TextStyle(color: Colors.white54)))
        else
          ...controller.clients.map((c) => _buildChatTile(c.name, c.status, c.time, c.unreadCount, c.avatar)),
      ],
    );
  }

  Widget _buildChatTile(String name, String status, String time, String count, String avatar) {
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

  Widget _buildCallBackList(CoachInboxController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Call Back Request List", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 16.h),
        if (controller.callbacks.isEmpty)
          const Padding(padding: EdgeInsets.only(top: 20), child: Text("No call back requests", style: TextStyle(color: Colors.white54)))
        else
          ...controller.callbacks.map((c) => _buildCallBackTile(c.name, c.timeRequested, c.avatar)),
      ],
    );
  }

  Widget _buildCallBackTile(String name, String time, String avatar) {
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
}
