import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../routes/app_router.dart';
import '../controllers/profile_controller.dart';
import 'logout.dart';
import '../../localization/localization_extension.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final count = 2;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          context.watchTr('my_profile'),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: Center(
              child: Badge(
                alignment: Alignment.bottomLeft,
                label: Text(
                  count.toString(),
                  style: TextStyle(fontSize: 10.sp),
                ),
                isLabelVisible: count > 0,
                backgroundColor: AppColors.defaultColor,
                offset: Offset(-5.w, -10.h),
                child: _headerIcon(AppAssets.cart, onTap: () {}),
              ),
            ),
          ),
        ],
      ),
      body: Consumer<ProfileController>(
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
                              color: AppColors.defaultColor,
                            ),
                            borderRadius: BorderRadius.circular(70.r),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 15.h,
                        right: 0,
                        child: InkWell(
                          onTap: () => context.push(AppRoutes.editProfile),
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
                              AppAssets.edit,
                              colorFilter: ColorFilter.mode(
                                AppColors.defaultColor,
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
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'kristinwatson@mail.com',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 10.h),
                  Column(
                    children: [
                      _profileMenuTile(
                        context,
                        icon: AppAssets.orderHistory,
                        title: context.watchTr('order_history'),
                        onTap: () => context.push(AppRoutes.orderHistory),
                      ),
                      _profileMenuTile(
                        context,
                        icon: AppAssets.paymentMethod,
                        title: context.watchTr('payment_method'),
                        onTap: () => context.push(AppRoutes.paymentMethod),
                      ),
                      _profileMenuTile(
                        context,
                        icon: AppAssets.address,
                        title: context.watchTr('my_address'),
                        onTap: () => context.push(AppRoutes.address),
                      ),
                      _profileMenuTile(
                        context,
                        icon: AppAssets.promoCode,
                        title: context.watchTr('my_promocodes'),
                        onTap: () => context.push(AppRoutes.promoCode),
                      ),
                      _profileMenuTile(
                        context,
                        icon: AppAssets.trackOrder,
                        title: context.watchTr('track_my_order'),
                        onTap: () => context.push(AppRoutes.trackOrder),
                      ),
                      _profileMenuTile(
                        context,
                        icon: AppAssets.points,
                        title: context.watchTr('my_points'),
                        onTap: () => context.push(AppRoutes.points),
                      ),
                      _profileMenuTile(
                        context,
                        icon: AppAssets.settings,
                        title: context.watchTr('settings'),
                        onTap: () => context.push(AppRoutes.settings),
                      ),
                      _profileMenuTile(
                        context,
                        icon: AppAssets.logout,
                        title: context.watchTr('sign_out'),
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
  Widget _profileMenuTile(
    BuildContext context, {
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
                color: Theme.of(context).colorScheme.surface,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1.w,
                    color: Theme.of(context).dividerColor,
                  ),
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
                      : ColorFilter.mode(
                          Theme.of(context).iconTheme.color!,
                          BlendMode.srcIn,
                        ),
                ),
              ),
            ),
            SizedBox(width: 15.w),
            // Title
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isLogout
                      ? Colors.redAccent
                      : Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
            // Arrow Icon
            if (!isLogout)
              Icon(
                Icons.arrow_forward_ios,
                size: 16.r,
                color: Theme.of(context).iconTheme.color?.withAlpha(127),
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
        colorFilter: ColorFilter.mode(AppColors.blackColor, BlendMode.srcIn),
      ),
    );
  }
}
