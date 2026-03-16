import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../res/colors/app_color.dart';

class OnboardingContent extends StatelessWidget {
  final String title;
  final String description;

  const OnboardingContent({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Spacer(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.tenorSans(
                  color: AppColor.textColor,
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.07,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                description,
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  color: AppColor.textColor2,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.22,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
