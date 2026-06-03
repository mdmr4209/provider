import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_loader.dart';
import '../controllers/circle_controller.dart';

class CircleMemberList extends StatelessWidget {
  const CircleMemberList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Consumer<CircleController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return SizedBox(
            height: 100.h,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: Column(
                  children: [
                    ShimmerLoader(
                      width: 60.r,
                      height: 60.r,
                      borderRadius: 30.r,
                    ),
                    SizedBox(height: 8.h),
                    ShimmerLoader(
                      width: 45.w,
                      height: 10.h,
                      borderRadius: 4.r,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return SizedBox(
          height: 100.h,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            scrollDirection: Axis.horizontal,
            itemCount: controller.members.length,
            itemBuilder: (context, index) {
              final member = controller.members[index];
              final bool isFirst = index == 0;
              
              return Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.r),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isFirst ? AppColors.secondaryColorLight : Colors.transparent,
                          width: 2.r,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 28.r,
                        backgroundColor: AppColors.whiteColor.withOpacity(0.1),
                        backgroundImage: member.avatar.isNotEmpty 
                            ? NetworkImage(member.avatar) 
                            : null,
                        child: member.avatar.isEmpty
                            ? Text(
                                member.name[0],
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: AppColors.secondaryColorLight,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      member.name,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.whiteColor.withOpacity(0.6),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
