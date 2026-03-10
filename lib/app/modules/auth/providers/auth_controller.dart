import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../res/components/api_service.dart';
import '../../../../widgets/show_custom_snackbar.dart';
import '../../home/views/navigation.dart';
import '../views/otp_verify_view.dart';

class AuthController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();
  // final NotificationService _notificationService =
  //     Get.find<NotificationService>();
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final RxBool isOtpVerified = false.obs;
  final RxBool isStorageAvailable = true.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString selectedRole = ''.obs;
  final RxBool isCheckingToken = true.obs;
  final RxBool isLoggedIn = false.obs;
  final RxBool isSignedIn = false.obs;
  final RxString signupEmail = ''.obs;
  final RxString accessToken = ''.obs;
  final RxString refreshToken = ''.obs;
  final RxString id = ''.obs;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController setPasswordController = TextEditingController();
  final TextEditingController signupEmailController = TextEditingController();
  final TextEditingController forgetEmailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final Map<String, String> _inMemoryStorage = {};
  final RxBool toggleNewPassword = false.obs;
  final RxBool toggleConfirmPassword = false.obs;
  final RxString newPassword = ''.obs;
  final RxString confirmPassword = ''.obs;
  final RxBool isRemembered = false.obs;
  var isPasswordVisible = true.obs;

  bool validatePasswords(String newPass, String confirmPass) {
    if (newPass.isEmpty || confirmPass.isEmpty) {
      showCustomSnackBar(
        title: 'Error',
        message: 'Passwords cannot be empty',

        isSuccess: false,
      );
      return false;
    }
    if (newPass != confirmPass) {
      showCustomSnackBar(
        title: 'Error',
        message: 'Passwords do not match',

        isSuccess: false,
      );
      return false;
    }
    if (newPass.length < 8) {
      showCustomSnackBar(
        title: 'Error',
        message: 'Password must be at least 8 characters',

        isSuccess: false,
      );
      return false;
    }
    return true;
  }

  RxInt secondsRemaining = 60.obs;
  RxString formattedTime = '01:00'.obs;
  Timer? _timer;
  void startTimer() {
    stopTimer(); // Cancel existing timer if running
    secondsRemaining.value = 60;
    _updateFormattedTime();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
        _updateFormattedTime();
      } else {
        timer.cancel();
      }
    });
  }

  void _updateFormattedTime() {
    final int minutes = secondsRemaining.value ~/ 60;
    final int seconds = secondsRemaining.value % 60;
    formattedTime.value =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void stopTimer() {
    _timer?.cancel();
  }

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  @override
  void onClose() {
    stopTimer();
    emailController.dispose();
    passwordController.dispose();
    setPasswordController.dispose();
    signupEmailController.dispose();
    forgetEmailController.dispose();
    otpController.dispose();
    super.onClose();
  }

  Future<void> _writeToStorage(String key, String value) async {
    if (isStorageAvailable.value) {
      try {
        await storage.write(key: key, value: value);
        debugPrint('Wrote $key to secure storage: $value');
      } catch (e) {
        debugPrint('Storage write error: $e');
        isStorageAvailable.value = false;
        showCustomSnackBar(
          title: 'Warning',
          message: 'Secure storage unavailable, using in-memory storage',
          isSuccess: false,
        );
        _inMemoryStorage[key] = value;
      }
    } else {
      _inMemoryStorage[key] = value;
      debugPrint('Wrote $key to in-memory storage: $value');
    }
  }

  Future<String?> _readFromStorage(String key) async {
    if (isStorageAvailable.value) {
      try {
        final value = await storage.read(key: key);
        debugPrint('Read $key from secure storage: $value');
        return value;
      } catch (e) {
        debugPrint('Storage read error: $e');
        isStorageAvailable.value = false;
        showCustomSnackBar(
          title: 'Warning',
          message:
              'Failed to read from secure storage, using in-memory storage',
          isSuccess: false,
        );
        return _inMemoryStorage[key];
      }
    } else {
      final value = _inMemoryStorage[key];
      debugPrint('Read $key from in-memory storage: $value');
      return value;
    }
  }

  Future<void> _deleteFromStorage(String key) async {
    if (isStorageAvailable.value) {
      try {
        await storage.delete(key: key);
        debugPrint('Deleted $key from secure storage');
      } catch (e) {
        debugPrint('Storage delete error: $e');
        isStorageAvailable.value = false;
        showCustomSnackBar(
          title: 'Warning',
          message: 'Secure storage unavailable, using in-memory storage',
          isSuccess: false,
        );
        _inMemoryStorage.remove(key);
      }
    } else {
      _inMemoryStorage.remove(key);
      debugPrint('Deleted $key from in-memory storage');
    }
  }

  Future<void> checkLoginStatus() async {
    try {
      isCheckingToken(true);
      final token = await _readFromStorage('access_token');
      final verifyToken = await _readFromStorage('verify');
      debugPrint('Token on app start: $token');
      if (token != null && token.isNotEmpty) {
        accessToken.value = token;
        if (verifyToken == 'yes') {
          isLoggedIn.value = true;
          isSignedIn.value = true;
        } else {
          isLoggedIn.value = false;
          isSignedIn.value = true;
        }
        debugPrint('Valid token found, user is logged in');
      } else {
        isLoggedIn.value = false;
        debugPrint('No valid token found');
      }
    } catch (e, stackTrace) {
      debugPrint('Check login error: $e\nStack trace: $stackTrace');
      isLoggedIn.value = false;
    } finally {
      isCheckingToken(false);
    }
  }

  Future<String?> getAccessToken() async {
    return _readFromStorage('access_token');
  }

  Future<void> storeTokens(String accessToken, String refreshToken) async {
    await storage.write(key: 'access_token', value: accessToken);
    await storage.write(key: 'refresh_token', value: refreshToken);
  }

  Future<bool> refreshAccessToken() async {
    final refresh = await _readFromStorage('refresh_token');
    try {
      final response = await apiService.refreshToken(refresh!);
      if (response['statusCode'] == 200) {
        debugPrint('response __________________ $response');
        final newAccessToken = response['data']['access'];
        final newRefreshToken = response['data']['refresh'];
        await _writeToStorage('access_token', newAccessToken);
        await _writeToStorage('refresh_token', newRefreshToken);
        accessToken.value = newAccessToken;
        refreshToken.value = newRefreshToken;
        debugPrint('New access token: $newAccessToken');
        debugPrint('New refresh token: $newRefreshToken');
        debugPrint('Token refreshed successfully');
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('Error refreshing token: $e');
      return false;
    }
  }
  // String sha256ofString(String input) {
  //   final bytes = utf8.encode(input);
  //   final digest = sha256.convert(bytes);
  //   return digest.toString();
  // }
  // Future<UserCredential> signInWithApple() async {
  //   // To prevent replay attacks with the credential returned from Apple, we
  //   // include a nonce in the credential request. When signing in with
  //   // Firebase, the nonce in the id token returned by Apple, is expected to
  //   // match the sha256 hash of `rawNonce`.
  //   final rawNonce = generateNonce();
  //   final nonce = sha256ofString(rawNonce);
  //
  //   // Request credential for the currently signed in Apple account.
  //   final appleCredential = await SignInWithApple.getAppleIDCredential(
  //     scopes: [
  //       AppleIDAuthorizationScopes.email,
  //       AppleIDAuthorizationScopes.fullName,
  //     ],
  //     nonce: nonce,
  //   );
  //
  //   // Create an `OAuthCredential` from the credential returned by Apple.
  //   final oauthCredential = OAuthProvider("apple.com").credential(
  //     idToken: appleCredential.identityToken,
  //     rawNonce: rawNonce,
  //   );
  //
  //   // Sign in the user with Firebase. If the nonce we generated earlier does
  //   // not match the nonce in `appleCredential.identityToken`, sign in will fail.
  //   return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  // }

  Future<void> signInWithFacebook() async {
    try {
      // String? fcmToken = await _notificationService.getDeviceToken();
      // debugPrint('FCM Token: $fcmToken');
      isLoading.value = true;

      // Trigger the Facebook sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login();

      if (loginResult.status == LoginStatus.success && loginResult.accessToken != null) {
        // Build a credential from the Facebook access token
        final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

        // Sign in with Firebase using the credential
        final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
        final User? user = userCredential.user;

        if (user != null) {
          debugPrint(':::::::::::USER EMAIL::::::::::::::::::::::::::::${user.email}');
          debugPrint(':::::::::::USER NAME::::::::::::::::::::::::::::${user.displayName}');
          debugPrint(':::::::::::USER ID::::::::::::::::::::::::::::${user.uid}');

          // Call signUpWithOther with user's email and FCM token
          // if (user.email != null && fcmToken != null) {
          //   await signUpWithOther(user.email!, fcmToken);
          // } else {
          //   debugPrint('Error: User email or FCM token is null');
          // }
        }
      } else {
        debugPrint('Facebook login failed: ${loginResult.status}');
        debugPrint('Message: ${loginResult.message}');
      }
    } catch (e) {
      debugPrint('Facebook sign-in error: $e');
    } finally {
      isLoading.value = false; // Hide the loading screen
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      // String? fcmToken = await _notificationService.getDeviceToken();
      // debugPrint('FCM Token: $fcmToken');
      isLoading.value = true;
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      final User? user = userCredential.user;

      if (user != null) {
        debugPrint(
          ':::::::::::USER EMAIL::::::::::::::::::::::::::::${user.email}',
        );
        debugPrint(
          ':::::::::::USER NAME::::::::::::::::::::::::::::${user.displayName}',
        );
        debugPrint(':::::::::::USER ID::::::::::::::::::::::::::::${user.uid}');

        // await signUpWithOther(user.email!, fcmToken!);
      }
    } catch (e) {
      debugPrint("Error signing in: $e");
    } finally {
      isLoading.value = false; // Hide the loading screen
    }
  }

  Future<void> signUpWithOther(String email, String fcmToken) async {
    isLoading.value = true;
    // try {
    //   final response = await apiService.signUpWithOther(email, fcmToken);
    //   debugPrint(
    //     ':::::::::::::::RESPONSE:::::::::::::::::::::${response.body.toString()}',
    //   );
    //   debugPrint(
    //     ':::::::::::::::CODE:::::::::::::::::::::${response.statusCode}',
    //   );
    //   debugPrint(
    //     ':::::::::::::::REQUEST:::::::::::::::::::::${response.request}',
    //   );
    //
    //   if (response.statusCode == 200 || response.statusCode == 201) {
    //     final data = jsonDecode(response.body);
    //     final accessToken = data['access_token'] as String?;
    //     final refreshToken = data['refresh_token'] as String?;
    //     final userId = data['user_id'] as int?;
    //     final message = data['message'] ?? 'Login successful';
    //     final verify = data['verify'] ?? 'no';
    //     if (accessToken == null || accessToken.isEmpty) {
    //       throw Exception('No access token received');
    //     }
    //     await _writeToStorage('access_token', accessToken);
    //     await _writeToStorage('refresh_token', refreshToken ?? '');
    //     await _writeToStorage('verify', verify);
    //     await _writeToStorage('user_id', userId.toString());
    //     this.accessToken.value = accessToken;
    //     this.refreshToken.value = refreshToken ?? '';
    //     this.id.value = userId.toString();
    //     debugPrint('Login successful, token: $accessToken');
    //     registerFcmToken();
    //     debugPrint('id: $id');
    //     showCustomSnackBar(title: 'Success', message: message, isSuccess: true);
    //     if (verify == 'yes') {
    //       isLoggedIn.value = true;
    //       // Fetch home data immediately after login
    //       final homeController =
    //           Get.isRegistered<HomeController>()
    //               ? Get.find<HomeController>()
    //               : Get.put(HomeController());
    //       await homeController.fetchProfiles();
    //       Get.offAll(() => Navbar());
    //     } else {
    //       Get.offAllNamed(Routes.onboarding);
    //     }
    //     final prefs = await SharedPreferences.getInstance();
    //     await prefs.setBool('isLoggedIn', true);
    //   } else {
    //     showCustomSnackBar(
    //       title: 'Error',
    //       message:
    //           'Login failed: Sign-up failed\nPlease Use Different Username',
    //       isSuccess: false,
    //     );
    //   }
    // } catch (e, stackTrace) {
    //   debugPrint('Signup error: $e\nStack trace: $stackTrace');
    //   errorMessage.value = 'Error: $e';
    //   showCustomSnackBar(
    //     title: 'Error',
    //     message: 'Signup failed: $e',
    //     isSuccess: false,
    //   );
    // } finally {
    //   isLoading.value = false;
    // }
  }

  Future<void> registerFcmToken() async {
    try {
      final token = await storage.read(key: 'fcm_token');
      if (token == null) {
        debugPrint('FCM token is null');
        return;
      }
      debugPrint('FCM token: $token');
      final accessToken = await storage.read(key: 'access_token');
      if (accessToken == null) {
        debugPrint('Access token not found');
        return;
      }

      ApiService? apiService;
      for (int attempt = 1; attempt <= 3; attempt++) {
        if (Get.isRegistered<ApiService>()) {
          apiService = Get.find<ApiService>();
          debugPrint(
            'ApiService found on attempt $attempt at ${DateTime.now()}',
          );
          break;
        }
        debugPrint(
          'ApiService not found on attempt $attempt. Retrying after 500ms...',
        );
        await Future.delayed(const Duration(milliseconds: 500));
      }

      if (apiService == null) {
        debugPrint(
          'ApiService not found after 3 attempts. Ensure Get.put(ApiService()) is called in main.dart',
        );
        return;
      }

      final response = await apiService.registerFcmToken(
        accessToken: accessToken,
        fcmToken: token,
      );

      if (response['statusCode'] == 200 || response['statusCode'] == 201) {
        debugPrint('FCM token registered: $token');
      } else {
        debugPrint(
          'FCM token registration failed: ${response['data']['detail'] ?? response['data']['message'] ?? 'Status code ${response['statusCode']}'}',
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Error registering FCM token: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    debugPrint('Logging in with email: $email, $password');
    Get.to(() => const Navbar());
    // try {
    //   isLoading(true);
    //   final response = await apiService.login(email, password);
    //   if (response['statusCode'] == 200) {
    //     final data = response['data'];
    //     final accessToken = data['access_token'] as String?;
    //     final refreshToken = data['refresh_token'] as String?;
    //     final userId = data['user_id'] as int?;
    //     final message = data['message'] ?? 'Login successful';
    //     final verify = data['verify'] ?? 'no';
    //     if (accessToken == null || accessToken.isEmpty) {
    //       throw Exception('No access token received');
    //     }
    //     await _writeToStorage('access_token', accessToken);
    //     await _writeToStorage('refresh_token', refreshToken ?? '');
    //     await _writeToStorage('verify', verify);
    //     await _writeToStorage('user_id', userId.toString());
    //     this.accessToken.value = accessToken;
    //     this.refreshToken.value = refreshToken ?? '';
    //     id.value = userId.toString();
    //     debugPrint('Login successful, token: $accessToken');
    //     registerFcmToken();
    //     debugPrint('id: $id');
    //     showCustomSnackBar(title: 'Success', message: message, isSuccess: true);
    //     if (verify == 'yes') {
    //       isLoggedIn.value = true;
    //       // Fetch home data immediately after login
    //       final homeController =
    //           Get.isRegistered<HomeController>()
    //               ? Get.find<HomeController>()
    //               : Get.put(HomeController());
    //       await homeController.fetchProfiles();
    //       Get.offAll(() => Navbar());
    //     } else {
    //       Get.offAllNamed(Routes.onboarding);
    //     }
    //   } else {
    //     final errorMsg =
    //         response['data']['error'] ??
    //         response['data']['message'] ??
    //         'Invalid credentials';
    //     errorMessage.value = errorMsg;
    //     showCustomSnackBar(
    //       title: 'Error',
    //       message: 'Login failed: $errorMsg',
    //
    //       isSuccess: false,
    //     );
    //   }
    // } catch (e, stackTrace) {
    //   debugPrint('Login error: $e\nStack trace: $stackTrace');
    //   errorMessage.value = 'Error: $e';
    //   showCustomSnackBar(
    //     title: 'Error',
    //     message: 'Login failed: $e',
    //
    //     isSuccess: false,
    //   );
    // } finally {
    //   isLoading(false);
    // }
  }

  Future<void> signup() async {
    final email = signupEmailController.text.trim();
    debugPrint('Signing up with email: $email');
    try {
      isLoading(true);
      final response = await apiService.signup(email);
      if (response['statusCode'] == 201) {
        final message = response['data']['message'] ?? 'OTP sent to your email';
        signupEmail.value = email;
        showCustomSnackBar(title: 'Success', message: message, isSuccess: true);
        // Get.to(() => OtpVerifyView(), arguments: {'origin': 'Signup'});
      } else {
        final errorMsg =
            response['data']['error'] ??
            response['data']['message'] ??
            'Signup failed';
        errorMessage.value = errorMsg;
        showCustomSnackBar(
          title: 'Error',
          message: 'Signup failed: $errorMsg',
          isSuccess: false,
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Signup error: $e\nStack trace: $stackTrace');
      errorMessage.value = 'Error: $e';
      showCustomSnackBar(
        title: 'Error',
        message: 'Signup failed: $e',
        isSuccess: false,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> forget() async {
    final email = forgetEmailController.text.trim();
    debugPrint('Forgot password for email: $email');
    // try {
    //   isLoading(true);
    //   final response = await apiService.forget(email);
    //   if (response['statusCode'] == 201) {
    //     final message = response['data']['message'] ?? 'OTP sent to your email';
    //     signupEmail.value = email;
    //     showCustomSnackBar(title: 'Success', message: message, isSuccess: true);
    //     // Get.to(() => const OtpVerifyView(), arguments: {'origin': 'Forget'});
    //   } else {
    //     final errorMsg =
    //         response['data']['error'] ??
    //         response['data']['message'] ??
    //         'Request failed';
    //     errorMessage.value = errorMsg;
    //     showCustomSnackBar(
    //       title: 'Error',
    //       message: 'Request failed: $errorMsg',
    //
    //       isSuccess: false,
    //     );
    //   }
    // } catch (e, stackTrace) {
    //   debugPrint('Forget password error: $e\nStack trace: $stackTrace');
    //   errorMessage.value = 'Error: $e';
    //   showCustomSnackBar(
    //     title: 'Error',
    //     message: 'Request failed: $e',
    //
    //     isSuccess: false,
    //   );
    // } finally {
    //   isLoading(false);
    // }
    Get.to(() => const OtpVerifyView(), arguments: {'origin': 'Forget'});
  }

  void updateOtp(String value) {
    isOtpVerified.value = value.isNotEmpty;
    debugPrint('OTP updated, isOtpVerified: ${isOtpVerified.value}');
  }

  Future<void> verifyOtp() async {
    final email = signupEmail.value;
    final otp = otpController.text.trim();
    debugPrint('Verifying OTP for email: $email, OTP: $otp');
    try {
      isLoading(true);
      final response = await apiService.verifyOtp(email, otp);
      if (response['statusCode'] == 200) {
        showCustomSnackBar(
          title: 'Success',
          message: 'Verified. Now set your password.',

          isSuccess: true,
        );
        final origin = Get.arguments?['origin'] as String?;

        // Get.offAll(
        //   () => const ChangePasswordView(),
        //   transition: Transition.noTransition,
        //   arguments: {'origin': origin ?? 'Signup'},
        // );
      } else {
        final errorMsg =
            response['data']['error'] ??
            response['data']['message'] ??
            'Invalid OTP';
        errorMessage.value = errorMsg;
        showCustomSnackBar(
          title: 'Error',
          message: 'OTP verification failed: $errorMsg',

          isSuccess: false,
        );
      }
    } catch (e, stackTrace) {
      debugPrint('OTP verification error: $e\nStack trace: $stackTrace');
      errorMessage.value = 'Error: $e';
      showCustomSnackBar(
        title: 'Error',
        message: 'OTP verification failed: $e',

        isSuccess: false,
      );
    } finally {
      isLoading(false);
    }
  }

  // Future<void> resendOtp() async {
  //   final email = signupEmail.value;
  //   debugPrint('Resending OTP for email: $email');
  //   try {
  //     isLoading(true);
  //     final response = await apiService.resendOtp(email);
  //     if (response['statusCode'] == 201) {
  //       final message =
  //           response['data']['message'] ?? 'OTP resent successfully';
  //       showCustomSnackBar(title: 'Success', message: message, isSuccess: true);
  //     } else {
  //       final errorMsg =
  //           response['data']['error'] ??
  //           response['data']['message'] ??
  //           'Failed to resend OTP';
  //       errorMessage.value = errorMsg;
  //       showCustomSnackBar(
  //         title: 'Error',
  //         message: 'Failed to resend OTP: $errorMsg',
  //
  //         isSuccess: false,
  //       );
  //     }
  //   } catch (e, stackTrace) {
  //     debugPrint('Resend OTP error: $e\nStack trace: $stackTrace');
  //     errorMessage.value = 'Error: $e';
  //     showCustomSnackBar(
  //       title: 'Error',
  //       message: 'Failed to resend OTP: $e',
  //
  //       isSuccess: false,
  //     );
  //   } finally {
  //     isLoading(false);
  //   }
  // }

  Future<void> setPassword() async {
    final email = signupEmail.value;
    final password = setPasswordController.text;
    debugPrint('Setting password for email: $email');
    try {
      isLoading(true);
      final response = await apiService.setPassword(email, password);
      if (response['statusCode'] == 201) {
        final data = response['data'];
        final accessToken = data['access_token'] as String?;
        final refreshToken = data['refresh_token'] as String?;
        final message = data['message'] ?? 'Password set successfully';
        final verify = data['verify'] ?? 'no';
        if (accessToken == null || accessToken.isEmpty) {
          throw Exception('No access token received');
        }
        await _writeToStorage('access_token', accessToken);
        await _writeToStorage('refresh_token', refreshToken ?? '');
        registerFcmToken();
        this.accessToken.value = accessToken;
        this.refreshToken.value = refreshToken ?? '';
        showCustomSnackBar(title: 'Success', message: message, isSuccess: true);
        isSignedIn.value = true;
        final origin = Get.arguments?['origin'] as String?;
        if (origin == 'Signup' && verify == 'no') {
          // Get.offAllNamed(Routes.onboarding, arguments: {'origin': 'Signup'});
        } else if (origin == 'Forget' && verify == 'yes') {
          // Get.offAll(() => Navbar(), transition: Transition.noTransition);/**/
        }
      } else {
        final errorMsg =
            response['data']['error'] ??
            response['data']['message'] ??
            'Failed to set password';
        errorMessage.value = errorMsg;
        showCustomSnackBar(
          title: 'Error',
          message: 'Failed to set password: $errorMsg',

          isSuccess: false,
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Set password error: $e\nStack trace: $stackTrace');
      errorMessage.value = 'Error: $e';
      showCustomSnackBar(
        title: 'Error',
        message: 'Failed to set password: $e',

        isSuccess: false,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> savePassword() async {
    // Implement password save logic (e.g., API call)
    // Example: Assume success for demonstration
    showCustomSnackBar(
      title: 'Success',
      message: 'Password saved successfully',

      isSuccess: true,
    );
  }

  Future<void> createSubscription(String planId) async {
    final String token = accessToken.value;
    final successUrl = 'https://api.example.com/success';
    final cancelUrl = 'https://api.example.com/cancel';

    if (planId.isEmpty) {
      showCustomSnackBar(
        title: 'Error',
        message: 'Invalid plan selected',
        isSuccess: false,
      );
      return;
    }

    // try {
    //   isLoading(true);
    //   final response = await apiService.createSubscription(
    //     planId,
    //     token,
    //     successUrl,
    //     cancelUrl,
    //   );
    //
    //   if (response['statusCode'] == 200 || response['statusCode'] == 201) {
    //     final checkoutUrl = response['data']['session_url'] as String?;
    //     if (checkoutUrl != null && checkoutUrl.isNotEmpty) {
    //       Get.to(() => WebViewScreen(url: checkoutUrl));
    //     } else {
    //       showCustomSnackBar(
    //         title: 'Error',
    //         message: 'No checkout URL provided',
    //         isSuccess: false,
    //       );
    //       debugPrint('Error: No checkout URL provided');
    //     }
    //     return; // Early return for success case
    //   } else if (response['statusCode'] == 401) {
    //     // Handle 401 Unauthorized - Token refresh logic
    //     final refreshed = await refreshAccessToken();
    //     if (refreshed) {
    //       final newToken = await getAccessToken();
    //       if (newToken == null || newToken.isEmpty) {
    //         showCustomSnackBar(
    //           title: 'Error',
    //           message: 'Failed to get new token after refresh',
    //           isSuccess: false,
    //         );
    //         Get.offAllNamed('/login');
    //         return;
    //       }
    //
    //       // Retry the subscription creation with refreshed token
    //       final retryResponse = await apiService.createSubscription(
    //         planId,
    //         newToken,
    //         successUrl,
    //         cancelUrl,
    //       );
    //
    //       if (retryResponse['statusCode'] == 200 ||
    //           retryResponse['statusCode'] == 201) {
    //         final checkoutUrl =
    //             retryResponse['data']['session_url']
    //                 as String?; // Fixed key to match original
    //         if (checkoutUrl != null && checkoutUrl.isNotEmpty) {
    //           Get.to(() => WebViewScreen(url: checkoutUrl));
    //         } else {
    //           showCustomSnackBar(
    //             title: 'Error',
    //             message: 'No checkout URL provided after token refresh',
    //             isSuccess: false,
    //           );
    //           debugPrint('Error: No checkout URL provided after token refresh');
    //         }
    //       } else if (retryResponse['statusCode'] == 401) {
    //         // Still unauthorized after refresh - force login
    //         showCustomSnackBar(
    //           title: 'Error',
    //           message: 'Session expired. Please log in again.',
    //           isSuccess: false,
    //         );
    //         Get.offAllNamed('/login');
    //       } else {
    //         final errorMsg =
    //             retryResponse['data']['error'] ??
    //             'Failed to create subscription after token refresh';
    //         debugPrint('Retry createSubscription Error: $errorMsg');
    //         showCustomSnackBar(
    //           title: 'Error',
    //           message: errorMsg,
    //           isSuccess: false,
    //         );
    //       }
    //     } else {
    //       // Refresh failed
    //       showCustomSnackBar(
    //         title: 'Error',
    //         message: 'Failed to refresh token. Please log in again.',
    //         isSuccess: false,
    //       );
    //       Get.offAllNamed('/login');
    //     }
    //   } else {
    //     // Handle other non-success status codes
    //     final errorMsg =
    //         response['data']['error'] ?? 'Failed to create subscription';
    //     debugPrint('createSubscription Error: $errorMsg');
    //     showCustomSnackBar(title: 'Error', message: errorMsg, isSuccess: false);
    //   }
    // } catch (e, stackTrace) {
    //   debugPrint('createSubscription Exception: $e\n$stackTrace');
    //   showCustomSnackBar(
    //     title: 'Error',
    //     message: 'Failed to create subscription: $e',
    //     isSuccess: false,
    //   );
    // } finally {
    //   isLoading(false);
    // }
  }

  Future<void> deleteAccount() async {
    debugPrint('Logging out');
    // try {
    //   isLoading(true);
    //   errorMessage('');
    //   final token = await storage.read(key: 'access_token');
    //   if (token == null) {
    //     errorMessage.value =
    //         'Authentication token not found. Please log in again.';
    //     showCustomSnackBar(
    //       title: 'Error',
    //       message: errorMessage.value,
    //       isSuccess: false,
    //     );
    //     Get.offAllNamed('/login');
    //     return;
    //   }

    //   final response = await apiService.accountDelete(token);
    //   debugPrint('Filter Options Response: $response');
    //   if (response['statusCode'] == 200) {
    //     await _deleteFromStorage('access_token');
    //     await _deleteFromStorage('refresh_token');
    //     await _deleteFromStorage('user_id');
    //
    //     // Reset AuthController state
    //     clear();
    //
    //     // Reset MyProfileController state
    //     if (Get.isRegistered<MyProfileController>()) {
    //       final profileController = Get.find<MyProfileController>();
    //       profileController.profile.value = null;
    //       profileController.maritalStatus.value = '';
    //       profileController.id.value = '';
    //       profileController.religion.value = '';
    //       profileController.height.value = '';
    //       profileController.gender.value = '';
    //       profileController.profession.value = '';
    //       profileController.dateOfBirth.value = '';
    //       profileController.name.value = '';
    //       profileController.aboutMe.value = '';
    //       profileController.selectedCity.value = '';
    //       profileController.selectedCountry.value = '';
    //       profileController.selectedEducationLevel.value = '';
    //       profileController.selectedFrame.value = '';
    //       profileController.selectedSmoke.value = '';
    //       profileController.selectedDrinks.value = '';
    //       profileController.selectedFamilyType.value = '';
    //       profileController.selectedMarriageTimeline.value = '';
    //       profileController.selectedRelationshipGoals.clear();
    //       profileController.selectedInterests.clear();
    //       profileController.selectedLanguages.clear();
    //       profileController.selectedFamilyOrigin.clear();
    //       profileController.isBottomSheetOpen.value = false;
    //       profileController.isLoading.value = false;
    //       profileController.isUpdating.value = false;
    //       profileController.errorMessage.value = '';
    //       profileController.isAboutUpdating.value = false;
    //       profileController.isGalleryUpdating.value = false;
    //       profileController.isBasicInfoUpdating.value = false;
    //       profileController.isRelationshipGoalsUpdating.value = false;
    //       profileController.isInterestsUpdating.value = false;
    //       profileController.isLanguagesUpdating.value = false;
    //       profileController.lastProfileFetch = null;
    //     }
    //
    //     // Reset BottomSheetController state
    //     if (Get.isRegistered<BottomSheetController>()) {
    //       final bottomSheetController = Get.find<BottomSheetController>();
    //       bottomSheetController.pickedImage.value = null;
    //       bottomSheetController.pickedImages.clear();
    //       bottomSheetController.isUploading.value = false;
    //       bottomSheetController.errorMessage.value = '';
    //     }
    //
    //     // Reset ChatsController state
    //     if (Get.isRegistered<ChatsController>()) {
    //       final chatsController = Get.find<ChatsController>();
    //       chatsController.messages.clear();
    //       chatsController.message.value = '';
    //       chatsController.isTyping.value = false;
    //       chatsController.textController.clear();
    //       chatsController.isMessageLoading.value = false;
    //       chatsController.isRoomLoading.value = false;
    //       chatsController.isRoomsLoading.value = false;
    //       chatsController.chatError.value = '';
    //       chatsController.roomsError.value = '';
    //       chatsController.roomId.value = null;
    //       chatsController.rooms.clear();
    //       chatsController.isFileUploading.value = false;
    //       chatsController.isRecipientTyping.value = false;
    //       chatsController.isOnline.value = false;
    //       chatsController.isLoadingMessages.value = false;
    //       chatsController.isLoadingMoreMessages.value = false;
    //       chatsController.isSending.value = false;
    //       chatsController.hasMoreMessages.value = true;
    //       chatsController.currentPage.value = 1;
    //       chatsController.pickedImage.value = null;
    //       chatsController.setSelectedTab.value = 'ChatHistory';
    //       chatsController.searchQuery.value = '';
    //       chatsController.selectedTab.value = 'ChatHistory';
    //       chatsController.chats.clear();
    //       chatsController.invitations.clear();
    //       chatsController.names.clear();
    //       chatsController.images.clear();
    //       chatsController.isUserBlocked.value = false;
    //       chatsController.chatRooms.clear();
    //       chatsController.isFetchingChats.value = false;
    //       chatsController.isRecipientOnline.value = false;
    //       chatsController.lastChatsFetch = null;
    //       chatsController.lastInvitationsFetch = null;
    //       chatsController.currentRoomId = null;
    //       chatsController.currentUserId = null;
    //       chatsController.currentRecipientId = null;
    //       chatsController.accessToken = null;
    //       chatsController.myAvatarUrl = null;
    //       chatsController.userAvatarCache.clear();
    //       chatsController.isuserblocked.value = false;
    //       chatsController.scrollController?.dispose();
    //       chatsController.scrollController = null;
    //     }
    //
    //     // Reset HomeController state
    //     if (Get.isRegistered<HomeController>()) {
    //       final homeController = Get.find<HomeController>();
    //       homeController.currentUserProfile.value = Profile(
    //         name: '',
    //         age: 0,
    //         designation: '',
    //         city: '',
    //         country: '',
    //         aboutMe: '',
    //         galleryImages: [],
    //         gender: '',
    //         height: '',
    //         maritalStatus: '',
    //         religion: '',
    //         relationshipGoal: [],
    //         interests: [],
    //         languages: [],
    //         bodyType: '',
    //         educationalLevel: '',
    //         familyType: '',
    //         drinks: '',
    //         smoke: '',
    //         marriageTimeline: '',
    //         imageAsset: '',
    //         familyOrigin: [],
    //       );
    //       homeController.isLoading.value = false;
    //       homeController.errorMessage.value = '';
    //       homeController.filteredProfiles.clear();
    //       homeController.allProfiles.clear();
    //       homeController.minAge.value = 18.0;
    //       homeController.maxAge.value = 80.0;
    //       homeController.minHeight.value = 1.4;
    //       homeController.maxHeight.value = 2.0;
    //       homeController.searchTerm.value = '';
    //       homeController.selectedBodyTypes.clear();
    //       homeController.selectedMaritalStatuses.clear();
    //       homeController.selectedMarriageTimelines.clear();
    //       homeController.selectedEducationalLevels.clear();
    //       homeController.selectedReligions.clear();
    //       homeController.selectedOccupations.clear();
    //       homeController.selectedFamilyTypes.clear();
    //       homeController.selectedDrinks.clear();
    //       homeController.selectedSmoke.clear();
    //       homeController.relationshipGoal.clear();
    //       homeController.isBodyTypeExpanded.value = false;
    //       homeController.isMaritalStatusExpanded.value = false;
    //       homeController.isMarriageTimelineExpanded.value = false;
    //       homeController.isEducationalLevelExpanded.value = false;
    //       homeController.isReligionExpanded.value = false;
    //       homeController.isOccupationExpanded.value = false;
    //       homeController.isFamilyTypeExpanded.value = false;
    //       homeController.isDrinksExpanded.value = false;
    //       homeController.isSmokeExpanded.value = false;
    //       homeController.selectedViewMode.value = 'Triple';
    //       homeController.isFilterApplied.value = false;
    //       homeController.selectedTab.value = 'Basic';
    //       homeController.selectedTab1.value = 'Distance';
    //     }
    //
    //     // Reset ProfileViewController state
    //     if (Get.isRegistered<ProfileViewController>()) {
    //       final profileViewController = Get.find<ProfileViewController>();
    //       profileViewController.profile.value = null;
    //       profileViewController.isLoading.value = true;
    //       profileViewController.errorMessage.value = '';
    //     }
    //
    //     // Reset OnboardingController state
    //     if (Get.isRegistered<OnboardingController>()) {
    //       final onboardingController = Get.find<OnboardingController>();
    //       onboardingController.isLoading.value = false;
    //       onboardingController.errorMessage.value = '';
    //       onboardingController.isselected.value = false;
    //       onboardingController.imagePaths.clear();
    //       onboardingController.selectedName.value = '';
    //       onboardingController.id.value = '';
    //       onboardingController.selectedGender.value = '';
    //       onboardingController.date.value = '';
    //       onboardingController.selectHeight.value = '';
    //       onboardingController.selectedWork.value = '';
    //       onboardingController.selectedFrame.value = '';
    //       onboardingController.selectedOriginsOfCountries.clear();
    //       onboardingController.selectedReligion.value = '';
    //       onboardingController.selectedMarital.value = '';
    //       onboardingController.selectedTimeline.value = '';
    //       onboardingController.selectedDatingGoals.clear();
    //       onboardingController.selectedEducation.value = '';
    //       onboardingController.selectedAbout.value = '';
    //       onboardingController.selectedCountry.value = '';
    //       onboardingController.selectedCity.value = '';
    //       onboardingController.selectedInterests.clear();
    //       onboardingController.selectedLanguages.clear();
    //       onboardingController.selectedSmoke.value = '';
    //       onboardingController.selectedDrinks.value = '';
    //       onboardingController.selectedFamilyType.value = '';
    //       onboardingController.searchTerm.value = '';
    //     }
    //
    //     // Reset SettingsController state
    //     if (Get.isRegistered<SettingsController>()) {
    //       final settingsController = Get.find<SettingsController>();
    //       settingsController.isLoading.value = false;
    //       settingsController.count.value = 0;
    //     }
    //
    //     // Clear shared preferences
    //     final prefs = await SharedPreferences.getInstance();
    //     await prefs.clear();
    //
    //     showCustomSnackBar(
    //       title: 'Success',
    //       message: 'Logged out successfully',
    //       isSuccess: true,
    //     );
    //     Get.offAllNamed(Routes.auth);
    //   } else if (response['statusCode'] == 401) {
    //     final refreshed = await refreshAccessToken();
    //     if (refreshed) {
    //       final newToken = await getAccessToken();
    //       final retryResponse = await apiService.accountDelete(newToken!);
    //       if (retryResponse['statusCode'] == 200) {
    //         await _deleteFromStorage('access_token');
    //         await _deleteFromStorage('refresh_token');
    //         await _deleteFromStorage('user_id');
    //
    //         // Reset AuthController state
    //         clear();
    //
    //         // Reset MyProfileController state
    //         if (Get.isRegistered<MyProfileController>()) {
    //           final profileController = Get.find<MyProfileController>();
    //           profileController.profile.value = null;
    //           profileController.maritalStatus.value = '';
    //           profileController.id.value = '';
    //           profileController.religion.value = '';
    //           profileController.height.value = '';
    //           profileController.gender.value = '';
    //           profileController.profession.value = '';
    //           profileController.dateOfBirth.value = '';
    //           profileController.name.value = '';
    //           profileController.aboutMe.value = '';
    //           profileController.selectedCity.value = '';
    //           profileController.selectedCountry.value = '';
    //           profileController.selectedEducationLevel.value = '';
    //           profileController.selectedFrame.value = '';
    //           profileController.selectedSmoke.value = '';
    //           profileController.selectedDrinks.value = '';
    //           profileController.selectedFamilyType.value = '';
    //           profileController.selectedMarriageTimeline.value = '';
    //           profileController.selectedRelationshipGoals.clear();
    //           profileController.selectedInterests.clear();
    //           profileController.selectedLanguages.clear();
    //           profileController.selectedFamilyOrigin.clear();
    //           profileController.isBottomSheetOpen.value = false;
    //           profileController.isLoading.value = false;
    //           profileController.isUpdating.value = false;
    //           profileController.errorMessage.value = '';
    //           profileController.isAboutUpdating.value = false;
    //           profileController.isGalleryUpdating.value = false;
    //           profileController.isBasicInfoUpdating.value = false;
    //           profileController.isRelationshipGoalsUpdating.value = false;
    //           profileController.isInterestsUpdating.value = false;
    //           profileController.isLanguagesUpdating.value = false;
    //           profileController.lastProfileFetch = null;
    //         }
    //
    //         // Reset BottomSheetController state
    //         if (Get.isRegistered<BottomSheetController>()) {
    //           final bottomSheetController = Get.find<BottomSheetController>();
    //           bottomSheetController.pickedImage.value = null;
    //           bottomSheetController.pickedImages.clear();
    //           bottomSheetController.isUploading.value = false;
    //           bottomSheetController.errorMessage.value = '';
    //         }
    //
    //         // Reset ChatsController state
    //         if (Get.isRegistered<ChatsController>()) {
    //           final chatsController = Get.find<ChatsController>();
    //           chatsController.messages.clear();
    //           chatsController.message.value = '';
    //           chatsController.isTyping.value = false;
    //           chatsController.textController.clear();
    //           chatsController.isMessageLoading.value = false;
    //           chatsController.isRoomLoading.value = false;
    //           chatsController.isRoomsLoading.value = false;
    //           chatsController.chatError.value = '';
    //           chatsController.roomsError.value = '';
    //           chatsController.roomId.value = null;
    //           chatsController.rooms.clear();
    //           chatsController.isFileUploading.value = false;
    //           chatsController.isRecipientTyping.value = false;
    //           chatsController.isOnline.value = false;
    //           chatsController.isLoadingMessages.value = false;
    //           chatsController.isLoadingMoreMessages.value = false;
    //           chatsController.isSending.value = false;
    //           chatsController.hasMoreMessages.value = true;
    //           chatsController.currentPage.value = 1;
    //           chatsController.pickedImage.value = null;
    //           chatsController.setSelectedTab.value = 'ChatHistory';
    //           chatsController.searchQuery.value = '';
    //           chatsController.selectedTab.value = 'ChatHistory';
    //           chatsController.chats.clear();
    //           chatsController.invitations.clear();
    //           chatsController.names.clear();
    //           chatsController.images.clear();
    //           chatsController.isUserBlocked.value = false;
    //           chatsController.chatRooms.clear();
    //           chatsController.isFetchingChats.value = false;
    //           chatsController.isRecipientOnline.value = false;
    //           chatsController.lastChatsFetch = null;
    //           chatsController.lastInvitationsFetch = null;
    //           chatsController.currentRoomId = null;
    //           chatsController.currentUserId = null;
    //           chatsController.currentRecipientId = null;
    //           chatsController.accessToken = null;
    //           chatsController.myAvatarUrl = null;
    //           chatsController.userAvatarCache.clear();
    //           chatsController.isuserblocked.value = false;
    //           chatsController.scrollController?.dispose();
    //           chatsController.scrollController = null;
    //         }
    //
    //         // Reset HomeController state
    //         if (Get.isRegistered<HomeController>()) {
    //           final homeController = Get.find<HomeController>();
    //           homeController.currentUserProfile.value = Profile(
    //             name: '',
    //             age: 0,
    //             designation: '',
    //             city: '',
    //             country: '',
    //             aboutMe: '',
    //             galleryImages: [],
    //             gender: '',
    //             height: '',
    //             maritalStatus: '',
    //             religion: '',
    //             relationshipGoal: [],
    //             interests: [],
    //             languages: [],
    //             bodyType: '',
    //             educationalLevel: '',
    //             familyType: '',
    //             drinks: '',
    //             smoke: '',
    //             marriageTimeline: '',
    //             imageAsset: '',
    //             familyOrigin: [],
    //           );
    //           homeController.isLoading.value = false;
    //           homeController.errorMessage.value = '';
    //           homeController.filteredProfiles.clear();
    //           homeController.allProfiles.clear();
    //           homeController.minAge.value = 18.0;
    //           homeController.maxAge.value = 80.0;
    //           homeController.minHeight.value = 1.4;
    //           homeController.maxHeight.value = 2.0;
    //           homeController.searchTerm.value = '';
    //           homeController.selectedBodyTypes.clear();
    //           homeController.selectedMaritalStatuses.clear();
    //           homeController.selectedMarriageTimelines.clear();
    //           homeController.selectedEducationalLevels.clear();
    //           homeController.selectedReligions.clear();
    //           homeController.selectedOccupations.clear();
    //           homeController.selectedFamilyTypes.clear();
    //           homeController.selectedDrinks.clear();
    //           homeController.selectedSmoke.clear();
    //           homeController.relationshipGoal.clear();
    //           homeController.isBodyTypeExpanded.value = false;
    //           homeController.isMaritalStatusExpanded.value = false;
    //           homeController.isMarriageTimelineExpanded.value = false;
    //           homeController.isEducationalLevelExpanded.value = false;
    //           homeController.isReligionExpanded.value = false;
    //           homeController.isOccupationExpanded.value = false;
    //           homeController.isFamilyTypeExpanded.value = false;
    //           homeController.isDrinksExpanded.value = false;
    //           homeController.isSmokeExpanded.value = false;
    //           homeController.selectedViewMode.value = 'Triple';
    //           homeController.isFilterApplied.value = false;
    //           homeController.selectedTab.value = 'Basic';
    //           homeController.selectedTab1.value = 'Distance';
    //         }
    //
    //         // Reset ProfileViewController state
    //         if (Get.isRegistered<ProfileViewController>()) {
    //           final profileViewController = Get.find<ProfileViewController>();
    //           profileViewController.profile.value = null;
    //           profileViewController.isLoading.value = true;
    //           profileViewController.errorMessage.value = '';
    //         }
    //
    //         // Reset OnboardingController state
    //         if (Get.isRegistered<OnboardingController>()) {
    //           final onboardingController = Get.find<OnboardingController>();
    //           onboardingController.isLoading.value = false;
    //           onboardingController.errorMessage.value = '';
    //           onboardingController.isselected.value = false;
    //           onboardingController.imagePaths.clear();
    //           onboardingController.selectedName.value = '';
    //           onboardingController.id.value = '';
    //           onboardingController.selectedGender.value = '';
    //           onboardingController.date.value = '';
    //           onboardingController.selectHeight.value = '';
    //           onboardingController.selectedWork.value = '';
    //           onboardingController.selectedFrame.value = '';
    //           onboardingController.selectedOriginsOfCountries.clear();
    //           onboardingController.selectedReligion.value = '';
    //           onboardingController.selectedMarital.value = '';
    //           onboardingController.selectedTimeline.value = '';
    //           onboardingController.selectedDatingGoals.clear();
    //           onboardingController.selectedEducation.value = '';
    //           onboardingController.selectedAbout.value = '';
    //           onboardingController.selectedCountry.value = '';
    //           onboardingController.selectedCity.value = '';
    //           onboardingController.selectedInterests.clear();
    //           onboardingController.selectedLanguages.clear();
    //           onboardingController.selectedSmoke.value = '';
    //           onboardingController.selectedDrinks.value = '';
    //           onboardingController.selectedFamilyType.value = '';
    //           onboardingController.searchTerm.value = '';
    //         }
    //
    //         // Reset SettingsController state
    //         if (Get.isRegistered<SettingsController>()) {
    //           final settingsController = Get.find<SettingsController>();
    //           settingsController.isLoading.value = false;
    //           settingsController.count.value = 0;
    //         }
    //
    //         // Clear shared preferences
    //         final prefs = await SharedPreferences.getInstance();
    //         await prefs.clear();
    //
    //         showCustomSnackBar(
    //           title: 'Success',
    //           message: 'Logged out successfully',
    //           isSuccess: true,
    //         );
    //         Get.offAllNamed(Routes.auth);
    //       } else {
    //         errorMessage.value =
    //             retryResponse['data']['detail'] ??
    //             'Failed to fetch filter options after token refresh';
    //         showCustomSnackBar(
    //           title: 'Error',
    //           message: errorMessage.value,
    //           isSuccess: false,
    //         );
    //         Get.offAllNamed('/login');
    //       }
    //     } else {
    //       errorMessage.value = 'Failed to refresh token. Please log in again.';
    //       showCustomSnackBar(
    //         title: 'Error',
    //         message: errorMessage.value,
    //         isSuccess: false,
    //       );
    //       Get.offAllNamed('/login');
    //     }
    //   } else {
    //     errorMessage.value =
    //         response['data']['detail'] ?? 'Failed to fetch filter options';
    //     showCustomSnackBar(
    //       title: 'Error',
    //       message: errorMessage.value,
    //       isSuccess: false,
    //     );
    //   }
    // } catch (e) {
    //   errorMessage.value = 'Error fetching filter options: $e';
    //   debugPrint('Exception in fetchFilterOptions: $e');
    //   showCustomSnackBar(
    //     title: 'Error',
    //     message: errorMessage.value,
    //     isSuccess: false,
    //   );
    // } finally {
    //   isLoading(false);
    // }
  }

  Future<void> logout() async {
    debugPrint('Logging out');

      await _deleteFromStorage('access_token');
    // try {
    //   // Clear secure storage
    //   await _deleteFromStorage('refresh_token');
    //   await _deleteFromStorage('user_id');
    //
    //   // Reset AuthController state
    //   clear();
    //
    //   // Reset MyProfileController state
    //   if (Get.isRegistered<MyProfileController>()) {
    //     final profileController = Get.find<MyProfileController>();
    //     profileController.profile.value = null;
    //     profileController.maritalStatus.value = '';
    //     profileController.id.value = '';
    //     profileController.religion.value = '';
    //     profileController.height.value = '';
    //     profileController.gender.value = '';
    //     profileController.profession.value = '';
    //     profileController.dateOfBirth.value = '';
    //     profileController.name.value = '';
    //     profileController.aboutMe.value = '';
    //     profileController.selectedCity.value = '';
    //     profileController.selectedCountry.value = '';
    //     profileController.selectedEducationLevel.value = '';
    //     profileController.selectedFrame.value = '';
    //     profileController.selectedSmoke.value = '';
    //     profileController.selectedDrinks.value = '';
    //     profileController.selectedFamilyType.value = '';
    //     profileController.selectedMarriageTimeline.value = '';
    //     profileController.selectedRelationshipGoals.clear();
    //     profileController.selectedInterests.clear();
    //     profileController.selectedLanguages.clear();
    //     profileController.selectedFamilyOrigin.clear();
    //     profileController.isBottomSheetOpen.value = false;
    //     profileController.isLoading.value = false;
    //     profileController.isUpdating.value = false;
    //     profileController.errorMessage.value = '';
    //     profileController.isAboutUpdating.value = false;
    //     profileController.isGalleryUpdating.value = false;
    //     profileController.isBasicInfoUpdating.value = false;
    //     profileController.isRelationshipGoalsUpdating.value = false;
    //     profileController.isInterestsUpdating.value = false;
    //     profileController.isLanguagesUpdating.value = false;
    //     profileController.lastProfileFetch = null;
    //   }
    //
    //   // Reset BottomSheetController state
    //   if (Get.isRegistered<BottomSheetController>()) {
    //     final bottomSheetController = Get.find<BottomSheetController>();
    //     bottomSheetController.pickedImage.value = null;
    //     bottomSheetController.pickedImages.clear();
    //     bottomSheetController.isUploading.value = false;
    //     bottomSheetController.errorMessage.value = '';
    //   }
    //
    //   // Reset ChatsController state
    //   if (Get.isRegistered<ChatsController>()) {
    //     final chatsController = Get.find<ChatsController>();
    //     chatsController.messages.clear();
    //     chatsController.message.value = '';
    //     chatsController.isTyping.value = false;
    //     chatsController.textController.clear();
    //     chatsController.isMessageLoading.value = false;
    //     chatsController.isRoomLoading.value = false;
    //     chatsController.isRoomsLoading.value = false;
    //     chatsController.chatError.value = '';
    //     chatsController.roomsError.value = '';
    //     chatsController.roomId.value = null;
    //     chatsController.rooms.clear();
    //     chatsController.isFileUploading.value = false;
    //     chatsController.isRecipientTyping.value = false;
    //     chatsController.isOnline.value = false;
    //     chatsController.isLoadingMessages.value = false;
    //     chatsController.isLoadingMoreMessages.value = false;
    //     chatsController.isSending.value = false;
    //     chatsController.hasMoreMessages.value = true;
    //     chatsController.currentPage.value = 1;
    //     chatsController.pickedImage.value = null;
    //     chatsController.setSelectedTab.value = 'ChatHistory';
    //     chatsController.searchQuery.value = '';
    //     chatsController.selectedTab.value = 'ChatHistory';
    //     chatsController.chats.clear();
    //     chatsController.invitations.clear();
    //     chatsController.names.clear();
    //     chatsController.images.clear();
    //     chatsController.isUserBlocked.value = false;
    //     chatsController.chatRooms.clear();
    //     chatsController.isFetchingChats.value = false;
    //     chatsController.isRecipientOnline.value = false;
    //     chatsController.lastChatsFetch = null;
    //     chatsController.lastInvitationsFetch = null;
    //     chatsController.currentRoomId = null;
    //     chatsController.currentUserId = null;
    //     chatsController.currentRecipientId = null;
    //     chatsController.accessToken = null;
    //     chatsController.myAvatarUrl = null;
    //     chatsController.userAvatarCache.clear();
    //     chatsController.isuserblocked.value = false;
    //     chatsController.scrollController?.dispose();
    //     chatsController.scrollController = null;
    //   }
    //
    //   // Reset HomeController state
    //   if (Get.isRegistered<HomeController>()) {
    //     final homeController = Get.find<HomeController>();
    //     homeController.currentUserProfile.value = Profile(
    //       name: '',
    //       age: 0,
    //       designation: '',
    //       city: '',
    //       country: '',
    //       aboutMe: '',
    //       galleryImages: [],
    //       gender: '',
    //       height: '',
    //       maritalStatus: '',
    //       religion: '',
    //       relationshipGoal: [],
    //       interests: [],
    //       languages: [],
    //       bodyType: '',
    //       educationalLevel: '',
    //       familyType: '',
    //       drinks: '',
    //       smoke: '',
    //       marriageTimeline: '',
    //       imageAsset: '',
    //       familyOrigin: [],
    //     );
    //     homeController.isLoading.value = false;
    //     homeController.errorMessage.value = '';
    //     homeController.filteredProfiles.clear();
    //     homeController.allProfiles.clear();
    //     homeController.minAge.value = 18.0;
    //     homeController.maxAge.value = 80.0;
    //     homeController.minHeight.value = 1.4;
    //     homeController.maxHeight.value = 2.0;
    //     homeController.searchTerm.value = '';
    //     homeController.selectedBodyTypes.clear();
    //     homeController.selectedMaritalStatuses.clear();
    //     homeController.selectedMarriageTimelines.clear();
    //     homeController.selectedEducationalLevels.clear();
    //     homeController.selectedReligions.clear();
    //     homeController.selectedOccupations.clear();
    //     homeController.selectedFamilyTypes.clear();
    //     homeController.selectedDrinks.clear();
    //     homeController.selectedSmoke.clear();
    //     homeController.relationshipGoal.clear();
    //     homeController.isBodyTypeExpanded.value = false;
    //     homeController.isMaritalStatusExpanded.value = false;
    //     homeController.isMarriageTimelineExpanded.value = false;
    //     homeController.isEducationalLevelExpanded.value = false;
    //     homeController.isReligionExpanded.value = false;
    //     homeController.isOccupationExpanded.value = false;
    //     homeController.isFamilyTypeExpanded.value = false;
    //     homeController.isDrinksExpanded.value = false;
    //     homeController.isSmokeExpanded.value = false;
    //     homeController.selectedViewMode.value = 'Triple';
    //     homeController.isFilterApplied.value = false;
    //     homeController.selectedTab.value = 'Basic';
    //     homeController.selectedTab1.value = 'Distance';
    //   }
    //
    //   // Reset ProfileViewController state
    //   if (Get.isRegistered<ProfileViewController>()) {
    //     final profileViewController = Get.find<ProfileViewController>();
    //     profileViewController.profile.value = null;
    //     profileViewController.isLoading.value = true;
    //     profileViewController.errorMessage.value = '';
    //   }
    //
    //   // Reset OnboardingController state
    //   if (Get.isRegistered<OnboardingController>()) {
    //     final onboardingController = Get.find<OnboardingController>();
    //     onboardingController.isLoading.value = false;
    //     onboardingController.errorMessage.value = '';
    //     onboardingController.isselected.value = false;
    //     onboardingController.imagePaths.clear();
    //     onboardingController.selectedName.value = '';
    //     onboardingController.id.value = '';
    //     onboardingController.selectedGender.value = '';
    //     onboardingController.date.value = '';
    //     onboardingController.selectHeight.value = '';
    //     onboardingController.selectedWork.value = '';
    //     onboardingController.selectedFrame.value = '';
    //     onboardingController.selectedOriginsOfCountries.clear();
    //     onboardingController.selectedReligion.value = '';
    //     onboardingController.selectedMarital.value = '';
    //     onboardingController.selectedTimeline.value = '';
    //     onboardingController.selectedDatingGoals.clear();
    //     onboardingController.selectedEducation.value = '';
    //     onboardingController.selectedAbout.value = '';
    //     onboardingController.selectedCountry.value = '';
    //     onboardingController.selectedCity.value = '';
    //     onboardingController.selectedInterests.clear();
    //     onboardingController.selectedLanguages.clear();
    //     onboardingController.selectedSmoke.value = '';
    //     onboardingController.selectedDrinks.value = '';
    //     onboardingController.selectedFamilyType.value = '';
    //     onboardingController.searchTerm.value = '';
    //   }
    //
    //   // Reset SettingsController state
    //   if (Get.isRegistered<SettingsController>()) {
    //     final settingsController = Get.find<SettingsController>();
    //     settingsController.isLoading.value = false;
    //     settingsController.count.value = 0;
    //   }
    //
    //   // Clear shared preferences
    //   final prefs = await SharedPreferences.getInstance();
    //   await prefs.clear();
    //
    //   showCustomSnackBar(
    //     title: 'Success',
    //     message: 'Logged out successfully',
    //     isSuccess: true,
    //   );
    //   Get.offAllNamed(Routes.auth);
    // } catch (e, stackTrace) {
    //   debugPrint('Logout error: $e\nStack trace: $stackTrace');
    //   showCustomSnackBar(
    //     title: 'Error',
    //     message: 'Failed to logout: $e',
    //     isSuccess: false,
    //   );
    // }
  }

  void clear() {
    signupEmail.value = '';
    accessToken.value = '';
    refreshToken.value = '';
    id.value = '';
    isOtpVerified.value = false;
    isSignedIn.value = false;
    errorMessage.value = '';
    isLoggedIn.value = false;
    newPassword.value = '';
    confirmPassword.value = '';
    toggleNewPassword.value = false;
    toggleConfirmPassword.value = false;
    isRemembered.value = false;
    isPasswordVisible.value = true;
    stopTimer();
    secondsRemaining.value = 60;
    formattedTime.value = '01:00';
    emailController.clear();
    passwordController.clear();
    setPasswordController.clear();
    signupEmailController.clear();
    forgetEmailController.clear();
    otpController.clear();
    debugPrint('Cleared AuthController state');
  }
}
