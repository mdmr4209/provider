import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newproject/core/widgets/background_widget.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_input.dart';
import '../../../../core/widgets/custom_button.dart';

class CreateGroupView extends StatelessWidget {
  const CreateGroupView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: BackgroundWidget(
        imagePath: AppAssets.bgMain,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.whiteColor),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              "Create New Group",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.whiteColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFieldTitle(context, "Group Name"),
                CustomInput(hintText: "Enter here", borderRadius: 12, height: 42),
                SizedBox(height: 20.h),
                _buildFieldTitle(context, "Group Logo"),
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: AppColors.coachColorFF21321E,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.coachColorFF334B2F),
                  ),
                  child: Row(
                    children: [
                      CustomButton(
                        onPress: () async {},
                        title: "Upload",
                        width: 80,
                        height: 32,
                        fontSize: 10,
                        buttonColor: AppColors.coachColorFF334B2F,
                        borderColor: Colors.transparent,
                        radius: 4,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        "False Logo.jpeg",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.whiteColor.withAlpha(128),
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                _buildFieldTitle(context, "Group Instruction"),
                CustomInput(
                  hintText: "🪶 Share Your Thoughts",
                  maxLines: 10,
                  borderRadius: 24,
                ),
                const Spacer(),
                CustomButton(
                  onPress: () async {},
                  title: "Create",
                  linearGradient: true,
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.whiteColor.withAlpha(200),
          fontSize: 14.sp,
        ),
      ),
    );
  }
}
