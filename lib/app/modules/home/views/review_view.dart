import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newproject/app/routes/app_router.dart';

import '../../../../res/colors/app_color.dart';
import '../../../../widgets/custom_button.dart';

class ReviewView extends StatelessWidget {
  const ReviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColor,
        leading:  IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back_ios_new),
        ),

        title: Text(
          'Reviews',
          textAlign: TextAlign.center,
          style: GoogleFonts.tenorSans(
            color: AppColor.textColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.w400,
            height: 1.20,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 8.h,
                    children: [
                      _reviewCard(),
                      _reviewCard(),
                      _reviewCard(),
                      _reviewCard(),
                      _reviewCard(),
                      _reviewCard(),
                      _reviewCard(),
                    ],
                  ),
                ),
              ),
              CustomButton(onPress: () async {context.push(AppRoutes.commentReview);}, title: '+ ADD REVIEW'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _reviewCard() {
    return Container(
      padding: EdgeInsets.all(20.r), // Standardizing padding
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1.w, color: AppColor.whiteTextColor),
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: 30.r,
                height: 30.r,
                decoration: const BoxDecoration(
                  color: Color(0xFFFCEDEA),
                  shape: BoxShape.circle,
                ),
                // Add child: Image.asset(...) or Text(...) for the avatar content
              ),
              SizedBox(width: 14.w),
              // Name and Date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Annette Black',
                      style: GoogleFonts.tenorSans(
                        color: AppColor.textColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.20,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Jul 23, 2022',
                      style: GoogleFonts.lato(
                        color: AppColor.textColor3,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                    ),
                  ],
                ),
              ),
              // Rating
              Row(
                children: [
                  Icon(
                    Icons.star,
                    size: 14.r,
                    color: const Color(0xFFDD8560), // Theme primary color
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '5.0',
                    style: GoogleFonts.lato(
                      color: AppColor.ratingColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.70,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 15.h),
          // Review Content
          Row(
            children: [
              SizedBox(
                width: 30.r,
                height: 30.r,
                // Add child: Image.asset(...) or Text(...) for the avatar content
              ),
              SizedBox(width: 14.w),
              SizedBox(
                width: 248.w,
                child: Text(
                  'Consequat ut ea dolor aliqua laborum tempor Lorem culpa. Commodo veniam sint est mollit proident commodo.',
                  style: GoogleFonts.lato(
                    color: const Color(0xFF666666),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
