import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'api_service.dart';
import '../../app/modules/auth/providers/auth_provider.dart';

// ── Add more provider imports here as your app grows ─────────────────────────
// import '../../app/modules/profile/providers/profile_provider.dart';
// import '../../app/modules/home/providers/home_provider.dart';

Widget appProviders({required Widget child}) {
  return MultiProvider(
    providers: [
      // ── Services ──────────────────────────────────────────────────────────
      Provider<ApiService>(
        create: (_) => ApiService(),
      ),

      // ── Auth (depends on ApiService) ──────────────────────────────────────
      ChangeNotifierProxyProvider<ApiService, AuthProvider>(
        create: (ctx) => AuthProvider(
          apiService: ctx.read<ApiService>(),
        ),
        update: (_, apiService, previous) =>
        previous ?? AuthProvider(apiService: apiService),
      ),

      // ── Add more providers below as you build each feature ────────────────
      // ChangeNotifierProvider(create: (_) => ProgressProvider()),
      // ChangeNotifierProvider(create: (_) => TabBarProvider()),
      // ChangeNotifierProvider(create: (_) => DiscoverProvider()),
      // ChangeNotifierProvider(create: (_) => CalendarProvider()),
      // ChangeNotifierProxyProvider<ApiService, ProfileProvider>(
      //   create: (ctx) => ProfileProvider(apiService: ctx.read<ApiService>()),
      //   update: (_, api, prev) => prev ?? ProfileProvider(apiService: api),
      // ),
      // ChangeNotifierProvider(create: (_) => NotificationProvider()),
    ],
    child: child,
  );
}