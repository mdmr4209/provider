import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newproject/core/widgets/glass_widget.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_input.dart';

class ResetPasswordView extends StatelessWidget {
  final ValueNotifier<bool> _oldPassVisible = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _passVisible = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _confirmPassVisible = ValueNotifier<bool>(false);

  ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.west,
            color: AppColors.coachColorFF5E7958,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Center(
              child: Text(
                'Reset Your Password',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.coachColorFFF5F0E8,
                  fontSize: 22,
                  fontFamily: 'Georgia',
                  fontWeight: FontWeight.w400,
                  height: 1.30,
                ),
              ),
            ),
            SizedBox(height: 60.h),
            _buildLabel(context, "Old Password"),
            ValueListenableBuilder<bool>(
              valueListenable: _oldPassVisible,
              builder: (context, visible, _) {
                return GlassWidget(
                  height: 45,
                  child: CustomInput(
                    hintText: "Password",
                    backgroundColor: AppColors.backgroundColor,
                    borderRadius: 12,
                    height: 43,
                    shadow: false,
                    obscureText: true,
                  ),
                );
              },
            ),
            SizedBox(height: 24.h),
            _buildLabel(context, "Password"),
            ValueListenableBuilder<bool>(
              valueListenable: _passVisible,
              builder: (context, visible, _) {
                return GlassWidget(
                  height: 45,
                  child: CustomInput(
                    hintText: "Confirm Password",
                    backgroundColor: AppColors.backgroundColor,
                    borderRadius: 12,
                    height: 43,
                    shadow: false,
                    obscureText: true,
                  ),
                );
              },
            ),
            SizedBox(height: 24.h),
            _buildLabel(context, "Confirm Password"),
            ValueListenableBuilder<bool>(
              valueListenable: _confirmPassVisible,
              builder: (context, visible, _) {
                return GlassWidget(
                  height: 45,
                  child: CustomInput(
                    hintText: "Confirm Password",
                    backgroundColor: AppColors.backgroundColor,
                    borderRadius: 12,
                    height: 43,
                    shadow: false,
                    obscureText: true,
                  ),
                );
              },
            ),
            SizedBox(height: 80.h),
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
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.whiteColor,
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
