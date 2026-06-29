import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_input.dart';

class EditView extends StatelessWidget {
  const EditView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.whiteColor),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.r),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60.r,
                    backgroundImage: const NetworkImage(
                      'https://i.pravatar.cc/300?u=me',
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 18.r,
                      backgroundColor: AppColors.defaultColorLight,
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: AppColors.whiteColor,
                        size: 20.r,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              "Profile Photo",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.whiteColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Tap to change your photo",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.whiteColor.withAlpha(128),
                fontSize: 13.sp,
              ),
            ),
            SizedBox(height: 40.h),
            _buildLabel(context, "Full Name"),
            const CustomInput(
              hintText: "Rahim Rehman",
              borderRadius: 12,
              shadow: false,
            ),
            SizedBox(height: 14.h),
            _buildLabel(context, "Bio"),
            const CustomInput(
              hintText: "Healing Journey Day 14",
              borderRadius: 12,
              shadow: false,
              height: 120,
              maxLines: 5,
            ),
            SizedBox(height: 60.h),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(20.r),
        child: CustomButton(
          onPress: () async {
            Navigator.pop(context);
          },
          title: "Save Change",
          linearGradient: true,
        ),
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h, left: 4.w),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.whiteColor,
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
