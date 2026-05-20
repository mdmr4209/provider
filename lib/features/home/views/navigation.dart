import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../localization/localization_extension.dart';

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
          color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
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
              _navItem(context, 0, context.watchTr('home'), AppAssets.home),
              _navItem(context, 1, context.watchTr('search'), AppAssets.search),
              _navItem(context, 2, context.watchTr('cart'), AppAssets.cart),
              _navItem(context, 3, context.watchTr('wishlist'), AppAssets.wishlist),
              _navItem(context, 4, context.watchTr('profile'), AppAssets.profile),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(BuildContext context, int index, String label, String icon) {
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
                    isSelected 
                        ? (Theme.of(context).bottomNavigationBarTheme.selectedIconTheme?.color ?? Theme.of(context).colorScheme.primary)
                        : (Theme.of(context).bottomNavigationBarTheme.unselectedIconTheme?.color ?? Colors.grey),
                    BlendMode.srcIn,
                  ),
                  width: 24.r,
                  height: 24.r,
                ),
                if (isSelected)
                  Positioned(
                    bottom: -5,
                    child: SvgPicture.asset(
                      AppAssets.selected, // Your underline/indicator asset
                      width: 30.r,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: (isSelected
                      ? Theme.of(context).bottomNavigationBarTheme.selectedLabelStyle
                      : Theme.of(context).bottomNavigationBarTheme.unselectedLabelStyle)
                  ?.copyWith(
                color: isSelected
                    ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor
                    : Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
