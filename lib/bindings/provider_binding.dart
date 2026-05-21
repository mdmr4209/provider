import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../features/auth/controllers/auth_controller.dart';
import '../features/cart/controllers/cart_controller.dart';
import '../features/home/controllers/home_controller.dart';
import '../features/localization/controllers/localization_controller.dart';
import '../features/onboarding/controllers/onboarding_controller.dart';
import '../features/profile/controllers/profile_controller.dart';
import '../features/theme/controllers/theme_controller.dart';

Widget appProviders({required Widget child}) {
  return MultiProvider(
    providers: [
      // Provider<ApiService>(create: (_) => ApiService()),
      ChangeNotifierProvider(create: (_) => OnboardingController()),
      ChangeNotifierProvider(create: (_) => AuthController()),
      ChangeNotifierProvider(create: (_) => HomeController()),
      ChangeNotifierProvider(create: (_) => ProfileController()),
      ChangeNotifierProvider(create: (_) => CartController()),
      ChangeNotifierProvider(create: (_) => ThemeController()),
      ChangeNotifierProvider(create: (_) => LocalizationController()),
      // ChangeNotifierProxyProvider<ApiService, AuthController>(
      //   create: (ctx) => AuthController(apiService: ctx.read<ApiService>()),
      //   update: (_, apiService, previous) =>
      //   previous ?? AuthController(apiService: apiService),
      // ),
    ],
    child: child,
  );
}
