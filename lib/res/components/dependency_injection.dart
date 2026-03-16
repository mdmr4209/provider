import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/modules/home/providers/home_provider.dart';
import '../../app/modules/onboarding/providers/onboarding_provider.dart';
import '../../app/modules/profile/providers/profile_provider.dart';
import '../../app/modules/cart/providers/cart_provider.dart';
import 'api_service.dart';
import '../../app/modules/auth/providers/auth_provider.dart';

Widget appProviders({required Widget child}) {
  return MultiProvider(
    providers: [
      Provider<ApiService>(create: (_) => ApiService()),

      ChangeNotifierProvider(create: (_) => OnboardingProvider()),

      ChangeNotifierProxyProvider<ApiService, AuthProvider>(
        create: (ctx) => AuthProvider(apiService: ctx.read<ApiService>()),
        update: (_, apiService, previous) =>
            previous ?? AuthProvider(apiService: apiService),
      ),

      ChangeNotifierProvider(create: (_) => HomeProvider()),
      ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ChangeNotifierProvider(create: (_) => CartProvider()),
    ],
    child: child,
  );
}
