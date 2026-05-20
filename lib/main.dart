import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'bindings/provider_binding.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'features/localization/controllers/localization_controller.dart';
import 'features/onboarding/controllers/onboarding_controller.dart';
import 'features/theme/controllers/theme_controller.dart';
import 'core/services/notifications/firebase_options.dart';
import 'core/constants/app_colors.dart';
import 'core/services/api_service.dart';
import 'core/services/notifications/notification_service.dart';
import 'routes/app_router.dart';
import 'core/utils/helpers/snack_bar_helper.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
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
    final initMsg = await FirebaseMessaging.instance.getInitialMessage();
    // if (initMsg != null) NotificationService.initialMessage = initMsg;
    // final apiService = ApiService();
    // await NotificationService.instance.initialize(apiService: apiService);
    debugPrint('✅ Firebase initialized successfully');
  } catch (e) {
    debugPrint('❌ Firebase init error: $e');
  }

  runApp(appProviders(child: MyApp(navigatorKey: navigatorKey)));
}

// ── Root widget ────────────────────────────────────────────────────────────
class MyApp extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const MyApp({super.key, required this.navigatorKey});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GoRouter? _router;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_router != null) return;

    final auth = context.read<AuthController>();
    final onboard = context.read<OnboardingController>();

    // Remove this line - don't overwrite:
    // SnackBarHelper.navigatorKey = _routerKey;

    AuthController.routerKey =
        widget.navigatorKey; // Use the passed navigatorKey
    ApiService.onUnauthorized = () {
      widget.navigatorKey.currentContext?.go(
        AppRoutes.login,
      ); // Use the passed navigatorKey
    };

    // Pass navigatorKey to AppRouter
    _router = AppRouter.create(auth, onboard, widget.navigatorKey);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_router == null) {
      return MaterialApp(
        navigatorKey: SnackBarHelper.navigatorKey,
        home: const Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: SizedBox.shrink(),
        ),
      );
    }

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
        routerConfig: _router!,
      ),
    );
  }
}
