import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../routes/app_router.dart';

/// Enhanced NavigationService for centralized app navigation
/// Integrates with GoRouter and AppRoutes for type-safe navigation
class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  
  factory NavigationService() => _instance;
  NavigationService._internal();

  static final navigatorKey = GlobalKey<NavigatorState>();
  
  // Store GoRouter instance for access
  static GoRouter? _router;
  
  /// Initialize with GoRouter instance
  static void initRouter(GoRouter router) {
    _router = router;
  }

  // ── Core Navigation Methods ────────────────────────────────────────────
  
  /// Navigate to route using AppRoutes
  static Future<T?> push<T>(String route, {Object? extra}) async {
    return await _router?.push<T>(route, extra: extra);
  }

  /// Replace current route
  static Future<T?> replace<T>(String route, {Object? extra}) async {
    return await _router?.replace<T>(route, extra: extra);
  }

  /// Navigate to route and remove all previous routes
  static Future<T?> go<T>(String route, {Object? extra}) async {
    return _router?.go(route, extra: extra) as Future<T?>?;
  }

  /// Go back to previous route
  static void pop<T>([T? result]) {
    navigatorKey.currentState?.pop(result);
  }

  /// Pop until predicate is true
  static void popUntil(String route) {
    navigatorKey.currentState?.popUntil(ModalRoute.withName(route));
  }

  /// Check if can pop
  static bool canPop() {
    return navigatorKey.currentState?.canPop() ?? false;
  }

  // ── Auth Navigation ────────────────────────────────────────────────────
  
  static void goToLogin() => go(AppRoutes.login);
  
  static void goToHome() => go(AppRoutes.home);
  
  static void goToOnboarding() => go(AppRoutes.onboarding);
  
  static void goToSignUp() => push(AppRoutes.signup);
  
  static void goToForgetPassword() => push(AppRoutes.forgetPass);
  
  static void goToOtpVerify({required String origin}) =>
      push(AppRoutes.otpVerify, extra: origin);
  
  static void goToChangePassword({required String origin}) =>
      push(AppRoutes.changePass, extra: origin);

  // ── Product Navigation ─────────────────────────────────────────────────

  
  static void goToSearch() => go(AppRoutes.search);
  
  static void goToFilter() => push(AppRoutes.filter);
  
  static void goToWishlist() => go(AppRoutes.wishlist);
  
  static void goToReview(String productId) =>
      push(AppRoutes.review, extra: productId);

  // ── Cart & Checkout Navigation ─────────────────────────────────────────
  
  static void goToCart() => go(AppRoutes.order);
  
  static void goToCheckout() => push(AppRoutes.checkout);
  
  static void goToShipping() => push(AppRoutes.shipping);
  
  static void goToPayment() => push(AppRoutes.payment);
  
  static void goToConfirmOrder({required bool fromCheckout}) =>
      push(AppRoutes.confirm, extra: fromCheckout);

  // ── Profile Navigation ─────────────────────────────────────────────────
  
  static void goToProfile() => go(AppRoutes.profile);
  
  static void goToEditProfile() => push(AppRoutes.editProfile);
  
  static void goToMyAddress() => push(AppRoutes.address);
  
  static void goToAddAddress() => push(AppRoutes.addAddress);
  
  static void goToPaymentMethods() => push(AppRoutes.paymentMethod);
  
  static void goToAddCard() => push(AppRoutes.addCard);
  
  static void goToPromoCode() => push(AppRoutes.promoCode);
  
  static void goToOrderHistory() => push(AppRoutes.orderHistory);
  
  static void goToTrackOrder() => push(AppRoutes.trackOrder);
  
  static void goToPoints() => push(AppRoutes.points);
  
  static void goToSettings() => push(AppRoutes.settings);

  // ── Home Features Navigation ───────────────────────────────────────────
  
  static void goToBreathing({required String title, required String subtitle}) =>
      push(AppRoutes.breathing, extra: {'title': title, 'subtitle': subtitle});

  static void goToWriteJournal() => push(AppRoutes.writeJournal);

  // ── Utility Methods ────────────────────────────────────────────────────
  
  /// Clear all analytics/tracking when logging out
  static void logout() {
    go(AppRoutes.login);
  }

  /// Get current route
  static String? getCurrentRoute() {
    return _router?.routeInformationProvider.value.uri.path;
  }

  /// Check if current route is
  static bool isCurrentRoute(String route) {
    return getCurrentRoute() == route;
  }
}
