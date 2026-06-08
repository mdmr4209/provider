import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_input.dart';

class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.r),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Text("Reset Your Password", style: TextStyle(color: Colors.white, fontSize: 24.sp, fontFamily: 'Georgia')),
            SizedBox(height: 60.h),
            _buildLabel("Old Password"),
            const CustomInput(hintText: "Password", backgroundColor: Colors.white10, borderRadius: 12, shadow: false, obscureText: true, leadingIcon: '', prefixIcon: Icons.lock_outline),
            SizedBox(height: 24.h),
            _buildLabel("Password"),
            const CustomInput(hintText: "Confirm Password", backgroundColor: Colors.white10, borderRadius: 12, shadow: false, obscureText: true, leadingIcon: '', prefixIcon: Icons.lock_outline),
            SizedBox(height: 24.h),
            _buildLabel("Confirm Password"),
            const CustomInput(hintText: "Confirm Password", backgroundColor: Colors.white10, borderRadius: 12, shadow: false, obscureText: true, leadingIcon: '', prefixIcon: Icons.lock_outline),
            SizedBox(height: 80.h),
            CustomButton(onPress: () async => Navigator.pop(context), title: "Save Change", linearGradient: true),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h, left: 4.w),
      child: Align(alignment: Alignment.centerLeft, child: Text(text, style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.w500))),
    );
  }
}
