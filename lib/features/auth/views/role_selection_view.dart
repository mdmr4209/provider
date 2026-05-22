import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../routes/app_router.dart';
import '../../../../core/widgets/custom_button.dart';

class RoleSelectionView extends StatelessWidget {
  const RoleSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome! How can we help you?",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 40.h),
              CustomButton(
                title: "I'm here for help",
                onPress: () async {
                  context.push(AppRoutes.nameInput, extra: "Help Seeker");
                },
              ),
              SizedBox(height: 20.h),
              CustomButton(
                title: "I'm a Coach",
                buttonColor: Theme.of(context).colorScheme.secondary,
                onPress: () async {
                  context.push(AppRoutes.nameInput, extra: "Coach");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
