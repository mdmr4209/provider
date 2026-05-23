import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/exceptions/app_exceptions.dart';
import '../../../core/exceptions/exception_handler.dart';
import '../../../core/services/api_service.dart';
import '../../../core/utils/helpers/snack_bar_helper.dart';
import '../../../core/constants/api_constants.dart';
import '../../../routes/app_router.dart';

class AuthController extends ChangeNotifier {
  static GlobalKey<NavigatorState>? routerKey;

  AuthController() {
    checkLoginStatus();
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool _isOtpVerified = false;
  bool _isLoading = false;
  bool _isCheckingToken = true;
  bool _isLoggedIn = false;
  bool _isSignedIn = false;
  bool _isRemembered = false;
  bool _isPasswordVisible = true;

  String _signupEmail = '';
  String _accessToken = '';
  String _refreshToken = '';
  String _id = '';

  int _secondsRemaining = 60;
  String _formattedTime = '01:00';
  Timer? _timer;

  // Exception handling - Centralized
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
  bool get isCheckingToken => _isCheckingToken;
  bool get isLoggedIn => _isLoggedIn;
  bool get isSignedIn => _isSignedIn;
  bool get isRemembered => _isRemembered;
  bool get isPasswordVisible => _isPasswordVisible;
  String get signupEmail => _signupEmail;
  String get accessToken => _accessToken;
  String get refreshToken => _refreshToken;
  String get id => _id;
  int get secondsRemaining => _secondsRemaining;
  String get formattedTime => _formattedTime;
  
  // Exception handling getter
  AppException? get error => _error;
  
  // Backwards compatibility getter (deprecated, will return error message if exists)
  String get errorMessage => _error?.message ?? '';

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
    _isOtpVerified = (value.length == 4);
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
      notifyListeners();
    }
  }

  Future<bool> refreshAccessToken() async {
    final refresh = await ApiService.getRefreshToken();
    if (refresh == null) return false;
    try {
      _setLoading(true);
      final response = await ApiService.post(
        api: ApiConstants.refreshTokenUrl,
        data: {'refresh': refresh},
      );

      if (response != null && response.statusCode == 200) {
        final data = response.data;
        _accessToken = data['access'] as String? ?? data['access_token'] as String;
        _refreshToken = data['refresh'] as String? ?? data['refresh_token'] as String;
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
      _setLoading(false);
    }
  }

  // ── Social sign-in ─────────────────────────────────────────────────────────
  Future<void> signInWithFacebook() async {
    try {
      _setLoading(true);
      final result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success && result.accessToken != null) {
        final credential = FacebookAuthProvider.credential(result.accessToken!.tokenString);
        await FirebaseAuth.instance.signInWithCredential(credential);
      }
    } catch (e) {
      _error = ExceptionHandler.handleException(e);
      notifyListeners();
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
      await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      _error = ExceptionHandler.handleException(e);
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // ── Core auth methods ────────────────────────────────────
  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

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
        
        // Handle DummyJSON vs Real API response keys
        if (ApiConstants.useDummyJson) {
          _accessToken = data['token'] as String? ?? '';
          _refreshToken = data['refreshToken'] as String? ?? '';
          _id = data['id']?.toString() ?? '';
          const verify = 'yes'; // Dummy is always verified
          await ApiService.storeTokens(accessToken: _accessToken, refreshToken: _refreshToken);
          await ApiService.store(key: 'verify', value: verify);
          await ApiService.store(key: 'user_id', value: _id);
          _isLoggedIn = true;
          _isSignedIn = true;
        } else {
          _accessToken = data['access_token'] as String;
          _refreshToken = data['refresh_token'] as String? ?? '';
          _id = data['user_id']?.toString() ?? '';
          final verify = data['verify']?.toString() ?? 'no';
          await ApiService.storeTokens(accessToken: _accessToken, refreshToken: _refreshToken);
          await ApiService.store(key: 'verify', value: verify);
          await ApiService.store(key: 'user_id', value: _id);
          if (verify == 'yes') {
            _isLoggedIn = true;
            _isSignedIn = true;
          } else {
            _go(AppRoutes.otpVerify, extra: 'Login');
          }
        }
        
        showSuccessSnackBar(message: data['message'] ?? 'Login successful');
        notifyListeners();
      } else if (response != null) {
        _error = ExceptionHandler.handleResponse(response);
        notifyListeners();
      }
    } catch (e) {
      _error = ExceptionHandler.handleException(e);
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signup() async {
    final email = signupEmailController.text.trim();
    try {
      _setLoading(true);
      _error = null;
      notifyListeners();

      final response = await ApiService.post(
        api: ApiConstants.signup,
        data: {'email': email},
      );

      // DummyJSON returns 200 for user creation, Real API returns 201
      final isSuccess = response != null && 
          (response.statusCode == 201 || (ApiConstants.useDummyJson && response.statusCode == 200));

      if (isSuccess) {
        _signupEmail = email;
        notifyListeners();
        showSuccessSnackBar(message: response?.data?['message'] ?? 'OTP sent to your email');
        _go(AppRoutes.otpVerify, extra: 'Signup');
      } else if (response != null) {
        _error = ExceptionHandler.handleResponse(response);
        notifyListeners();
      }
    } catch (e) {
      _error = ExceptionHandler.handleException(e);
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> forget() async {
    final email = forgetEmailController.text.trim();
    try {
      _setLoading(true);
      _error = null;
      notifyListeners();

      if (ApiConstants.useDummyJson) {
        await Future.delayed(const Duration(seconds: 1));
        _signupEmail = email;
        notifyListeners();
        showSuccessSnackBar(message: 'Dummy: OTP sent to your email (use 1234)');
        _go(AppRoutes.otpVerify, extra: 'Forget');
        return;
      }

      final response = await ApiService.post(
        api: ApiConstants.forget,
        data: {'email': email},
      );

      if (response != null && response.statusCode == 201) {
        _signupEmail = email;
        notifyListeners();
        showSuccessSnackBar(message: response.data?['message'] ?? 'OTP sent to your email');
        _go(AppRoutes.otpVerify, extra: 'Forget');
      } else if (response != null) {
        _error = ExceptionHandler.handleResponse(response);
        notifyListeners();
      }
    } catch (e) {
      _error = ExceptionHandler.handleException(e);
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> verifyOtp({String? origin}) async {
    final email = _signupEmail;
    final otp = otpController.text.trim();
    try {
      _setLoading(true);
      _error = null;
      notifyListeners();

      if (ApiConstants.useDummyJson) {
        await Future.delayed(const Duration(seconds: 1));
        // Mock success for any 4 digit OTP in dummy mode
        if (otp.length == 4) {
          showSuccessSnackBar(message: 'Dummy: OTP Verified.');
          _isOtpVerified = true;
          notifyListeners();
          if (origin == 'Signup') {
             await setPassword(origin: origin);
          } else {
             _go(AppRoutes.changePass, extra: origin ?? 'Forget');
          }
        } else {
          _error = BadRequestException(message: 'Invalid OTP (use any 4 digits)');
          notifyListeners();
        }
        return;
      }

      final response = await ApiService.post(
        api: ApiConstants.verifyOtp,
        data: {'email': email, 'otp': otp},
      );

      if (response != null && response.statusCode == 200) {
        showSuccessSnackBar(message: 'OTP Verified.');
        _isOtpVerified = true;
        notifyListeners();
        
        if (origin == 'Signup') {
           await setPassword(origin: origin);
        } else {
           _go(AppRoutes.changePass, extra: origin ?? 'Forget');
        }
      } else if (response != null) {
        _error = ExceptionHandler.handleResponse(response);
        notifyListeners();
      }
    } catch (e) {
      _error = ExceptionHandler.handleException(e);
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> resendOtp() async {
    final email = _signupEmail;
    if (email.isEmpty) {
      _error = BadRequestException(message: 'Email for OTP is missing.');
      notifyListeners();
      return;
    }
    try {
      _setLoading(true);
      _error = null;
      notifyListeners();

      if (ApiConstants.useDummyJson) {
        await Future.delayed(const Duration(milliseconds: 500));
        showSuccessSnackBar(message: 'Dummy: OTP resent successfully.');
        startTimer();
        return;
      }

      final response = await ApiService.post(
        api: ApiConstants.resendOtp,
        data: {'email': email},
      );

      if (response != null && response.statusCode == 200) {
        showSuccessSnackBar(message: response.data?['message'] ?? 'OTP resent successfully.');
        startTimer();
      } else if (response != null) {
        _error = ExceptionHandler.handleResponse(response);
        notifyListeners();
      }
    } catch (e) {
      _error = ExceptionHandler.handleException(e);
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> setPassword({String? origin}) async {
    final email = _signupEmail;
    final password = setPasswordController.text;
    try {
      _setLoading(true);
      _error = null;
      notifyListeners();

      if (ApiConstants.useDummyJson) {
        await Future.delayed(const Duration(seconds: 1));
        await ApiService.storeTokens(accessToken: 'dummy_access', refreshToken: 'dummy_refresh');
        await ApiService.store(key: 'verify', value: 'yes');
        _accessToken = 'dummy_access';
        _refreshToken = 'dummy_refresh';
        _isSignedIn = true;
        _isLoggedIn = true;
        notifyListeners();
        showSuccessSnackBar(message: 'Dummy: Password set successfully');
        if (origin == 'Signup') {
           _go(AppRoutes.roleSelection);
        } else {
           _go(AppRoutes.goToHome, extra: origin);
        }
        return;
      }

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

        if (access == null || access.isEmpty) throw Exception('No access token received');

        await ApiService.storeTokens(accessToken: access, refreshToken: refresh ?? '');
        await ApiService.store(key: 'verify', value: verify);
        _accessToken = access;
        _refreshToken = refresh ?? '';
        _isSignedIn = true;
        _isLoggedIn = (verify == 'yes');
        notifyListeners();
        showSuccessSnackBar(message: message);
        await registerFcmToken();

        if (origin == 'Signup') {
           _go(AppRoutes.roleSelection);
        } else {
           _go(AppRoutes.goToHome, extra: origin);
        }
      } else if (response != null) {
        _error = ExceptionHandler.handleResponse(response);
        notifyListeners();
      }
    } catch (e) {
      _error = ExceptionHandler.handleException(e);
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // ── Validation ─────────────────────────────────────────────────────────────
  bool validatePasswords(String newPass, String confirm) {
    if (newPass.isEmpty || confirm.isEmpty) {
      _error = ValidationException(message: 'Passwords cannot be empty');
      notifyListeners();
      return false;
    }
    if (newPass != confirm) {
      _error = ValidationException(message: 'Passwords do not match');
      notifyListeners();
      return false;
    }
    if (newPass.length < 8) {
      _error = ValidationException(message: 'Password must be at least 8 characters');
      notifyListeners();
      return false;
    }
    return true;
  }

  // ── Logout ─────────────────────────────────────────────────────────────────
  Future<void> logout() async {
    try {
      await ApiService.clearTokens();
      clear();
      showSuccessSnackBar(message: 'Logged out successfully');
    } catch (e) {
      _error = ExceptionHandler.handleException(e);
      notifyListeners();
    }
  }

  // ── FCM ────────────────────────────────────────────────────────────────────
  Future<void> registerFcmToken() async {
    try {
      final fcm = await ApiService.getStored(key: 'fcm_token');
      final access = await ApiService.getAccessToken();
      if (fcm == null || access == null) return;

      await ApiService.post(
        api: ApiConstants.registerFcmTokenUrl,
        data: {'fcm_token': fcm},
        auth: true,
      );
    } catch (e) {
      debugPrint('registerFcmToken error: $e');
    }
  }

  // ── Clear ──────────────────────────────────────────────────────────────────
  void clearInputFields() {
    emailController.clear();
    passwordController.clear();
    setPasswordController.clear();
    signupEmailController.clear();
    forgetEmailController.clear();
    otpController.clear();
    _signupEmail = '';
    _isOtpVerified = false;
    _error = null;
    stopTimer();
    _secondsRemaining = 60;
    _formattedTime = '01:00';
    notifyListeners();
  }

  void clear() {
    _accessToken = '';
    _refreshToken = '';
    _id = '';
    _isSignedIn = false;
    _isLoggedIn = false;
    _isRemembered = false;
    _isPasswordVisible = true;
    clearInputFields();
  }

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
