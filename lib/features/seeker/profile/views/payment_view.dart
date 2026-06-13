import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Payment Details",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
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
            const CustomInput(
              hintText: "Prabal Pratap Singh",
              backgroundColor: Colors.white10,
              borderRadius: 12,
              shadow: false,
            ),
            SizedBox(height: 24.h),
            _buildLabel("Card Number"),
            const CustomInput(
              hintText: "5296 7820 4820 9637",
              backgroundColor: Colors.white10,
              borderRadius: 12,
              shadow: false,
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("MM/YY"),
                      const CustomInput(
                        hintText: "12/24",
                        backgroundColor: Colors.white10,
                        borderRadius: 12,
                        shadow: false,
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
                      const CustomInput(
                        hintText: "****",
                        backgroundColor: Colors.white10,
                        borderRadius: 12,
                        shadow: false,
                        obscureText: true,
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
