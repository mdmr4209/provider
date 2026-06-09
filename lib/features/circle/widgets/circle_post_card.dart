import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../views/user_profile_view.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/design_system.dart';
import '../../../core/widgets/custom_input.dart';
import '../../../core/widgets/custom_loader.dart';
import '../../../core/widgets/full_screen_image_viewer.dart';
import '../models/circle_post_model.dart';

class CirclePostCard extends StatelessWidget {
  final CirclePostModel post;
  final ValueNotifier<bool> _isExpanded = ValueNotifier<bool>(false);

  CirclePostCard({super.key, required this.post});

  void _showPostMenu(
    BuildContext context,
    Offset offset,
    bool isOwnPost,
    AppDesignSystem designSystem,
  ) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Dismiss",
      barrierColor: Colors.black.withValues(alpha: 0.1),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Stack(
          children: [
            Positioned(
              top: offset.dy - 28,
              right: 25.w,
              child: Material(
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Triangle Pointer
                    Padding(
                      padding: EdgeInsets.only(right: 12.w),
                      child: CustomPaint(
                        size: Size(15.w, 10.h),
                        painter: _TrianglePainter(
                          color: AppColors.commentCardColor,
                        ),
                      ),
                    ),
                    Container(
                      width: 180.w,
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      decoration: BoxDecoration(
                        color: AppColors.commentCardColor,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [designSystem.deepShadow],
                      ),
                      child: Column(
                        children: [
                          _buildMenuItem(
                            context,
                            icon: AppAssets.shareMenu,
                            label: "Share link",
                            onTap: () => Navigator.pop(context),
                          ),
                          if (isOwnPost) ...[
                            _buildMenuItem(
                              context,
                              icon: AppAssets.edit,
                              label: "Edit",
                              onTap: () => Navigator.pop(context),
                            ),
                            _buildMenuItem(
                              context,
                              icon: AppAssets.delete,
                              label: "Delete Post",
                              isDestructive: true,
                              onTap: () => Navigator.pop(context),
                            ),
                          ] else ...[
                            _buildMenuItem(
                              context,
                              icon: AppAssets.reportMenu,
                              label: "Report to admin",
                              onTap: () => Navigator.pop(context),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        child: Row(
          children: [
            icon.endsWith("png")
                ? Image.asset(
                    icon,
                    width: 16.r,
                    color: isDestructive
                        ? AppColors.redAlphaColor
                        : AppColors.greyColor,
                  )
                : SvgPicture.asset(
                    icon,
                    width: 16.r,
                    colorFilter: ColorFilter.mode(
                      isDestructive
                          ? AppColors.redAlphaColor
                          : AppColors.greyColor,
                      BlendMode.srcIn,
                    ),
                  ),
            SizedBox(width: 12.w),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isDestructive
                    ? AppColors.redAlphaColor
                    : AppColors.whiteColor,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final designSystem = theme.extension<AppDesignSystem>()!;

    return ValueListenableBuilder<bool>(
      valueListenable: _isExpanded,
      builder: (context, isExpanded, child) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.postCardColor.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [designSystem.softShadow],
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.05),
              width: 0.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Main Post Content Section ---
              Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header: Avatar, Name, Time, More
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primaryColor.withValues(alpha: 0.3),
                              width: 1.r,
                            ),
                          ),
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    UserProfileView(userId: post.id),
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 20.r,
                              backgroundColor: Colors.white.withValues(alpha: 0.1),
                              backgroundImage: post.userAvatar.isNotEmpty
                                  ? NetworkImage(post.userAvatar)
                                  : null,
                              child: post.userAvatar.isEmpty
                                  ? Text(
                                      post.userName[0],
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.white,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    UserProfileView(userId: post.id),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  post.userName,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.sp,
                                  ),
                                ),
                                Text(
                                  post.timeAgo,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.6),
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTapDown: (details) {
                            _showPostMenu(
                              context,
                              details.globalPosition,
                              post.isOwnPost,
                              designSystem,
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.all(4.r),
                            child: SvgPicture.asset(AppAssets.menu, width: 16.r),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    // Content Text
                    Text(
                      post.content,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14.sp,
                        height: 1.4,
                      ),
                    ),

                    // Image/Video Grid
                    if (post.images != null &&
                        post.images!.isNotEmpty) ...[
                      SizedBox(height: 12.h),
                      _buildImageGrid(context, post.images!, theme, designSystem),
                    ],

                    SizedBox(height: 16.h),

                    // Action Buttons Footer: Like, Comment, Share
                    Row(
                      children: [
                        _ActionButton(
                          icon: AppAssets.like,
                          count: post.likes,
                          onTap: () {},
                          theme: theme,
                          designSystem: designSystem,
                        ),
                        SizedBox(width: 12.w),
                        _ActionButton(
                          icon: AppAssets.comment,
                          count: post.claps,
                          onTap: () {
                            _isExpanded.value = !_isExpanded.value;
                          },
                          theme: theme,
                          designSystem: designSystem,
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(12.r),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            child: Row(
                              children: [
                                Image.asset(AppAssets.shareMenu, width: 16.r),
                                SizedBox(width: 6.w),
                                Text(
                                  "Share",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // --- Expanded Comments Section ---
              if (isExpanded)
                Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: AppColors.commentCardColor.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(16.r),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back arrow and Comments title
                      InkWell(
                        onTap: () => _isExpanded.value = false,
                        child: Row(
                          children: [
                            Icon(
                              Icons.keyboard_arrow_down,
                              size: 18.sp,
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              "Comments",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.h),

                      // Render Comment Items
                      if (post.comments != null)
                        ...post.comments!.map(
                          (comment) => _buildCommentItem(comment, theme),
                        ),

                      SizedBox(height: 12.h),

                      // Comment Input row
                      Row(
                        children: [
                          Expanded(
                            child: CustomInput(
                              height: 31,
                              hintText: "Start typing...",
                              fontSize: 11,
                              shadow: true,
                              contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Center(
                            child: SvgPicture.asset(
                              AppAssets.send,
                              height: 32.h,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageGrid(
    BuildContext context,
    List<String> images,
    ThemeData theme,
    AppDesignSystem designSystem,
  ) {
    if (images.length == 1) {
      return GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FullScreenImageViewer(imageUrl: images[0]),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Image.network(
            images[0],
            width: double.infinity,
            height: 200.h,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return ShimmerLoader(
                width: double.infinity,
                height: 200.h,
                borderRadius: 12.r,
              );
            },
            errorBuilder: (context, error, stackTrace) =>
                ShimmerLoader(height: 200.h, borderRadius: 12.r),
          ),
        ),
      );
    }
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FullScreenImageViewer(imageUrl: images[0]),
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.network(
                    images[0],
                    height: 180.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return ShimmerLoader(
                        width: double.infinity,
                        height: 180.h,
                        borderRadius: 12.r,
                      );
                    },
                    errorBuilder: (context, error, stackTrace) =>
                        ShimmerLoader(height: 180.h, borderRadius: 12.r),
                  ),
                ),
                SizedBox(
                  width: 28.r,
                  height: 28.r,
                  child: SvgPicture.asset(AppAssets.play),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FullScreenImageViewer(
                  imageUrl: images.length > 1 ? images[1] : images[0],
                ),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.network(
                images.length > 1 ? images[1] : images[0],
                height: 180.h,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return ShimmerLoader(
                    width: double.infinity,
                    height: 180.h,
                    borderRadius: 12.r,
                  );
                },
                errorBuilder: (context, error, stackTrace) =>
                    ShimmerLoader(height: 180.h, borderRadius: 12.r),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCommentItem(CircleComment comment, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12.r,
            backgroundImage: NetworkImage(comment.userAvatar),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comment.userName,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    comment.content,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String icon;
  final int count;
  final VoidCallback onTap;
  final ThemeData theme;
  final AppDesignSystem designSystem;

  const _ActionButton({
    required this.icon,
    required this.count,
    required this.onTap,
    required this.theme,
    required this.designSystem,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: SvgPicture.asset(icon, width: 14.r),
          ),
          SizedBox(width: 8.w),
          Text(
            count.toString(),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;

  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
