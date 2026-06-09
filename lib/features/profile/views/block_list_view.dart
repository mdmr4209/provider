import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_input.dart';
import '../../../core/widgets/custom_loader.dart';
import '../controllers/profile_controller.dart';

class BlockListView extends StatelessWidget {
  const BlockListView({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<ProfileController>();
      if (controller.blockedUsers.isEmpty && !controller.isLoading) {
        controller.fetchBlockedUsers();
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
          "Block List",
          style: TextStyle(color: Colors.white, fontSize: 18.sp),
        ),
        centerTitle: true,
      ),
      body: Consumer<ProfileController>(
        builder: (context, controller, child) {
          final blocked = controller.blockedUsers;

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.w),
                child: CustomInput(
                  height: 48,
                  hintText: "Search By Name",
                  backgroundColor: Colors.white.withAlpha(13),
                  borderRadius: 24,
                  shadow: false,
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    RefreshIndicator(
                      onRefresh: () => controller.fetchBlockedUsers(isRefresh: true),
                      color: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      strokeWidth: 0,
                      elevation: 0,
                      child: controller.isLoading && blocked.isEmpty
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
                          : blocked.isEmpty
                              ? ListView(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 40.h),
                                      child: Center(
                                        child: Text(
                                          "No blocked users.",
                                          style: TextStyle(color: Colors.white.withAlpha(128)),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : ListView.builder(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                                  itemCount: blocked.length,
                                  itemBuilder: (context, index) {
                                    final user = blocked[index];
                                    return _BlockTile(
                                      id: user['id'],
                                      name: user['name'],
                                      avatar: user['avatar'],
                                      date: user['date'],
                                      onUnblock: () => controller.unblockUser(user['id']),
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
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BlockTile extends StatelessWidget {
  final String id;
  final String name;
  final String avatar;
  final String date;
  final VoidCallback onUnblock;

  const _BlockTile({
    required this.id,
    required this.name,
    required this.avatar,
    required this.date,
    required this.onUnblock,
  });

  @override
  Widget build(BuildContext context) {
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
            backgroundImage: NetworkImage(avatar),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold),
                ),
                Text(
                  date,
                  style: TextStyle(color: Colors.white.withAlpha(128), fontSize: 11.sp),
                ),
              ],
            ),
          ),
          CustomButton(
            onPress: () async => onUnblock(),
            title: "Unblock",
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
