import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_input.dart';

class PaymentView extends StatelessWidget {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.west, color: Color(0xFF5E7958), size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Payment Details",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Georgia',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("Card Holder Name"),
            CustomInput(
              height: 42,
              hintText: "Write Card Holder Name",
              fontSize: 12,
              hintColor: AppColors.greyColor,
              hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.whiteColor.withAlpha(153),
                fontSize: 12,
              ),
              shadow: true,
              shadowColor: Color(0xFF2E4429),
              backgroundColor: Color(0xFF21321E),
              borderRadius: 8,
              borderWidth: 0.50,
              borderColor: Color(0xFF334B2F),
            ),
            SizedBox(height: 24.h),
            _buildLabel("Card Number"),
            CustomInput(
              height: 42,
              hintText: "Write Card Number",
              fontSize: 12,
              hintColor: AppColors.greyColor,
              hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.whiteColor.withAlpha(153),
                fontSize: 12,
              ),
              shadow: true,
              shadowColor: Color(0xFF2E4429),
              backgroundColor: Color(0xFF21321E),
              borderRadius: 8,
              borderWidth: 0.50,
              borderColor: Color(0xFF334B2F),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("MM/YY"),
                      CustomInput(
                        height: 42,
                        hintText: "exp. 12/24",
                        fontSize: 12,
                        hintColor: AppColors.greyColor,
                        hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.whiteColor.withAlpha(153),
                          fontSize: 12,
                        ),
                        shadow: true,
                        shadowColor: Color(0xFF2E4429),
                        backgroundColor: Color(0xFF21321E),
                        borderRadius: 8,
                        borderWidth: 0.50,
                        borderColor: Color(0xFF334B2F),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("CVC"),
                      CustomInput(
                        height: 42,
                        hintText: "*****",
                        fontSize: 12,
                        hintColor: AppColors.greyColor,
                        hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.whiteColor.withAlpha(153),
                          fontSize: 12,
                        ),
                        shadow: true,
                        shadowColor: Color(0xFF2E4429),
                        backgroundColor: Color(0xFF21321E),
                        borderRadius: 8,
                        borderWidth: 0.50,
                        borderColor: Color(0xFF334B2F),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 60.h),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(20.r),
        child: CustomButton(
          onPress: () async {
            Navigator.pop(context);
          },
          title: "Save Payment Method",
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
