import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newproject/features/coach/bid_board/views/payment_success_view.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../profile/views/payment_terms_view.dart';
import '../controllers/coach_controller.dart';

class PaymentView extends StatelessWidget {
  final CoachController controller;
  final String slot;

  const PaymentView({super.key, required this.controller, required this.slot});

  @override
  Widget build(BuildContext context) {
    final agreed = ValueNotifier<bool>(false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.whiteColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Payment View",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.whiteColor,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.r),
        child: Column(
          children: [
            SizedBox(height: 60.h),
            ValueListenableBuilder<bool>(
              valueListenable: agreed,
              builder: (context, currentAgreed, _) {
                return Container(
                  padding: EdgeInsets.all(20.r),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(20.r),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor.withAlpha(13),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Willing To Pay Now?",
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: AppColors.whiteColor,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              "Please Check Your Terms, Before Moving Forward to payment.",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: AppColors.whiteColor.withAlpha(128),
                                    fontSize: 12.sp,
                                  ),
                            ),
                            SizedBox(height: 16.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Checkbox(
                                  value: currentAgreed,
                                  onChanged: (v) => agreed.value = v!,
                                  activeColor: AppColors.amberColor,
                                  checkColor: AppColors.blackColor,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Agree to ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: AppColors.whiteColor
                                                .withAlpha(179),
                                          ),
                                    ),
                                    InkWell(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const PaymentTermsView(),
                                        ),
                                      ),
                                      child: Text(
                                        "Payment Terms",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: AppColors.amberColor,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      CustomButton(
                        onPress: currentAgreed
                            ? () async {
                                final success = await controller.bookSession(
                                  slot,
                                );
                                if (success && context.mounted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const PaymentSuccessView(),
                                    ),
                                  );
                                }
                              }
                            : null,
                        title: "Continue to Pay",
                        linearGradient: currentAgreed,
                        buttonColor: currentAgreed
                            ? AppColors.buttonColor
                            : AppColors.white10Color,
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 60.h),
          ],
        ),
      ),
    );
  }
}
