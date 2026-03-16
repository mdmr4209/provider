import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../res/assets/image_assets.dart';
import '../../../../res/colors/app_color.dart';

class Navbar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const Navbar({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(12),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(0, 'Home', ImageAssets.home),
              _navItem(1, 'Search', ImageAssets.search),
              _navItem(2, 'Cart', ImageAssets.cart),
              _navItem(3, 'Wishlist', ImageAssets.wishlist),
              _navItem(4, 'Profile', ImageAssets.profile),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index, String label, String icon) {
    // Check if this index is the one currently active in GoRouter
    final isSelected = navigationShell.currentIndex == index;

    return GestureDetector(
      onTap: () => navigationShell.goBranch(
        index,
        // If user taps the active tab, it resets the stack to the home of that tab
        initialLocation: index == navigationShell.currentIndex,
      ),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  icon,
                  colorFilter: ColorFilter.mode(
                    isSelected ? AppColor.blackColor : AppColor.textColor2,
                    BlendMode.srcIn,
                  ),
                  width: 24.r,
                  height: 24.r,
                ),
                if (isSelected)
                  Positioned(
                    bottom: -5,
                    child: SvgPicture.asset(
                      ImageAssets.selected, // Your underline/indicator asset
                      width: 30.r,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: GoogleFonts.tenorSans(
                color: isSelected ? AppColor.blackColor : AppColor.textColor2,
                fontSize: 10.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
