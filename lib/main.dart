//
// import 'dart:io';
//
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:provider/provider.dart';
//
// import '../../../../firebase_options.dart';
// import '../../../../res/components/api_service.dart';
// import '../../../../res/components/notification_service.dart';
// import 'app/modules/auth/providers/auth_controller.dart';
// import 'app/modules/auth/providers/auth_provider.dart';
// import 'app/modules/auth/views/auth_view.dart';
// import 'app/modules/home/controllers/home_controller.dart';
// import 'app/modules/splash/controllers/splash_controller.dart';
//
//
//
// /// 👇 Accept all certificates (use carefully — not for production)
// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }
//
// /// 👇 Background FCM handler
// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   try {
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//     debugPrint('📩 Background message received: ${message.data}');
//   } catch (e, stackTrace) {
//     debugPrint('❌ Error in background message handler: $e');
//     debugPrint('Stack trace: $stackTrace');
//   }
// }
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   /// ✅ Allow custom certificates (optional)
//   HttpOverrides.global = MyHttpOverrides();
//
//   try {
//     /// ✅ Initialize Firebase
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//
//     /// ✅ Setup Firebase Messaging
//     FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
//
//     /// ✅ Handle initial message if app opened from notification
//     final initMsg = await FirebaseMessaging.instance.getInitialMessage();
//     if (initMsg != null) {
//       NotificationService.initialMessage = initMsg;
//     }
//
//     debugPrint('✅ Firebase initialized successfully');
//   } catch (e) {
//     debugPrint('❌ Error initializing Firebase: $e');
//   }
//
//   final apiService = ApiService(); // initialise your ApiService here
//   Get.put(ApiService());
//   Get.put(AuthController());
//   Get.put(SplashController());
//   Get.put(HomeController());
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider<AuthProvider>(
//           create: (_) => AuthProvider(apiService: apiService),
//         ),
//         // Add more providers here as needed
//       ],
//       child: const MyApp(),
//     ),
//   );
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: const Size(390, 844),
//       minTextAdapt: true,
//       splitScreenMode: true,
//       builder: (context, child) => MaterialApp(
//         title: 'My App',
//         debugShowCheckedModeBanner: false,
//         home: child,
//       ),
//       child: const AuthView(),
//     );
//   }
// }


import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'app/modules/auth/providers/auth_provider.dart';
import 'app/routes/app_router.dart';
import 'firebase_options.dart';
import 'res/components/base_client.dart';
import 'res/components/dependency_injection.dart';
import 'res/components/notification_service.dart';
import 'widgets/snack_bar_helper.dart';

// ── Background FCM handler ─────────────────────────────────────────────────
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    debugPrint('📩 Background message: ${message.data}');
  } catch (e) {
    debugPrint('❌ Background handler error: $e');
  }
}

// ── Entry point ────────────────────────────────────────────────────────────
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    final initMsg = await FirebaseMessaging.instance.getInitialMessage();
    if (initMsg != null) NotificationService.initialMessage = initMsg;
    debugPrint('✅ Firebase initialized successfully');
  } catch (e) {
    debugPrint('❌ Firebase init error: $e');
  }

  runApp(
    appProviders(child: const MyApp()),
  );
}

// ── Root widget ────────────────────────────────────────────────────────────
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _routerKey = GlobalKey<NavigatorState>();
  GoRouter? _router;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // didChangeDependencies is the correct place to call context.read —
    // the Provider tree is fully built here. Guard with _router != null
    // so we only initialise once.
    if (_router != null) return;

    final auth = context.read<AuthProvider>();

    SnackBarHelper.navigatorKey = _routerKey;
    AuthProvider.routerKey      = _routerKey;
    BaseClient.onUnauthorized   = () {
      _routerKey.currentContext?.go(AppRoutes.login);
    };

    _router = AppRouter.create(auth);
    setState(() {}); // rebuild now that _router is ready
  }

  @override
  Widget build(BuildContext context) {
    // Show a blank screen for the single frame before router is ready
    if (_router == null) {
      return const MaterialApp(
        home: Scaffold(body: SizedBox.shrink()),
      );
    }

    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) => MaterialApp.router(
        title: 'My App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Roboto',
          useMaterial3: true,
        ),
        routerConfig: _router!,
      ),
    );
  }
}