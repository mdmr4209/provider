import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../auth/providers/auth_controller.dart';
import '../../auth/views/auth_view.dart';
import '../../home/views/navigation.dart';

class SplashController extends GetxController with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> fadeAnimation;

  @override
  void onInit() {
    super.onInit();
    final authController = Get.find<AuthController>();

    // Initialize animation
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeIn,
      ),
    );

    // Start animation
    animationController.forward();

    // Navigate after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (authController.isCheckingToken.value) {
        authController.isCheckingToken.listen((isChecking) {
          if (!isChecking) {
            _navigate(authController);
          }
        });
      } else {
        _navigate(authController);
      }
    });
  }

  void _navigate(AuthController controller) {
    if (controller.isLoggedIn.value && controller.isSignedIn.value) {
      Get.offAll(() => Navbar());
    } else if (!controller.isLoggedIn.value && controller.isSignedIn.value) {
      // Get.offAllNamed(Routes.onboarding);
    } else {
      Get.offAll(() => AuthView());
    }
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}