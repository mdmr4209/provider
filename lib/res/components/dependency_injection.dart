import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/modules/home/controllers/home_controller.dart';
import '../../app/modules/onboarding/controllers/onboarding_controller.dart';
import '../../app/modules/profile/controllers/profile_controller.dart';
import '../../app/modules/cart/controllers/cart_controller.dart';
import 'api_service.dart';
import '../../app/modules/auth/controllers/auth_controller.dart';
import '../../app/modules/theme/controllers/theme_controller.dart';
import '../../app/modules/localization/controllers/localization_controller.dart';

Widget appProviders({required Widget child}) {
  return MultiProvider(
    providers: [
      Provider<ApiService>(create: (_) => ApiService()),

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
