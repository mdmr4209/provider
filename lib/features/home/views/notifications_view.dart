import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_loader.dart';
import '../controllers/home_controller.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<HomeController>();
      if (controller.notifications.isEmpty && !controller.isLoading) {
        controller.fetchNotifications();
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
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.groups, color: const Color(0xFFC19E5F), size: 24.r),
            SizedBox(width: 8.w),
            Text(
              "Notification",
              style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Consumer<HomeController>(
        builder: (context, controller, child) {
          final notifications = controller.notifications;

          if (controller.isLoading && notifications.isEmpty) {
            return ListView.builder(
              padding: EdgeInsets.all(20.r),
              itemCount: 3,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: ShimmerLoader(
                  width: double.infinity,
                  height: 80.h,
                  borderRadius: 12.r,
                ),
              ),
            );
          }

          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: () => controller.fetchNotifications(isRefresh: true),
                color: Colors.transparent,
                backgroundColor: Colors.transparent,
                strokeWidth: 0,
                elevation: 0,
                child: notifications.isEmpty
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 40.h),
                            child: Center(
                              child: Text(
                                "No notifications yet.",
                                style: TextStyle(color: Colors.white.withAlpha(128)),
                              ),
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.all(20.r),
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          final item = notifications[index];
                          if (item['type'] == 'invitation') {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: _buildInvitationTile(item['message'] ?? ''),
                            );
                          } else {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: _buildPushNotificationCard(
                                item['title'] ?? '',
                                item['message'] ?? '',
                                item['image'] ?? '',
                              ),
                            );
                          }
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
        },
      ),
    );
  }

  Widget _buildInvitationTile(String message) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(13),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: message.split('"')[0],
              style: TextStyle(color: Colors.white.withAlpha(179), fontSize: 13.sp),
            ),
            if (message.contains('"')) ...[
              TextSpan(
                text: '"${message.split('"')[1]}"',
                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: message.split('"')[2],
                style: TextStyle(color: Colors.white.withAlpha(179), fontSize: 13.sp),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPushNotificationCard(String title, String message, String imageUrl) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(13),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12.h),
          Text(
            message,
            style: TextStyle(color: Colors.white.withAlpha(153), fontSize: 13.sp, height: 1.5),
          ),
          if (imageUrl.isNotEmpty) ...[
            SizedBox(height: 20.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 150.h,
                fit: BoxFit.cover,
              ),
            ),
          ],
          SizedBox(height: 24.h),
          CustomButton(
            onPress: () async {},
            title: "Proceed To Pay",
            linearGradient: true,
          ),
        ],
      ),
    );
  }
}
