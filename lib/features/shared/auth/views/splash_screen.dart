import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:newproject/core/constants/app_assets.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/background_widget.dart';
import '../../../../routes/app_router.dart';
import '../controllers/auth_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SplashAnimationController>(
      create: (_) => SplashAnimationController(context),
      child: Consumer<SplashAnimationController>(
        builder: (context, anim, _) {
          return BackgroundWidget(
            child: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // --- ANIMATED LOGO ---
                    ScaleTransition(
                      scale: anim.logoScaleAnimation,
                      child: FadeTransition(
                        opacity: anim.logoFadeAnimation,
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(AppAssets.sb1Logo, height: 200.h),
                        ),
                      ),
                    ),

                    SizedBox(height: 10.h),
                    // --- ANIMATED TITLE ---
                    SlideTransition(
                      position: anim.titleSlideAnimation,
                      child: FadeTransition(
                        opacity: anim.titleFadeAnimation,
                        child: Text(
                          'STRONGER BY TWO',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium!
                              .copyWith(
                                fontStyle: FontStyle.italic,
                                color: AppColors.textColor,
                              ),
                        ),
                      ),
                    ),

                    SizedBox(height: 10.h),

                    // --- ANIMATED SUBTITLE ---
                    SlideTransition(
                      position: anim.subtitleSlideAnimation,
                      child: FadeTransition(
                        opacity: anim.subtitleFadeAnimation,
                        child: Text(
                          '"You are not in this alone."',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleSmall!
                              .copyWith(
                                fontStyle: FontStyle.italic,
                                color: AppColors.textColor,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SplashAnimationController extends ChangeNotifier
    implements TickerProvider {
  final BuildContext context;
  late AnimationController controller;

  late Animation<double> logoScaleAnimation;
  late Animation<double> logoFadeAnimation;
  late Animation<Offset> titleSlideAnimation;
  late Animation<double> titleFadeAnimation;
  late Animation<Offset> subtitleSlideAnimation;
  late Animation<double> subtitleFadeAnimation;

  SplashAnimationController(this.context) {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );
    logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.2, curve: Curves.easeIn),
      ),
    );

    titleSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.3, 0.6, curve: Curves.easeOutCubic),
          ),
        );
    titleFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.3, 0.5, curve: Curves.easeIn),
      ),
    );

    subtitleSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.5, 0.8, curve: Curves.easeOutCubic),
          ),
        );
    subtitleFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.5, 0.8, curve: Curves.easeIn),
      ),
    );

    controller.forward();
    _navigateBasedOnAuth();
  }

  Future<void> _navigateBasedOnAuth() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!context.mounted) return;
    final authController = context.read<AuthController>();
    if (authController.isLoggedIn) {
      context.go(AppRoutes.home);
    } else {
      context.go(AppRoutes.login);
    }
  }

  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
