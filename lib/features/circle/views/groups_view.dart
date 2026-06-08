import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'create_group_view.dart';
import 'group_details_view.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_input.dart';
import '../../../core/widgets/custom_button.dart';

class GroupsView extends StatefulWidget {
  const GroupsView({super.key});

  @override
  State<GroupsView> createState() => _GroupsViewState();
}

class _GroupsViewState extends State<GroupsView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              AppAssets.group,
              width: 24.r,
              colorFilter: const ColorFilter.mode(AppColors.secondaryColorLight, BlendMode.srcIn),
            ),
            SizedBox(width: 8.w),
            Text(
              "Groups",
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
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
              style: TextStyle(
                color: AppColors.secondaryColorLight,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: CustomInput(
              height: 48,
              hintText: "Search groups",
              leadingIcon: AppAssets.feather, // Using feather as search icon fallback
              backgroundColor: Colors.white.withAlpha(13),
              borderRadius: 24,
              shadow: false,
            ),
          ),
          SizedBox(height: 16.h),
          TabBar(
            controller: _tabController,
            isScrollable: true,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: AppColors.secondaryColorLight, width: 1),
              color: AppColors.whiteColor.withAlpha(13),
            ),
            labelColor: AppColors.secondaryColorLight,
            unselectedLabelColor: AppColors.whiteColor.withAlpha(128),
            dividerColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize.tab,
            tabAlignment: TabAlignment.start,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            labelPadding: EdgeInsets.symmetric(horizontal: 16.w),
            tabs: const [
              Tab(text: "My Groups"),
              Tab(text: "Find Groups"),
              Tab(text: "Invitations"),
            ],
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMyGroupsList(),
                _buildFindGroupsList(),
                _buildInvitationsList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyGroupsList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: 3,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const GroupDetailsView(isAdmin: true)),
        ),
        child: const _GroupCard(
          type: GroupCardType.myGroup,
        ),
      ),
    );
  }

  Widget _buildFindGroupsList() {
    return Column(
      children: [
        _buildFirstGroupFreeBanner(),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: 3,
            itemBuilder: (context, index) => const _GroupCard(
              type: GroupCardType.findGroup,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInvitationsList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: 2,
      itemBuilder: (context, index) => const _GroupCard(
        type: GroupCardType.invitation,
      ),
    );
  }

  Widget _buildFirstGroupFreeBanner() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.whiteColor.withAlpha(13),
        borderRadius: BorderRadius.circular(12.r),
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
                  style: TextStyle(
                    color: Colors.white.withAlpha(230),
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
                Text(
                  "Join any free group to get started",
                  style: TextStyle(
                    color: Colors.white.withAlpha(128),
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
  const _GroupCard({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.postCardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withAlpha(13)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48.r,
                height: 48.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withAlpha(26),
                ),
                child: const Center(child: Icon(Icons.groups, color: Colors.white)),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "No Contact Warriors",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                    Text(
                      "1,243 members",
                      style: TextStyle(
                        color: Colors.white.withAlpha(128),
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
            "Day 14 of No Contact. It was really hard today today, I almost texted him when I saw his favorite song playing. But I stayed strong!",
            style: TextStyle(
              color: Colors.white.withAlpha(204),
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
                    onPress: () async {},
                    title: "Leave",
                    buttonColor: Colors.transparent,
                    borderColor: Colors.white.withAlpha(26),
                    height: 36,
                    fontSize: 13,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: CustomButton(
                    onPress: () async {},
                    title: "View",
                    buttonColor: Colors.white.withAlpha(13),
                    borderColor: Colors.white.withAlpha(26),
                    height: 36,
                    fontSize: 13,
                  ),
                ),
              ] else if (type == GroupCardType.findGroup) ...[
                Expanded(
                  child: CustomButton(
                    onPress: () async => _showUnlockPremium(context),
                    title: "Join Now",
                    buttonColor: Colors.transparent,
                    borderColor: AppColors.secondaryColorLight.withAlpha(128),
                    height: 36,
                    fontSize: 13,
                    textColor: AppColors.secondaryColorLight,
                  ),
                ),
              ] else if (type == GroupCardType.invitation) ...[
                Expanded(
                  child: CustomButton(
                    onPress: () async {},
                    title: "Join Now",
                    linearGradient: true,
                    height: 36,
                    fontSize: 13,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: CustomButton(
                    onPress: () async {},
                    title: "Ignore",
                    buttonColor: Colors.white.withAlpha(13),
                    borderColor: Colors.white.withAlpha(26),
                    height: 36,
                    fontSize: 13,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  void _showUnlockPremium(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const _UnlockPremiumSheet(),
    );
  }
}

class _UnlockPremiumSheet extends StatelessWidget {
  const _UnlockPremiumSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(26),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 24.h),
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.secondaryColorLight),
            ),
            child: Icon(Icons.lock_outline, color: AppColors.secondaryColorLight, size: 32.r),
          ),
          SizedBox(height: 16.h),
          Text(
            "Unlock More Groups",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            "Join unlimited groups, connect with more people, and access exclusive communities with Premium.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withAlpha(153),
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 24.h),
          _buildFeatureRow(Icons.check_circle_outline, "Join unlimited Circle groups"),
          _buildFeatureRow(Icons.check_circle_outline, "Direct message other users"),
          _buildFeatureRow(Icons.check_circle_outline, "Access exclusive content and resources"),
          SizedBox(height: 32.h),
          CustomButton(
            onPress: () async {},
            title: "Upgrade Now",
            linearGradient: true,
          ),
          SizedBox(height: 12.h),
          CustomButton(
            onPress: () async => Navigator.pop(context),
            title: "Later",
            buttonColor: Colors.transparent,
            borderColor: Colors.transparent,
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Icon(icon, color: Colors.green, size: 20.r),
          SizedBox(width: 12.w),
          Text(
            text,
            style: TextStyle(color: Colors.white.withAlpha(204), fontSize: 14.sp),
          ),
        ],
      ),
    );
  }
}
