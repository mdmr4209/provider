import 'find_friends_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_input.dart';
import '../../../core/widgets/custom_button.dart';
import 'user_profile_view.dart';

class FriendsView extends StatefulWidget {
  const FriendsView({super.key});

  @override
  State<FriendsView> createState() => _FriendsViewState();
}

class _FriendsViewState extends State<FriendsView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
              AppAssets.group, // Assuming using similar icon as design shows hands shaking/groups
              width: 28.r,
              colorFilter: const ColorFilter.mode(AppColors.secondaryColorLight, BlendMode.srcIn),
            ),
            SizedBox(width: 10.w),
            Text(
              "Friends",
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
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
                  MaterialPageRoute(builder: (_) => const FindFriendsView()),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(13),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    children: [
                      Text("Add", style: TextStyle(color: Colors.white.withAlpha(204), fontSize: 13.sp)),
                      SizedBox(width: 4.w),
                      Icon(Icons.add, color: AppColors.secondaryColorLight, size: 16.r),
                    ],
                  ),
                ),
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
              hintText: _getSearchHint(),
              leadingIcon: '', // Search logic inside
              backgroundColor: Colors.white.withAlpha(13),
              borderRadius: 24,
              shadow: false,
            ),
          ),
          SizedBox(height: 16.h),
          TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorColor: AppColors.secondaryColorLight,
            labelColor: AppColors.secondaryColorLight,
            unselectedLabelColor: Colors.white.withAlpha(128),
            dividerColor: Colors.white.withAlpha(13),
            tabAlignment: TabAlignment.start,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            labelPadding: EdgeInsets.only(right: 24.w),
            onTap: (index) => setState(() {}),
            tabs: const [
              Tab(text: "Friends"),
              Tab(text: "Friend Request"),
              Tab(text: "Followers"),
              Tab(text: "Following"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFriendsList(),
                _buildRequestsList(),
                _buildFollowersList(),
                _buildFollowingList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getSearchHint() {
    switch (_tabController.index) {
      case 1: return "Search Request";
      case 2: return "Search Follower";
      case 3: return "Search Following";
      default: return "Search Friends";
    }
  }

  Widget _buildFriendsList() {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: 10,
      itemBuilder: (context, index) => _SocialTile(type: SocialTileType.friend),
    );
  }

  Widget _buildRequestsList() {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: 8,
      itemBuilder: (context, index) => _SocialTile(type: SocialTileType.request),
    );
  }

  Widget _buildFollowersList() {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: 12,
      itemBuilder: (context, index) => _SocialTile(type: SocialTileType.follower),
    );
  }

  Widget _buildFollowingList() {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: 15,
      itemBuilder: (context, index) => _SocialTile(type: SocialTileType.following),
    );
  }
}

enum SocialTileType { friend, request, follower, following }

class _SocialTile extends StatelessWidget {
  final SocialTileType type;
  const _SocialTile({required this.type});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => UserProfileView(
            userId: type == SocialTileType.request ? "u2" : "u1",
            userName: type == SocialTileType.request ? "Mike Lee" : "Miles Esther",
          ),
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: AppColors.postCardColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.white.withAlpha(13)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24.r,
              backgroundImage: const NetworkImage('https://i.pravatar.cc/150?u=social'),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type == SocialTileType.request ? "Mike Lee" : "Miles Esther",
                    style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _getSubTitle(),
                    style: TextStyle(color: Colors.white.withAlpha(128), fontSize: 12.sp),
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
      case SocialTileType.request: return "2 mutual Friend";
      default: return "Online";
    }
  }

  Widget _buildTrailingAction(BuildContext context) {
    switch (type) {
      case SocialTileType.friend:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("09:30 PM", style: TextStyle(color: Colors.white.withAlpha(102), fontSize: 11.sp)),
            SizedBox(height: 4.h),
            CircleAvatar(radius: 8.r, backgroundColor: Colors.green, child: Text("2", style: TextStyle(color: Colors.white, fontSize: 10.sp))),
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
              fontSize: 12,
              linearGradient: true,
              radius: 8,
            ),
            SizedBox(width: 8.w),
            CustomButton(
              onPress: () async {},
              title: "Decline",
              width: 80,
              height: 32,
              fontSize: 12,
              buttonColor: Colors.white.withAlpha(13),
              borderColor: Colors.transparent,
              radius: 8,
            ),
          ],
        );
      case SocialTileType.follower:
        return CustomButton(
          onPress: () async {},
          title: "Remove Follower",
          width: 120,
          height: 32,
          fontSize: 12,
          buttonColor: Colors.white.withAlpha(13),
          borderColor: Colors.transparent,
          radius: 8,
        );
      case SocialTileType.following:
        return CustomButton(
          onPress: () async {},
          title: "Unfollow",
          width: 100,
          height: 32,
          fontSize: 12,
          buttonColor: Colors.white.withAlpha(13),
          borderColor: Colors.transparent,
          radius: 8,
        );
    }
  }
}
