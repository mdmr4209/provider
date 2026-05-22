class ApiConstants {
  // Toggle this to switch between real and dummy APIs
  static const bool useDummyJson = true;

  static const String _baseUrl = useDummyJson 
      ? 'https://dummyjson.com'
      : 'https://cowbird-central-crawdad.ngrok-free.app';
      
  static const String imageUrl = 'https://cowbird-central-crawdad.ngrok-free.app';

  /// Returns the full API URL for a given relative path.
  static String getFullUrl(String path) {
    if (path.isEmpty) return _baseUrl;
    if (path.startsWith('http')) return path;
    final cleanPath = path.startsWith('/') ? path : '/$path';
    return '$_baseUrl$cleanPath';
  }

  // Auth & Account Endpoints
  static const String loginUrl = useDummyJson 
      ? 'https://dummyjson.com/auth/login' 
      : '$_baseUrl/api/accounts/mobile/auth/mobile/';

  static const String signup = useDummyJson 
      ? 'https://dummyjson.com/users/add' 
      : '$_baseUrl/user/signup/';

  // DummyJSON doesn't have these, keeping placeholders or mapping to valid test routes
  static const String verifyOtp = '$_baseUrl/api/accounts/auth/verify-otp/';
  static const String resendOtp = '$_baseUrl/api/accounts/mobile/auth/resend-otp/';
  static const String refreshTokenUrl = useDummyJson 
      ? 'https://dummyjson.com/auth/refresh' 
      : '$_baseUrl/api/accounts/mobile/auth/refresh/';
  static const String setPassword = '$_baseUrl/user/signup/set-password/';
  static const String forget = '$_baseUrl/user/forgot-password/';
  static const String signUpGoogleUrl = '$_baseUrl/api/accounts/mobile/auth/social-auth/';

  // Profile Endpoints
  static const String getProfileUrl = useDummyJson 
      ? 'https://dummyjson.com/auth/me' 
      : '$_baseUrl/api/accounts/mobile/current-user/';
      
  static const String updateProfileUrl = '$_baseUrl/user/update-profile/';
  static const String dummyImageUrl = '$imageUrl/media/user_images/profile_image/Image_3_LDElN57.jpg';

  // Chat & Messaging Endpoints (Placeholders)
  static const String registerFcmTokenUrl = '$_baseUrl/fcm/register/';
}
