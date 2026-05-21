class ApiConstants {
  static const String _baseUrl =
      'https://cowbird-central-crawdad.ngrok-free.app';
  static const String imageUrl =
      'https://cowbird-central-crawdad.ngrok-free.app';

  /// Returns the full API URL for a given relative path.
  static String getFullUrl(String path) {
    if (path.isEmpty) return _baseUrl;
    if (path.startsWith('http')) return path;
    final cleanPath = path.startsWith('/') ? path : '/$path';
    return '$_baseUrl$cleanPath';
  }

  /// Returns the full Image URL for a given relative path.
  static String getFullImageUrl(String path) {
    if (path.isEmpty) return imageUrl;
    if (path.startsWith('http')) return path;
    final cleanPath = path.startsWith('/') ? path : '/$path';
    return '$imageUrl$cleanPath';
  }

  // Auth & Account Endpoints
  static const String loginUrl = '$_baseUrl/api/accounts/mobile/auth/mobile/';
  static const String verifyOtp = '$_baseUrl/api/accounts/auth/verify-otp/';
  static const String resendOtp =
      '$_baseUrl/api/accounts/mobile/auth/resend-otp/';
  static const String refreshTokenUrl =
      '$_baseUrl/api/accounts/mobile/auth/refresh/';
  static const String signup = '$_baseUrl/user/signup/';
  static const String setPassword = '$_baseUrl/user/signup/set-password/';
  static const String forget = '$_baseUrl/user/forgot-password/';
  static const String signUpGoogleUrl =
      '$_baseUrl/api/accounts/mobile/auth/social-auth/';

  // Profile Endpoints
  static const String getProfileUrl =
      '$_baseUrl/api/accounts/mobile/current-user/';
  static const String updateDriverProfileUrl =
      '$_baseUrl/api/accounts/mobile/profile/update_driver/';
  static const String updateUserProfileUrl =
      '$_baseUrl/api/accounts/mobile/profile/update_user/';
  static const String updateProfileUrl = '$_baseUrl/user/update-profile/';
  static const String fetchProfilesUrl = '$_baseUrl/user/profiles/';
  static const String profilesFilterUrl = '$_baseUrl/profiles/filter/';
  static const String getProfileByIdUrl = '$_baseUrl/user/profile';
  static const String deleteGalleryImageUrl = '$_baseUrl/user/delete-photos';
  static const String dummyImageUrl =
      '$imageUrl/media/user_images/profile_image/Image_3_LDElN57.jpg';

  // Company & Car Endpoints
  static const String companyNameUrl =
      '$_baseUrl/api/accounts/mobile/company-list/';
  static const String employeeRequestsUrl =
      '$_baseUrl/api/accounts/mobile/apply-employee/';
  static const String getCarsUrl = '$_baseUrl/mobile/cars/';
  static const String getDriversUrl = '$_baseUrl/api/accounts/mobile/drivers/';
  static const String getCompanyUrl = '$_baseUrl/mobile/company/';
  static const String createToken = '$_baseUrl/mobile/company/';

  // Chat & Messaging Endpoints
  static const String getMessagesUrl = '$_baseUrl/chat/room';
  static const String getChatsUrl = '$_baseUrl/chat/rooms/';
  static const String createChatRoomUrl = '$_baseUrl/chat/create/';
  static const String sendMessageUrl = '$_baseUrl/chat/room';
  static const String deleteMessageUrl = '$_baseUrl/chat/room';
  static const String registerFcmTokenUrl = '$_baseUrl/fcm/register/';
  static const String respondToInvitationUrl = '$_baseUrl/chat/invitations';
  static const String sendChatInvitationUrl =
      '$_baseUrl/chat/invitations/send/';
  static const String getInvitationsUrl =
      '$_baseUrl/chat/invitations/received/';

  // WebSocket
  static const String webSocketUrl =
      'ws://cumulative-essay-senior-politicians.trycloudflare.com';
}
