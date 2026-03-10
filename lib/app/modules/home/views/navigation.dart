
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../../../res/colors/app_color.dart';
import '../../add/views/add_view.dart';
import '../../auth/providers/auth_controller.dart';
import '../../buddies/views/buddies_view.dart';
import '../../map/views/map_view.dart';
import '../../profile/views/profile_view.dart';
import '../controllers/home_controller.dart';
import 'home_view.dart';

class Navbar extends GetView<HomeController> {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    debugPrint("Your role is ${authController.selectedRole.value}");
    final String role = authController.selectedRole.value;

    final pages = [
      const HomeView(),
      MapView(),
      AddView(),
      BuddiesView(),
      ProfileView(),
    ];

    return Scaffold(
      body: Obx(() => pages[controller.currentIndex.value]),
      bottomNavigationBar: Obx(
            () => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: GNav(
              gap: 8,
              backgroundColor: Colors.white,
              color: AppColor.textColor,
              activeColor: AppColor.defaultColor,
              tabBackgroundColor: AppColor.containerColor3,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              selectedIndex: controller.currentIndex.value,
              onTabChange: (index) => controller.currentIndex.value = index,
              tabs: [
                GButton(
                  icon: Icons.home_rounded,
                  text: 'Home',
                  iconActiveColor: AppColor.defaultColor,
                  textColor: AppColor.defaultColor,
                ),
                GButton(
                  icon: Icons.map_rounded,
                  text: 'Map',
                  iconActiveColor: AppColor.defaultColor,
                  textColor: AppColor.defaultColor,
                ),
                GButton(
                  icon: Icons.add_circle_outline,
                  text: 'Add',
                  iconActiveColor: AppColor.defaultColor,
                  textColor: AppColor.defaultColor,
                ),
                GButton(
                  icon: Icons.people_alt_rounded,
                  text: 'Buddies',
                  iconActiveColor: AppColor.defaultColor,
                  textColor: AppColor.defaultColor,
                ),
                GButton(
                  icon: Icons.person_outline,
                  text: 'Profile',
                  iconActiveColor: AppColor.defaultColor,
                  textColor: AppColor.defaultColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
