import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../routes/app_router.dart';
import '../../localization/localization_extension.dart';

class Logout extends StatelessWidget {
  const Logout({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.r)),
      backgroundColor: Theme.of(
        context,
      ).colorScheme.surface, // Your light red/pink color
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
                  Image.asset(AppAssets.bgIcon),
                  Positioned(
                    bottom: 0,
                    child: SvgPicture.asset(AppAssets.bgLogout),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // Text Message
            Text(
              context.watchTr('sign_out_confirm'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
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
                    textColor: Theme.of(context).colorScheme.onSurface,
                    buttonColor: Theme.of(context).colorScheme.surface,
                    title: context.watchTr('sure'),
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
                    title: context.watchTr('cancel'),
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
