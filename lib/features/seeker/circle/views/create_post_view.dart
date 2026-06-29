import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/full_screen_image_viewer.dart';
import '../controllers/circle_controller.dart';

class CreatePostView extends StatelessWidget {
  const CreatePostView({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<CircleController>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.whiteColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Create Public Post",
          style: theme.textTheme.titleLarge?.copyWith(
            color: AppColors.whiteColor,
            fontFamily: 'Georgia',
            fontSize: 20.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── User Info ──────────────────────────────────────────
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primaryColor.withAlpha(77),
                              width: 1.5.r,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 24.r,
                            backgroundImage: const NetworkImage(
                              "https://xsgames.co/randomusers/assets/avatars/male/5.jpg",
                            ),
                            backgroundColor: AppColors.whiteColor.withAlpha(26),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          "joshua_l",
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    // ── Input Box ─────────────────────────────────────────
                    Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor.withAlpha(13),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: AppColors.whiteColor.withAlpha(20),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                AppAssets.feather,
                                width: 20.r,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.greyColor,
                                  BlendMode.srcIn,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: TextField(
                                  controller: controller.postTextController,
                                  maxLines: 8,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: AppColors.whiteColor),
                                  decoration: InputDecoration(
                                    hintText: "Share Your Thoughts",
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: AppColors.whiteColor.withAlpha(
                                            128,
                                          ),
                                        ),
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    fillColor: Colors.transparent,
                                    contentPadding: EdgeInsets.only(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Video icon — pick video from device
                              IconButton(
                                icon: SvgPicture.asset(
                                  AppAssets.video,
                                  width: 24.r,
                                ),
                                onPressed: () =>
                                    controller.pickMedia(isVideo: true),
                              ),
                              // Image icon — pick image from device
                              IconButton(
                                icon: SvgPicture.asset(
                                  AppAssets.image,
                                  width: 24.r,
                                ),
                                onPressed: () =>
                                    controller.pickMedia(isVideo: false),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                    // ── Media Preview Grid ────────────────────────────────
                    if (controller.selectedMedia.isNotEmpty)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12.w,
                          mainAxisSpacing: 12.h,
                          childAspectRatio: 1,
                        ),
                        itemCount: controller.selectedMedia.length,
                        itemBuilder: (context, index) {
                          final file = controller.selectedMedia[index];
                          final isVideo =
                              file.path.toLowerCase().endsWith('.mp4') ||
                              file.path.toLowerCase().endsWith('.mov') ||
                              file.path.toLowerCase().endsWith('.avi');
                          return Stack(
                            children: [
                              // ── Tappable Image → Full Screen ────────
                              GestureDetector(
                                onTap: () {
                                  if (!isVideo) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => FullScreenImageViewer(
                                          imageUrl: file.path,
                                          isLocalFile: true,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Hero(
                                  tag: 'create_post_image_$index',
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: Border.all(
                                        color: AppColors.whiteColor.withAlpha(
                                          26,
                                        ),
                                      ),
                                      image: isVideo
                                          ? null
                                          : DecorationImage(
                                              image: FileImage(File(file.path)),
                                              fit: BoxFit.cover,
                                            ),
                                      color: AppColors.black26Color,
                                    ),
                                    child: isVideo
                                        ? Center(
                                            child: SvgPicture.asset(
                                              AppAssets.play,
                                              width: 40.r,
                                            ),
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                              // ── Remove Button ──────────────────────
                              Positioned(
                                top: 6,
                                right: 6,
                                child: GestureDetector(
                                  onTap: () => controller.removeMedia(index),
                                  child: Container(
                                    padding: EdgeInsets.all(4.r),
                                    decoration: BoxDecoration(
                                      color: AppColors.blackColor.withAlpha(
                                        153,
                                      ),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.whiteColor.withAlpha(
                                          51,
                                        ),
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      size: 16.r,
                                      color: AppColors.whiteColor,
                                    ),
                                  ),
                                ),
                              ),
                              // ── Expand Indicator ───────────────────
                              if (!isVideo)
                                Positioned(
                                  bottom: 6,
                                  right: 6,
                                  child: Container(
                                    padding: EdgeInsets.all(4.r),
                                    decoration: BoxDecoration(
                                      color: AppColors.blackColor.withAlpha(
                                        128,
                                      ),
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    child: Icon(
                                      Icons.fullscreen_rounded,
                                      size: 16.r,
                                      color: AppColors.whiteColor.withAlpha(
                                        204,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
            // ── Post Button ──────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.all(20.r),
              child: CustomButton(
                title: "Post Now",
                linearGradient: true,
                loading: controller.isLoading,
                onPress: () async {
                  final success = await controller.createPost();
                  if (success && context.mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
