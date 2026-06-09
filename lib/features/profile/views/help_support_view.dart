import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';

class HelpSupportView extends StatelessWidget {
  const HelpSupportView({super.key});

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
          "Help and Support",
          style: TextStyle(color: Colors.white, fontSize: 18.sp),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Instructions",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              "1. Welcome to Ai. By using our services, you agree to abide by the terms and conditions outlined below. These terms govern your access to and\n2. use of Ai tools and services, so please review them carefully before proceeding.\n3. Ai provides innovative tools designed to enhance how you capture and manage voice recordings. Our services include voice-to-text transcription and AI-driven summarization, which are intended\n4. for lawful, ethical purposes only. You must ensure compliance with applicable laws, including obtaining consent from all participants when recording conversations. CleverTalk disclaims liability for any misuse of its tools.",
              style: TextStyle(
                color: Colors.white.withAlpha(179),
                fontSize: 14.sp,
                height: 2.0,
              ),
            ),
            SizedBox(height: 40.h),
            Text(
              "Admin Email for support",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "sajibahhamed@gmail.com",
              style: TextStyle(
                color: Colors.white.withAlpha(179),
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 24.h),
            CustomButton(
              onPress: () async {
                // Handle email logic
              },
              title: "Email Us",
              trailingWidget: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_forward, color: Colors.white, size: 16.r),
                  const VerticalDivider(color: Colors.white24, width: 20),
                ],
              ),
              leadingWidget: Icon(
                Icons.email_outlined,
                color: Colors.white,
                size: 20.r,
              ),
              buttonColor: Colors.white.withAlpha(13),
              borderColor: Colors.white.withAlpha(26),
              radius: 12.r,
            ),
          ],
        ),
      ),
    );
  }
}
