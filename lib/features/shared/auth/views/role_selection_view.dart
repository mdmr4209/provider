import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:newproject/core/constants/app_assets.dart';
import 'package:newproject/core/constants/app_colors.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/background_widget.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../routes/app_router.dart';
import '../controllers/auth_controller.dart';

class RoleSelectionView extends StatelessWidget {
  const RoleSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      imagePath: 'assets/images/bg.png',
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 130.r,
                  width: 130.r,
                  child: Image.asset(AppAssets.logo),
                ),
                SizedBox(height: 10.h),
                Text(
                  "\"You are not in this alone.\"",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 40.h),
                CustomButton(
                  linearGradient: true,
                  title: "I'm here for help",
                  onPress: () async {
                    context.read<AuthController>().setSelectedRole(
                      "Help Seeker",
                    );
                    context.push(AppRoutes.nameInput, extra: "Help Seeker");
                  },
                ),
                SizedBox(height: 20.h),
                CustomButton(
                  title: "I'm a Coach",
                  buttonColor: AppColors.buttonColor3,
                  onPress: () async {
                    context.read<AuthController>().setSelectedRole("Coach");
                    context.push(AppRoutes.coachWelcome);
                  },
                ),
                SizedBox(height: 20.h),
                Text(
                  "STRONGER BY ONE",
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.borderColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
