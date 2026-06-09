import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_input.dart';

class ResetPasswordView extends StatelessWidget {
  final ValueNotifier<bool> _oldPassVisible = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _passVisible = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _confirmPassVisible = ValueNotifier<bool>(false);

  ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                "Reset Your Password",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontFamily: 'Georgia',
                ),
              ),
            ),
            SizedBox(height: 60.h),
            _buildLabel("Old Password"),
            ValueListenableBuilder<bool>(
              valueListenable: _oldPassVisible,
              builder: (context, visible, _) {
                return CustomInput(
                  hintText: "Password",
                  backgroundColor: Colors.white10,
                  borderRadius: 12,
                  shadow: false,
                  obscureText: !visible,
                  trailingWidget: IconButton(
                    icon: Icon(
                      visible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white.withAlpha(51),
                    ),
                    onPressed: () => _oldPassVisible.value = !_oldPassVisible.value,
                  ),
                  leadingWidget: const Icon(
                    Icons.lock_outline,
                    color: Colors.amber,
                    size: 20,
                  ),
                );
              },
            ),
            SizedBox(height: 24.h),
            _buildLabel("Password"),
            ValueListenableBuilder<bool>(
              valueListenable: _passVisible,
              builder: (context, visible, _) {
                return CustomInput(
                  hintText: "Confirm Password",
                  backgroundColor: Colors.white10,
                  borderRadius: 12,
                  shadow: false,
                  obscureText: !visible,
                  trailingWidget: IconButton(
                    icon: Icon(
                      visible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white.withAlpha(51),
                    ),
                    onPressed: () => _passVisible.value = !_passVisible.value,
                  ),
                  leadingWidget: const Icon(
                    Icons.lock_outline,
                    color: Colors.amber,
                    size: 20,
                  ),
                );
              },
            ),
            SizedBox(height: 24.h),
            _buildLabel("Confirm Password"),
            ValueListenableBuilder<bool>(
              valueListenable: _confirmPassVisible,
              builder: (context, visible, _) {
                return CustomInput(
                  hintText: "Confirm Password",
                  backgroundColor: Colors.white10,
                  borderRadius: 12,
                  shadow: false,
                  obscureText: !visible,
                  trailingWidget: IconButton(
                    icon: Icon(
                      visible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white.withAlpha(51),
                    ),
                    onPressed: () => _confirmPassVisible.value = !_confirmPassVisible.value,
                  ),
                  leadingWidget: const Icon(
                    Icons.lock_outline,
                    color: Colors.amber,
                    size: 20,
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h, left: 4.w),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
