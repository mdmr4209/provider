import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/full_screen_image_viewer.dart';
import '../controllers/group_post_controller.dart';

class CreateGroupPostView extends StatelessWidget {
  final String groupId;
  const CreateGroupPostView({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return ChangeNotifierProvider(
      create: (_) => GroupPostController(),
      child: Consumer<GroupPostController>(
        builder: (context, controller, child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                "Create Post",
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
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
                          // ── User / Anonymous Header ──────────────────────
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
                                  backgroundImage: NetworkImage(
                                    controller.isAnonymous
                                        ? "https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y"
                                        : "https://xsgames.co/randomusers/assets/avatars/male/5.jpg",
                                  ),
                                  backgroundColor: Colors.white.withAlpha(26),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Text(
                                  controller.isAnonymous ? "nomyously1234" : "joshua_l",
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Transform.scale(
                                scale: 0.9,
                                child: Checkbox(
                                  value: controller.isAnonymous,
                                  onChanged: controller.toggleAnonymous,
                                  activeColor: AppColors.secondaryColorLight,
                                  checkColor: Colors.black,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
                                  side: const BorderSide(color: Colors.white),
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.groups, color: Colors.white.withAlpha(128), size: 18.r),
                                  SizedBox(width: 4.w),
                                  Text(
                                    "Annomyously",
                                    style: TextStyle(color: Colors.white.withAlpha(128), fontSize: 13.sp),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),
                          // ── Input Box ──────────────────────────────────────
                          Container(
                            padding: EdgeInsets.all(16.r),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(13),
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(color: Colors.white.withAlpha(20)),
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
                                    Expanded(
                                      child: TextField(
                                        controller: controller.postTextController,
                                        maxLines: 8,
                                        style: const TextStyle(color: Colors.white),
                                        decoration: InputDecoration(
                                          hintText: "Share Your Thoughts",
                                          hintStyle: TextStyle(
                                            color: Colors.white.withAlpha(128),
                                          ),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.only(left: 5.w),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: SvgPicture.asset(AppAssets.video, width: 24.r),
                                      onPressed: () => controller.pickMedia(isVideo: true),
                                    ),
                                    IconButton(
                                      icon: SvgPicture.asset(AppAssets.image, width: 24.r),
                                      onPressed: () => controller.pickMedia(isVideo: false),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24.h),
                          // ── Media Preview ──────────────────────────────────
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
                                final isVideo = file.path.toLowerCase().endsWith('.mp4');
                                return Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12.r),
                                      child: isVideo 
                                        ? Container(color: Colors.black, child: const Center(child: Icon(Icons.play_circle_fill, color: Colors.white, size: 40)))
                                        : Image.file(File(file.path), fit: BoxFit.cover, width: double.infinity, height: double.infinity),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: GestureDetector(
                                        onTap: () => controller.removeMedia(index),
                                        child: CircleAvatar(radius: 12.r, backgroundColor: Colors.black54, child: Icon(Icons.close, size: 16.r, color: Colors.white)),
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
                  Padding(
                    padding: EdgeInsets.all(20.r),
                    child: CustomButton(
                      onPress: () async {
                        final success = await controller.createGroupPost(groupId);
                        if (success && context.mounted) Navigator.pop(context);
                      },
                      title: "Post Now",
                      linearGradient: true,
                      loading: controller.isLoading,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
