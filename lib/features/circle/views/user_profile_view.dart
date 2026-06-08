import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../models/circle_post_model.dart';
import '../widgets/circle_post_card.dart';

enum RelationshipStatus { none, friend, requestSent, requestReceived }

class UserProfileView extends StatefulWidget {
  final String userId;
  final String? userName;
  final String? userAvatar;

  const UserProfileView({
    super.key,
    required this.userId,
    this.userName,
    this.userAvatar,
  });

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  RelationshipStatus _status = RelationshipStatus.none;

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
        title: Text(
          "User Profile",
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontFamily: 'Georgia',
            fontSize: 20.sp,
          ),
        ),
        centerTitle: true,
        actions: [
          _buildMoreMenu(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            // ── Header Section ──────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withAlpha(26)),
                    ),
                    child: CircleAvatar(
                      radius: 45.r,
                      backgroundImage: NetworkImage(
                        widget.userAvatar ?? 'https://i.pravatar.cc/150?u=${widget.userId}',
                      ),
                      backgroundColor: Colors.white.withAlpha(26),
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.userName ?? "Mike Tyson",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Expanded(child: _buildRelationshipButton()),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: CustomButton(
                                onPress: () async {},
                                title: "Message",
                                buttonColor: Colors.white.withAlpha(13),
                                borderColor: Colors.transparent,
                                height: 36,
                                fontSize: 13,
                                radius: 8,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            // ── Stats Section ───────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatItem("07", "Post"),
                  _buildStatDivider(),
                  _buildStatItem("128", "Friends"),
                  _buildStatDivider(),
                  _buildStatItem("220", "Followers"),
                  _buildStatDivider(),
                  _buildStatItem("14", "Following"),
                ],
              ),
            ),
            SizedBox(height: 32.h),
            // ── Bio Section ────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Bio",
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    "Amazon Alexa Shopping is seeking a talented, experienced, and self-directed UX Designer to define and drive the future of shopping at Amazon.",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withAlpha(179),
                      height: 1.5,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            // ── Media Preview ─────────────────────────────────────────────
            SizedBox(
              height: 100.h,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) => Container(
                  width: 100.w,
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    image: const DecorationImage(
                      image: NetworkImage('https://picsum.photos/300/300?random=1'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 32.h),
            // ── Post Feed ────────────────────────────────────────────────
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: 3,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: CirclePostCard(
                  post: CirclePostModel.dummyPosts[index % CirclePostModel.dummyPosts.length],
                ),
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            color: AppColors.secondaryColorLight,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withAlpha(128),
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
      color: Colors.white.withAlpha(26),
    );
  }

  Widget _buildRelationshipButton() {
    String title;
    bool gradient = false;

    switch (_status) {
      case RelationshipStatus.none:
        title = "Add Friend";
        gradient = true;
        break;
      case RelationshipStatus.friend:
        title = "Unfriend";
        gradient = true;
        break;
      case RelationshipStatus.requestSent:
        title = "Request Sent";
        break;
      case RelationshipStatus.requestReceived:
        title = "Accept Request";
        gradient = true;
        break;
    }

    return CustomButton(
      onPress: () async {
        setState(() {
          if (_status == RelationshipStatus.none) {
            _status = RelationshipStatus.requestSent;
          } else if (_status == RelationshipStatus.requestSent) {
            _status = RelationshipStatus.none;
          } else if (_status == RelationshipStatus.requestReceived) {
            _status = RelationshipStatus.friend;
          } else if (_status == RelationshipStatus.friend) {
            _status = RelationshipStatus.none;
          }
        });
      },
      title: title,
      linearGradient: gradient,
      buttonColor: gradient ? AppColors.buttonColor : Colors.white.withAlpha(13),
      borderColor: Colors.transparent,
      height: 36,
      fontSize: 13,
      radius: 8,
    );
  }

  Widget _buildMoreMenu() {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_horiz, color: Colors.white),
      color: AppColors.postCardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      offset: const Offset(0, 45),
      itemBuilder: (context) => [
        _buildPopupItem("Remove Follower", Icons.person_remove_outlined),
        _buildPopupItem("Report", Icons.report_gmailerrorred_outlined),
        _buildPopupItem("Block", Icons.block_outlined),
        _buildPopupItem("Unfollow", Icons.person_off_outlined),
      ],
    );
  }

  PopupMenuItem<String> _buildPopupItem(String title, IconData icon) {
    return PopupMenuItem(
      value: title,
      child: Row(
        children: [
          Icon(icon, color: Colors.white.withAlpha(128), size: 20.r),
          SizedBox(width: 12.w),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}
