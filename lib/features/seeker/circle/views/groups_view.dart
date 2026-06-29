import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/background_widget.dart';
import 'create_group_view.dart';
import 'group_details_view.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_input.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_loader.dart';
import '../controllers/group_controller.dart';

class GroupsView extends StatelessWidget {
  const GroupsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Dynamic Fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<GroupController>();
      if (controller.myGroups.isEmpty && !controller.isLoading) {
        controller.fetchGroupsData();
      }
    });

    return DefaultTabController(
      length: 3,
      child: BackgroundWidget(
        imagePath: AppAssets.bgGroup,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.defaultColor,
            // These two lines prevent the color change / tinting when scrolling
            scrolledUnderElevation: 0,
            surfaceTintColor: AppColors.defaultColor,

            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(24.r),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.whiteColor),
              onPressed: () => Navigator.pop(context),
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(AppAssets.group, width: 24.r),
                SizedBox(width: 8.w),
                Text(
                  "Groups",
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            centerTitle: true,
            actions: [
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateGroupView()),
                ),
                child: Text(
                  "Create +",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.secondaryColorLight,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          body: Consumer<GroupController>(
            builder: (context, controller, child) {
              return Column(
                children: [
                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: CustomInput(
                      height: 44,
                      hintText: "Search groups",
                      fontSize: 14,
                      hintColor: AppColors.greyColor,
                      hintStyle: Theme.of(context).textTheme.bodyLarge
                          ?.copyWith(
                            color: AppColors.whiteColor.withAlpha(153),
                            fontSize: 14.sp,
                          ),
                      shadow: true,
                      leadingIcon: AppAssets.search,
                      leadingPadding: EdgeInsets.only(left: 16.w, right: 8.w),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  TabBar(
                    isScrollable: true,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: AppColors.coachColorF2C9A84C,
                        width: .50,
                      ),
                      color: AppColors.buttonColor3,
                    ),
                    labelColor: AppColors.textColor,
                    labelStyle: theme.textTheme.bodyMedium,
                    unselectedLabelStyle: theme.textTheme.bodyMedium,
                    unselectedLabelColor: AppColors.whiteColor.withAlpha(128),
                    dividerColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabAlignment: TabAlignment.start,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    labelPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 0.h,
                    ),
                    tabs: const [
                      Tab(text: "My Groups"),
                      Tab(text: "Find Groups"),
                      Tab(text: "Invitations"),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Expanded(
                    child: controller.isLoading
                        ? ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            itemCount: 3,
                            itemBuilder: (context, index) => Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: ShimmerLoader(
                                width: double.infinity,
                                height: 130.h,
                                borderRadius: 16.r,
                              ),
                            ),
                          )
                        : TabBarView(
                            children: [
                              _buildMyGroupsList(context, controller),
                              _buildFindGroupsList(context, controller),
                              _buildInvitationsList(context, controller),
                            ],
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMyGroupsList(BuildContext context, GroupController controller) {
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () => controller.fetchGroupsData(isRefresh: true),
          color: Colors.transparent,
          backgroundColor: Colors.transparent,
          strokeWidth: 0,
          elevation: 0,
          child: controller.myGroups.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: 100.h),
                    Center(
                      child: Text(
                        "No joined groups found",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.whiteColor.withAlpha(128),
                        ),
                      ),
                    ),
                  ],
                )
              : NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (!controller.isFetchingMoreGroups &&
                        controller.groupsHasMore &&
                        scrollInfo.metrics.pixels >=
                            scrollInfo.metrics.maxScrollExtent - 50) {
                      controller.fetchGroupsData(
                        isFetchMore: true,
                        tab: 'myGroups',
                      );
                    }
                    return false;
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount:
                        controller.myGroups.length +
                        (controller.isFetchingMoreGroups ? 1 : 0),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (index == controller.myGroups.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CustomLoader(size: 40)),
                        );
                      }
                      final group = controller.myGroups[index];
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => GroupDetailsView(groupId: group.id),
                          ),
                        ),
                        child: _GroupCard(
                          type: GroupCardType.myGroup,
                          name: group.name,
                          icon: group.icon,
                          membersCount: group.memberCount,
                          description: group.description,
                          onActionPress: () => controller.leaveGroup(group.id),
                        ),
                      );
                    },
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

  Widget _buildFindGroupsList(
    BuildContext context,
    GroupController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFirstGroupFreeBanner(context),
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'Suggestions',
            style: TextStyle(
              color: const Color(0xFFBBBDB1),
              fontSize: 12,
              fontFamily: 'Segoe UI',
              fontWeight: FontWeight.w400,
              height: 1.33,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Expanded(
          child: Stack(
            children: [
              RefreshIndicator(
                onRefresh: () => controller.fetchGroupsData(isRefresh: true),
                color: Colors.transparent,
                backgroundColor: Colors.transparent,
                strokeWidth: 0,
                elevation: 0,
                child: controller.suggestedGroups.isEmpty
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(height: 100.h),
                          Center(
                            child: Text(
                              "No suggested groups available",
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: AppColors.whiteColor.withAlpha(128),
                                  ),
                            ),
                          ),
                        ],
                      )
                    : NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scrollInfo) {
                          if (!controller.isFetchingMoreSuggestions &&
                              controller.suggestionsHasMore &&
                              scrollInfo.metrics.pixels >=
                                  scrollInfo.metrics.maxScrollExtent - 50) {
                            controller.fetchGroupsData(
                              isFetchMore: true,
                              tab: 'findGroups',
                            );
                          }
                          return false;
                        },
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          itemCount:
                              controller.suggestedGroups.length +
                              (controller.isFetchingMoreSuggestions ? 1 : 0),
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            if (index == controller.suggestedGroups.length) {
                              return Padding(
                                padding: EdgeInsets.all(16.r),
                                child: Center(child: CustomLoader(size: 40)),
                              );
                            }
                            final group = controller.suggestedGroups[index];
                            return _GroupCard(
                              type: GroupCardType.findGroup,
                              name: group.name,
                              icon: group.icon,
                              membersCount: group.memberCount,
                              description: group.description,
                              onActionPress: () =>
                                  controller.joinGroup(group.id),
                            );
                          },
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
          ),
        ),
      ],
    );
  }

  Widget _buildInvitationsList(
    BuildContext context,
    GroupController controller,
  ) {
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () => controller.fetchGroupsData(isRefresh: true),
          color: Colors.transparent,
          backgroundColor: Colors.transparent,
          strokeWidth: 0,
          elevation: 0,
          child: controller.invitations.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: 100.h),
                    Center(
                      child: Text(
                        "No group invitations",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.whiteColor.withAlpha(128),
                        ),
                      ),
                    ),
                  ],
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: controller.invitations.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final invite = controller.invitations[index];
                    return _GroupCard(
                      type: GroupCardType.invitation,
                      name: invite.group.name,
                      icon: invite.group.icon,
                      membersCount: invite.group.memberCount,
                      description:
                          "Invited by ${invite.invitedBy}: ${invite.group.description}",
                      onActionPress: () =>
                          controller.joinGroup(invite.group.id),
                    );
                  },
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

  Widget _buildFirstGroupFreeBanner(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(12.r),
      decoration: ShapeDecoration(
        color: const Color(0xFF1E2D1B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        shadows: [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 24.20,
            offset: Offset(0, 13),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.stars, color: AppColors.secondaryColorLight, size: 32.r),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your first group is free!",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.whiteColor.withAlpha(230),
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
                Text(
                  "Join any free group to get started",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.whiteColor.withAlpha(128),
                    fontSize: 12.sp,
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

enum GroupCardType { myGroup, findGroup, invitation }

class _GroupCard extends StatelessWidget {
  final GroupCardType type;
  final String name;
  final String icon;
  final int membersCount;
  final String description;
  final VoidCallback? onActionPress;

  const _GroupCard({
    required this.type,
    required this.name,
    required this.icon,
    required this.membersCount,
    required this.description,
    this.onActionPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 15),
      decoration: ShapeDecoration(
        color: const Color(0xFF253523),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        shadows: [
          BoxShadow(
            color: Color(0x0F000000),
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
                backgroundImage: NetworkImage(icon),
                backgroundColor: AppColors.whiteColor.withAlpha(26),
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
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                    Text(
                      "$membersCount members",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.whiteColor.withAlpha(128),
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.whiteColor.withAlpha(204),
              fontSize: 12.sp,
              height: 1.4,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              if (type == GroupCardType.myGroup) ...[
                Expanded(
                  child: CustomButton(
                    onPress: () async {
                      if (onActionPress != null) onActionPress!();
                    },
                    title: "Leave",
                    buttonColor: AppColors.whiteColor.withAlpha(13),
                    borderColor: AppColors.whiteColor.withAlpha(26),
                    height: 36,
                    fontSize: 13,
                    radius: 8,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: CustomButton(
                    onPress: () async {},
                    title: "View",
                    buttonColor: AppColors.coachColorA5354C30,
                    borderColor: AppColors.coachColorA5354C30,
                    height: 36,
                    fontSize: 13,
                    radius: 8,
                  ),
                ),
              ] else if (type == GroupCardType.findGroup) ...[
                Expanded(
                  child: CustomButton(
                    onPress: () async {
                      if (onActionPress != null) onActionPress!();
                    },
                    title: "Join Now",
                    height: 44,
                    buttonColor: AppColors.coachColor33434928,
                    borderColor: AppColors.coachColorF2C9A84C,
                    borderWidth: .5,
                    radius: 8,
                  ),
                ),
              ] else if (type == GroupCardType.invitation) ...[
                Expanded(
                  child: CustomButton(
                    onPress: () async {
                      if (onActionPress != null) onActionPress!();
                    },
                    title: "Join Now",
                    linearGradient: true,
                    height: 44,
                    fontSize: 13,
                    borderWidth: .5,
                    radius: 8,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: CustomButton(
                    onPress: () async {},
                    title: "Ignore",
                    buttonColor: AppColors.coachColorA5354C30,
                    borderColor: AppColors.coachColorA5354C30,
                    height: 44,
                    fontSize: 13,
                    borderWidth: .5,
                    radius: 8,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
