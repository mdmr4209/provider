import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../res/assets/image_assets.dart';
import '../../../../res/colors/app_color.dart';
import '../../../../widgets/custom_button.dart';
import '../../../routes/app_router.dart';
import '../providers/profile_provider.dart';
import 'logout.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final count = 2;
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColor,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'My profile',
          style: GoogleFonts.tenorSans(
            color: AppColor.textColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: Center(
              child: Badge(
                alignment: Alignment.topRight,
                label: Text(count.toString()),
                isLabelVisible: count > 0,
                backgroundColor: AppColor.defaultColor,
                child: _headerIcon(ImageAssets.cart, onTap: () {}),
              ),
            ),
          ),
        ],
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profile, _) => SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20.h),
                  Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.all(10.w),
                        width: 100.w,
                        height: 100.h,
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/image/img_3.png"),
                            fit: BoxFit.cover,
                          ),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1.5.w,
                              strokeAlign: BorderSide.strokeAlignOutside,
                              color: AppColor.defaultColor,
                            ),
                            borderRadius: BorderRadius.circular(70.r),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 15.h,
                        right: 0,
                        child: InkWell(
                          onTap: ()=>context.push(AppRoutes.editProfile),
                          child: Container(
                            width: 40.w,
                            height: 40.h,
                            padding: EdgeInsets.all(5.w),
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
                              ImageAssets.edit,
                              colorFilter: ColorFilter.mode(
                                AppColor.defaultColor,
                                BlendMode.srcIn,
                              ),
                              width: 20.w,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Kristin Watson',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.tenorSans(
                      color: AppColor.textColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.20,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'kristinwatson@mail.com',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      color: AppColor.textColor2,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Column(
                    children: [
                      _profileMenuTile(
                        icon: ImageAssets.orderHistory,
                        title: 'Order history',
                        onTap: () => context.push(AppRoutes.orderHistory),
                      ),
                      _profileMenuTile(
                        icon: ImageAssets.paymentMethod,
                        title: 'Payment method',
                        onTap: () => context.push(AppRoutes.paymentMethod),
                      ),
                      _profileMenuTile(
                        icon: ImageAssets.address,
                        title: 'My address',
                        onTap: () => context.push(AppRoutes.address),
                      ),
                      _profileMenuTile(
                        icon: ImageAssets.promoCode,
                        title: 'My promocodes',
                        onTap: () => context.push(AppRoutes.promoCode),
                      ),
                      _profileMenuTile(
                        icon: ImageAssets.trackOrder,
                        title: 'Track my order',
                        onTap: () => context.push(AppRoutes.trackOrder),
                      ),
                      _profileMenuTile(
                        icon: ImageAssets.points,
                        title: 'My Points',
                        onTap: () => context.push(AppRoutes.points),
                      ),
                      _profileMenuTile(
                        icon: ImageAssets.logout,
                        title: 'Sign out',
                        isLogout: true,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => const Logout(),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
        ),
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
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            // Icon Box
            Container(
              width: 50.r,
              height: 50.r,
              decoration: ShapeDecoration(
                color: const Color(0xFFFAF9FF),
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1.w, color: AppColor.whiteTextColor),
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