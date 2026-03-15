import 'package:flutter/material.dart';
import 'package:newproject/app/modules/home/providers/home_provider.dart';
import 'package:provider/provider.dart';

import '../../app/modules/profile/providers/profile_provider.dart';
import '../../app/modules/splash/providers/splash_provider.dart';
import '../../app/onboarding/providers/onboarding_provider.dart';
import 'api_service.dart';
import '../../app/modules/auth/providers/auth_provider.dart';

// ── Add more provider imports here as your app grows ─────────────────────────
// import '../../app/modules/profile/providers/profile_provider.dart';
// import '../../app/modules/home/providers/home_provider.dart';

// res/components/dependency_injection.dart

Widget appProviders({required Widget child}) {
  return MultiProvider(
    providers: [
      Provider<ApiService>(create: (_) => ApiService()),

      // Add the OnboardingProvider here
      ChangeNotifierProvider(create: (_) => OnboardingProvider()),

      ChangeNotifierProxyProvider<ApiService, AuthProvider>(
        create: (ctx) => AuthProvider(apiService: ctx.read<ApiService>()),
        update: (_, apiService, previous) => previous ?? AuthProvider(apiService: apiService),
      ),

      ChangeNotifierProvider(create: (_) => SplashProvider()),
      ChangeNotifierProvider(create: (_) => HomeProvider()),
      ChangeNotifierProvider(create: (_) => ProfileProvider()),
    ],
    child: child,
  );
}