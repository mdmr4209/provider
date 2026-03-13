import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newproject/app/modules/auth/views/go_to_home.dart';

import '../modules/auth/providers/auth_provider.dart';
import '../modules/auth/views/auth_view.dart';
import '../modules/auth/views/change_password_view.dart';
import '../modules/auth/views/forget_password_view.dart';
import '../modules/auth/views/otp_verify_view.dart';
import '../modules/auth/views/sign_up_view.dart';
import '../modules/splash/views/splash_view.dart';
import '../onboarding/providers/onboarding_provider.dart';
import '../onboarding/views/onboarding_view.dart';

// ── Route name constants ────────────────────────────────────────────────────
abstract class AppRoutes {
  static const login = '/login';
  static const signup = '/signup';
  static const forgetPass = '/forget-password';
  static const otpVerify = '/otp-verify';
  static const changePass = '/change-password';
  static const home = '/home';
  static const onboarding = '/onboarding';
  static const goToHome = '/go-home';
}

// ── Router factory ──────────────────────────────────────────────────────────
class AppRouter {
  /// Pass the [AuthProvider] so the router can listen to auth state changes
  /// and auto-redirect without any manual navigation calls inside the provider.
  static GoRouter create(
    AuthProvider auth,
    OnboardingProvider onboard,
    GlobalKey<NavigatorState> navigatorKey,
  ) {
    return GoRouter(
      navigatorKey: navigatorKey, // Add this line
      initialLocation: AppRoutes.onboarding,
      // Listen to both for changes
      refreshListenable: Listenable.merge([auth, onboard]),

      redirect: (context, state) {
        if (onboard.isLoading || auth.isCheckingToken) return null;

        final bool hasOnboarded = onboard.hasCompletedOnboarding;
        final bool isLoggedIn = auth.isLoggedIn;
        final String loc = state.matchedLocation;

        // 1. Force Onboarding if not done
        if (!hasOnboarded && loc != AppRoutes.onboarding) {
          return AppRoutes.onboarding;
        }

        // 2. If finished onboarding but on onboarding page, go to login/home
        if (hasOnboarded && loc == AppRoutes.onboarding) {
          return isLoggedIn ? AppRoutes.home : AppRoutes.login;
        }

        // 3. Standard Auth Guard
        final onAuthScreen =
            loc == AppRoutes.login ||
            loc == AppRoutes.signup ||
            loc == AppRoutes.forgetPass ||
            loc == AppRoutes.otpVerify ||
            loc == AppRoutes.home ||
            loc == AppRoutes.goToHome ||
            loc == AppRoutes.changePass; // etc
        if (isLoggedIn && onAuthScreen) return AppRoutes.home;
        if (!isLoggedIn && !onAuthScreen && hasOnboarded) {
          return AppRoutes.login;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: AppRoutes.onboarding,
          builder: (context, state) => const OnboardingView(),
        ),
        // ── Auth ──────────────────────────────────────────────────────────────
        GoRoute(
          path: AppRoutes.onboarding,
          name: 'splash',
          // Usage: context.go(AppRoutes.changePass, extra: 'Forget')
          pageBuilder: (_, __) => const MaterialPage(child: SplashView()),
        ),
        GoRoute(
          path: AppRoutes.login,
          name: 'login',
          pageBuilder: (_, __) => const NoTransitionPage(child: AuthView()),
        ),
        GoRoute(
          path: AppRoutes.signup,
          name: 'signup',
          pageBuilder: (_, __) => const MaterialPage(child: SignUpView()),
        ),
        GoRoute(
          path: AppRoutes.forgetPass,
          name: 'forgetPassword',
          pageBuilder: (_, __) =>
              const MaterialPage(child: ForgetPasswordView()),
        ),
        GoRoute(
          path: AppRoutes.otpVerify,
          name: 'otpVerify',
          // Usage: context.go(AppRoutes.otpVerify, extra: 'Signup')
          pageBuilder: (_, state) => MaterialPage(
            child: OtpVerifyView(origin: state.extra as String?),
          ),
        ),
        GoRoute(
          path: AppRoutes.changePass,
          name: 'changePassword',
          // Usage: context.go(AppRoutes.changePass, extra: 'Forget')
          pageBuilder: (_, state) => MaterialPage(
            child: ChangePasswordView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.goToHome,
          name: 'goToHome',
          // Usage: context.go(AppRoutes.changePass, extra: 'Forget')
          pageBuilder: (_, state) => MaterialPage(
            child: GoToHome(origin: state.extra as String?),
          ),
        ),

        // ── Protected ─────────────────────────────────────────────────────────
        GoRoute(
          path: AppRoutes.home,
          name: 'home',
          pageBuilder: (_, __) => const MaterialPage(
            // child: NavBar(),  // swap in your home widget
            child: Scaffold(body: Center(child: Text('Home'))),
          ),
        ),
      ],

      // ── 404 ───────────────────────────────────────────────────────────────
      errorPageBuilder: (_, state) => MaterialPage(
        child: Scaffold(
          body: Center(child: Text('Page not found: ${state.error}')),
        ),
      ),
    );
  }
}
