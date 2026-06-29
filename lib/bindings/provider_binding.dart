import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../features/shared/auth/controllers/auth_controller.dart';
import '../features/seeker/circle/controllers/circle_controller.dart';
import '../features/seeker/circle/controllers/group_controller.dart';
import '../features/seeker/find_coach/controllers/coach_controller.dart';
import '../features/seeker/home/controllers/home_controller.dart';
import '../features/seeker/inbox/controllers/inbox_controller.dart';
import '../features/shared/localization/controllers/localization_controller.dart';
import '../features/seeker/profile/controllers/profile_controller.dart';
import '../features/shared/theme/controllers/theme_controller.dart';
import '../features/coach/home/controllers/coach_home_controller.dart';
import '../features/coach/circle/controllers/coach_circle_controller.dart';
import '../features/coach/bid_board/controllers/coach_bid_controller.dart';
import '../features/coach/inbox/controllers/coach_inbox_controller.dart';
import '../features/coach/profile/controllers/coach_profile_controller.dart';

Widget appProviders({required Widget child}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthController()),
      ChangeNotifierProvider(create: (_) => HomeController()),
      ChangeNotifierProvider(create: (_) => CoachHomeController()),
      ChangeNotifierProvider(create: (_) => CoachCircleController()),
      ChangeNotifierProvider(create: (_) => CoachBidController()),
      ChangeNotifierProvider(create: (_) => CoachInboxController()),
      ChangeNotifierProvider(create: (_) => CoachProfileController()),
      ChangeNotifierProvider(create: (_) => ProfileController()),
      ChangeNotifierProvider(create: (_) => ThemeController()),
      ChangeNotifierProvider(create: (_) => LocalizationController()),
      ChangeNotifierProvider(create: (_) => CircleController()),
      ChangeNotifierProvider(create: (_) => GroupController()),
      ChangeNotifierProvider(create: (_) => CoachController()),
      ChangeNotifierProvider(create: (_) => InboxController()),
    ],
    child: child,
  );
}
