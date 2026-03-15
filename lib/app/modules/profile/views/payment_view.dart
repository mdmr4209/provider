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

class PaymentView extends StatelessWidget {
  const PaymentView({super.key});

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
          'Payment method',
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
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  children: [
                    SizedBox(height: 20.h),
                    _titleHeader('Cards'),
                    SizedBox(height: 10.h),

                    // HORIZONTAL CARD SLIDER
                    SizedBox(
                      height: 200
                          .h, // Explicit height is REQUIRED for horizontal lists
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        clipBehavior:
                            Clip.none, // Allows shadows to show outside bounds
                        children: [
                          _cardItem(ImageAssets.card1),
                          _cardItem(ImageAssets.card2),
                        ],
                      ),
                    ),

                    SizedBox(height: 30.h),
                    methodeItem(true),
                    SizedBox(height: 8.h),
                    methodeItem(true),
                    SizedBox(height: 8.h),
                    methodeItem(false),
                    SizedBox(height: 30.h),
                    // You can add more sections here (e.g., Apple Pay, PayPal)
                  ],
                ),
              ),
              Column(
                children: [
                  InkWell(
                    onTap: () => context.push(AppRoutes.addCard),
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
                    'Add a new card',
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
    );
  }

  Widget methodeItem(bool asset) {
    return Container(
      padding: EdgeInsets.all(10.r),
      height: 60.w,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1.w, color: AppColor.whiteTextColor),
        ),
      ),
      child: Row(
        children: [
          Row(
            children: [
              SizedBox(width: 10.w),
              Text(
                'Pay Method ',
                style: GoogleFonts.tenorSans(
                  color: AppColor.textColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.20,
                ),
              ),
              Text(
                '✔',
                style: GoogleFonts.tenorSans(
                  color: AppColor.greenColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.20,
                ),
              ),
            ],
          ),
          Spacer(),
          IconButton(
            onPressed: () {},
            icon: asset == true
                ? SvgPicture.asset(ImageAssets.edit, width: 16.w, height: 16.h)
                : SvgPicture.asset(ImageAssets.add, width: 22.w, height: 22.h),
          ),
        ],
      ),
    );
  }

  // Helper for Card items to handle scaling and spacing
  Widget _cardItem(String asset) {
    return Padding(
      padding: EdgeInsets.only(right: 15.w),
      child: SvgPicture.asset(asset, width: 300.w, fit: BoxFit.contain),
    );
  }

  Widget _titleHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: GoogleFonts.tenorSans(
            color: AppColor.textColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            letterSpacing: 2,
          ),
        ),
        SizedBox(height: 5.h),
        // Minimalist custom divider
        Divider(thickness: 2.h, color: AppColor.blackColor, height: 10.h),
      ],
    );
  }
}
