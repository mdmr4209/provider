import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_input.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_loader.dart';
import '../controllers/group_controller.dart';

class InviteFriendsView extends StatelessWidget {
  const InviteFriendsView({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<GroupController>();
      if (controller.friendsToInvite.isEmpty && !controller.isLoading) {
        controller.fetchFriendsToInvite();
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Invite to Group",
          style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Consumer<GroupController>(
        builder: (context, controller, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16.w),
                child: CustomInput(
                  height: 48,
                  hintText: "Search Friends",
                  leadingIcon: '',
                  backgroundColor: Colors.white.withAlpha(13),
                  borderRadius: 24,
                  shadow: false,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Text(
                  "Suggestions",
                  style: TextStyle(color: Colors.white.withAlpha(128), fontSize: 13.sp),
                ),
              ),
              Expanded(
                child: controller.isLoading
                    ? ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        itemCount: 3,
                        itemBuilder: (context, index) => Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: ShimmerLoader(
                            width: double.infinity,
                            height: 56.h,
                            borderRadius: 12.r,
                          ),
                        ),
                      )
                    : Stack(
                        children: [
                          RefreshIndicator(
                            onRefresh: () => controller.fetchFriendsToInvite(isRefresh: true),
                            color: Colors.transparent,
                            backgroundColor: Colors.transparent,
                            strokeWidth: 0,
                            elevation: 0,
                            child: controller.friendsToInvite.isEmpty
                                ? ListView(
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    children: [
                                      SizedBox(height: 100.h),
                                      Center(
                                        child: Text(
                                          "No friends available to invite.",
                                          style: TextStyle(color: Colors.white.withAlpha(128)),
                                        ),
                                      ),
                                    ],
                                  )
                                : ListView.builder(
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                                    itemCount: controller.friendsToInvite.length,
                                    itemBuilder: (context, index) {
                                      final friend = controller.friendsToInvite[index];
                                      return _InviteTile(friend: friend);
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
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _InviteTile extends StatelessWidget {
  final Map<String, String> friend;

  const _InviteTile({required this.friend});

  @override
  Widget build(BuildContext context) {
    final name = friend['name'] ?? '';
    final avatar = friend['avatar'] ?? '';
    final id = friend['id'] ?? '';

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.postCardColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20.r,
            backgroundImage: NetworkImage(avatar.isNotEmpty ? avatar : 'https://i.pravatar.cc/150?u=$id'),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              name,
              style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w500),
            ),
          ),
          CustomButton(
            onPress: () async {},
            title: "Invite",
            width: 80,
            height: 32,
            fontSize: 12,
            buttonColor: Colors.white.withAlpha(13),
            borderColor: Colors.transparent,
            radius: 8,
          ),
        ],
      ),
    );
  }
}

