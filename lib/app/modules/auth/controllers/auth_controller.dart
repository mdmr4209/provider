import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Removed: import '../../../../res/components/api_service.dart';
import '../../../../res/components/base_client.dart';
import '../../../../res/app_url/app_url.dart'; // Import Api for URLs
import '../../../../widgets/snack_bar_helper.dart';
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
      _setLoading(true); // Added loading state for refresh
      final response = await BaseClient.post(
        api: Api.refreshTokenUrl,
        data: {'refresh': refresh},
      );

      if (response != null && response.statusCode == 200) {
        final data = response.data;
        _accessToken = data['access'] as String? ?? data['access_token'] as String;
        _refreshToken = data['refresh'] as String? ?? data['refresh_token'] as String;
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
      final response = await BaseClient.post(
        api: Api.loginUrl,
        data: {'email': email, 'password': password},
      );

      if (response != null && response.statusCode == 200) {
        final data = response.data;
        _accessToken = data['access_token'] as String;
        _refreshToken = data['refresh_token'] as String? ?? '';
        _id = data['user_id']?.toString() ?? '';
        final verify = data['verify']?.toString() ?? 'no';
        final message = data['message'] ?? 'Login successful';

        await BaseClient.storeTokens(
            accessToken: _accessToken, refreshToken: _refreshToken);
        await BaseClient.store(key: 'verify', value: verify);
        await BaseClient.store(key: 'user_id', value: _id);

        showSuccessSnackBar(message: message);

        if (verify == 'yes') {
          _isLoggedIn = true;
          _isSignedIn = true; // Also set isSignedIn on successful login
          notifyListeners(); // GoRouter redirect → /home
        } else {
          // If not verified, maybe redirect to OTP or a verification screen
          _go(AppRoutes.otpVerify, extra: 'Login'); // Assuming OTP verification is next
        }
      } else {
        // Error message already shown by BaseClient's interceptor
        _errorMessage = response?.data?['error']?.toString() ?? response?.data?['message']?.toString() ?? 'Invalid credentials';
        notifyListeners();
      }
    } catch (e) {
      debugPrint('login error: $e');
      // SnackBar already shown by BaseClient's _handleDioError or _processResponse
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signup() async {
    final email = signupEmailController.text.trim();
    debugPrint('signup: $email');
    try {
      _setLoading(true);
      final response = await BaseClient.post(
        api: Api.signup,
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
        _errorMessage = response?.data?['error']?.toString() ?? response?.data?['message']?.toString() ?? 'Signup failed';
        notifyListeners();
      }
    } catch (e) {
      debugPrint('signup error: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> forget() async {
    final email = forgetEmailController.text.trim();
    debugPrint('forget: $email');
    try {
      _setLoading(true);
      final response = await BaseClient.post(
        api: Api.forget,
        data: {'email': email},
      );

      if (response != null && response.statusCode == 201) {
        _signupEmail = email;
        notifyListeners();
        showSuccessSnackBar(message: response.data?['message'] ?? 'OTP sent to your email');
        _go(AppRoutes.otpVerify, extra: 'Forget');
      } else {
        _errorMessage = response?.data?['error']?.toString() ?? response?.data?['message']?.toString() ?? 'Request failed';
        notifyListeners();
        // Even on failure, if the server indicates OTP sent (or a client side error preventing it), still navigate.
        // This is a design choice; if strict failure means no navigation, remove this line.
        _go(AppRoutes.otpVerify, extra: 'Forget');
      }
    } catch (e) {
      debugPrint('forget error: $e');
      _go(AppRoutes.otpVerify, extra: 'Forget'); // Still navigate to OTP view to give user a chance to input OTP
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
      final response = await BaseClient.post(
        api: Api.verifyOtp,
        data: {'email': email, 'otp': otp},
      );

      if (response != null && response.statusCode == 200) {
        showSuccessSnackBar(message: 'OTP Verified. Now set your password.');
        _isOtpVerified = true; // Mark OTP as verified
        notifyListeners();
        _go(AppRoutes.changePass, extra: origin ?? 'Signup');
      } else {
        _errorMessage = response?.data?['error']?.toString() ?? response?.data?['message']?.toString() ?? 'Invalid OTP';
        notifyListeners();
      }
    } catch (e) {
      debugPrint('verifyOtp error: $e');
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
      final response = await BaseClient.post(
        api: Api.resendOtp,
        data: {'email': email},
      );

      if (response != null && response.statusCode == 200) {
        showSuccessSnackBar(message: response.data?['message'] ?? 'OTP resent successfully.');
        startTimer(); // Restart the timer
      } else {
        _errorMessage = response?.data?['error']?.toString() ?? response?.data?['message']?.toString() ?? 'Failed to resend OTP.';
        notifyListeners();
      }
    } catch (e) {
      debugPrint('resendOtp error: $e');
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
      final response = await BaseClient.post(
        api: Api.setPassword,
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

        await BaseClient.storeTokens(
          accessToken: access,
          refreshToken: refresh ?? '',
        );
        await BaseClient.store(key: 'verify', value: verify);
        _accessToken = access;
        _refreshToken = refresh ?? '';
        _isSignedIn = true;
        _isLoggedIn = verify == 'yes'; // Update isLoggedIn based on verification
        notifyListeners();
        showSuccessSnackBar(message: message);
        await registerFcmToken(); // Register FCM after setting password and logging in

        if (origin == 'Signup') {
          _go(AppRoutes.home); // Assuming home is the next step after signup & set password
        } else if (origin == 'Forget') {
          _isLoggedIn = true; // If forget and set password, they are logged in
          notifyListeners();
          _go(AppRoutes.home);
        } else {
          // Default navigation if origin is not specified
          _go(AppRoutes.home);
        }
      } else {
        _errorMessage = response?.data?['error']?.toString() ?? response?.data?['message']?.toString() ?? 'Failed to set password';
        notifyListeners();
      }
    } catch (e) {
      debugPrint('setPassword error: $e');
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
      
      final response = await BaseClient.post(
        api: Api.registerFcmTokenUrl,
        data: {
          'fcm_token': fcm,
        },
        auth: true, // This endpoint requires authentication
      );

      if (response != null && response.statusCode == 200) {
         debugPrint('FCM register successful: ${response.statusCode}');
      } else {
         debugPrint('FCM register failed: ${response?.statusCode} - ${response?.data}');
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
