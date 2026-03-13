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
class AuthProvider extends ChangeNotifier {
  final ApiService apiService;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Set this from main.dart: AuthProvider.routerKey = _routerKey;
  static GlobalKey<NavigatorState>? routerKey;

  AuthProvider({required this.apiService}) {
    checkLoginStatus();
  }

  // ── Firebase / Social ──────────────────────────────────────────────────────
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // ── State ──────────────────────────────────────────────────────────────────
  bool _isOtpVerified = false;
  bool _isLoading = false;
  bool _isHomeLoading = false;
  bool _isCheckingToken = true;
  bool _isLoggedIn = false;
  bool _isSignedIn = false;
  bool _isRemembered = false;
  bool _isPasswordVisible = true;

  String _errorMessage = '';
  String _signupEmail = '';
  String _accessToken = '';
  String _refreshToken = '';
  String _id = '';

  int _secondsRemaining = 60;
  String _formattedTime = '01:00';
  Timer? _timer;

  // ── Text controllers ───────────────────────────────────────────────────────
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController setPasswordController = TextEditingController();
  final TextEditingController signupEmailController = TextEditingController();
  final TextEditingController forgetEmailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  // ── Getters ────────────────────────────────────────────────────────────────
  bool get isOtpVerified => _isOtpVerified;
  bool get isLoading => _isLoading;
  bool get isHomeLoading => _isHomeLoading;
  bool get isCheckingToken => _isCheckingToken;
  bool get isLoggedIn => _isLoggedIn;
  bool get isSignedIn => _isSignedIn;
  bool get isRemembered => _isRemembered;
  bool get isPasswordVisible => _isPasswordVisible;
  String get errorMessage => _errorMessage;
  String get signupEmail => _signupEmail;
  String get accessToken => _accessToken;
  String get refreshToken => _refreshToken;
  String get id => _id;
  int get secondsRemaining => _secondsRemaining;
  String get formattedTime => _formattedTime;

  // ── Toggle helpers ─────────────────────────────────────────────────────────
  void toggleRemembered() {
    _isRemembered = !_isRemembered;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void updateOtp(String value) {
    if (value.length == 5) {
      _isOtpVerified = true;
    } else {
      _isOtpVerified = false;
    }
    notifyListeners();
  }

  // ── Timer ──────────────────────────────────────────────────────────────────
  void startTimer() {
    stopTimer();
    _secondsRemaining = 60;
    _formattedTime = '01:00';
    notifyListeners();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsRemaining > 0) {
        _secondsRemaining--;
        final m = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
        final s = (_secondsRemaining % 60).toString().padLeft(2, '0');
        _formattedTime = '$m:$s';
        notifyListeners();
      } else {
        t.cancel();
      }
    });
  }

  void stopTimer() => _timer?.cancel();

  // ── GoRouter navigation helper ─────────────────────────────────────────────
  void _go(String path, {Object? extra}) {
    final ctx = routerKey?.currentContext;
    if (ctx != null && ctx.mounted) {
      ctx.go(path, extra: extra);
    } else {
      debugPrint('AppRouter: no context available for navigation to $path');
    }
  }

  // ── Login status ───────────────────────────────────────────────────────────
  Future<void> checkLoginStatus() async {
    try {
      _isCheckingToken = true;
      notifyListeners();

      final token = await BaseClient.getAccessToken();
      final verify = await BaseClient.getStored(key: 'verify');

      if (token != null && token.isNotEmpty) {
        _accessToken = token;
        _isLoggedIn = verify == 'yes';
        _isSignedIn = true;
      } else {
        _isLoggedIn = false;
      }
    } catch (e) {
      debugPrint('checkLoginStatus error: $e');
      _isLoggedIn = false;
    } finally {
      _isCheckingToken = false;
      notifyListeners(); // triggers GoRouter redirect
    }
  }

  Future<bool> refreshAccessToken() async {
    final refresh = await BaseClient.getRefreshToken();
    if (refresh == null) return false;
    try {
      final response = await apiService.refreshToken(refresh);
      if (response['statusCode'] == 200) {
        _accessToken = response['data']['access'] as String;
        _refreshToken = response['data']['refresh'] as String;
        await BaseClient.storeTokens(
          accessToken: _accessToken,
          refreshToken: _refreshToken,
        );
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('refreshAccessToken error: $e');
      return false;
    }
  }

  // ── Social sign-in ─────────────────────────────────────────────────────────
  Future<void> signInWithFacebook() async {
    try {
      _setLoading(true);
      final result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success && result.accessToken != null) {
        final credential = FacebookAuthProvider.credential(
          result.accessToken!.tokenString,
        );
        final uc = await FirebaseAuth.instance.signInWithCredential(credential);
        debugPrint('FB user: ${uc.user?.email}');
      }
    } catch (e) {
      debugPrint('Facebook sign-in error: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      _setLoading(true);
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final uc = await _firebaseAuth.signInWithCredential(credential);
      debugPrint('Google user: ${uc.user?.email}');
    } catch (e) {
      debugPrint('Google sign-in error: $e');
    } finally {
      _setLoading(false);
    }
  }

  // ── Core auth methods (no BuildContext) ────────────────────────────────────
  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    debugPrint('login: $email');

    // try {
    //   _setLoading(true);
    //   final response = await apiService.login(email, password);
    //   if (response['statusCode'] == 200) {
    //     final data     = response['data'];
    //     _accessToken   = data['access_token']  as String;
    //     _refreshToken  = data['refresh_token'] ?? '';
    //     _id            = data['user_id'].toString();
    //     final verify   = data['verify']  ?? 'no';
    //     final message  = data['message'] ?? 'Login successful';
    //
    //     await BaseClient.storeTokens(
    //         accessToken: _accessToken, refreshToken: _refreshToken);
    //     await BaseClient.store(key: 'verify',   value: verify);
    //     await BaseClient.store(key: 'user_id',  value: _id);
    //
    //     showSuccessSnackBar(message: message);
    //
    //     if (verify == 'yes') {
    //       _isLoggedIn = true;
    //       notifyListeners(); // GoRouter redirect → /home
    //     }
    //   } else {
    //     _errorMessage = response['data']['error'] ?? 'Invalid credentials';
    //     showErrorSnackBar(message: _errorMessage);
    //     notifyListeners();
    //   }
    // } catch (e) {
    //   debugPrint('login error: $e');
    //   showErrorSnackBar(message: 'Login failed: $e');
    // } finally {
    //   _setLoading(false);
    // }
  }

  Future<void> signup() async {
    final email = signupEmailController.text.trim();
    debugPrint('signup: $email');
    try {
      _setLoading(true);
      final response = await apiService.signup(email);
      if (response['statusCode'] == 201) {
        _signupEmail = email;
        notifyListeners();
        showSuccessSnackBar(
          message: response['data']['message'] ?? 'OTP sent to your email',
        );
        _go(AppRoutes.otpVerify, extra: 'Signup');
      } else {
        _errorMessage =
            response['data']['error'] ??
            response['data']['message'] ??
            'Signup failed';
        showErrorSnackBar(message: 'Signup failed: $_errorMessage');
        notifyListeners();
      }
    } catch (e) {
      debugPrint('signup error: $e');
      showErrorSnackBar(message: 'Signup failed: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> forget() async {
    final email = forgetEmailController.text.trim();
    debugPrint('forget: $email');
    try {
      _setLoading(true);
      final response = await apiService.forget(email);
      if (response['statusCode'] == 201) {
        _signupEmail = email;
        notifyListeners();
        showSuccessSnackBar(message: response['data']['message'] ?? 'OTP sent');
        _go(AppRoutes.otpVerify, extra: 'Forget');
      } else {
        _errorMessage =
            response['data']['error'] ??
            response['data']['message'] ??
            'Request failed';
        showErrorSnackBar(message: _errorMessage);
        notifyListeners();
        _go(AppRoutes.otpVerify, extra: 'Forget');
      }
    } catch (e) {
      debugPrint('forget error: $e');
      showErrorSnackBar(message: 'Request failed: $e');
      _go(AppRoutes.otpVerify, extra: 'Forget');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> verifyOtp({String? origin}) async {
    final email = _signupEmail;
    final otp = otpController.text.trim();
    debugPrint('verifyOtp email=$email otp=$otp');
    try {
      _setLoading(true);
      final response = await apiService.verifyOtp(email, otp);
      if (response['statusCode'] == 200) {
        showSuccessSnackBar(message: 'Verified. Now set your password.');

      } else {
        _errorMessage =
            response['data']['error'] ??
            response['data']['message'] ??
            'Invalid OTP';
        showErrorSnackBar(message: 'OTP verification failed: $_errorMessage');
        notifyListeners();
      }
    } catch (e) {  _go(AppRoutes.changePass, extra: origin ?? 'Signup');
      debugPrint('verifyOtp error: $e');
      showErrorSnackBar(message: 'OTP verification failed: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> setPassword({String? origin}) async {
    final email = _signupEmail;
    final password = setPasswordController.text;
    debugPrint('setPassword email=$email');
    try {
      _setLoading(true);
      final response = await apiService.setPassword(email, password);
      if (response['statusCode'] == 201) {
        final data = response['data'];
        final access = data['access_token'] as String?;
        final refresh = data['refresh_token'] as String?;
        final verify = data['verify'] ?? 'no';
        final message = data['message'] ?? 'Password set successfully';

        if (access == null || access.isEmpty) {
          throw Exception('No access token received');
        }

        await BaseClient.storeTokens(
          accessToken: access,
          refreshToken: refresh ?? '',
        );
        await BaseClient.store(key: 'verify', value: verify);
        _accessToken = access;
        _refreshToken = refresh ?? '';
        _isSignedIn = true;
        notifyListeners();
        showSuccessSnackBar(message: message);
        await registerFcmToken();

        if (origin == 'Signup' && verify == 'no') {
          _go(AppRoutes.home); // or onboarding route
        } else if (origin == 'Forget' && verify == 'yes') {
          _isLoggedIn = true;
          notifyListeners(); // GoRouter redirect → /home
        }
      } else {
        _errorMessage =
            response['data']['error'] ??
            response['data']['message'] ??
            'Failed to set password';
        showErrorSnackBar(message: 'Failed to set password: $_errorMessage');
        notifyListeners();
      }
    } catch (e) {
      debugPrint('setPassword error: $e');
      showErrorSnackBar(message: 'Failed to set password: $e');
    } finally {
      _setLoading(false);
    }
  }

  // ── Validation ─────────────────────────────────────────────────────────────
  bool validatePasswords(String newPass, String confirm) {
    if (newPass.isEmpty || confirm.isEmpty) {
      showErrorSnackBar(message: 'Passwords cannot be empty');
      return false;
    }
    if (newPass != confirm) {
      showErrorSnackBar(message: 'Passwords do not match');
      return false;
    }
    if (newPass.length < 8) {
      showErrorSnackBar(message: 'Password must be at least 8 characters');
      return false;
    }
    return true;
  }

  // ── Logout ─────────────────────────────────────────────────────────────────
  Future<void> logout() async {
    try {
      await BaseClient.clearTokens();
      clear(); // notifyListeners() inside → GoRouter redirect → /login
      showSuccessSnackBar(message: 'Logged out successfully');
    } catch (e) {
      showErrorSnackBar(message: 'Failed to logout: $e');
    }
  }

  // ── FCM ────────────────────────────────────────────────────────────────────
  Future<void> registerFcmToken() async {
    try {
      final fcm = await BaseClient.getStored(key: 'fcm_token');
      final access = await BaseClient.getAccessToken();
      if (fcm == null || access == null) return;
      final response = await apiService.registerFcmToken(
        accessToken: access,
        fcmToken: fcm,
      );
      debugPrint('FCM register: ${response['statusCode']}');
    } catch (e) {
      debugPrint('registerFcmToken error: $e');
    }
  }

  // ── Clear ──────────────────────────────────────────────────────────────────
  void clear() {
    _signupEmail = '';
    _accessToken = '';
    _refreshToken = '';
    _id = '';
    _isOtpVerified = false;
    _isSignedIn = false;
    _isLoggedIn = false;
    _errorMessage = '';
    _isRemembered = false;
    _isPasswordVisible = true;
    stopTimer();
    _secondsRemaining = 60;
    _formattedTime = '01:00';
    emailController.clear();
    passwordController.clear();
    setPasswordController.clear();
    signupEmailController.clear();
    forgetEmailController.clear();
    otpController.clear();
    notifyListeners(); // triggers GoRouter redirect to /login
  }

  // ── Private ────────────────────────────────────────────────────────────────
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    stopTimer();
    emailController.dispose();
    passwordController.dispose();
    setPasswordController.dispose();
    signupEmailController.dispose();
    forgetEmailController.dispose();
    otpController.dispose();
    super.dispose();
  }
}
