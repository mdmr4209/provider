import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newproject/core/constants/app_assets.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';

class PaymentSuccessView extends StatelessWidget {
  const PaymentSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 80.h),
              Image.asset(AppAssets.paySuccess),
              // Container(
              //   height: 250.h,
              //   width: double.infinity,
              //   decoration: const BoxDecoration(
              //     image: DecorationImage(
              //       image: ,
              //       fit: BoxFit.contain,
              //     ),
              //   ),
              // ),
              SizedBox(height: 40.h),
              Text(
                "Payment Successful",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.whiteColor,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                "Please Check Your Notification, We Just Sent You A Message.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.whiteColor.withAlpha(128),
                  fontSize: 14.sp,
                ),
              ),
              const Spacer(),
              CustomButton(
                onPress: () async =>
                    Navigator.of(context).popUntil((route) => route.isFirst),
                title: "Got it",
                linearGradient: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
