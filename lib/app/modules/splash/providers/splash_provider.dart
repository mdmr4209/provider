import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../res/components/api_service.dart';
import '../../../../res/components/base_client.dart';
import '../../../../widgets/custom_snack_bar.dart';
import '../../../routes/app_router.dart';

/// Pure ChangeNotifier — zero BuildContext, zero Navigator.
/// Navigation is done via GoRouter using the routerKey set in main.dart.
class SplashProvider extends ChangeNotifier {


  /// Set this from main.dart: AuthProvider.routerKey = _routerKey;
  static GlobalKey<NavigatorState>? routerKey;



  @override
  void dispose() {
    super.dispose();
  }
}
