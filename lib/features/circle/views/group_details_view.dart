import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'create_group_post_view.dart';
import 'invite_friends_view.dart';
import 'group_reports_view.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_input.dart';
import '../models/circle_post_model.dart';
import '../widgets/circle_post_card.dart';

class GroupDetailsView extends StatefulWidget {
  final bool isAdmin;
  const GroupDetailsView({super.key, this.isAdmin = false});

  @override
  State<GroupDetailsView> createState() => _GroupDetailsViewState();
}

class _GroupDetailsViewState extends State<GroupDetailsView> {
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
          children: [
            CircleAvatar(
              radius: 18.r,
              backgroundImage: const NetworkImage('https://api.dicebear.com/7.x/avataaars/svg?seed=group'),
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "No Contact Warriors",
                  style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                Text(
                  "1,243 members",
                  style: TextStyle(color: Colors.white.withAlpha(128), fontSize: 11.sp),
                ),
              ],
            ),
          ],
        ),
        actions: [
          _buildMenuButton(),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: CustomInput(
              height: 48,
              hintText: "Share Your Thoughts in the group",
              leadingIcon: AppAssets.feather,
              backgroundColor: Colors.white.withAlpha(13),
              borderRadius: 24,
              shadow: false,
              readOnly: true, // Navigate to create post on tap
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateGroupPostView(groupId: "group_001")),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: CirclePostModel.dummyPosts.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: CirclePostCard(post: CirclePostModel.dummyPosts[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton() {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_horiz, color: Colors.white),
      color: AppColors.postCardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      onSelected: (value) {
        if (value == "Invite Friends") {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const InviteFriendsView()));
        } else if (value == "Report to Platform") {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const GroupReportsView()));
        }
      },
      itemBuilder: (context) {
        if (widget.isAdmin) {
          return [
            _buildMenuItem("Share link", Icons.share_outlined),
            _buildMenuItem("Invite Friends", Icons.person_add_outlined),
            _buildMenuItem("Edit Group", Icons.edit_outlined),
            _buildMenuItem("Report to Platform", Icons.remove_red_eye_outlined),
            _buildMenuItem("Delete Group", Icons.delete_outline, isDestructive: true),
          ];
        } else {
          return [
            _buildMenuItem("Share link", Icons.share_outlined),
            _buildMenuItem("Invite Friends", Icons.person_add_outlined),
            _buildMenuItem("Report to admin", Icons.analytics_outlined),
            _buildMenuItem("Leave Group", Icons.logout_outlined, isDestructive: true),
          ];
        }
      },
    );
  }

  PopupMenuItem<String> _buildMenuItem(String title, IconData icon, {bool isDestructive = false}) {
    return PopupMenuItem(
      value: title,
      child: Row(
        children: [
          Icon(icon, color: isDestructive ? Colors.red : Colors.white.withAlpha(200), size: 20.r),
          SizedBox(width: 12.w),
          Text(
            title,
            style: TextStyle(color: isDestructive ? Colors.red : Colors.white.withAlpha(200), fontSize: 14.sp),
          ),
        ],
      ),
    );
  }
}
