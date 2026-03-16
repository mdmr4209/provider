import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../res/assets/image_assets.dart';
import '../../../../res/colors/app_color.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/input_text_widget.dart';

class CommentReviewView extends StatelessWidget {
  const CommentReviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColor,
        title: Text(
          'Leave A Review',
          textAlign: TextAlign.center,
          style: GoogleFonts.tenorSans(
            color: AppColor.textColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.w400,
            height: 1.20,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 220.h,
                        child: Image.asset(ImageAssets.addReview),
                      ),
                      SizedBox(height: 10.h),
                      SizedBox(
                        width: 303.w,
                        child: Text(
                          'Please rate the quality of service for the order!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.tenorSans(
                            color: AppColor.textColor,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.20,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 4.w,
                        children: [
                          Icon(
                            Icons.star,
                            color: AppColor.ratingColor,
                            size: 40.r,
                          ),
                          Icon(
                            Icons.star,
                            color: AppColor.ratingColor,
                            size: 40.r,
                          ),
                          Icon(
                            Icons.star,
                            color: AppColor.ratingColor,
                            size: 40.r,
                          ),
                          Icon(
                            Icons.star,
                            color: AppColor.ratingColor,
                            size: 40.r,
                          ),
                          Icon(
                            Icons.star,
                            color: AppColor.whiteTextColor,
                            size: 40.r,
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      SizedBox(
                        width: 335.w,
                        child: Text(
                          'Your comments and suggestions help us improve the service quality better!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            color: AppColor.textColor2,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.70,
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      InputTextWidget(
                        maxLines: 10,
                        onChanged: (onChanged) {},
                        height: 130.h,
                        hintText: 'Enter your comment',
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
              CustomButton(onPress: () async {}, title: 'SUBMIT'),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }
}
