import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../res/assets/image_assets.dart';
import '../../../../res/colors/app_color.dart';
import '../../../../widgets/custom_button.dart';
import '../../../routes/app_router.dart';

class Logout extends StatelessWidget {
  const Logout({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.r)),
      backgroundColor: AppColor.backgroundColor, // Your light red/pink color
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Dialog should fit content
          children: [
            // Image/Illustration
            SizedBox(
              height: 180.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(ImageAssets.bgIcon),
                  Positioned(
                    bottom: 0,
                    child: SvgPicture.asset(ImageAssets.bgLogout),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // Text Message
            Text(
              'Are you sure you want to sign out?',
              textAlign: TextAlign.center,
              style: GoogleFonts.tenorSans(
                color: AppColor.textColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w400,
                height: 1.3,
              ),
            ),
            SizedBox(height: 30.h),

            // Action Buttons
            Row(
              children: [
                // Cancel Button
                Expanded(
                  child: CustomButton(
                    height: 48,
                    onPress: () async {
                      // Call your clear/logout logic
                      // context.read<AuthProvider>().clear();
                      context.go(AppRoutes.login);
                    },
                    textColor: AppColor.textColor,
                    buttonColor: AppColor.whiteColor,
                    title: 'SURE',
                  ),
                ),
                SizedBox(width: 15.w),
                // Logout Button
                Expanded(
                  child: CustomButton(
                    height: 48,
                    onPress: () async {
                      // Call your clear/logout logic
                      // context.read<AuthProvider>().clear();
                      context.pop();
                    },
                    title: 'CANCEL',
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}
