import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../res/assets/image_assets.dart';
import '../../../../res/colors/app_color.dart';
import '../controllers/splash_controller.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize SplashController
    Get.put(SplashController());

    return Scaffold(
      backgroundColor: AppColor.textAreaColor,
      body: GetBuilder<SplashController>(
        builder: (controller) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: FadeTransition(
                opacity: controller.fadeAnimation,
                child: Image.asset(ImageAssets.splash),
              ),
            ),
            Text(
              'stay connected \nFor your perfect match',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColor.textColor,
                fontSize: 18.sp,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                height: 1.20,
                letterSpacing: 0.90,
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}