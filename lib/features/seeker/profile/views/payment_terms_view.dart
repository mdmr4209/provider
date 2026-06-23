import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newproject/core/constants/app_colors.dart';

class PaymentTermsView extends StatelessWidget {
  const PaymentTermsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.whiteColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Payment terms",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.whiteColor, fontSize: 18.sp),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.r),
        child: Column(
          children: [
            _buildNumberedText(context, "1.", "Welcome to Ai. By using our services, you agree to abide by the terms and conditions outlined below. These terms govern your access to and"),
            _buildNumberedText(context, "2.", "use of Ai tools and services, so please review them carefully before proceeding."),
            _buildNumberedText(context, "3.", "Ai provides innovative tools designed to enhance how you capture and manage voice recordings. Our services include voice-to-text transcription and AI-driven summarization, which are intended"),
            _buildNumberedText(context, "4.", "for lawful, ethical purposes only. You must ensure compliance with applicable laws, including obtaining consent from all participants when recording conversations. CleverTalk disclaims liability for any misuse of its tools."),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberedText(BuildContext context, String number, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24.w,
            child: Text(
              number,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.whiteColor.withAlpha(179), fontSize: 15.sp),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.whiteColor.withAlpha(179), fontSize: 15.sp, height: 1.8),
            ),
          ),
        ],
      ),
    );
  }
}
