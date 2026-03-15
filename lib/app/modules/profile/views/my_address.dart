import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../res/assets/image_assets.dart';
import '../../../../res/colors/app_color.dart';
import '../../../routes/app_router.dart';
import '../providers/profile_provider.dart';

class MyAddress extends StatelessWidget {
  const MyAddress({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 20.r,
            color: AppColor.textColor,
          ),
        ),
        title: Text(
          'My Address',
          style: GoogleFonts.tenorSans(
            color: AppColor.textColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.w400,
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profile, _) => SafeArea(
          // Use ListView as the primary body to handle small screens/overflow
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      SizedBox(height: 30.h),
                      addressItem('Home', '8000 S Kirkland Ave, Chicago...'),
                      SizedBox(height: 8.h),
                      addressItem('Work', '8000 S Kirkland Ave, Chicago...'),
                      SizedBox(height: 8.h),
                      addressItem('Other', '8000 S Kirkland Ave, Chicago...'),
                      SizedBox(height: 8.h),
                      SizedBox(height: 30.h),
                    ],
                  ),
                ),
                Column(
                  children: [
                    InkWell(
                      onTap: () => context.push(AppRoutes.addAddress),
                      child: Container(
                        width: 50.r,
                        height: 50.r,
                        padding: EdgeInsets.all(5.r),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          shadows: [
                            BoxShadow(
                              color: Color(0x26222222),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: SvgPicture.asset(
                          ImageAssets.add,
                          width: 22.w,
                          height: 22.h,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Add a new address',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.tenorSans(
                        color: AppColor.textColor2,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget addressItem(String title, String subtitle) {
    return SizedBox(
      height: 50.h,
      child: Row(
        children: [
          Container(
            width: 50.r,
            height: 50.r,
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: const Color(0xFFFAF9FF),
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1.w, color: AppColor.whiteTextColor),
              ),
            ),
            child: title == 'Home'
                ? Icon(Icons.home_outlined, size: 20.r)
                : title == 'Work'
                ? Icon(Icons.work_outline_rounded, size: 20.r)
                : Icon(Icons.home_outlined, size: 20.r),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.tenorSans(
                    color: AppColor.textColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.20,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.lato(
                    color: AppColor.textColor2,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
              ],
            ),
          ),
          SvgPicture.asset(ImageAssets.edit, width: 16.w, height: 16.h),
        ],
      ),
    );
  }

}
