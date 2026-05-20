import 'package:flutter/material.dart';

class NavigationService {
  static final navigatorKey =
  GlobalKey<NavigatorState>();

  static Future<dynamic>? pushNamed(
      String routeName) {
    return navigatorKey.currentState
        ?.pushNamed(routeName);
  }

  static void goBack() {
    navigatorKey.currentState?.pop();
  }
}

// NavigationService.pushNamed(
// AppRoutes.home,
// );