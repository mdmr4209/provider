import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'bindings/provider_binding.dart';
import 'core/services/api_service.dart';
import 'core/services/navigation_service.dart';
import 'core/services/notifications/firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/helpers/snack_bar_helper.dart';
import 'core/widgets/background_widget.dart';
import 'features/shared/auth/controllers/auth_controller.dart';
import 'features/shared/localization/controllers/localization_controller.dart';
import 'features/shared/theme/controllers/theme_controller.dart';
import 'routes/app_router.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    debugPrint('📩 Background message: ${message.data}');
  } catch (e) {
    debugPrint('❌ Background handler error: $e');
  }
}

// ── Entry point ────────────────────────────────────────────────────────────
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final navigatorKey = GlobalKey<NavigatorState>();
  SnackBarHelper.navigatorKey = navigatorKey;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    debugPrint('✅ Firebase initialized successfully');
  } catch (e) {
    debugPrint('❌ Firebase init error: $e');
  }

  runApp(appProviders(child: MyApp(navigatorKey: navigatorKey)));
}

// ── Root widget ────────────────────────────────────────────────────────────
class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const MyApp({super.key, required this.navigatorKey});

  static GoRouter? _router;

  GoRouter _getRouter(BuildContext context) {
    if (_router != null) return _router!;

    final auth = context.read<AuthController>();

    AuthController.routerKey = navigatorKey;
    ApiService.onUnauthorized = () {
      navigatorKey.currentContext?.go(AppRoutes.login);
    };

    _router = AppRouter.create(auth, navigatorKey);
    // Initialize NavigationService with the router instance
    NavigationService.initRouter(_router!);
    return _router!;
  }

  @override
  Widget build(BuildContext context) {
    final router = _getRouter(context);
    final themeController = context.watch<ThemeController>();
    final localizationController = context.watch<LocalizationController>();

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) => MaterialApp.router(
        title: 'My App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeController.themeMode,
        locale: localizationController.locale,
        routerConfig: router,
        // Wrap every route with BackgroundWidget
        builder: (context, child) {
          return BackgroundWidget(child: child!);
        },
      ),
    );
  }
}
