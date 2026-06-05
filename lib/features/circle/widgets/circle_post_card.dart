import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_loader.dart';
import '../models/circle_post_model.dart';

class CirclePostCard extends StatefulWidget {
  final CirclePostModel post;

  const CirclePostCard({super.key, required this.post});

  @override
  State<CirclePostCard> createState() => _CirclePostCardState();
}

class _CirclePostCardState extends State<CirclePostCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.postCardColor,
        borderRadius: BorderRadius.circular(8.r),
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
                          color: AppColors.secondaryColorLight.withOpacity(0.3),
                          width: 1.r,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 20.r,
                        backgroundColor: AppColors.whiteColor.withOpacity(0.1),
                        backgroundImage: widget.post.userAvatar.isNotEmpty
                            ? NetworkImage(widget.post.userAvatar)
                            : null,
                        child: widget.post.userAvatar.isEmpty
                            ? Text(
                                widget.post.userName[0],
                                style: TextStyle(fontSize: 14.sp),
                              )
                            : null,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.post.userName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                          Text(
                            widget.post.timeAgo,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.whiteColor.withOpacity(0.6),
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      child: SvgPicture.asset(
                        AppAssets.menu,
                        height: 16.r,
                        width: 16.r,
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Content Text
                Text(
                  widget.post.content,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.whiteColor.withOpacity(0.9),
                    fontSize: 14.sp,
                    height: 1.5,
                  ),
                ),

                // Image/Video Grid
                if (widget.post.images != null &&
                    widget.post.images!.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  _buildImageGrid(widget.post.images!),
                ],

                SizedBox(height: 16.h),

                // Action Buttons Footer: Like, Comment, Share
                Row(
                  children: [
                    _ActionButton(
                      icon: AppAssets.like,
                      count: widget.post.likes,
                      onTap: () {},
                    ),
                    SizedBox(width: 12.w),
                    _ActionButton(
                      icon: AppAssets.comment,
                      count: widget.post.claps,
                      onTap: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {},
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(AppAssets.shareMenu, width: 14.r),
                          SizedBox(width: 8.w),
                          Text(
                            "Share",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // --- Expanded Comments Section ---
          if (_isExpanded)
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: AppColors.commentCardColor,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(12.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back arrow and Comments title
                  InkWell(
                    onTap: () => setState(() => _isExpanded = false),
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          size: 10.sp,
                          color: AppColors.whiteColor.withOpacity(0.8),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          "Comments",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.whiteColor.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Render Comment Items
                  if (widget.post.comments != null)
                    ...widget.post.comments!.map(
                      (comment) => _buildCommentItem(comment, theme),
                    ),
                  Text(
                    "Write comment",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),

                  // Comment Input row
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 31.h,
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                          child: TextField(
                            style: TextStyle(
                              color: AppColors.whiteColor,
                              fontSize: 14.sp,
                            ),
                            decoration: InputDecoration(
                              hintText: "Start typing...",
                              hintStyle: TextStyle(
                                color: AppColors.whiteColor.withOpacity(0.3),
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 8.h,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Container(
                        height: 44.h,
                        width: 44.w,
                        decoration: BoxDecoration(
                          color: AppColors.buttonColor,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            AppAssets.send,
                            width: 20.r,
                            colorFilter: const ColorFilter.mode(
                              AppColors.whiteColor,
                              BlendMode.srcIn,
                            ),
                          ),
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
  }

  Widget _buildImageGrid(List<String> images) {
    if (images.length == 1) {
      return ClipRRect(
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
      );
    }
    return Row(
      children: [
        Expanded(
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
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: const BoxDecoration(
                  color: AppColors.whiteColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.play_arrow,
                  color: AppColors.backgroundColor,
                  size: 20.r,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
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
      ],
    );
  }

  Widget _buildCommentItem(CircleComment comment, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, left: 10.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 23.85.r,
            height: 23.85.r,
            child: CircleAvatar(
              radius: 16.r,
              backgroundImage: NetworkImage(comment.userAvatar),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.postCardColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comment.userName,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    comment.content,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.whiteColor.withOpacity(0.8),
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

  const _ActionButton({
    required this.icon,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 22.r,
            height: 22.r,
            padding: EdgeInsets.all(3.r),
            decoration: BoxDecoration(
              color: AppColors.whiteColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: SvgPicture.asset(
              icon,
              width: 14.r,
              colorFilter: const ColorFilter.mode(
                AppColors.iconColor,
                BlendMode.srcIn,
              ),
            ),
          ),

          SizedBox(width: 8.w),
          Text(
            count.toString(),
            style: TextStyle(color: AppColors.whiteColor, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }
}
