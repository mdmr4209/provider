import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

// ...existing imports...
import '../../../core/exceptions/app_exceptions.dart';
import '../../../core/exceptions/exception_handler.dart';
import '../../../core/services/api_service.dart';
import '../../../core/utils/helpers/snack_bar_helper.dart';
import '../../../core/constants/api_constants.dart';
import '../../../routes/app_router.dart';

class AuthController extends ChangeNotifier {
  // Removed final ApiService apiService;

  static GlobalKey<NavigatorState>? routerKey;

  AuthController() {
    checkLoginStatus();
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool _isOtpVerified = false;
  bool _isLoading = false;
  final bool _isHomeLoading = false;
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

  // Exception handling
  AppException? _error;

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

  // Exception handling getter
  AppException? get error => _error;

  // ── Toggle helpers ─────────────────────────────────────────────────────────
  void toggleRemembered() {
    _isRemembered = !_isRemembered;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void clearError() {
    _error = null;
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

      final token = await ApiService.getAccessToken();
      final verify = await ApiService.getStored(key: 'verify');

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
    final refresh = await ApiService.getRefreshToken();
    if (refresh == null) return false;
    try {
      _setLoading(true); // Added loading state for refresh
      final response = await ApiService.post(
        api: ApiConstants.refreshTokenUrl,
        data: {'refresh': refresh},
      );

      if (response != null && response.statusCode == 200) {
        final data = response.data;
        _accessToken =
            data['access'] as String? ?? data['access_token'] as String;
        _refreshToken =
            data['refresh'] as String? ?? data['refresh_token'] as String;
        await ApiService.storeTokens(
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
    } finally {
      _setLoading(false); // Ensure loading state is reset
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

    try {
      _setLoading(true);
      _error = null;
      notifyListeners();

      final response = await ApiService.post(
        api: ApiConstants.loginUrl,
        data: {'email': email, 'password': password},
      );

      if (response != null && response.statusCode == 200) {
        final data = response.data;
        _accessToken = data['access_token'] as String;
        _refreshToken = data['refresh_token'] as String? ?? '';
        _id = data['user_id']?.toString() ?? '';
        final verify = data['verify']?.toString() ?? 'no';
        final message = data['message'] ?? 'Login successful';

        await ApiService.storeTokens(
          accessToken: _accessToken,
          refreshToken: _refreshToken,
        );
        await ApiService.store(key: 'verify', value: verify);
        await ApiService.store(key: 'user_id', value: _id);

        showSuccessSnackBar(message: message);

        if (verify == 'yes') {
          _isLoggedIn = true;
          _isSignedIn = true;
          notifyListeners();
        } else {
          _go(AppRoutes.otpVerify, extra: 'Login');
        }
      } else {
        _errorMessage =
            response?.data?['error']?.toString() ??
            response?.data?['message']?.toString() ??
            'Invalid credentials';
        notifyListeners();
      }
    } catch (e) {
      debugPrint('login error: $e');
      _error = ExceptionHandler.handleException(e);
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signup() async {
    final email = signupEmailController.text.trim();
    debugPrint('signup: $email');
    try {
      _setLoading(true);
      _error = null;
      notifyListeners();

      final response = await ApiService.post(
        api: ApiConstants.signup,
        data: {'email': email},
      );

      if (response != null && response.statusCode == 201) {
        _signupEmail = email;
        notifyListeners();
        showSuccessSnackBar(
          message: response.data?['message'] ?? 'OTP sent to your email',
        );
        _go(AppRoutes.otpVerify, extra: 'Signup');
      } else {
        _errorMessage =
            response?.data?['error']?.toString() ??
            response?.data?['message']?.toString() ??
            'Signup failed';
        notifyListeners();
      }
    } catch (e) {
      debugPrint('signup error: $e');
      _error = ExceptionHandler.handleException(e);
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> forget() async {
    final email = forgetEmailController.text.trim();
    debugPrint('forget: $email');
    try {
      _setLoading(true);
      _error = null;
      notifyListeners();

      final response = await ApiService.post(
        api: ApiConstants.forget,
        data: {'email': email},
      );

      if (response != null && response.statusCode == 201) {
        _signupEmail = email;
        notifyListeners();
        showSuccessSnackBar(
          message: response.data?['message'] ?? 'OTP sent to your email',
        );
        _go(AppRoutes.otpVerify, extra: 'Forget');
      } else {
        _errorMessage =
            response?.data?['error']?.toString() ??
            response?.data?['message']?.toString() ??
            'Request failed';
        notifyListeners();
        _go(AppRoutes.otpVerify, extra: 'Forget');
      }
    } catch (e) {
      debugPrint('forget error: $e');
      _error = ExceptionHandler.handleException(e);
      notifyListeners();
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
      _error = null;
      notifyListeners();

      final response = await ApiService.post(
        api: ApiConstants.verifyOtp,
        data: {'email': email, 'otp': otp},
      );

      if (response != null && response.statusCode == 200) {
        showSuccessSnackBar(message: 'OTP Verified. Now set your password.');
        _isOtpVerified = true;
        notifyListeners();
        _go(AppRoutes.changePass, extra: origin ?? 'Signup');
      } else {
        _errorMessage =
            response?.data?['error']?.toString() ??
            response?.data?['message']?.toString() ??
            'Invalid OTP';
        notifyListeners();
      }
    } catch (e) {
      debugPrint('verifyOtp error: $e');
      _error = ExceptionHandler.handleException(e);
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> resendOtp() async {
    final email = _signupEmail;
    if (email.isEmpty) {
      showErrorSnackBar(message: 'Email for OTP is missing.');
      return;
    }
    debugPrint('resendOtp email=$email');
    try {
      _setLoading(true);
      _error = null;
      notifyListeners();

      final response = await ApiService.post(
        api: ApiConstants.resendOtp,
        data: {'email': email},
      );

      if (response != null && response.statusCode == 200) {
        showSuccessSnackBar(
          message: response.data?['message'] ?? 'OTP resent successfully.',
        );
        startTimer();
      } else {
        _errorMessage =
            response?.data?['error']?.toString() ??
            response?.data?['message']?.toString() ??
            'Failed to resend OTP.';
        notifyListeners();
      }
    } catch (e) {
      debugPrint('resendOtp error: $e');
      _error = ExceptionHandler.handleException(e);
      notifyListeners();
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
      _error = null;
      notifyListeners();

      final response = await ApiService.post(
        api: ApiConstants.setPassword,
        data: {'email': email, 'password': password},
      );

      if (response != null && response.statusCode == 201) {
        final data = response.data;
        final access = data['access_token'] as String?;
        final refresh = data['refresh_token'] as String?;
        final verify = data['verify']?.toString() ?? 'no';
        final message = data['message'] ?? 'Password set successfully';

        if (access == null || access.isEmpty) {
          throw Exception('No access token received');
        }

        await ApiService.storeTokens(
          accessToken: access,
          refreshToken: refresh ?? '',
        );
        await ApiService.store(key: 'verify', value: verify);
        _accessToken = access;
        _refreshToken = refresh ?? '';
        _isSignedIn = true;
        _isLoggedIn = verify == 'yes';
        notifyListeners();
        showSuccessSnackBar(message: message);
        await registerFcmToken();

        if (origin == 'Signup') {
          _go(AppRoutes.home);
        } else if (origin == 'Forget') {
          _isLoggedIn = true;
          notifyListeners();
          _go(AppRoutes.home);
        } else {
          _go(AppRoutes.home);
        }
      } else {
        _errorMessage =
            response?.data?['error']?.toString() ??
            response?.data?['message']?.toString() ??
            'Failed to set password';
        notifyListeners();
      }
    } catch (e) {
      debugPrint('setPassword error: $e');
      _error = ExceptionHandler.handleException(e);
      notifyListeners();
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
      await ApiService.clearTokens();
      clear(); // notifyListeners() inside → GoRouter redirect → /login
      showSuccessSnackBar(message: 'Logged out successfully');
    } catch (e) {
      showErrorSnackBar(message: 'Failed to logout: $e');
    }
  }

  // ── FCM ────────────────────────────────────────────────────────────────────
  Future<void> registerFcmToken() async {
    try {
      final fcm = await ApiService.getStored(key: 'fcm_token');
      final access = await ApiService.getAccessToken();
      if (fcm == null || access == null) return;

      final response = await ApiService.post(
        api: ApiConstants.registerFcmTokenUrl,
        data: {'fcm_token': fcm},
        auth: true, // This endpoint requires authentication
      );

      if (response != null && response.statusCode == 200) {
        debugPrint('FCM register successful: ${response.statusCode}');
      } else {
        debugPrint(
          'FCM register failed: ${response?.statusCode} - ${response?.data}',
        );
      }
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
