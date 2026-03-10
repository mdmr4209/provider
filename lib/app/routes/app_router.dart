import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../modules/auth/providers/auth_provider.dart';
import '../modules/auth/views/auth_view.dart';
import '../modules/auth/views/change_password_view.dart';
import '../modules/auth/views/forget_password_view.dart';
import '../modules/auth/views/otp_verify_view.dart';
import '../modules/auth/views/sign_up_view.dart';


// ── Route name constants ────────────────────────────────────────────────────
abstract class AppRoutes {
  static const login      = '/login';
  static const signup     = '/signup';
  static const forgetPass = '/forget-password';
  static const otpVerify  = '/otp-verify';
  static const changePass = '/change-password';
  static const home       = '/home';
}

// ── Router factory ──────────────────────────────────────────────────────────
class AppRouter {
  /// Pass the [AuthProvider] so the router can listen to auth state changes
  /// and auto-redirect without any manual navigation calls inside the provider.
  static GoRouter create(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: AppRoutes.login,
      debugLogDiagnostics: true,
      // Rebuild redirect whenever provider calls notifyListeners()
      refreshListenable: authProvider,

      // ── Global auth guard ─────────────────────────────────────────────────
      redirect: (context, state) {
        final isChecking   = authProvider.isCheckingToken;
        final isLoggedIn   = authProvider.isLoggedIn;
        final loc          = state.matchedLocation;
        final onAuthScreen = loc == AppRoutes.login     ||
                             loc == AppRoutes.signup    ||
                             loc == AppRoutes.forgetPass ||
                             loc == AppRoutes.otpVerify  ||
                             loc == AppRoutes.changePass;

        if (isChecking) return null;                             // token check in progress
        if (isLoggedIn && onAuthScreen) return AppRoutes.home;  // already logged in
        if (!isLoggedIn && !onAuthScreen) return AppRoutes.login; // not logged in

        return null;
      },

      routes: [
        // ── Auth ──────────────────────────────────────────────────────────────
        GoRoute(
          path: AppRoutes.login,
          name: 'login',
          pageBuilder: (_, __) =>
              const NoTransitionPage(child: AuthView()),
        ),
        GoRoute(
          path: AppRoutes.signup,
          name: 'signup',
          pageBuilder: (_, __) =>
              const MaterialPage(child: SignUpView()),
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
            child: ChangePasswordView(origin: state.extra as String?),
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
