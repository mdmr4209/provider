import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'app/modules/auth/providers/auth_provider.dart';
import 'app/modules/onboarding/providers/onboarding_provider.dart';
import 'app/routes/app_router.dart';
import 'firebase_options.dart';
import 'res/colors/app_color.dart';
import 'res/components/base_client.dart';
import 'res/components/dependency_injection.dart';
import 'res/components/notification_service.dart';
import 'widgets/snack_bar_helper.dart';


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
    if (initMsg != null) NotificationService.initialMessage = initMsg;
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

    final auth = context.read<AuthProvider>();
    final onboard = context.read<OnboardingProvider>();

    // Remove this line - don't overwrite:
    // SnackBarHelper.navigatorKey = _routerKey;

    AuthProvider.routerKey = widget.navigatorKey;  // Use the passed navigatorKey
    BaseClient.onUnauthorized = () {
      widget.navigatorKey.currentContext?.go(AppRoutes.login);  // Use the passed navigatorKey
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
            backgroundColor: AppColor.backgroundColor,
            body: SizedBox.shrink()),
      );
    }

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) => MaterialApp.router(
        title: 'My App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Roboto', useMaterial3: true),
        routerConfig: _router!,
      ),
    );
  }
}