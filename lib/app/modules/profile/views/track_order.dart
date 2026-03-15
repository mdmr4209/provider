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

class TrackOrder extends StatelessWidget {
  const TrackOrder({super.key});

  @override
  Widget build(BuildContext context) {
    final count = 2;
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        backgroundColor: AppColor.backgroundColor,
        elevation: 0,
        centerTitle: true,
        title:  Text(
          'Track Your Order',
          textAlign: TextAlign.center,
          style: GoogleFonts.tenorSans(
            color: AppColor.textColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.w400,
            height: 1.20,
          ),
        ),
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profile, _) => SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 349.50.h,
                    child: Image.asset(ImageAssets.addReview),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Your order:',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColor.textColor,
                      fontSize: 20,
                      fontFamily: 'Tenor Sans',
                      fontWeight: FontWeight.w400,
                      height: 1.20,
                    ),
                  ),
                  SizedBox(height: 4.h),Text(
                    '#205479',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColor.textColor2,
                      fontSize: 16,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      height: 1.70,
                    ),
                  ),
                  SizedBox(height: 10.h),_orderTrackingTimeline(),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _orderTrackingTimeline() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _trackingStep(
          title: 'Order Placed',
          subtitle: 'Your order has been placed',
          time: '9:45 AM',
          isCompleted: true,
          isLast: false,
        ),
        _trackingStep(
          title: 'Pending',
          subtitle: 'Our store is reviewing your order',
          time: '10:15 AM',
          isCompleted: true,
          isLast: false,
        ),
        _trackingStep(
          title: 'On it’s way',
          subtitle: 'Our delivery man is on the way to you',
          time: '11:00 AM',
          isCompleted: false, // Active status
          isLast: false,
          isActive: true,
        ),
        _trackingStep(
          title: 'Delivered',
          subtitle: 'Order has been delivered',
          time: '',
          isCompleted: false,
          isLast: true,
        ),
      ],
    );
  }

  Widget _trackingStep({
    required String title,
    required String subtitle,
    required String time,
    bool isCompleted = false,
    bool isActive = false,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        children: [
          // Left Side: Dot and Line
          Column(
            children: [
              // Indicator Dot
              Container(
                width: 16.r,
                height: 16.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted || isActive
                      ? AppColor.defaultColor
                      : const Color(0xFFEEEEEE),
                  border: isActive
                      ? Border.all(color: AppColor.defaultColor.withOpacity(0.3), width: 4.r)
                      : null,
                ),
                child: isCompleted
                    ? Icon(Icons.check, size: 10.r, color: Colors.white)
                    : null,
              ),
              // Connecting Line
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2.w,
                    color: isCompleted ? AppColor.defaultColor : const Color(0xFFEEEEEE),
                  ),
                ),
            ],
          ),
          SizedBox(width: 15.w),
          // Right Side: Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 25.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.tenorSans(
                          color: AppColor.textColor,
                          fontSize: 16.sp,
                          fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                        ),
                      ),
                      if (time.isNotEmpty)
                        Text(
                          time,
                          style: GoogleFonts.lato(
                            color: AppColor.textColor3,
                            fontSize: 14.sp,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.lato(
                      color: const Color(0xFF666666),
                      fontSize: 13.sp,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  // Reusable Menu Tile Widget
  Widget _profileMenuTile({
    required String icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
        child: Row(
          children: [
            // Icon Box
            Container(
              width: 50.r,
              height: 50.r,
              decoration: ShapeDecoration(
                color: const Color(0xFFFAF9FF),
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1.w, color: const Color(0xFFEEEEEE)),
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: Center(
                child: SvgPicture.asset(
                  icon,
                  width: 20.r,
                  height: 20.r,
                  // Flavor: turn logout icon red if desired
                  colorFilter: isLogout
                      ? const ColorFilter.mode(
                    Colors.redAccent,
                    BlendMode.srcIn,
                  )
                      : ColorFilter.mode(AppColor.textColor, BlendMode.srcIn),
                ),
              ),
            ),
            SizedBox(width: 15.w),
            // Title
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.tenorSans(
                  color: isLogout ? Colors.redAccent : const Color(0xFF222222),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            // Arrow Icon
            if (!isLogout)
              Icon(
                Icons.arrow_forward_ios,
                size: 16.r,
                color: const Color(0xFF999999),
              ),
          ],
        ),
      ),
    );
  }

  Widget _headerIcon(String asset, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: SvgPicture.asset(
        asset,
        width: 24.w,
        height: 24.h,
        colorFilter: ColorFilter.mode(AppColor.blackColor, BlendMode.srcIn),
      ),
    );
  }
}
