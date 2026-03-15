import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../res/colors/app_color.dart';
import '../../../../res/assets/image_assets.dart'; // Ensure SVG paths are here
import '../../add/views/add_view.dart';
import '../../buddies/views/buddies_view.dart';
import '../../map/views/map_view.dart';
import '../../profile/views/profile_view.dart';
import '../providers/home_provider.dart';
import 'home_view.dart';
import 'search_view.dart';
import 'wishlist_view.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeView(),
      const SearchView(),
      const AddView(),
      const WishlistView(),
      const ProfileView(),
    ];

    return Consumer<HomeProvider>(
      builder: (context, home, _) {
        return Scaffold(
          // IndexedStack prevents screens from re-initializing when switching tabs
          body: IndexedStack(index: home.currentIndex, children: pages),
          bottomNavigationBar: Container(
            height: 80.h,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(
                    0,
                    home,
                    'Home',
                    ImageAssets.home,
                  ), // Or ImageAssets.homeSvg
                  _navItem(1, home, 'Map', ImageAssets.search),
                  _navItem(2, home, 'Add', ImageAssets.cart),
                  _navItem(3, home, 'Buddies', ImageAssets.wishlist),
                  _navItem(4, home, 'Profile', ImageAssets.profile),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _navItem(
    int index,
    HomeProvider home,
    String label,
    String fallbackIcon,
  ) {
    final isSelected = home.currentIndex == index;
    return GestureDetector(
      onTap: () => home.setIndex(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Example of using SVG. Replace 'ImageAssets.example' with your actual SVG paths.
            // SvgPicture.asset(
            //   isSelected ? ImageAssets.activeIcon : ImageAssets.inactiveIcon,
            //   colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            //   height: 24.h,
            // ),
            Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  fallbackIcon,
                  color: AppColor.blackColor,
                  width: 24.r,
                  height: 24.r,
                ), // Temporary fallback
                if (isSelected)
                  SvgPicture.asset(
                    ImageAssets.selected,
                    width: 30.r,
                    height: 25.85.r,
                  ),
              ],
            ),
            // Temporary fallback
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                color: AppColor.textColor2,
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
