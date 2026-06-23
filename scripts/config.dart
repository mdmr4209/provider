import 'dart:io';

void main(List<String> args) async {
  if (args.isEmpty) {
    printUsage();
    exit(1);
  }

  final command = args[0];

  if (command == 'init') {
    await initProject();
  } else if (command == 'generate' || command == 'g') {
    if (args.length < 3) {
      print("[ERROR] Missing arguments for generate.");
      print("Usage: dart scripts/config.dart generate <role> <feature_name>");
      exit(1);
    }
    final role = args[1];
    final featureName = args[2];
    scaffoldFeature(role, featureName);
  } else {
    print("[ERROR] Unknown command: $command");
    printUsage();
    exit(1);
  }
}

void printUsage() {
  print("""
🚀 Flutter Boilerplate CLI (config.dart)

Available Commands:
  init                           Initializes the project with core folders, dependencies, and routing.
                                 Usage: dart scripts/config.dart init

  generate <role> <feature>      Generates a new feature (View, Model, Controller) and adds the route.
                                 Aliases: g
                                 Usage: dart scripts/config.dart generate shared auth
""");
}

// ==========================================
// 1. INIT COMMAND
// ==========================================
Future<void> initProject() async {
  print("🚀 Initializing Flutter Boilerplate...");

  print("📦 Updating pubspec.yaml with dependencies...");
  final pubspecFile = File('pubspec.yaml');
  if (pubspecFile.existsSync()) {
    List<String> lines = pubspecFile.readAsLinesSync();

    // Helper to add dependency
    void addDep(String name, String version, bool isDev) {
      String target = isDev ? 'dev_dependencies:' : 'dependencies:';
      int idx = lines.indexWhere((line) => line.trim() == target);
      if (idx != -1) {
        if (!lines.any((line) => line.trim().startsWith(name + ':'))) {
          lines.insert(idx + 1, '  $name: $version');
        }
      }
    }

    // Core UI/State
    addDep('provider', '^6.1.1', false);
    addDep('go_router', '^13.2.0', false);
    addDep('flutter_screenutil', '^5.9.0', false);
    addDep('flutter_svg', '^2.0.10', false);
    addDep('cupertino_icons', '^1.0.6', false);
    addDep('pin_code_fields', '^8.0.1', false);

    // Networking
    addDep('dio', '^5.4.0', false);
    addDep('http', '^1.2.0', false);
    addDep('http_parser', '^4.0.2', false);

    // Storage / Cache / Pickers
    addDep('flutter_secure_storage', '^9.0.0', false);
    addDep('shared_preferences', '^2.2.2', false);
    addDep('file_picker', '^6.1.1', false);
    addDep('image_picker', '^1.0.7', false);
    addDep('cached_network_image', '^3.3.1', false);

    // Utils
    addDep('intl', '^0.19.0', false);
    addDep('permission_handler', '^11.3.0', false);

    // Firebase / Auth
    addDep('firebase_core', '^4.0.0', false);
    addDep('firebase_auth', '6.0.1', false);
    addDep('google_sign_in', '^6.2.1', false);
    addDep('flutter_facebook_auth', '^7.1.2', false);

    // Dev Dependencies
    addDep('flutter_native_splash', '^2.4.0', true);
    addDep('rename', '^3.0.2', true);

    pubspecFile.writeAsStringSync(lines.join('\n'));
    print("✅ pubspec.yaml updated! Please remember to run: flutter pub get");
  }

  final libPath = Directory('${Directory.current.path}/lib');
  if (!libPath.existsSync()) {
    libPath.createSync();
  }

  print("📂 Creating core directories...");
  final corePath = Directory('${libPath.path}/core');

  File('${corePath.path}/constants/api_constants.dart')
    ..createSync(recursive: true)
    ..writeAsStringSync(r"""class ApiConstants {
  // Toggle this to switch between real and dummy APIs
  static const bool useDummyJson = true;

  static const String _baseUrl = useDummyJson
      ? 'https://dummyjson.com'
      : 'https://cowbird-central-crawdad.ngrok-free.app';

  static const String imageUrl =
      'https://cowbird-central-crawdad.ngrok-free.app';

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
  static const String verifyOtp = useDummyJson
      ? 'https://dummyjson.com/users/verify-otp'
      : '$_baseUrl/api/accounts/auth/verify-otp/';
  static const String resendOtp =
      '$_baseUrl/api/accounts/mobile/auth/resend-otp/';
  static const String refreshTokenUrl = useDummyJson
      ? 'https://dummyjson.com/auth/refresh'
      : '$_baseUrl/api/accounts/mobile/auth/refresh/';
  static const String setPassword = '$_baseUrl/user/signup/set-password/';
  static const String forget = '$_baseUrl/user/forgot-password/';
  static const String signUpGoogleUrl =
      '$_baseUrl/api/accounts/mobile/auth/social-auth/';

  // Profile Endpoints
  static const String getProfileUrl = useDummyJson
      ? 'https://dummyjson.com/auth/me'
      : '$_baseUrl/api/accounts/mobile/current-user/';

  static const String updateProfileUrl = '$_baseUrl/user/update-profile/';
  static const String dummyImageUrl =
      '$imageUrl/media/user_images/profile_image/Image_3_LDElN57.jpg';

  // Chat & Messaging Endpoints (Placeholders)
  static const String registerFcmTokenUrl = '$_baseUrl/fcm/register/';
}
""");

  File('${corePath.path}/constants/app_assets.dart')
    ..createSync(recursive: true)
    ..writeAsStringSync(r"""class AppAssets {
  // ── Core Branding ──────────────────────────────────────────────────────────
  static const String logo = 'assets/images/logo2.png';
  static const String logoImg = 'assets/images/logo.png';
  static const String splash = 'assets/images/splash.png';
  static const String title = 'assets/image/title.svg';
  static const String sb2Logo = 'assets/images/logo2.png'; // Using logo2 as the SB2 circle logo
  static const String sb1Logo = 'assets/images/logo1.png'; // Using logo2 as the SB2 circle logo

  // ── Navigation Icons (SVG) ────────────────────────────────────────────────
  static const String home = 'assets/icons/home.svg';
  static const String circle = 'assets/icons/circle.svg';
  static const String coach = 'assets/icons/coach.svg';
  static const String inbox = 'assets/icons/inbox.svg';
  static const String profile = 'assets/icons/profile.svg';
  static const String board = 'assets/icons/board.svg';
  static const String settings = 'assets/icons/settings.svg';

  // ── Home Dashboard Icons (SVG) ─────────────────────────────────────────────
  static const String notify = 'assets/icons/notification.svg';
  static const String reset = 'assets/icons/reset.svg';
  static const String feather = 'assets/icons/feather.svg';
  static const String journal = 'assets/icons/journal.svg';

  // ── Authentication ─────────────────────────────────────────────────────────
  static const String email = 'assets/icons/email.svg';
  static const String google = 'assets/icons/ggl.svg';
  static const String pass = 'assets/icons/pass.svg';
  static const String apple = 'assets/icons/auth/apple.svg';
  static const String facebook = 'assets/icons/auth/facebook.svg';
  static const String line = 'assets/icons/auth/Line.svg';

  // ── Backgrounds ────────────────────────────────────────────────────────────
  static const String background = 'assets/image/bg.png';
  static const String bgMain = 'assets/images/bg_main.png';
  static const String background1 = 'assets/images/bg1.png';
  static const String bgHome = 'assets/images/bgHome.png';
  static const String bgSplash = 'assets/images/bgSplash.png';
  static const String bgJournal = 'assets/images/bgJournal.png';
  static const String circleBg = 'assets/images/circle.png';

  // ── General / UI ───────────────────────────────────────────────────────────
  static const String cart = 'assets/image/cart.svg';
  static const String wishlist = 'assets/image/wishlist.svg';
  static const String selected = 'assets/image/selected.svg';
  static const String filter = 'assets/image/filter.svg';
  static const String banner = 'assets/image/img_2.png';
  static const String addReview = 'assets/image/addReview.png';
  static const String points = 'assets/image/points.svg';
  static const String trackOrder = 'assets/image/trackOrder.svg';
  static const String promoCode = 'assets/image/promoCode.svg';
  static const String address = 'assets/image/address.svg';
  static const String paymentMethod = 'assets/image/paymentMethod.svg';
  static const String orderHistory = 'assets/image/orderHistory.svg';
  static const String logout = 'assets/image/logout.svg';
  static const String camera = 'assets/image/camera.svg';
  static const String home2 = 'assets/image/home2.svg';
  static const String top = 'assets/images/top.png';
  static const String win = 'assets/images/win.png';
  static const String paySuccess = 'assets/images/paySuccess.png';


  // ── Circle flow, Group , Friends connection───────────────────────────────────────────────────────────
  static const String anno = 'assets/icons/anno.svg';
  static const String block = 'assets/icons/block.svg';
  static const String clap = 'assets/icons/clap.svg';
  static const String comment = 'assets/icons/comment.svg';
  static const String delete = 'assets/icons/delete.svg';
  static const String edit = 'assets/icons/edit.svg';
  static const String freeGroup = 'assets/icons/freeGroup.svg';
  static const String group = 'assets/icons/group.svg';
  static const String image = 'assets/icons/image.svg';
  static const String invite = 'assets/icons/invite.svg';
  static const String leave = 'assets/icons/leave.svg';
  static const String like = 'assets/icons/like.svg';
  static const String menu = 'assets/icons/menu.svg';
  static const String play = 'assets/icons/play.svg';
  static const String remove = 'assets/icons/remove.svg';
  static const String reportMenu = 'assets/icons/reportMenu.svg';
  static const String search = 'assets/icons/search.svg';
  static const String see = 'assets/icons/see.svg';
  static const String send = 'assets/icons/send.svg';
  static const String shareMenu = 'assets/icons/share.png';
  static const String shareMenu1 = 'assets/icons/share.png';
  static const String unfollow = 'assets/icons/unfollow.svg';
  static const String unlock = 'assets/icons/unlock.svg';
  static const String video = 'assets/icons/video.svg';
  static const String view = 'assets/icons/view.svg';
  static const String addBid = 'assets/icons/addBid.svg';
  static const String missedCall = 'assets/icons/missedCall.svg';
  static const String availableNotify = 'assets/icons/availableNotify.svg';
  static const String circleIcon = 'assets/icons/circleIcon.svg';
  static const String lock = 'assets/icons/lock.svg';
  static const String icon1 = 'assets/icons/1.svg';
  static const String icon2 = 'assets/icons/2.svg';
  static const String icon3 = 'assets/icons/3.svg';
  static const String icon4 = 'assets/icons/4.svg';
  static const String icon5 = 'assets/icons/5.svg';
  static const String dailyRaffle = 'assets/icons/dailyRaffle.svg';
  static const String ticket = 'assets/icons/ticket.svg';
  static const String copy = 'assets/icons/copy.svg';
  static const String balance = 'assets/icons/balance.svg';
  // static const String  = 'assets/icons/.svg';

}
""");

  File('${corePath.path}/constants/app_colors.dart')
    ..createSync(recursive: true)
    ..writeAsStringSync(r"""import 'dart:ui';
import 'package:flutter/material.dart';

class AppColors {
  static const Color whiteLiteColor = Color(0xFFBABABA);
  static const Color blackLiteColor = Color(0xFF31432F);
  static const Color defaultColor = Color(0xFF22331F);
  static const Color defaultColorLight = Color(0xFF4A6741);
  static const Color defaultColorAlpha2 = Color(0xFF1F3A2F);
  static const Color secondaryColorLight = Color(0xFFFFD258);
  static const Color backgroundColor = Color(0xFF2D3D2A);
  static const Color defaultLightColor = Color(0xFFFFD7E3);
  static const Color ratingColor = Color(0xFFCFC819);
  static const Color ratingColor2 = Color(0xFFFFBE00);
  static const Color primaryColor = Color(0xFFAC823A);
  static const Color iconColor = Color(0xFFC9A84C);
  static const Color popupBackgroundColor = Color(0xFF20341F);

  static const Color textColor = Color(0xFFDAE0DA);
  static const Color textColor2 = Color(0xFF8CA08B);
  static const Color textColor3 = Color(0xFFFFBE3D);
  static const Color whiteTextColor = Color(0xFFEEEEEE);
  static const Color indicatorColor = Color(0xFFF4CED3);
  static const Color hintTextColor = Color(0xFFA9A8A8);
  static const Color buttonColor = Color(0xFFAC823A);
  static const Color buttonColor3 = Color(0xFF434928);
  static const Color buttonColor4 = Color(0xBA384737);
  static const Color buttonShadowColor4 = Color(0x2B000000);
  static const Color buttonBorderColor4 = Color(0x66EBEBEB);
  static const Color containerColor = Color(0xFFFAF9FF);
  static const Color containerColor2 = Color(0xFFF5F5F5);
  static const Color cardBorderColor = Color(0xFFE8E8E8);

  static const Color greyColor = Color(0xFF828282);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color defaultColorAlpha = Color(0xFF334931);
  static const Color postCardColor = Color(0xFF20311D);
  static const Color commentCardColor = Color(0xFF263923);
  static const Color blackColor = Color(0xFF000000);
  static const Color redColor = Color(0xFFFF0000);
  static const Color greenColor = Color(0xFF00824B);
  static const Color lightGrey = Color(0xFFE0E0E0);

  static const Color warningColor = Color(0xFFFF710B);

  static const Color yellowColor = Color(0xFFEEA100);
  static const Color defaultColor1 = Color(0x4D0B2088);
  static const Color redAlphaColor = Color(0xFFF44336);
  static const Color black20Color = Color(0x33000000);
  static const Color defaultDeepColor = Color(0xFF0A1C79);
  static const Color defaultLightColor2 = Color(0xFFE3E9FF);
  static const Color alphaColor = Color(0x1E000000);
  static const Color textColor1 = Color(0xFF515F84);
  static const Color backgroundColor1 = Color(0xB3F6F8FF);
  static const Color chatColor = Color(0xFFE7E9F5);
  static const Color seeAllColor = Color(0xFF2E47C7);
  static const Color savedColor = Color(0xFF040C35);
  static const Color linearColor = Color(0xFF000F5B);
  static const Color linearLightColor = Color(0xFF6294FF);
  static const Color linearShadowColor = Color(0x3F000000);
  static const Color buttonColor1 = Color(0xFFD0B47D);
  static const Color borderColor = Color(0xFFF3D194);
  static const Color inputBorderColor = Color(0x66EBEBEB);
  static const Color boxShadowColor = Color(0x1E000000);
  static const Color boxShadowColor2 = Color(0x26000000);
  static const Color containerColor3 = Color(0xFFE0E4F2);
  static const Color containerBorderColor = Color(0xFFB5B5B5);
  static const Color disableColor = Color(0xEEEEEEFF);
  static const Color otpColor = Color(0xFFDBDEEF);
  static const Color orangeColor = Color(0xFFB26E20);
  static const Color orangeAccentColor = Color(0xFFFFAB40);
  static const Color greenLightColor = Color(0x8E9AFFB8);
  static const Color blueColor = Color(0xFF1D2B86);
  static const Color deepRedColor = Color(0xFF960808);
  static const Color textAreaColor = Color(0xFFF8FCFF);
  static const Color dividerColor = Color(0xFFC7C7C7);
  static const Color textAreaColor2 = Color(0xFFE8EBF0);
  static const Color containerColor4 = Color(0xFF929292);

  static const Color orangeColor1 = Color(0xFFFB7065);
  static const Color textGreyColor = Color(0xFF85899D);
  static const Color heightBorderColor = Color(0xFFE0E0E0);
  static const Color searchBorderColor = Color(0xFFFFFEFD);
  static const Color textAreaBorderColor = Color(0xFFE7E2E4);
  static const Color inactiveTrack = Color(0xFFD9D9D9);
  static const Color inactiveButton = Color(0xFFD9D9D9);
  static const Color nameColor = Color(0xFF63667E);
  static const Color degicColor = Color(0xFF7B7D87);
  static const Color titleColor = Color(0xFF484B5B);
  static const Color aboutTitleColor = Color(0xFF44485C);
  static const Color aboutDetailsColor = Color(0xFFF0F2F7);
  static const Color subTitleColor = Color(0xFFB5B6B9);
  static const Color backColor = Color(0xFF9095AC);
  static const Color toggleColor = Color(0xFFE8EAF0);
  static const Color inactiveScroll = Color(0xFFAFAFAF);

  static const Color textWhiteColor = Color(0xFFFFFFFF);
  static const Color textTitleColor = Color(0xFF002B5B);
  static const Color textHintColor = Color(0xFF807B75);
  static const Color textGreenColor = Color(0xFFA1B17E);
  static const Color buttonBackgroundColor = Color(0xFFF1EADB);
  static const Color buttonDisableColor = Color(0xFF8D8D8D);
  static const Color greyTone1 = Color(0xFF636A70);
  static const Color textGreyColor2 = Color(0xFF676360);
  static const Color textGreyColor3 = Color(0xFFAEAEB2);
  static const Color textSendColor = Color(0xFF806E6A);
  static const Color textareaColor = Color(0xFFFDFDFE);
  static const Color borderareaColor = Color(0xFFE7E9ED);
  static const Color background1Color = Color(0xFFEAEAEA);
  static const Color black25 = Color(0x40000000);
  static const Color greyBC = Color(0xFFBCBCC0);
  static const Color darkGrey = Color(0xFF343537);
  static const Color subTitleGrey = Color(0xFF8E8E93);

  static const Color greyTone = Color(0xFF676360);
  static const Color beigeBrown = Color(0xFFC4AD8E);
  static const Color lightBeige = Color(0xFFF1E9DB);
  static const Color softBeige = Color(0xFFE6DBC9);

  static const Color deepred = Color(0xFFCA0000);
  static const Color vividBlue = Color(0xFF1D85FF);
  static const Color mutedBlueGrey = Color(0xFF767D95);

  static const Color lightBlue = Color(0xFFF3F6FF);
  static const Color softRed = Color(0xFFC94C6D);
  static const Color palePink = Color(0xFFD7AFB9);
  static const Color black12 = Color(0x1F000000);
  static const Color veryLightGray = Color(0xFFFDFDFE);
  static const Color softBlueGrey = Color(0xFFA8AAB9);
  static const Color lightBlueBackground = Color(0xFFF0F2F8);

  // --- Coach Hardcoded Colors ---
  static const Color coachColor0F000000 = Color(0X0F000000);
  static const Color coachColor33434928 = Color(0X33434928);
  static const Color coachColorA5354C30 = Color(0XA5354C30);
  static const Color coachColorF2C9A84C = Color(0XF2C9A84C);
  static const Color coachColorFF0D1E0D = Color(0XFF0D1E0D);
  static const Color coachColorFF102710 = Color(0XFF102710);
  static const Color coachColorFF132312 = Color(0XFF132312);
  static const Color coachColorFF182617 = Color(0XFF182617);
  static const Color coachColorFF192915 = Color(0XFF192915);
  static const Color coachColorFF193115 = Color(0XFF193115);
  static const Color coachColorFF1B2B1B = Color(0XFF1B2B1B);
  static const Color coachColorFF1C2B19 = Color(0XFF1C2B19);
  static const Color coachColorFF1D2A1A = Color(0XFF1D2A1A);
  static const Color coachColorFF1D311A = Color(0XFF1D311A);
  static const Color coachColorFF1F2E1F = Color(0XFF1F2E1F);
  static const Color coachColorFF21321D = Color(0XFF21321D);
  static const Color coachColorFF21321E = Color(0XFF21321E);
  static const Color coachColorFF22391E = Color(0XFF22391E);
  static const Color coachColorFF243521 = Color(0XFF243521);
  static const Color coachColorFF253523 = Color(0XFF253523);
  static const Color coachColorFF253921 = Color(0XFF253921);
  static const Color coachColorFF263424 = Color(0XFF263424);
  static const Color coachColorFF263523 = Color(0XFF263523);
  static const Color coachColorFF273B23 = Color(0XFF273B23);
  static const Color coachColorFF273B24 = Color(0XFF273B24);
  static const Color coachColorFF2B3C28 = Color(0XFF2B3C28);
  static const Color coachColorFF2C3E28 = Color(0XFF2C3E28);
  static const Color coachColorFF2C3F28 = Color(0XFF2C3F28);
  static const Color coachColorFF2C4728 = Color(0XFF2C4728);
  static const Color coachColorFF2D3D2D = Color(0XFF2D3D2D);
  static const Color coachColorFF2E4429 = Color(0XFF2E4429);
  static const Color coachColorFF2F432B = Color(0XFF2F432B);
  static const Color coachColorFF304C2B = Color(0XFF304C2B);
  static const Color coachColorFF334B2F = Color(0XFF334B2F);
  static const Color coachColorFF354C30 = Color(0XFF354C30);
  static const Color coachColorFF354D31 = Color(0XFF354D31);
  static const Color coachColorFF355530 = Color(0XFF355530);
  static const Color coachColorFF3E5E39 = Color(0XFF3E5E39);
  static const Color coachColorFF42513B = Color(0XFF42513B);
  static const Color coachColorFF425F3D = Color(0XFF425F3D);
  static const Color coachColorFF42673C = Color(0XFF42673C);
  static const Color coachColorFF486244 = Color(0XFF486244);
  static const Color coachColorFF4A5D4A = Color(0XFF4A5D4A);
  static const Color coachColorFF4C6D45 = Color(0XFF4C6D45);
  static const Color coachColorFF4F9445 = Color(0XFF4F9445);
  static const Color coachColorFF5E7958 = Color(0XFF5E7958);
  static const Color coachColorFF64B5F6 = Color(0XFF64B5F6);
  static const Color coachColorFF81C784 = Color(0XFF81C784);
  static const Color coachColorFF838383 = Color(0XFF838383);
  static const Color coachColorFF868A85 = Color(0XFF868A85);
  static const Color coachColorFF99A1AF = Color(0XFF99A1AF);
  static const Color coachColorFFB8BCB7 = Color(0XFFB8BCB7);
  static const Color coachColorFFB9BBB0 = Color(0XFFB9BBB0);
  static const Color coachColorFFC19E5F = Color(0XFFC19E5F);
  static const Color coachColorFFD1D1D1 = Color(0XFFD1D1D1);
  static const Color coachColorFFE57373 = Color(0XFFE57373);
  static const Color coachColorFFEFC348 = Color(0XFFEFC348);
  static const Color coachColorFFF4F6F0 = Color(0XFFF4F6F0);
  static const Color coachColorFFF5F0E8 = Color(0XFFF5F0E8);
  static const Color coachColorFFFB6262 = Color(0XFFFB6262);
  static const Color coachColorFFFBC02D = Color(0XFFFBC02D);
  // --- Material Color Fallbacks ---
  static const Color white54Color = Color(0x8AFFFFFF);
  static const Color redAccentColor = Color(0xFFFF5252);
  static const Color white10Color = Color(0x1AFFFFFF);
  static const Color white24Color = Color(0x3DFFFFFF);
  static const Color pinkColor = Color(0xFFE91E63);
  static const Color greenAccentColor = Color(0xFF69F0AE);
  static const Color white70Color = Color(0xB3FFFFFF);
  static const Color cyanColor = Color(0xFF00BCD4);
  static const Color purpleColor = Color(0xFF9C27B0);
  static const Color white38Color = Color(0x61FFFFFF);
  static const Color black54Color = Color(0x8A000000);
  static const Color black26Color = Color(0x42000000);
  static const Color white12Color = Color(0x1FFFFFFF);
  static const Color amberColor = Color(0xFFFFC107);
  // --- Auto-Extracted Hex Colors ---
  static const Color coachColorFF112E11 = Color(0XFF112E11);
  static const Color coachColorFF2D402D = Color(0XFF2D402D);
  static const Color coachColorFFE5CE8E = Color(0XFFE5CE8E);
  static const Color coachColorFFD44637 = Color(0XFFD44637);
  static const Color coachColor55E6DBC9 = Color(0X55E6DBC9);
  static const Color coachColorCCFFFFFF = Color(0XCCFFFFFF);
  static const Color coachColorFFB03030 = Color(0XFFB03030);
  static const Color coachColorFF438A3F = Color(0XFF438A3F);
  static const Color coachColorFFE55656 = Color(0XFFE55656);
  static const Color coachColorFF2E7D32 = Color(0XFF2E7D32);
  static const Color coachColorAAE6DBC9 = Color(0XAAE6DBC9);
  static const Color coachColorFF62745E = Color(0XFF62745E);
  static const Color coachColorFFD05278 = Color(0XFFD05278);
  static const Color coachColorFFB18406 = Color(0XFFB18406);
  static const Color coachColorFF41503C = Color(0XFF41503C);
  static const Color coachColorFF4A5D44 = Color(0XFF4A5D44);
  static const Color coachColorFF1B222B = Color(0XFF1B222B);
  static const Color coachColorFFB28406 = Color(0XFFB28406);
  static const Color coachColorFF2E1B1B = Color(0XFF2E1B1B);
  static const Color coachColorFFE65100 = Color(0XFFE65100);
  static const Color coachColorFFC96630 = Color(0XFFC96630);
  static const Color coachColorB2FFFFFF = Color(0XB2FFFFFF);
  static const Color coachColorFF2B1B2A = Color(0XFF2B1B2A);
  static const Color coachColorFF2B291B = Color(0XFF2B291B);
  static const Color coachColorFFD4AF37 = Color(0XFFD4AF37);
  static const Color coachColor0A1E1E01 = Color(0X0A1E1E01);
  static const Color coachColorFF1E331A = Color(0XFF1E331A);
  static const Color coachColorFF152A38 = Color(0XFF152A38);

  // Auto-extracted colors
  static const Color color00AF935B = Color(0x00AF935B);
  static const Color color14000000 = Color(0x14000000);
  static const Color color1EC9A84C = Color(0x1EC9A84C);
  static const Color color3D000000 = Color(0x3D000000);
  static const Color color4D384737 = Color(0x4D384737);
  static const Color color4DEBEBEB = Color(0x4DEBEBEB);
  static const Color color55AF935B = Color(0x55AF935B);
  static const Color color64C7C7C7 = Color(0x64C7C7C7);
  static const Color color96DAE0DA = Color(0x96DAE0DA);
  static const Color colorAAAF935B = Color(0xAAAF935B);
  static const Color colorFF111B10 = Color(0xFF111B10);
  static const Color colorFF1B2B1B = Color(0xFF1B2B1B);
  static const Color colorFF21321E = Color(0xFF21321E);
  static const Color colorFF2D3D2D = Color(0xFF2D3D2D);
  static const Color colorFF2E4429 = Color(0xFF2E4429);
  static const Color colorFF334B2F = Color(0xFF334B2F);
  static const Color colorFFAF935B = Color(0xFFAF935B);
  static const Color colorFFC4B65D = Color(0xFFC4B65D);
  static const Color colorFFD4AF37 = Color(0xFFD4AF37);
  static const Color colorFFE9D19E = Color(0xFFE9D19E);
}
""");

  File('${corePath.path}/exceptions/app_exceptions.dart')
    ..createSync(recursive: true)
    ..writeAsStringSync(r"""/// Base exception class for the application
abstract class AppException implements Exception {
  final String message;
  final String title;
  final String? code;
  final bool isCritical;
  final dynamic originalException;

  AppException({
    required this.message,
    required this.title,
    this.isCritical = false,
    this.code,
    this.originalException,
  });

  @override
  String toString() => '$title: $message';

  /// Helper to check if the error is network related
  bool get isNetworkError => 
    this is InternetException || 
    this is TimeoutException || 
    this is NetworkException;

  /// Helper to check if the error is auth related
  bool get isAuthError => 
    this is UnauthorizedException || 
    this is ForbiddenException || 
    this is AuthException;
}

// ── Network Exceptions ─────────────────────────────────────────────────

/// Internet connection exception
class InternetException extends AppException {
  InternetException({
    super.message = 'No internet connection',
    super.code,
    super.originalException,
  }) : super(
          title: 'Connectivity Issue',
          isCritical: true,
        );
}

/// Request timeout exception
class TimeoutException extends AppException {
  TimeoutException({
    super.message = 'Request timeout',
    super.code,
    super.originalException,
  }) : super(
          title: 'Timeout',
          isCritical: true,
        );
}

/// Bad request exception (400)
class BadRequestException extends AppException {
  BadRequestException({
    required super.message,
    String? code,
    super.originalException,
  }) : super(
          title: 'Invalid Request',
          isCritical: false,
          code: code ?? '400',
        );
}

/// Unauthorized exception (401)
class UnauthorizedException extends AppException {
  UnauthorizedException({
    super.message = 'Unauthorized access',
    String? code,
    super.originalException,
  }) : super(
          title: 'Unauthorized',
          isCritical: false,
          code: code ?? '401',
        );
}

/// Forbidden exception (403)
class ForbiddenException extends AppException {
  ForbiddenException({
    super.message = 'Access forbidden',
    String? code,
    super.originalException,
  }) : super(
          title: 'Forbidden',
          isCritical: false,
          code: code ?? '403',
        );
}

/// Not found exception (404)
class NotFoundException extends AppException {
  NotFoundException({
    required super.message,
    String? code,
    super.originalException,
  }) : super(
          title: 'Not Found',
          isCritical: false,
          code: code ?? '404',
        );
}

/// Server exception (500, 502, 503, 504)
class ServerException extends AppException {
  ServerException({
    super.message = 'Server error',
    String? code,
    super.originalException,
  }) : super(
          title: 'Server Error',
          isCritical: true,
          code: code ?? '500',
        );
}

/// Validation exception (422)
class ValidationException extends AppException {
  final Map<String, dynamic>? errors;

  ValidationException({
    super.message = 'Validation error',
    String? code,
    super.originalException,
    this.errors,
  }) : super(
          title: 'Validation Failed',
          isCritical: false,
          code: code ?? '422',
        );
}

/// Generic network exception
class NetworkException extends AppException {
  NetworkException({
    required super.message,
    super.code,
    super.originalException,
  }) : super(
          title: 'Network Error',
          isCritical: false,
        );
}

// ── App-Level Exceptions ───────────────────────────────────────────────

/// Generic app exception
class GenericException extends AppException {
  GenericException({
    super.message = 'Something went wrong',
    super.code,
    super.originalException,
  }) : super(
          title: 'Error',
          isCritical: false,
        );
}

/// Authentication exception
class AuthException extends AppException {
  AuthException({
    required super.message,
    super.code,
    super.originalException,
  }) : super(
          title: 'Authentication Error',
          isCritical: false,
        );
}

/// Data parsing exception
class DataParsingException extends AppException {
  DataParsingException({
    super.message = 'Failed to parse data',
    super.code,
    super.originalException,
  }) : super(
          title: 'Parsing Error',
          isCritical: true,
        );
}

/// Cache exception
class CacheException extends AppException {
  CacheException({
    super.message = 'Cache error',
    super.code,
    super.originalException,
  }) : super(
          title: 'Cache Error',
          isCritical: false,
        );
}
""");

  File('${corePath.path}/exceptions/exception_handler.dart')
    ..createSync(recursive: true)
    ..writeAsStringSync(r"""import 'dart:io';
import 'package:dio/dio.dart';
import 'app_exceptions.dart';

/// Handles exceptions and converts them to AppException
class ExceptionHandler {
  static AppException handleException(dynamic exception) {
    if (exception is AppException) {
      return exception;
    }

    if (exception is DioException) {
      return _handleDioException(exception);
    }

    if (exception is FormatException) {
      return DataParsingException(
        message: exception.message,
        originalException: exception,
      );
    }

    return GenericException(
      message: exception.toString(),
      originalException: exception,
    );
  }

  /// Handles manual response checks when Dio validateStatus allows error codes
  static AppException handleResponse(Response response) {
    return _handleStatusCode(
      response.statusCode ?? 0,
      response.data,
      null,
    );
  }

  static AppException _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(
          originalException: error,
        );

      case DioExceptionType.connectionError:
        return InternetException(
          originalException: error,
        );

      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return InternetException(
            message: 'Failed to connect to server',
            originalException: error,
          );
        }
        return NetworkException(
          message: error.message ?? 'Network error occurred',
          originalException: error,
        );

      case DioExceptionType.badResponse:
        return _handleStatusCode(
          error.response?.statusCode ?? 0,
          error.response?.data,
          error,
        );

      case DioExceptionType.cancel:
        return NetworkException(
          message: 'Request cancelled',
          originalException: error,
        );

      case DioExceptionType.badCertificate:
        return NetworkException(
          message: 'Certificate validation failed',
          originalException: error,
        );
    }
  }

  static AppException _handleStatusCode(int statusCode, dynamic data, dynamic original) {
    final message = _extractErrorMessage(data);

    switch (statusCode) {
      case 400:
        return BadRequestException(
          message: message,
          originalException: original,
        );
      case 401:
        return UnauthorizedException(
          message: message,
          originalException: original,
        );
      case 403:
        return ForbiddenException(
          message: message,
          originalException: original,
        );
      case 404:
        return NotFoundException(
          message: message,
          originalException: original,
        );
      case 422:
        return ValidationException(
          message: message,
          originalException: original,
          errors: data is Map ? data['errors'] : null,
        );
      case 500:
      case 502:
      case 503:
      case 504:
        return ServerException(
          message: message,
          code: '$statusCode',
          originalException: original,
        );
      default:
        return NetworkException(
          message: message,
          code: '$statusCode',
          originalException: original,
        );
    }
  }

  static String _extractErrorMessage(dynamic data) {
    if (data is Map) {
      return data['message']?.toString() ??
          data['error']?.toString() ??
          data['detail']?.toString() ??
          data['msg']?.toString() ??
          (data['errors'] is Map ? (data['errors'] as Map).values.first.toString() : null) ??
          'An error occurred';
    }
    return 'An error occurred';
  }
}
""");

  File('${corePath.path}/services/api_service.dart')
    ..createSync(recursive: true)
    ..writeAsStringSync(r"""import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/api_constants.dart';
import '../utils/helpers/snack_bar_helper.dart';

/// Robust HTTP client built on Dio with automatic token refresh and centralized error handling.
/// Supports GET, POST, PUT, PATCH, DELETE and Multipart for all methods.
class ApiService {
  static const _storage = FlutterSecureStorage();

  /// Set in main.dart — called when 401 refresh fails to redirect the user to login.
  static VoidCallback? onUnauthorized;

  // ── Dio singleton ──────────────────────────────────────────────────────────
  static final Dio _dio = _buildDio();

  static Dio _buildDio() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(minutes: 10),
        sendTimeout: const Duration(seconds: 30),
        // By default, Dio throws for status codes >= 400.
        // We'll catch them in onError interceptor for global handling.
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
          logPrint: (o) => debugPrint('🌐 [API]: ${o.toString()}'),
        ),
      );
    }

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (options.extra['auth'] == true) {
            final token = await getAccessToken();
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          handler.next(options);
        },
        onError: (DioException error, handler) async {
          final statusCode = error.response?.statusCode;
          final isAuthReq = error.requestOptions.extra['auth'] == true;

          // 1. Automatic 401 handling: Attempt to refresh token if authorized request fails
          if (statusCode == 401 && isAuthReq) {
            final refreshed = await _silentRefresh();
            if (refreshed) {
              final token = await getAccessToken();
              final opts = error.requestOptions;
              opts.headers['Authorization'] = 'Bearer $token';

              try {
                // Retry the original request with a fresh Dio instance to avoid looping
                final retryRes = await Dio(_dio.options).fetch(opts);
                return handler.resolve(retryRes);
              } catch (e) {
                return handler.next(error);
              }
            } else {
              showErrorSnackBar(
                message: 'Session expired. Please log in again.',
              );
              onUnauthorized?.call();
              return handler.next(error);
            }
          }

          // 2. Centralized Error Handling for all other status codes
          _handleDioError(error);
          handler.next(error);
        },
      ),
    );

    return dio;
  }

  // ── Storage Helpers ────────────────────────────────────────────────────────
  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> storeTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
    debugPrint('🔐 Tokens saved');
  }

  static Future<String?> getAccessToken() => _storage.read(key: 'access_token');
  static Future<String?> getRefreshToken() =>
      _storage.read(key: 'refresh_token');

  static Future<void> store({
    required String key,
    required String value,
  }) async => await _storage.write(key: key, value: value);

  static Future<String?> getStored({required String key}) =>
      _storage.read(key: key);

  static Future<void> storeRole({required String role}) async =>
      await _storage.write(key: 'user_role', value: role);
  static Future<String?> getStoredRole() => _storage.read(key: 'user_role');

  static Future<void> storeUserId({required String id}) async =>
      await _storage.write(key: 'user_id', value: id);
  static Future<int?> getStoredId() async {
    final v = await _storage.read(key: 'user_id');
    return v == null ? null : int.tryParse(v);
  }

  static Future<void> clearTokens() async {
    await _storage.deleteAll();
    debugPrint('🗑️ All auth data cleared');
  }

  // ── Unified Request Core ───────────────────────────────────────────────────
  /// Main entry point for all network calls.
  /// Handles GET, POST, PUT, PATCH, DELETE and Multipart automatically.
  static Future<Response?> safeRequest({
    required String api,
    required String method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool authenticated = false,
    bool isMultipart = false,
  }) async {
    try {
      dynamic finalData = data;

      // Auto-convert to FormData if Multipart is specified and data is a Map
      if (isMultipart && data is Map<String, dynamic>) {
        finalData = await _convertToFormData(data);
      }

      return await _dio.request(
        api,
        data: finalData,
        queryParameters: queryParameters,
        options: Options(
          method: method,
          extra: {'auth': authenticated},
          contentType: isMultipart
              ? 'multipart/form-data'
              : Headers.jsonContentType,
        ),
      );
    } on DioException {
      // Handled globally in Interceptor
      return null;
    } catch (e) {
      debugPrint('❌ Unexpected Error: $e');
      return null;
    }
  }

  // ── API Methods ────────────────────────────────────────────────────────────

  static Future<Response?> get({
    required String api,
    Map<String, dynamic>? params,
    bool auth = false,
  }) => safeRequest(
    api: api,
    method: 'GET',
    queryParameters: params,
    authenticated: auth,
  );

  static Future<Response?> post({
    required String api,
    dynamic data,
    bool auth = false,
    bool multipart = false,
  }) => safeRequest(
    api: api,
    method: 'POST',
    data: data,
    authenticated: auth,
    isMultipart: multipart,
  );

  static Future<Response?> put({
    required String api,
    dynamic data,
    bool auth = false,
    bool multipart = false,
  }) => safeRequest(
    api: api,
    method: 'PUT',
    data: data,
    authenticated: auth,
    isMultipart: multipart,
  );

  static Future<Response?> patch({
    required String api,
    dynamic data,
    bool auth = false,
    bool multipart = false,
  }) => safeRequest(
    api: api,
    method: 'PATCH',
    data: data,
    authenticated: auth,
    isMultipart: multipart,
  );

  static Future<Response?> delete({
    required String api,
    dynamic data,
    bool auth = false,
  }) =>
      safeRequest(api: api, method: 'DELETE', data: data, authenticated: auth);

  // ── Error & Response Handling ──────────────────────────────────────────────

  static void _handleDioError(DioException e) {
    String message = 'Unexpected error occurred';

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      message = 'Request timed out. Check your connection.';
    } else if (e.type == DioExceptionType.connectionError) {
      message = 'Internet connection lost.';
    } else if (e.error is SocketException) {
      message = 'Could not reach the server.';
    } else if (e.response != null) {
      final status = e.response!.statusCode;
      final data = e.response!.data;

      switch (status) {
        case 400:
          message = _extractErrorMessage(data, 'Bad Request (400)');
          break;
        case 401:
          // 401 is handled for auth:true requests in interceptor.
          // This case catches guest 401s or failed refreshes.
          message = 'Unauthorized access (401).';
          break;
        case 402:
          message = 'Payment Required (402).';
          break;
        case 403:
          message = 'Forbidden: Access denied (403).';
          break;
        case 404:
          message = 'Resource not found (404).';
          break;
        case 405:
          message = 'Method not allowed (405).';
          break;
        case 408:
          message = 'Request Timeout (408).';
          break;
        case 422:
          message = _extractErrorMessage(data, 'Validation Error (422)');
          break;
        case 429:
          message = 'Too many requests. Please slow down.';
          break;
        case 500:
          message = 'Internal Server Error (500).';
          break;
        case 502:
          message = 'Bad Gateway (502). Server might be down.';
          break;
        case 503:
          message = 'Service Unavailable (503).';
          break;
        case 504:
          message = 'Gateway Timeout (504).';
          break;
        default:
          message = _extractErrorMessage(data, 'Error code: $status');
      }
    }

    showErrorSnackBar(message: message);
  }

  static String _extractErrorMessage(dynamic data, String defaultMsg) {
    if (data is Map) {
      return data['message']?.toString() ??
          data['error']?.toString() ??
          data['errors']?.toString() ??
          data['detail']?.toString() ??
          data['details']?.toString() ??
          data['msg']?.toString() ??
          (data['errors'] is Map
              ? (data['errors'] as Map).values.first.toString()
              : null) ??
          (data['errors'] is List
              ? (data['errors'] as List).first.toString()
              : null) ??
          defaultMsg;
    }
    return defaultMsg;
  }

  // ── Silent Token Refresh ───────────────────────────────────────────────────
  static Future<bool> _silentRefresh() async {
    try {
      final refresh = await getRefreshToken();
      if (refresh == null) return false;

      // Use a pure Dio instance to avoid infinite interceptor loops
      final response = await Dio().post(
        ApiConstants.refreshTokenUrl,
        data: {'refresh': refresh},
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200) {
        final newAccess =
            response.data['access'] as String? ??
            response.data['access_token'] as String?;
        if (newAccess != null) {
          await _storage.write(key: 'access_token', value: newAccess);
          final newRefresh =
              response.data['refresh'] as String? ??
              response.data['refresh_token'] as String?;
          if (newRefresh != null) {
            await _storage.write(key: 'refresh_token', value: newRefresh);
          }
          debugPrint('🔐 Access token successfully refreshed');
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint('❌ Silent refresh failed: $e');
      return false;
    }
  }

  /// Extracts data if response is successful.
  static dynamic handleResponse(Response? response) {
    if (response == null) return null;
    final status = response.statusCode ?? 0;
    if (status >= 200 && status < 300) {
      return response.data;
    }
    return null;
  }

  // ── Internal Multipart Utility ─────────────────────────────────────────────
  static Future<FormData> _convertToFormData(Map<String, dynamic> data) async {
    final Map<String, dynamic> formDataMap = {};
    for (var entry in data.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value is File) {
        formDataMap[key] = await MultipartFile.fromFile(
          value.path,
          filename: value.path.split('/').last,
        );
      } else if (value is List<File>) {
        formDataMap[key] = await Future.wait(
          value.map(
            (f) => MultipartFile.fromFile(
              f.path,
              filename: f.path.split('/').last,
            ),
          ),
        );
      } else {
        formDataMap[key] = value;
      }
    }
    return FormData.fromMap(formDataMap);
  }
}
""");

  File('${corePath.path}/services/navigation_service.dart')
    ..createSync(recursive: true)
    ..writeAsStringSync(r"""import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../routes/app_router.dart';

/// Enhanced NavigationService for centralized app navigation
/// Integrates with GoRouter and AppRoutes for type-safe navigation
class NavigationService {
  static final NavigationService _instance = NavigationService._internal();

  factory NavigationService() => _instance;
  NavigationService._internal();

  static final navigatorKey = GlobalKey<NavigatorState>();

  // Store GoRouter instance for access
  static GoRouter? _router;

  /// Initialize with GoRouter instance
  static void initRouter(GoRouter router) {
    _router = router;
  }

  // ── Core Navigation Methods ────────────────────────────────────────────

  /// Navigate to route using AppRoutes
  static Future<T?> push<T>(String route, {Object? extra}) async {
    return await _router?.push<T>(route, extra: extra);
  }

  /// Replace current route
  static Future<T?> replace<T>(String route, {Object? extra}) async {
    return await _router?.replace<T>(route, extra: extra);
  }

  /// Navigate to route and remove all previous routes
  static Future<T?> go<T>(String route, {Object? extra}) async {
    return _router?.go(route, extra: extra) as Future<T?>?;
  }

  /// Go back to previous route
  static void pop<T>([T? result]) {
    navigatorKey.currentState?.pop(result);
  }

  /// Pop until predicate is true
  static void popUntil(String route) {
    navigatorKey.currentState?.popUntil(ModalRoute.withName(route));
  }

  /// Check if can pop
  static bool canPop() {
    return navigatorKey.currentState?.canPop() ?? false;
  }

  // ── Auth Navigation ────────────────────────────────────────────────────

  static void goToLogin() => go(AppRoutes.login);

  static void goToHome() => go(AppRoutes.home);

  static void goToOnboarding() => go(AppRoutes.onboarding);

  static void goToSignUp() => push(AppRoutes.signup);

  static void goToForgetPassword() => push(AppRoutes.forgetPass);

  static void goToOtpVerify({required String origin}) =>
      push(AppRoutes.otpVerify, extra: origin);

  static void goToChangePassword({required String origin}) =>
      push(AppRoutes.changePass, extra: origin);

  // ── Product Navigation ─────────────────────────────────────────────────

  static void goToSearch() => go(AppRoutes.search);

  static void goToFilter() => push(AppRoutes.filter);

  static void goToWishlist() => go(AppRoutes.wishlist);

  static void goToReview(String productId) =>
      push(AppRoutes.review, extra: productId);

  // ── Cart & Checkout Navigation ─────────────────────────────────────────

  static void goToCart() => go(AppRoutes.order);

  static void goToCheckout() => push(AppRoutes.checkout);

  static void goToShipping() => push(AppRoutes.shipping);

  static void goToPayment() => push(AppRoutes.payment);

  static void goToConfirmOrder({required bool fromCheckout}) =>
      push(AppRoutes.confirm, extra: fromCheckout);

  // ── Profile Navigation ─────────────────────────────────────────────────

  static void goToProfile() => go(AppRoutes.profile);

  static void goToTheme() => go(AppRoutes.theme);

  static void goToEditProfile() => push(AppRoutes.editProfile);

  static void goToMyAddress() => push(AppRoutes.address);

  static void goToAddAddress() => push(AppRoutes.addAddress);

  static void goToPaymentMethods() => push(AppRoutes.paymentMethod);

  static void goToAddCard() => push(AppRoutes.addCard);

  static void goToPromoCode() => push(AppRoutes.promoCode);

  static void goToOrderHistory() => push(AppRoutes.orderHistory);

  static void goToTrackOrder() => push(AppRoutes.trackOrder);

  static void goToPoints() => push(AppRoutes.points);

  static void goToSettings() => push(AppRoutes.settings);

  // ── Home Features Navigation ───────────────────────────────────────────

  static void goToBreathing({
    required String title,
    required String subtitle,
  }) =>
      push(AppRoutes.breathing, extra: {'title': title, 'subtitle': subtitle});

  static void goToWriteJournal() => push(AppRoutes.writeJournal);

  // ── Utility Methods ────────────────────────────────────────────────────

  /// Clear all analytics/tracking when logging out
  static void logout() {
    go(AppRoutes.login);
  }

  /// Get current route
  static String? getCurrentRoute() {
    return _router?.routeInformationProvider.value.uri.path;
  }

  /// Check if current route is
  static bool isCurrentRoute(String route) {
    return getCurrentRoute() == route;
  }
}
""");

  File('${corePath.path}/services/notifications/firebase_options.dart')
    ..createSync(recursive: true)
    ..writeAsStringSync(r"""// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAfORxGnIS3Flkb2yJlxIv8SBZwjsJM-rU',
    appId: '1:490515839267:web:4465c9b266432d1597b496',
    messagingSenderId: '490515839267',
    projectId: 'dogbuddy-592d8',
    authDomain: 'dogbuddy-592d8.firebaseapp.com',
    storageBucket: 'dogbuddy-592d8.firebasestorage.app',
    measurementId: 'G-03RQM1EFRV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAOCa4WRWhmPZVmPpUqZ8pwayh-e3xMBy4',
    appId: '1:490515839267:android:79986eb9738fec8b97b496',
    messagingSenderId: '490515839267',
    projectId: 'dogbuddy-592d8',
    storageBucket: 'dogbuddy-592d8.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB6fWwiITP7pSGXBLt4yVWjt2Z7SehgPKk',
    appId: '1:490515839267:ios:f81c2b02f8cd1e3197b496',
    messagingSenderId: '490515839267',
    projectId: 'dogbuddy-592d8',
    storageBucket: 'dogbuddy-592d8.firebasestorage.app',
    iosBundleId: 'com.dog.dog',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB6fWwiITP7pSGXBLt4yVWjt2Z7SehgPKk',
    appId: '1:490515839267:ios:f81c2b02f8cd1e3197b496',
    messagingSenderId: '490515839267',
    projectId: 'dogbuddy-592d8',
    storageBucket: 'dogbuddy-592d8.firebasestorage.app',
    iosBundleId: 'com.dog.dog',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAfORxGnIS3Flkb2yJlxIv8SBZwjsJM-rU',
    appId: '1:490515839267:web:0887a5d7c68bdc3297b496',
    messagingSenderId: '490515839267',
    projectId: 'dogbuddy-592d8',
    authDomain: 'dogbuddy-592d8.firebaseapp.com',
    storageBucket: 'dogbuddy-592d8.firebasestorage.app',
    measurementId: 'G-08YRL893YC',
  );
}
""");

  File('${corePath.path}/services/notifications/notification_service.dart')
    ..createSync(recursive: true)
    ..writeAsStringSync(r"""// import 'dart:convert';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// import '../../../../main.dart';
//
//
// class NotificationService {
//   static RemoteMessage? initialMessage;
//   NotificationService();
//
//   // static final FlutterLocalNotificationsPlugin _notificationsPlugin =
//   // FlutterLocalNotificationsPlugin();
//
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//
//   // static Future<void> initialize() async {
//   //   await requestNotificationPermission();
//   //   Get.put(NotificationSubscriptionController());
//   //   const AndroidInitializationSettings androidSettings =
//   //   AndroidInitializationSettings('@mipmap/ic_launcher');
//   //
//   //   final InitializationSettings settings = InitializationSettings(
//   //     android: androidSettings,
//   //   );
//   //
//   //   await _notificationsPlugin.initialize(
//   //     settings,
//   //     onDidReceiveNotificationResponse: (NotificationResponse response) {
//   //       if (response.payload != null) {
//   //         debugPrint("Notification Clicked: ${response.payload}");
//   //         _handleNotificationClick(response.payload!);
//   //       }
//   //     },
//   //   );
//   // }
//
//   Future<String> getDeviceToken() async {
//     String? token = await messaging.getToken();
//     debugPrint('DEVICE token :::::::::::::::::::::::::::    $token');
//     return token!;
//   }
//
//   static Future<void> requestNotificationPermission() async {
//     final status = await Permission.notification.request();
//     if (status.isGranted) {
//       debugPrint('Notification permission granted');
//     } else if (status.isDenied) {
//       debugPrint('Notification permission denied.');
//     } else if (status.isPermanentlyDenied) {
//       debugPrint('Notification permission permanently denied. Open settings.');
//       openAppSettings();
//     }
//   }
//
//   // static Future<void> showNotification({
//   //   int id = 0,
//   //   required String title,
//   //   required String body,
//   //   String? payload,
//   //   String? keyPoints,
//   //   String? fileName,
//   //   String? filePath,
//   // }) async {
//   //   debugPrint("🔔 showNotification -> $title - $body");
//   //   // Generate payload
//   //   String jsonPayload = jsonEncode({
//   //     'type': payload,
//   //     'message': body,
//   //     'time': DateTime.now().toLocal().toString().substring(11, 16),
//   //     // HH:MM format
//   //     'keyPoints': keyPoints,
//   //     'fileName': fileName,
//   //     'filePath': filePath,
//   //   });
//   //
//   //   const AndroidNotificationDetails androidDetails =
//   //   AndroidNotificationDetails(
//   //     'channel_id_one',
//   //     'Default Channel',
//   //     importance: Importance.high,
//   //     priority: Priority.high,
//   //     playSound: true,
//   //   );
//   //
//   //   const NotificationDetails details = NotificationDetails(
//   //     android: androidDetails,
//   //   );
//   //
//   //   // Show notification in system tray
//   //   await _notificationsPlugin.show(id, title, body, details,
//   //       payload: jsonPayload);
//   //
//   //   // **Update the UI with new notification**
//   //   if (Get.isRegistered<NotificationSubscriptionController>()) {
//   //     Get.find<NotificationSubscriptionController>()
//   //         .addNotification(jsonPayload);
//   //   } else {
//   //     debugPrint("NotificationSubscriptionController is not registered");
//   //   }
//   // }
//
//   // static void _handleNotificationClick(String payload) {
//   //   try {
//   //     final Map<String, dynamic> data = jsonDecode(payload);
//   //     String? type = data['type'];
//   //     String? fileName = data['fileName'];
//   //     String? filePath = data['filePath'];
//   //
//   //     if (type == "notification_page") {
//   //       // Get.to(ProfileView());
//   //     } else if (type == "subscription_page") {
//   //       // Get.to(SubscriptionView());
//   //     } else if (type == "Summary") {
//   //       debugPrint('REGENERATE noti ::::: filePath ::::::::: $filePath');
//   //       debugPrint('REGENERATE noti ::::: fileName ::::::::: $fileName');
//   //       // Get.to(() => SummaryKeyPointView(
//   //       //   //keyPoints: keyPoints ?? "No Key Points",
//   //       //   fileName: fileName ?? "Unknown File",
//   //       //   filePath: filePath ?? "Unknown FilePath",
//   //       // ));
//   //     } else if (type == "Conversion") {
//   //       // Get.to(() => ConvertToTextView(
//   //       //   filePath: filePath ?? "No file path",
//   //       //   fileName: fileName ?? "Unknown File",
//   //       // ));
//   //     } else {
//   //       debugPrint("Unknown payload type: $type");
//   //     }
//   //   } catch (e) {
//   //     debugPrint("Error parsing notification payload: $e");
//   //   }
//   // }
//
//   NotificationService._();
//   static final NotificationService instance = NotificationService._();
//   void handleInitialMessage() {
//     if (NotificationService.initialMessage != null) {
//       final msg = NotificationService.initialMessage!;
//       _handleMessage(msg);
//
//       // clear so it won’t trigger twice
//       NotificationService.initialMessage = null;
//     }
//   }
//
//   final _messaging = FirebaseMessaging.instance;
//   final _localNotifications = FlutterLocalNotificationsPlugin();
//   final _storage = const FlutterSecureStorage();
//   bool _isLocalNotificationsInitialized = false;
//
//   Future<void> initialize({ApiService? apiService}) async {
//     try {
//       FirebaseMessaging.onBackgroundMessage(
//         firebaseMessagingBackgroundHandler,
//       );
//
//       await _requestPermission();
//
//       await setupLocalNotifications();
//
//       await _setupMessageHandlers();
//
//       handleInitialMessage();
//
//       await Future.delayed(const Duration(milliseconds: 1000));
//       debugPrint(
//         'Delayed FCM registration to ensure ApiService availability at ${DateTime.now()}',
//       );
//       await _registerFcmToken(apiService: apiService);
//
//       _messaging.onTokenRefresh.listen((newToken) async {
//         debugPrint('FCM token refreshed: $newToken');
//         _storage.write(key: 'fcm_token', value: newToken);
//         await _registerFcmToken(fcmToken: newToken, apiService: apiService);
//       });
//     } catch (e, stackTrace) {
//       debugPrint('NotificationService initialization error: $e');
//       debugPrint('Stack trace: $stackTrace');
//     }
//   }
//
//   Future<void> _requestPermission() async {
//     try {
//       final settings = await _messaging.requestPermission(
//         alert: true,
//         badge: true,
//         sound: true,
//         provisional: false,
//         announcement: false,
//         carPlay: false,
//         criticalAlert: false,
//       );
//       debugPrint(
//         'Notification permission status: ${settings.authorizationStatus}',
//       );
//     } catch (e, stackTrace) {
//       debugPrint('Error requesting notification permissions: $e');
//       debugPrint('Stack trace: $stackTrace');
//     }
//   }
//
//   Future<void> _registerFcmToken({String? fcmToken, ApiService? apiService}) async {
//     try {
//       final token = fcmToken ?? await _messaging.getToken();
//       if (token == null) {
//         debugPrint('FCM token is null');
//         return;
//       }
//       debugPrint('FCM token: $token');
//
//       final accessToken = await _storage.read(key: 'access_token');
//       if (accessToken == null) {
//         debugPrint('Access token not found');
//         return;
//       }
//
//       if (apiService == null) {
//         debugPrint('ApiService not provided for FCM registration');
//         return;
//       }
//
//       final response = await apiService.registerFcmToken(
//         accessToken: accessToken,
//         fcmToken: token,
//       );
//
//       if (response['statusCode'] == 200 || response['statusCode'] == 201) {
//         debugPrint('FCM token registered: $token');
//       } else {
//         debugPrint(
//           'FCM token registration failed: ${response['data']['detail'] ?? response['data']['message'] ?? 'Status code ${response['statusCode']}'}',
//         );
//       }
//     } catch (e, stackTrace) {
//       debugPrint('Error registering FCM token: $e');
//       debugPrint('Stack trace: $stackTrace');
//     }
//   }
//
//   Future<void> setupLocalNotifications() async {
//     if (_isLocalNotificationsInitialized) return;
//
//     try {
//       const channel = AndroidNotificationChannel(
//         'high_importance_channel',
//         'High Importance Notifications',
//         description: 'Used for important notifications.',
//         importance: Importance.high,
//       );
//
//       final androidPlugin =
//       _localNotifications
//           .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin
//       >();
//       await androidPlugin?.createNotificationChannel(channel);
//
//       const androidSettings = AndroidInitializationSettings(
//         '@mipmap/ic_launcher',
//       );
//       const iosSettings = DarwinInitializationSettings(
//         requestAlertPermission: true,
//         requestBadgePermission: true,
//         requestSoundPermission: true,
//       );
//       const initializationSettings = InitializationSettings(
//         android: androidSettings,
//         iOS: iosSettings,
//       );
//
//       await _localNotifications.initialize(
//         initializationSettings,
//         onDidReceiveNotificationResponse: (response) {
//           if (response.payload != null) {
//             _handleNotificationTap(response.payload!);
//           }
//         },
//       );
//
//       _isLocalNotificationsInitialized = true;
//       debugPrint('Local notifications initialized');
//     } catch (e, stackTrace) {
//       debugPrint('Error setting up local notifications: $e');
//       debugPrint('Stack trace: $stackTrace');
//     }
//   }
//
//   Future<void> showNotification(RemoteMessage message) async {
//     try {
//       final notification = message.notification;
//       final android = message.notification?.android;
//       if (notification == null || android == null) {
//         debugPrint('No notification or Android-specific data found');
//         return;
//       }
//
//       await _localNotifications.show(
//         notification.hashCode,
//         notification.title,
//         notification.body,
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             'high_importance_channel',
//             'High Importance Notifications',
//             channelDescription: 'Used for important notifications.',
//             importance: Importance.high,
//             priority: Priority.high,
//             icon: '@drawable/ic_stat_notify',
//           ),
//           iOS: const DarwinNotificationDetails(
//             presentAlert: true,
//             presentBadge: true,
//             presentSound: true,
//           ),
//         ),
//         payload: jsonEncode(message.data),
//       );
//       debugPrint('Notification shown: ${notification.title}');
//     } catch (e, stackTrace) {
//       debugPrint('Error showing notification: $e');
//       debugPrint('Stack trace: $stackTrace');
//     }
//   }
//
//   Future<void> _setupMessageHandlers() async {
//     try {
//
//       FirebaseMessaging.onMessage.listen((message) {
//         debugPrint('Foreground message received: ${message.data}');
//         showNotification(message);
//       });
//
//       FirebaseMessaging.onMessageOpenedApp.listen((message) {
//         debugPrint('Message opened app: ${message.data}');
//         _handleMessage(message);
//       });
//
//       final initialMessage = await _messaging.getInitialMessage();
//       if (initialMessage != null) {
//         debugPrint('Initial message: ${initialMessage.data}');
//         _handleMessage(initialMessage);
//       }
//     } catch (e, stackTrace) {
//       debugPrint('Error setting up message handlers: $e');
//       debugPrint('Stack trace: $stackTrace');
//     }
//   }
//
//   void _handleMessage(RemoteMessage message) {
//     final data = message.data;
//     final type = data['type']?.toString();
//     debugPrint('Handling message type: $type');
//
//     switch (type) {
//       case 'message':
//         _handleChatNotification(data);
//         break;
//       case 'invitation':
//         _handleChatInvitation(data);
//         break;
//       case 'profile':
//         _handleProfileNotification(data);
//         break;
//       default:
//         debugPrint('Unknown notification type: $type');
//     }
//   }
//
//   void _handleChatNotification(Map<String, dynamic> data) {
//     try {
//       final roomId = int.tryParse(data['chat_room_id']?.toString() ?? '') ?? 0;
//       final name = data['sender_name']?.toString() ?? 'Unknown';
//       // final image = "${Api.imageUrl}${data['sender_profile_image']?.toString()}";
//
//       if (roomId > 0) {
//         // Get.to(
//         //       () => PersonalChat(name: name, roomId: roomId, image: image),
//         //   transition: Transition.rightToLeft,
//         // );
//         debugPrint('✅ Navigated to PersonalChat: $roomId - $name');
//       } else {
//         debugPrint('⚠️ Invalid chat notification payload: $data');
//       }
//     } catch (e, st) {
//       debugPrint('❌ Error in _handleChatNotification: $e');
//       debugPrint('$st');
//     }
//   }
//
//   void _handleChatInvitation(Map<String, dynamic> data) {
//     try {
//       // final chatsController = Get.find<ChatsController>();
//       // final homeController = Get.find<HomeController>();
//       // chatsController.setSelectedTab('Invitations');
//       // homeController.selectedIndex(2);
//       // Get.to(() => Navbar());
//       debugPrint('✅ Navigated to Chats (Invitations)');
//     } catch (e, st) {
//       debugPrint('❌ Error in _handleChatInvitation: $e');
//       debugPrint('$st');
//     }
//   }
//
//   void _handleProfileNotification(Map<String, dynamic> data) {
//     try {
//       final profileId = data['profileId']?.toString();
//       if (profileId != null) {
//         // Get.to(() => const ProfileView(), arguments: {'id': profileId});
//         debugPrint('Navigated to profile: $profileId');
//       } else {
//         debugPrint('Invalid profile notification: missing profileId');
//       }
//     } catch (e, stackTrace) {
//       debugPrint('Error handling profile notification: $e');
//       debugPrint('Stack trace: $stackTrace');
//     }
//   }
//
//   void _handleNotificationTap(String payload) {
//     try {
//       final data = jsonDecode(payload) as Map<String, dynamic>;
//       debugPrint('Notification tapped with payload: $payload');
//       _handleMessage(RemoteMessage(data: data));
//     } catch (e, stackTrace) {
//       debugPrint('Error parsing notification tap payload: $e');
//       debugPrint('Stack trace: $stackTrace');
//     }
//   }
// }
//
//
""");

  File('${corePath.path}/theme/app_theme.dart')
    ..createSync(recursive: true)
    ..writeAsStringSync(r"""import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import 'design_system.dart';

class AppTheme {
  // ── Shared Gradients ─────────────────────────────────────────────────────
  static const _goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.primaryColor, // #AC823A
      AppColors.buttonColor1, // #D0B47D
      AppColors.primaryColor, // #AC823A
    ],
  );

  static const _deepGoldGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.buttonColor1, AppColors.buttonColor],
  );

  static const _progressBarGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [AppColors.buttonColor, AppColors.borderColor],
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // LIGHT THEME
  // ═══════════════════════════════════════════════════════════════════════════
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Segoe UI',
    brightness: Brightness.light,
    primaryColor: AppColors.primaryColor,
    primaryColorDark: AppColors.defaultColor,
    hintColor: AppColors.hintTextColor,
    scaffoldBackgroundColor: AppColors.backgroundColor,

    // ── Design System Extension ────────────────────────────────────────────
    extensions: [
      AppDesignSystem(
        // Gradients
        primaryGradient: _goldGradient,
        secondaryGradient: _goldGradient,
        deepGradient: _deepGoldGradient,
        progressBarGradient: _progressBarGradient,

        // Glass
        glassOpacity: 0.1,
        glassBorderOpacity: 0.15,

        // Card / Container tokens  (from buttonColor4 / buttonBorderColor4)
        cardFillColor: AppColors.buttonColor4, // #BA384737
        cardBorderColor: AppColors.buttonBorderColor4, // #66EBEBEB
        cardFillMuted: AppColors.buttonColor4.withAlpha(30),
        cardBorderMuted: AppColors.buttonBorderColor4.withAlpha(30),

        // Input
        inputFillColor: AppColors.coachColorFF21321E,
        inputBorderColor: AppColors.coachColorFF334B2F,
        inputShadowColor: AppColors.coachColorFF2E4429,
        inputFocusBorderColor: AppColors.iconColor, // #C9A84C
        // Tab Bar
        tabactiveThumbColor: AppColors.iconColor,
        tabInactiveThumbColor: AppColors.textColor.withAlpha(150),
        tabIndicatorColor: AppColors.iconColor,

        // Checkbox
        checkboxactiveThumbColor: AppColors.iconColor,
        checkboxInactiveThumbColor: AppColors.inputBorderColor,
        checkboxCheckColor: AppColors.backgroundColor,

        // Bottom Sheet
        bottomSheetBackground: AppColors.popupBackgroundColor, // #20341F
        bottomSheetDivider: AppColors.dividerColor.withAlpha(100),
        bottomSheetSelectedItem: AppColors.iconColor,

        // Upload / Chip
        uploadPillColor: AppColors.buttonColor3, // #434928
        addChipFillColor: AppColors.buttonColor4,
        addChipBorderColor: AppColors.buttonBorderColor4,

        // Celebration Badge
        badgeGlowColor: AppColors.iconColor.withAlpha(30),
        badgeSolidColor: AppColors.iconColor,

        // Status Bar
        statusBarColor: AppColors.colorFF111B10,
      ),
    ],

    // ── Color Scheme ───────────────────────────────────────────────────────
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryColor,
      brightness: Brightness.light,
      primary: AppColors.primaryColor, // #AC823A
      onPrimary: AppColors.whiteColor, // #FFFFFF
      surface: AppColors.whiteColor,
      onSurface: AppColors.textColor, // #DAE0DA
      secondary: AppColors.defaultColor, // #22331F
      outline: AppColors.borderColor, // #F3D194
      error: AppColors.redAlphaColor, // #F44336
    ),

    // ── AppBar ─────────────────────────────────────────────────────────────
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundColor,
      scrolledUnderElevation: 0,
      surfaceTintColor: AppColors.backgroundColor,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(
        color: AppColors.textColor2,
      ), // #8CA08B muted icons
      titleTextStyle: TextStyle(
        color: AppColors.whiteColor,
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Georgia',
      ),
    ),

    // ── Text Theme ─────────────────────────────────────────────────────────
    //   Sizes aligned with coach folder actual usage:
    //   headlineLarge 24sp  → welcome/completion headings (Georgia)
    //   titleLarge    22sp  → page titles (Georgia)
    //   titleMedium   18sp  → appBar titles
    //   titleSmall    16sp  → button text (Proxima Nova via CustomButton)
    //   bodyLarge     14sp  → form field labels, descriptions
    //   bodyMedium    12sp  → step counter, completion text
    //   bodySmall     11sp  → error text, captions
    //   labelLarge    14sp  → input title labels
    textTheme: TextTheme(
      displayLarge: TextStyle(
        color: AppColors.whiteColor,
        fontSize: 36.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Georgia',
      ),
      displayMedium: TextStyle(
        color: AppColors.whiteColor,
        fontSize: 28.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Georgia',
      ),
      headlineLarge: TextStyle(
        color: AppColors.whiteColor,
        fontSize: 24.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Georgia',
      ),
      titleLarge: TextStyle(
        color: AppColors.whiteColor,
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Georgia',
      ),
      titleMedium: TextStyle(
        color: AppColors.whiteColor,
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: TextStyle(
        color: AppColors.whiteColor,
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        color: AppColors.textColor,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        color: AppColors.textColor,
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        color: AppColors.textColor.withAlpha(200),
        fontSize: 11.sp,
        fontWeight: FontWeight.w400,
      ),
      labelLarge: TextStyle(
        color: AppColors.textColor,
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: TextStyle(
        color: AppColors.textColor.withAlpha(200),
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: TextStyle(
        color: AppColors.hintTextColor,
        fontSize: 11.sp,
        fontWeight: FontWeight.w400,
      ),
    ),

    // ── Tab Bar ─────────────────────────────────────────────────────────────
    tabBarTheme: TabBarThemeData(
      labelColor: AppColors.iconColor, // gold active
      unselectedLabelColor: AppColors.textColor.withAlpha(150),
      indicatorSize: TabBarIndicatorSize.label,
      indicatorColor: AppColors.iconColor,
      labelStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.normal,
      ),
    ),

    // ── Chip ───────────────────────────────────────────────────────────────
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.buttonColor4,
      disabledColor: AppColors.lightGrey,
      selectedColor: AppColors.primaryColor.withAlpha(51),
      secondarySelectedColor: AppColors.primaryColor,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      labelStyle: TextStyle(color: AppColors.textColor, fontSize: 12.sp),
      secondaryLabelStyle: TextStyle(
        color: AppColors.whiteColor,
        fontSize: 12.sp,
      ),
      brightness: Brightness.light,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
        side: BorderSide(color: AppColors.primaryColor.withAlpha(51)),
      ),
    ),

    // ── Slider ─────────────────────────────────────────────────────────────
    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors.primaryColor,
      inactiveTrackColor: AppColors.primaryColor.withAlpha(51),
      thumbColor: AppColors.primaryColor,
      overlayColor: AppColors.primaryColor.withAlpha(32),
      valueIndicatorColor: AppColors.primaryColor,
      valueIndicatorTextStyle: TextStyle(color: AppColors.whiteColor),
    ),

    // ── Input Decoration ───────────────────────────────────────────────────
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.coachColorFF21321E,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24.r),
        borderSide: const BorderSide(color: AppColors.coachColorFF334B2F),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24.r),
        borderSide: const BorderSide(color: AppColors.coachColorFF334B2F),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24.r),
        borderSide: BorderSide(
          color: AppColors.iconColor,
          width: 1.5,
        ), // gold on focus
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24.r),
        borderSide: BorderSide(color: AppColors.redAlphaColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24.r),
        borderSide: BorderSide(color: AppColors.redAlphaColor, width: 1.5),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24.r),
        borderSide: BorderSide(color: AppColors.inputBorderColor.withAlpha(50)),
      ),
      hintStyle: TextStyle(
        color: AppColors.hintTextColor, // #A9A8A8
        fontSize: 14.sp,
      ),
      labelStyle: TextStyle(color: AppColors.textColor, fontSize: 14.sp),
    ),

    // ── Elevated Button ────────────────────────────────────────────────────
    //   CustomButton resolves from this for default colors
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonColor, // #AC823A
        foregroundColor: AppColors.whiteColor, // #FFFFFF
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        textStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w900,
          fontFamily: 'Proxima Nova',
        ),
      ),
    ),

    // ── Switch ─────────────────────────────────────────────────────────────
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.iconColor;
        return AppColors.textColor;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.iconColor.withAlpha(80);
        }
        return AppColors.buttonColor4;
      }),
    ),

    // ── Dialog ─────────────────────────────────────────────────────────────
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.defaultColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
        side: BorderSide(color: AppColors.primaryColor.withAlpha(51), width: 1),
      ),
      titleTextStyle: TextStyle(
        color: AppColors.whiteColor,
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Georgia',
      ),
      contentTextStyle: TextStyle(
        color: AppColors.textColor.withAlpha(217),
        fontSize: 13.sp,
        fontFamily: 'Segoe UI',
      ),
    ),

    // ── Bottom Sheet ───────────────────────────────────────────────────────
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.popupBackgroundColor, // #20341F
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
    ),

    // ── Divider ────────────────────────────────────────────────────────────
    dividerTheme: DividerThemeData(
      color: AppColors.dividerColor.withAlpha(100),
      thickness: 1,
      space: 1,
    ),

    // ── Progress Indicator ─────────────────────────────────────────────────
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColors.iconColor, // gold spinner
      linearTrackColor: AppColors.iconColor.withAlpha(30),
    ),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // DARK THEME
  // ═══════════════════════════════════════════════════════════════════════════
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Segoe UI',
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryColor,
    hintColor: AppColors.white38Color,
    scaffoldBackgroundColor: Colors.transparent,

    // ── Design System Extension ────────────────────────────────────────────
    extensions: [
      AppDesignSystem(
        // Gradients
        primaryGradient: _goldGradient,
        secondaryGradient: _goldGradient,
        deepGradient: _deepGoldGradient,
        progressBarGradient: _progressBarGradient,

        // Glass — slightly more opaque for dark mode
        glassOpacity: 0.15,
        glassBorderOpacity: 0.25,

        // Card / Container tokens
        cardFillColor: AppColors.buttonColor4,
        cardBorderColor: AppColors.buttonBorderColor4,
        cardFillMuted: AppColors.buttonColor4.withAlpha(30),
        cardBorderMuted: AppColors.buttonBorderColor4.withAlpha(30),

        // Input
        inputFillColor: AppColors.coachColorFF21321E,
        inputBorderColor: AppColors.coachColorFF334B2F,
        inputShadowColor: AppColors.coachColorFF2E4429,
        inputFocusBorderColor: AppColors.iconColor,

        // Tab Bar
        tabactiveThumbColor: AppColors.iconColor,
        tabInactiveThumbColor: AppColors.white38Color,
        tabIndicatorColor: AppColors.iconColor,

        // Checkbox
        checkboxactiveThumbColor: AppColors.iconColor,
        checkboxInactiveThumbColor: AppColors.white24Color,
        checkboxCheckColor: AppColors.backgroundColor,

        // Bottom Sheet
        bottomSheetBackground: AppColors.popupBackgroundColor,
        bottomSheetDivider: AppColors.white24Color,
        bottomSheetSelectedItem: AppColors.iconColor,

        // Upload / Chip
        uploadPillColor: AppColors.buttonColor3,
        addChipFillColor: AppColors.buttonColor4,
        addChipBorderColor: AppColors.buttonBorderColor4,

        // Celebration Badge
        badgeGlowColor: AppColors.iconColor.withAlpha(30),
        badgeSolidColor: AppColors.iconColor,

        // Status Bar
        statusBarColor: AppColors.colorFF111B10,
      ),
    ],

    // ── Color Scheme ───────────────────────────────────────────────────────
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryColor,
      brightness: Brightness.dark,
      primary: AppColors.primaryColor,
      onPrimary: AppColors.whiteColor,
      surface: AppColors.defaultColor, // #22331F
      onSurface: AppColors.whiteColor,
      secondary: AppColors.defaultColor,
      outline: AppColors.white24Color,
      error: AppColors.redAlphaColor,
    ),

    // ── AppBar ─────────────────────────────────────────────────────────────
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundColor,
      scrolledUnderElevation: 0,
      surfaceTintColor: AppColors.backgroundColor,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: AppColors.whiteColor),
      titleTextStyle: TextStyle(
        color: AppColors.whiteColor,
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Georgia',
      ),
    ),

    // ── Text Theme ─────────────────────────────────────────────────────────
    textTheme: TextTheme(
      displayLarge: TextStyle(
        color: AppColors.whiteColor,
        fontSize: 36.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Georgia',
      ),
      displayMedium: TextStyle(
        color: AppColors.whiteColor,
        fontSize: 28.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Georgia',
      ),
      headlineLarge: TextStyle(
        color: AppColors.whiteColor,
        fontSize: 24.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Georgia',
      ),
      titleLarge: TextStyle(
        color: AppColors.whiteColor,
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Georgia',
      ),
      titleMedium: TextStyle(
        color: AppColors.whiteColor,
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: TextStyle(
        color: AppColors.whiteColor,
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        color: AppColors.textColor,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        color: AppColors.textColor,
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        color: AppColors.textColor.withAlpha(200),
        fontSize: 11.sp,
        fontWeight: FontWeight.w400,
      ),
      labelLarge: TextStyle(
        color: AppColors.textColor,
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: TextStyle(
        color: AppColors.textColor.withAlpha(200),
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: TextStyle(
        color: AppColors.white38Color,
        fontSize: 11.sp,
        fontWeight: FontWeight.w400,
      ),
    ),

    // ── Tab Bar ─────────────────────────────────────────────────────────────
    tabBarTheme: TabBarThemeData(
      labelColor: AppColors.iconColor,
      unselectedLabelColor: AppColors.white38Color,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorColor: AppColors.iconColor,
      labelStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.normal,
      ),
    ),

    // ── Chip ───────────────────────────────────────────────────────────────
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.buttonColor4,
      disabledColor: AppColors.white12Color,
      selectedColor: AppColors.primaryColor.withAlpha(102),
      secondarySelectedColor: AppColors.primaryColor,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      labelStyle: TextStyle(color: AppColors.whiteColor, fontSize: 12.sp),
      secondaryLabelStyle: TextStyle(
        color: AppColors.whiteColor,
        fontSize: 12.sp,
      ),
      brightness: Brightness.dark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
        side: BorderSide(color: AppColors.primaryColor.withAlpha(102)),
      ),
    ),

    // ── Slider ─────────────────────────────────────────────────────────────
    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors.primaryColor,
      inactiveTrackColor: AppColors.primaryColor.withAlpha(51),
      thumbColor: AppColors.primaryColor,
      overlayColor: AppColors.primaryColor.withAlpha(32),
      valueIndicatorColor: AppColors.primaryColor,
      valueIndicatorTextStyle: TextStyle(color: AppColors.whiteColor),
    ),

    // ── Input Decoration ───────────────────────────────────────────────────
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.coachColorFF21321E,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24.r),
        borderSide: const BorderSide(color: AppColors.coachColorFF334B2F),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24.r),
        borderSide: const BorderSide(color: AppColors.coachColorFF334B2F),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24.r),
        borderSide: BorderSide(color: AppColors.iconColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24.r),
        borderSide: BorderSide(color: AppColors.redAlphaColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24.r),
        borderSide: BorderSide(color: AppColors.redAlphaColor, width: 1.5),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24.r),
        borderSide: BorderSide(color: AppColors.inputBorderColor.withAlpha(50)),
      ),
      hintStyle: TextStyle(color: AppColors.white38Color, fontSize: 14.sp),
      labelStyle: TextStyle(color: AppColors.textColor, fontSize: 14.sp),
    ),

    // ── Elevated Button ────────────────────────────────────────────────────
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonColor,
        foregroundColor: AppColors.whiteColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        textStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w900,
          fontFamily: 'Proxima Nova',
        ),
      ),
    ),

    // ── Switch ─────────────────────────────────────────────────────────────
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.iconColor;
        return AppColors.textColor;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.iconColor.withAlpha(80);
        }
        return AppColors.buttonColor4;
      }),
    ),

    // ── Dialog ─────────────────────────────────────────────────────────────
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.popupBackgroundColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
        side: BorderSide(
          color: AppColors.primaryColor.withAlpha(102),
          width: 1.5,
        ),
      ),
      titleTextStyle: TextStyle(
        color: AppColors.whiteColor,
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Georgia',
      ),
      contentTextStyle: TextStyle(
        color: AppColors.whiteColor.withAlpha(217),
        fontSize: 15.sp,
        fontFamily: 'Segoe UI',
      ),
    ),

    // ── Bottom Sheet ───────────────────────────────────────────────────────
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.popupBackgroundColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
    ),

    // ── Divider ────────────────────────────────────────────────────────────
    dividerTheme: const DividerThemeData(
      color: AppColors.white24Color,
      thickness: 1,
      space: 1,
    ),

    // ── Progress Indicator ─────────────────────────────────────────────────
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColors.iconColor,
      linearTrackColor: AppColors.iconColor.withAlpha(30),
    ),
  );
}
""");

  File('${corePath.path}/theme/design_system.dart')
    ..createSync(recursive: true)
    ..writeAsStringSync(r"""import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

@immutable
class AppDesignSystem extends ThemeExtension<AppDesignSystem> {
  // ── Gradients ──────────────────────────────────────────────────────────────
  final LinearGradient primaryGradient;
  final LinearGradient secondaryGradient;
  final LinearGradient deepGradient;
  final LinearGradient progressBarGradient;

  // ── Glass / Blur ───────────────────────────────────────────────────────────
  final double glassBlur;
  final double glassOpacity;
  final double glassBorderOpacity;

  // ── Shadows ────────────────────────────────────────────────────────────────
  final BoxShadow softShadow;
  final BoxShadow deepShadow;

  // ── Animation ──────────────────────────────────────────────────────────────
  final Duration navDuration;

  // ── Card / Container Colors ────────────────────────────────────────────────
  final Color cardFillColor;
  final Color cardBorderColor;
  final Color cardFillMuted; // lower alpha variant for saved-item cards
  final Color cardBorderMuted; // lower alpha variant for saved-item borders

  // ── Coach Specific Panels ──────────────────────────────────────────────────
  final Color panelColor;
  final Color accentPanelColor;

  // ── Input Field Colors ─────────────────────────────────────────────────────
  final Color inputFillColor;
  final Color inputBorderColor;
  final Color inputFocusBorderColor;
  final Color inputShadowColor;
  final Color inputHintColor;

  // ── Tab Bar ────────────────────────────────────────────────────────────────
  final Color tabactiveThumbColor;
  final Color tabInactiveThumbColor;
  final Color tabIndicatorColor;

  // ── Checkbox ───────────────────────────────────────────────────────────────
  final Color checkboxactiveThumbColor;
  final Color checkboxInactiveThumbColor;
  final Color checkboxCheckColor;

  // ── Bottom Sheet ───────────────────────────────────────────────────────────
  final Color bottomSheetBackground;
  final Color bottomSheetDivider;
  final Color bottomSheetSelectedItem;

  // ── Upload / Chip Buttons ──────────────────────────────────────────────────
  final Color uploadPillColor;
  final Color addChipFillColor;
  final Color addChipBorderColor;

  // ── Celebration Badge ──────────────────────────────────────────────────────
  final Color badgeGlowColor;
  final Color badgeSolidColor;

  // ── Status Bar ─────────────────────────────────────────────────────────────
  final Color statusBarColor;

  const AppDesignSystem({
    // Gradients
    required this.primaryGradient,
    required this.secondaryGradient,
    required this.deepGradient,
    this.progressBarGradient = const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [AppColors.buttonColor, AppColors.borderColor],
    ),

    // Glass
    this.glassBlur = 15.0,
    this.glassOpacity = 0.15,
    this.glassBorderOpacity = 0.2,

    // Shadows
    this.softShadow = const BoxShadow(
      color: AppColors.color14000000,
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
    this.deepShadow = const BoxShadow(
      color: AppColors.color3D000000,
      blurRadius: 20,
      offset: Offset(0, 10),
    ),

    // Animation
    this.navDuration = const Duration(milliseconds: 400),

    // Card / Container  (buttonColor4 + buttonBorderColor4 from AppColors)
    this.cardFillColor = AppColors.buttonColor4,
    this.cardBorderColor = AppColors.inputBorderColor,
    this.cardFillMuted = AppColors.color4D384737, // ~30 alpha
    this.cardBorderMuted = AppColors.color4DEBEBEB, // ~30 alpha
    // Coach Specific Panels
    this.panelColor = AppColors.colorFF2D3D2D,
    this.accentPanelColor = AppColors.colorFF1B2B1B,

    // Input
    this.inputFillColor = AppColors.colorFF21321E,
    this.inputBorderColor = AppColors.colorFF334B2F,
    this.inputFocusBorderColor = AppColors.iconColor,
    this.inputShadowColor = AppColors.colorFF2E4429,
    this.inputHintColor = AppColors.greyColor,

    // Tab Bar
    this.tabactiveThumbColor = AppColors.iconColor,
    this.tabInactiveThumbColor = AppColors.color96DAE0DA, // textColor alpha 150
    this.tabIndicatorColor = AppColors.iconColor,

    // Checkbox
    this.checkboxactiveThumbColor = AppColors.iconColor,
    this.checkboxInactiveThumbColor = AppColors.inputBorderColor,
    this.checkboxCheckColor = AppColors.backgroundColor,

    // Bottom Sheet
    this.bottomSheetBackground = AppColors.popupBackgroundColor,
    this.bottomSheetDivider = AppColors.color64C7C7C7,
    this.bottomSheetSelectedItem = AppColors.iconColor,

    // Upload / Chip
    this.uploadPillColor = AppColors.buttonColor3,
    this.addChipFillColor = AppColors.buttonColor4,
    this.addChipBorderColor = AppColors.inputBorderColor,

    // Celebration
    this.badgeGlowColor = AppColors.color1EC9A84C, // alpha ~30
    this.badgeSolidColor = AppColors.iconColor,

    // Status Bar
    this.statusBarColor = AppColors.colorFF111B10,
  });

  @override
  AppDesignSystem copyWith({
    LinearGradient? primaryGradient,
    LinearGradient? secondaryGradient,
    LinearGradient? deepGradient,
    LinearGradient? progressBarGradient,
    double? glassBlur,
    double? glassOpacity,
    double? glassBorderOpacity,
    BoxShadow? softShadow,
    BoxShadow? deepShadow,
    Duration? navDuration,
    Color? cardFillColor,
    Color? cardBorderColor,
    Color? cardFillMuted,
    Color? cardBorderMuted,
    Color? panelColor,
    Color? accentPanelColor,
    Color? inputFillColor,
    Color? inputBorderColor,
    Color? inputFocusBorderColor,
    Color? inputShadowColor,
    Color? inputHintColor,
    Color? tabactiveThumbColor,
    Color? tabInactiveThumbColor,
    Color? tabIndicatorColor,
    Color? checkboxactiveThumbColor,
    Color? checkboxInactiveThumbColor,
    Color? checkboxCheckColor,
    Color? bottomSheetBackground,
    Color? bottomSheetDivider,
    Color? bottomSheetSelectedItem,
    Color? uploadPillColor,
    Color? addChipFillColor,
    Color? addChipBorderColor,
    Color? badgeGlowColor,
    Color? badgeSolidColor,
    Color? statusBarColor,
  }) {
    return AppDesignSystem(
      primaryGradient: primaryGradient ?? this.primaryGradient,
      secondaryGradient: secondaryGradient ?? this.secondaryGradient,
      deepGradient: deepGradient ?? this.deepGradient,
      progressBarGradient: progressBarGradient ?? this.progressBarGradient,
      glassBlur: glassBlur ?? this.glassBlur,
      glassOpacity: glassOpacity ?? this.glassOpacity,
      glassBorderOpacity: glassBorderOpacity ?? this.glassBorderOpacity,
      softShadow: softShadow ?? this.softShadow,
      deepShadow: deepShadow ?? this.deepShadow,
      navDuration: navDuration ?? this.navDuration,
      cardFillColor: cardFillColor ?? this.cardFillColor,
      cardBorderColor: cardBorderColor ?? this.cardBorderColor,
      cardFillMuted: cardFillMuted ?? this.cardFillMuted,
      cardBorderMuted: cardBorderMuted ?? this.cardBorderMuted,
      panelColor: panelColor ?? this.panelColor,
      accentPanelColor: accentPanelColor ?? this.accentPanelColor,
      inputFillColor: inputFillColor ?? this.inputFillColor,
      inputBorderColor: inputBorderColor ?? this.inputBorderColor,
      inputFocusBorderColor:
          inputFocusBorderColor ?? this.inputFocusBorderColor,
      inputShadowColor: inputShadowColor ?? this.inputShadowColor,
      inputHintColor: inputHintColor ?? this.inputHintColor,
      tabactiveThumbColor: tabactiveThumbColor ?? this.tabactiveThumbColor,
      tabInactiveThumbColor:
          tabInactiveThumbColor ?? this.tabInactiveThumbColor,
      tabIndicatorColor: tabIndicatorColor ?? this.tabIndicatorColor,
      checkboxactiveThumbColor:
          checkboxactiveThumbColor ?? this.checkboxactiveThumbColor,
      checkboxInactiveThumbColor:
          checkboxInactiveThumbColor ?? this.checkboxInactiveThumbColor,
      checkboxCheckColor: checkboxCheckColor ?? this.checkboxCheckColor,
      bottomSheetBackground:
          bottomSheetBackground ?? this.bottomSheetBackground,
      bottomSheetDivider: bottomSheetDivider ?? this.bottomSheetDivider,
      bottomSheetSelectedItem:
          bottomSheetSelectedItem ?? this.bottomSheetSelectedItem,
      uploadPillColor: uploadPillColor ?? this.uploadPillColor,
      addChipFillColor: addChipFillColor ?? this.addChipFillColor,
      addChipBorderColor: addChipBorderColor ?? this.addChipBorderColor,
      badgeGlowColor: badgeGlowColor ?? this.badgeGlowColor,
      badgeSolidColor: badgeSolidColor ?? this.badgeSolidColor,
      statusBarColor: statusBarColor ?? this.statusBarColor,
    );
  }

  @override
  AppDesignSystem lerp(ThemeExtension<AppDesignSystem>? other, double t) {
    if (other is! AppDesignSystem) return this;
    return AppDesignSystem(
      // Gradients
      primaryGradient: LinearGradient.lerp(
        primaryGradient,
        other.primaryGradient,
        t,
      )!,
      secondaryGradient: LinearGradient.lerp(
        secondaryGradient,
        other.secondaryGradient,
        t,
      )!,
      deepGradient: LinearGradient.lerp(deepGradient, other.deepGradient, t)!,
      progressBarGradient: LinearGradient.lerp(
        progressBarGradient,
        other.progressBarGradient,
        t,
      )!,

      // Glass
      glassBlur: _lerpDouble(glassBlur, other.glassBlur, t),
      glassOpacity: _lerpDouble(glassOpacity, other.glassOpacity, t),
      glassBorderOpacity: _lerpDouble(
        glassBorderOpacity,
        other.glassBorderOpacity,
        t,
      ),

      // Shadows
      softShadow: BoxShadow.lerp(softShadow, other.softShadow, t)!,
      deepShadow: BoxShadow.lerp(deepShadow, other.deepShadow, t)!,

      // Animation
      navDuration: t < 0.5 ? navDuration : other.navDuration,

      // Colors
      cardFillColor: Color.lerp(cardFillColor, other.cardFillColor, t)!,
      cardBorderColor: Color.lerp(cardBorderColor, other.cardBorderColor, t)!,
      cardFillMuted: Color.lerp(cardFillMuted, other.cardFillMuted, t)!,
      cardBorderMuted: Color.lerp(cardBorderMuted, other.cardBorderMuted, t)!,
      panelColor: Color.lerp(panelColor, other.panelColor, t)!,
      accentPanelColor: Color.lerp(
        accentPanelColor,
        other.accentPanelColor,
        t,
      )!,
      inputFillColor: Color.lerp(inputFillColor, other.inputFillColor, t)!,
      inputBorderColor: Color.lerp(
        inputBorderColor,
        other.inputBorderColor,
        t,
      )!,
      inputFocusBorderColor: Color.lerp(
        inputFocusBorderColor,
        other.inputFocusBorderColor,
        t,
      )!,
      inputShadowColor: Color.lerp(
        inputShadowColor,
        other.inputShadowColor,
        t,
      )!,
      inputHintColor: Color.lerp(inputHintColor, other.inputHintColor, t)!,
      tabactiveThumbColor: Color.lerp(
        tabactiveThumbColor,
        other.tabactiveThumbColor,
        t,
      )!,
      tabInactiveThumbColor: Color.lerp(
        tabInactiveThumbColor,
        other.tabInactiveThumbColor,
        t,
      )!,
      tabIndicatorColor: Color.lerp(
        tabIndicatorColor,
        other.tabIndicatorColor,
        t,
      )!,
      checkboxactiveThumbColor: Color.lerp(
        checkboxactiveThumbColor,
        other.checkboxactiveThumbColor,
        t,
      )!,
      checkboxInactiveThumbColor: Color.lerp(
        checkboxInactiveThumbColor,
        other.checkboxInactiveThumbColor,
        t,
      )!,
      checkboxCheckColor: Color.lerp(
        checkboxCheckColor,
        other.checkboxCheckColor,
        t,
      )!,
      bottomSheetBackground: Color.lerp(
        bottomSheetBackground,
        other.bottomSheetBackground,
        t,
      )!,
      bottomSheetDivider: Color.lerp(
        bottomSheetDivider,
        other.bottomSheetDivider,
        t,
      )!,
      bottomSheetSelectedItem: Color.lerp(
        bottomSheetSelectedItem,
        other.bottomSheetSelectedItem,
        t,
      )!,
      uploadPillColor: Color.lerp(uploadPillColor, other.uploadPillColor, t)!,
      addChipFillColor: Color.lerp(
        addChipFillColor,
        other.addChipFillColor,
        t,
      )!,
      addChipBorderColor: Color.lerp(
        addChipBorderColor,
        other.addChipBorderColor,
        t,
      )!,
      badgeGlowColor: Color.lerp(badgeGlowColor, other.badgeGlowColor, t)!,
      badgeSolidColor: Color.lerp(badgeSolidColor, other.badgeSolidColor, t)!,
      statusBarColor: Color.lerp(statusBarColor, other.statusBarColor, t)!,
    );
  }

  static double _lerpDouble(double a, double b, double t) {
    return a + (b - a) * t;
  }
}
""");

  File('${corePath.path}/utils/helpers/helpers.dart')
    ..createSync(recursive: true)
    ..writeAsStringSync(r"""import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Helpers {
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  static String formatPrice(double price) {
    return "\$${price.toStringAsFixed(2)}";
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

// Helpers.hideKeyboard(context);
// Text(Helpers.formatPrice(99.5)) Output:$99.50
// Helpers.showSnackBar(
// context,
// "Login Successful",
// );
""");

  File('${corePath.path}/utils/helpers/snack_bar_helper.dart')
    ..createSync(recursive: true)
    ..writeAsStringSync(r"""import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_colors.dart';

// ── Public entry point ────────────────────────────────────────────────────────
/// Set this in main.dart:
///   SnackBarHelper.navigatorKey = navigatorKey;
class SnackBarHelper {
  static GlobalKey<NavigatorState>? navigatorKey;

  static BuildContext? get _context {
    if (navigatorKey == null) {
      debugPrint('SnackBarHelper: navigatorKey is not set yet');
      return null;
    }
    return navigatorKey?.currentState?.overlay?.context;
  }
}

// ── Types ──────────────────────────────────────────────────────────────────────
enum SnackBarType { success, error, warning, info }

class _SnackBarConfig {
  final Color backgroundColor;
  final Color accentColor;
  final Color textColor;
  final IconData icon;
  final Duration duration;

  const _SnackBarConfig({
    required this.backgroundColor,
    required this.accentColor,
    required this.textColor,
    required this.icon,
    required this.duration,
  });

  factory _SnackBarConfig.fromType(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return _SnackBarConfig(
          backgroundColor: AppColors.greenColor,
          accentColor: AppColors.greenColor.withValues(alpha: 0.4),
          textColor: AppColors.textWhiteColor,
          icon: Icons.check_circle_outline,
          duration: const Duration(seconds: 3),
        );
      case SnackBarType.error:
        return _SnackBarConfig(
          backgroundColor: AppColors.redColor,
          accentColor: AppColors.redColor.withValues(alpha: 0.4),
          textColor: AppColors.textWhiteColor,
          icon: Icons.error_outline,
          duration: const Duration(seconds: 4),
        );
      case SnackBarType.warning:
        return _SnackBarConfig(
          backgroundColor: AppColors.warningColor,
          accentColor: AppColors.warningColor.withValues(alpha: 0.4),
          textColor: AppColors.textWhiteColor,
          icon: Icons.warning_amber_rounded,
          duration: const Duration(seconds: 3),
        );
      case SnackBarType.info:
        return _SnackBarConfig(
          backgroundColor: AppColors.seeAllColor,
          accentColor: AppColors.seeAllColor.withValues(alpha: 0.4),
          textColor: AppColors.textWhiteColor,
          icon: Icons.info_outline,
          duration: const Duration(seconds: 3),
        );
    }
  }
}

// ── Queue Management ─────────────────────────────────────────────────────────
class _SnackBarQueue {
  static final _SnackBarQueue _instance = _SnackBarQueue._internal();
  factory _SnackBarQueue() => _instance;
  _SnackBarQueue._internal();

  bool _isShowing = false;
  final List<VoidCallback> _queue = [];

  Future<void> enqueue(VoidCallback show) async {
    _queue.add(show);
    if (!_isShowing) await _processQueue();
  }

  Future<void> _processQueue() async {
    while (_queue.isNotEmpty) {
      _isShowing = true;
      _queue.removeAt(0)();
      // Wait for duration + buffer for entrance and exit animations
      await Future.delayed(const Duration(milliseconds: 5000));
    }
    _isShowing = false;
  }
}

// ── Core show function ────────────────────────────────────────────────────────
void showAppSnackBar({
  required String title,
  required String message,
  SnackBarType type = SnackBarType.success,
  Color? backgroundColor,
  Color? accentColor,
  Color? textColor,
  Duration? duration,
}) {
  final context = SnackBarHelper._context;
  if (context == null) return;

  final base = _SnackBarConfig.fromType(type);
  final cfg = _SnackBarConfig(
    backgroundColor: backgroundColor ?? base.backgroundColor,
    accentColor: accentColor ?? base.accentColor,
    textColor: textColor ?? base.textColor,
    icon: base.icon,
    duration: duration ?? base.duration,
  );

  _SnackBarQueue().enqueue(() {
    final overlay = SnackBarHelper.navigatorKey?.currentState?.overlay;
    if (overlay == null) return;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _SnackBarOverlay(
        title: title,
        message: message,
        config: cfg,
        onDismiss: () {
          if (entry.mounted) entry.remove();
        },
      ),
    );
    overlay.insert(entry);
  });
}

// ── Convenience helpers ───────────────────────────────────────────────────────
void showSuccessSnackBar({
  String? title,
  required String message,
  Duration? duration,
}) => showAppSnackBar(
  title: title ?? 'Success',
  message: message,
  type: SnackBarType.success,
  duration: duration,
);

void showErrorSnackBar({
  String? title,
  required String message,
  Duration? duration,
}) => showAppSnackBar(
  title: title ?? 'Error',
  message: message,
  type: SnackBarType.error,
  duration: duration,
);

void showWarningSnackBar({
  String? title,
  required String message,
  Duration? duration,
}) => showAppSnackBar(
  title: title ?? 'Warning',
  message: message,
  type: SnackBarType.warning,
  duration: duration,
);

void showInfoSnackBar({
  required String title,
  required String message,
  Duration? duration,
}) => showAppSnackBar(
  title: title,
  message: message,
  type: SnackBarType.info,
  duration: duration,
);

// ── Overlay widget ────────────────────────────────────────────────────────────
class _SnackBarState {
  final ValueNotifier<double> slideTarget;
  final ValueNotifier<double> pulseTarget;
  bool isExiting;
  bool isDelayStarted;

  _SnackBarState()
      : slideTarget = ValueNotifier<double>(1.5),
        pulseTarget = ValueNotifier<double>(1.25),
        isExiting = false,
        isDelayStarted = false;
}

class _SnackBarOverlay extends StatelessWidget {
  final String title;
  final String message;
  final _SnackBarConfig config;
  final VoidCallback onDismiss;

  const _SnackBarOverlay({
    required this.title,
    required this.message,
    required this.config,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<_SnackBarState>(
      initialValue: _SnackBarState(),
      builder: (fieldState) {
        final state = fieldState.value!;

        // Trigger the slide entrance animation post-frame
        if (state.slideTarget.value == 1.5 && !state.isExiting && !state.isDelayStarted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            state.slideTarget.value = 0.0;
          });
        }

        // Start the duration delay timer to exit
        if (!state.isDelayStarted) {
          state.isDelayStarted = true;
          Future.delayed(config.duration + const Duration(milliseconds: 600), () {
            state.isExiting = true;
            state.slideTarget.value = 1.5;
          });
        }

        return Positioned(
          top: 60.h,
          right: 16.w,
          left: 16.w,
          child: ValueListenableBuilder<double>(
            valueListenable: state.slideTarget,
            builder: (context, slideVal, _) {
              return TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: state.isExiting ? 0.0 : 1.5, end: slideVal),
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutBack,
                onEnd: () {
                  if (state.isExiting && slideVal == 1.5) {
                    onDismiss();
                  }
                },
                builder: (context, val, child) {
                  return Transform.translate(
                    offset: Offset(val * MediaQuery.of(context).size.width, 0),
                    child: child,
                  );
                },
                child: Align(
                  alignment: Alignment.topRight,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 0.9.sw),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            config.backgroundColor,
                            config.accentColor,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: [
                              config.backgroundColor,
                              config.accentColor,
                            ].first.withValues(alpha: 0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(16.w, 14.h, 8.w, 14.h),
                              child: Row(
                                children: [
                                  // Pulse Icon Animation
                                  ValueListenableBuilder<double>(
                                    valueListenable: state.pulseTarget,
                                    builder: (context, pulseVal, child) {
                                      return TweenAnimationBuilder<double>(
                                        tween: Tween<double>(begin: pulseVal == 1.25 ? 1.0 : 1.25, end: pulseVal),
                                        duration: const Duration(milliseconds: 800),
                                        onEnd: () {
                                          state.pulseTarget.value = pulseVal == 1.25 ? 1.0 : 1.25;
                                        },
                                        builder: (context, scale, child) {
                                          return Transform.scale(
                                            scale: scale,
                                            child: child,
                                          );
                                        },
                                        child: child,
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(8.w),
                                      decoration: BoxDecoration(
                                        color: AppColors.whiteColor.withValues(alpha: 0.2),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.whiteColor.withValues(alpha: 0.1),
                                            blurRadius: 10,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        config.icon,
                                        color: config.textColor,
                                        size: 24.w,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 14.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          title,
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: config.textColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.sp,
                                            letterSpacing: 0.5,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          message,
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: config.textColor.withValues(
                                              alpha: 0.9,
                                            ),
                                            fontSize: 12.sp,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      if (!state.isExiting) {
                                        state.isExiting = true;
                                        state.slideTarget.value = 1.5;
                                      }
                                    },
                                    icon: Icon(
                                      Icons.close_rounded,
                                      color: config.textColor.withValues(
                                        alpha: 0.8,
                                      ),
                                      size: 22.w,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ),
                            ),
                            // Futuristic Progress Bar
                            if (!state.isExiting)
                              TweenAnimationBuilder<double>(
                                tween: Tween<double>(begin: 1.0, end: 0.0),
                                duration: config.duration,
                                builder: (context, progressVal, _) {
                                  return LinearProgressIndicator(
                                    value: progressVal, // Shrinks as time passes
                                    minHeight: 5.h,
                                    backgroundColor: AppColors.blackColor.withValues(alpha: 0.1),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      config.textColor.withValues(alpha: 0.5),
                                    ),
                                  );
                                },
                              )
                            else
                              SizedBox(height: 5.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
""");

  File('${corePath.path}/utils/validators/input_validators.dart')
    ..createSync(recursive: true)
    ..writeAsStringSync(r"""/// Validators for form inputs
/// All methods return null if valid, error message if invalid
class InputValidators {
  // ── Email Validation ─────────────────────────────────────────────
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    const emailPattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final regex = RegExp(emailPattern);

    if (!regex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  // ── Password Validation ──────────────────────────────────────────
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    // Check for uppercase letter
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    // Check for lowercase letter
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }

    // Check for digit
    if (!value.contains(RegExp(r'\d'))) {
      return 'Password must contain at least one number';
    }

    // Check for special character
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }

    return null;
  }

  // ── Password Match Validation ────────────────────────────────────
  static String? validatePasswordMatch(String? password, String? confirm) {
    if (confirm == null || confirm.isEmpty) {
      return 'Please confirm your password';
    }

    if (password != confirm) {
      return 'Passwords do not match';
    }

    return null;
  }

  // ── Name Validation ──────────────────────────────────────────────
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }

    if (value.trim().length < 3) {
      return 'Name must be at least 3 characters long';
    }

    if (value.length > 50) {
      return 'Name must not exceed 50 characters';
    }

    // Check if name contains only letters and spaces
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name can only contain letters and spaces';
    }

    return null;
  }

  // ── Phone Validation ────────────────────────────────────────────
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    if (value.length < 10) {
      return 'Phone number must be at least 10 digits';
    }

    if (value.length > 15) {
      return 'Phone number must not exceed 15 digits';
    }

    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'Phone number can only contain digits';
    }

    return null;
  }

  // ── OTP Validation ──────────────────────────────────────────────
  static String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return 'OTP is required';
    }

    if (value.length != 6) {
      return 'OTP must be 6 digits';
    }

    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'OTP can only contain digits';
    }

    return null;
  }

  // ── Generic Required Field Validation ────────────────────────────
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // ── Address Validation ──────────────────────────────────────────
  static String? validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Address is required';
    }

    if (value.length < 5) {
      return 'Address must be at least 5 characters long';
    }

    if (value.length > 200) {
      return 'Address must not exceed 200 characters';
    }

    return null;
  }

  // ── City Validation ────────────────────────────────────────────
  static String? validateCity(String? value) {
    if (value == null || value.isEmpty) {
      return 'City is required';
    }

    if (value.length < 2) {
      return 'City name must be at least 2 characters long';
    }

    if (value.length > 50) {
      return 'City name must not exceed 50 characters';
    }

    return null;
  }

  // ── Postal Code Validation ────────────────────────────────────────
  static String? validatePostalCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Postal code is required';
    }

    if (value.length < 3) {
      return 'Postal code must be at least 3 characters long';
    }

    if (value.length > 20) {
      return 'Postal code must not exceed 20 characters';
    }

    return null;
  }

  // ── Card Number Validation ────────────────────────────────────────
  static String? validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Card number is required';
    }

    // Remove spaces
    final cardNumber = value.replaceAll(' ', '');

    if (cardNumber.length != 16) {
      return 'Card number must be 16 digits';
    }

    if (!RegExp(r'^\d+$').hasMatch(cardNumber)) {
      return 'Card number can only contain digits';
    }

    // Luhn algorithm validation
    if (!_luhnCheck(cardNumber)) {
      return 'Invalid card number';
    }

    return null;
  }

  // ── CVV Validation ────────────────────────────────────────────
  static String? validateCVV(String? value) {
    if (value == null || value.isEmpty) {
      return 'CVV is required';
    }

    if (value.length < 3 || value.length > 4) {
      return 'CVV must be 3 or 4 digits';
    }

    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'CVV can only contain digits';
    }

    return null;
  }

  // ── Expiry Date Validation ────────────────────────────────────────
  static String? validateExpiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Expiry date is required';
    }

    final parts = value.split('/');
    if (parts.length != 2) {
      return 'Expiry date must be in MM/YY format';
    }

    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]);

    if (month == null || year == null) {
      return 'Expiry date must contain valid numbers';
    }

    if (month < 1 || month > 12) {
      return 'Month must be between 01 and 12';
    }

    // Get current year and month
    final now = DateTime.now();
    final currentYear = now.year % 100;
    final currentMonth = now.month;

    if (year < currentYear ||
        (year == currentYear && month < currentMonth)) {
      return 'Card has expired';
    }

    return null;
  }

  // ── Promo Code Validation ────────────────────────────────────────
  static String? validatePromoCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Promo code is required';
    }

    if (value.length < 3) {
      return 'Promo code must be at least 3 characters';
    }

    if (value.length > 20) {
      return 'Promo code must not exceed 20 characters';
    }

    if (!RegExp(r'^[A-Z0-9]+$').hasMatch(value.toUpperCase())) {
      return 'Promo code can only contain letters and numbers';
    }

    return null;
  }

  // ── URL Validation ────────────────────────────────────────────
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL is required';
    }

    final urlPattern =
        r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$';
    final regex = RegExp(urlPattern);

    if (!regex.hasMatch(value)) {
      return 'Please enter a valid URL';
    }

    return null;
  }

  // ── Helper method: Luhn Algorithm ────────────────────────────────
  static bool _luhnCheck(String cardNumber) {
    int sum = 0;
    bool isEven = false;

    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cardNumber[i]);

      if (isEven) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;
        }
      }

      sum += digit;
      isEven = !isEven;
    }

    return sum % 10 == 0;
  }
}

""");

  File('${corePath.path}/utils/validators/validators.dart')
    ..createSync(recursive: true)
    ..writeAsStringSync(r"""class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');

    if (!emailRegex.hasMatch(value)) {
      return "Invalid email";
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }

    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }

    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Name is required";
    }

    return null;
  }
}

// TextFormField(
// validator: Validators.validateEmail,
// )
// validator: (value) =>
// Validators.validatePassword(value),
// TextFormField(
// validator: (value) {
// if (value == null || value.isEmpty) {
// return "Required";
// }
// return null;
// },
// )
""");

  File('${corePath.path}/widgets/background_widget.dart')
    ..createSync(recursive: true)
    ..writeAsStringSync(r"""import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';

class BackgroundWidget extends StatelessWidget {
  final Widget child;
  final String imagePath;

  const BackgroundWidget({
    super.key,
    required this.child,
    this.imagePath = 'assets/images/bg.png',
  });

  @override
  Widget build(BuildContext context) {
    final bool isDefaultBg = imagePath == 'assets/images/bg.png';
    // Use paddingOf to get the system status bar height
    final double topPadding = MediaQuery.paddingOf(context).top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: isDefaultBg
            ? AppColors.colorFF111B10
            : Colors.transparent,
        statusBarIconBrightness: isDefaultBg
            ? Brightness.light
            : Brightness.dark,
        statusBarBrightness: isDefaultBg ? Brightness.dark : Brightness.light,
      ),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: isDefaultBg && topPadding > 0
            ? Column(
                children: [
                  // This container colors the status bar area
                  Container(height: topPadding, color: AppColors.colorFF111B10),
                  // We MUST remove the top padding for the child,
                  // otherwise any SafeArea or AppBar inside 'child'
                  // will add another gap, making it look "too big".
                  Expanded(
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: child,
                    ),
                  ),
                ],
              )
            : child,
      ),
    );
  }
}
""");

  File('${corePath.path}/widgets/custom_app_dialog.dart')
    ..createSync(recursive: true)
    ..writeAsStringSync(r"""import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';
import '../constants/app_assets.dart';
import 'custom_button.dart';

class CustomAppDialog extends StatelessWidget {
  final String title;
  final String description;
  final String primaryText;
  final VoidCallback onPrimaryTap;
  final String? secondaryText;
  final VoidCallback? onSecondaryTap;
  final Widget? icon;
  final bool showLogo;

  const CustomAppDialog({
    super.key,
    required this.title,
    required this.description,
    required this.primaryText,
    required this.onPrimaryTap,
    this.secondaryText,
    this.onSecondaryTap,
    this.icon,
    this.showLogo = true,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        padding: EdgeInsets.all(24.r),
        decoration: BoxDecoration(
          color: AppColors.defaultColor,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: AppColors.colorFFD4AF37.withAlpha(102),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.blackColor.withAlpha(128),
              blurRadius: 40,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (showLogo) ...[
              Image.asset(
                AppAssets.sb1Logo,
                height: 60.h,
              ),
              SizedBox(height: 20.h),
            ] else if (icon != null) ...[
              icon!,
              SizedBox(height: 20.h),
            ],
            
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.whiteColor,
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Georgia',
                letterSpacing: 0.5,
                height: 1.2,
              ),
            ),
            
            SizedBox(height: 12.h),
            
            Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.whiteColor.withAlpha(217),
                fontSize: 15.sp,
                height: 1.5,
                fontFamily: 'Proxima Nova',
              ),
            ),
            
            SizedBox(height: 32.h),
            
            CustomButton(
              onPress: () async {
                Navigator.pop(context);
                onPrimaryTap();
              },
              title: primaryText,
              linearGradient: true,
              height: 52,
              fontSize: 16,
            ),
            
            if (secondaryText != null) ...[
              SizedBox(height: 12.h),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  onSecondaryTap?.call();
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColors.iconColor.withAlpha(153),
                      width: 1.2,
                    ),
                  ),
                  child: Text(
                    secondaryText!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.whiteColor.withAlpha(242),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Helper function to show the custom app dialog
void showAppCustomDialog(
  BuildContext context, {
  required String title,
  required String description,
  required String primaryText,
  required VoidCallback onPrimaryTap,
  String? secondaryText,
  VoidCallback? onSecondaryTap,
  Widget? icon,
  bool showLogo = true,
}) {
  showDialog(
    context: context,
    // Solid barrier color using exact color from AppColors
    barrierColor: AppColors.defaultColor,
    builder: (context) => CustomAppDialog(
      title: title,
      description: description,
      primaryText: primaryText,
      onPrimaryTap: onPrimaryTap,
      secondaryText: secondaryText,
      onSecondaryTap: onSecondaryTap,
      icon: icon,
      showLogo: showLogo,
    ),
  );
}
""");

  File('${corePath.path}/widgets/custom_bottom_sheet.dart')
    ..createSync(recursive: true)
    ..writeAsStringSync(r"""import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBottomSheet extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final bool showHandle;

  const CustomBottomSheet({
    super.key,
    required this.title,
    required this.children,
    this.showHandle = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bsTheme = theme.bottomSheetTheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 32.h),
      decoration: BoxDecoration(
        color: bsTheme.backgroundColor,
        borderRadius: (bsTheme.shape as RoundedRectangleBorder).borderRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showHandle) ...[
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: theme.dividerColor.withAlpha(77),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 24.h),
          ],
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontFamily: 'Georgia',
            ),
          ),
          SizedBox(height: 24.h),
          ...children,
        ],
      ),
    );
  }
}

class BottomSheetAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? color;

  const BottomSheetAction({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      leading: Icon(icon, color: color ?? theme.iconTheme.color),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: color,
        ),
      ),
      contentPadding: EdgeInsets.zero,
    );
  }
}

void showAppBottomSheet(
  BuildContext context, {
  required String title,
  required List<Widget> children,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => CustomBottomSheet(
      title: title,
      children: children,
    ),
  );
}
""");

  File('${corePath.path}/widgets/custom_button.dart')
    ..createSync(recursive: true)
    ..writeAsStringSync(r"""import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/app_colors.dart';
import '../theme/design_system.dart';
import 'custom_loader.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPress,
    required this.title,
    this.subtitle = '',
    this.buttonColor = AppColors.buttonColor,
    this.buttonColor1 = AppColors.buttonColor1,
    this.textColor = AppColors.textWhiteColor,
    this.subtextColor = AppColors.textWhiteColor,
    this.borderColor = AppColors.borderColor,
    this.borderShadowColor = AppColors.boxShadowColor,
    this.borderWidth = 1,
    this.height = 50,
    this.width = double.infinity,
    this.radius = 12,
    this.fontSize = 14,
    this.subfontSize = 12,
    this.fontWeight = FontWeight.w900,
    this.subfontWeight = FontWeight.w400,
    this.fontFamily = 'Proxima Nova',
    this.subfontFamily = 'Proxima Nova',
    this.loading = false,
    this.center = true,
    this.linearGradient = false,
    this.horizontalPadding = 16,

    // Leading properties
    this.leadingIcon = '',
    this.leadingWidget,
    this.leadingIconHeight = 25,
    this.leadingIconWidth = 25,
    this.leadingPadding = const EdgeInsets.only(right: 8),
    this.useLeadingColor = false,

    // Trailing properties
    this.trailingIcon = '',
    this.trailingWidget,
    this.trailingIconHeight = 25,
    this.trailingIconWidth = 25,
    this.trailingPadding = const EdgeInsets.only(left: 8),
    this.useTrailingColor = false,

    this.iconColor,
  });

  final String title,
      subtitle,
      fontFamily,
      subfontFamily,
      leadingIcon,
      trailingIcon;
  final Widget? leadingWidget, trailingWidget;
  final double borderWidth,
      height,
      width,
      radius,
      fontSize,
      subfontSize,
      leadingIconHeight,
      leadingIconWidth,
      trailingIconHeight,
      trailingIconWidth,
      horizontalPadding;
  final EdgeInsetsGeometry leadingPadding, trailingPadding;
  final Future<void> Function()? onPress;
  final Color textColor,
      subtextColor,
      buttonColor,
      buttonColor1,
      borderColor,
      borderShadowColor;
  final Color? iconColor;
  final FontWeight fontWeight, subfontWeight;
  final bool loading, center, linearGradient, useLeadingColor, useTrailingColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final designSystem = theme.extension<AppDesignSystem>();
    final buttonStyle = theme.elevatedButtonTheme.style;

    // Resolve colors from theme if they are defaults
    final effectiveButtonColor = buttonColor == AppColors.buttonColor
        ? (buttonStyle?.backgroundColor?.resolve({}) ?? buttonColor)
        : buttonColor;
    final effectiveTextColor = textColor == AppColors.textWhiteColor
        ? (buttonStyle?.foregroundColor?.resolve({}) ?? textColor)
        : textColor;
    final effectiveIconColor = iconColor ?? effectiveTextColor;

    // Determine Gradient
    final Gradient? effectiveGradient = linearGradient
        ? (designSystem?.primaryGradient ??
              LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [buttonColor, buttonColor1, buttonColor],
              ))
        : null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (onPress != null && !loading) ? () => onPress!() : null,
        borderRadius: BorderRadius.circular(radius.r),
        child: Container(
          height: height.h,
          width: width.w,
          decoration: ShapeDecoration(
            color: effectiveGradient == null ? effectiveButtonColor : null,
            gradient: effectiveGradient,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius.r),
              side: BorderSide(color: borderColor, width: borderWidth.r),
            ),
            shadows: [
              if (borderShadowColor != Colors.transparent)
                designSystem?.softShadow ??
                    BoxShadow(
                      color: borderShadowColor,
                      blurRadius: 12,
                      offset: const Offset(0, 12),
                      spreadRadius: 0,
                    ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding.w),
            child: loading
                ? CustomLoader(
                    size: 20,
                    color: effectiveTextColor,
                    // strokeWidth: 2,
                  )
                : _buildContent(
                    context,
                    effectiveTextColor,
                    effectiveIconColor,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Color textColor, Color iconColor) {
    final theme = Theme.of(context);

    final leading =
        leadingWidget ??
        (leadingIcon.isNotEmpty
            ? _buildAsset(
                leadingIcon,
                leadingIconWidth,
                leadingIconHeight,
                useLeadingColor,
                iconColor,
              )
            : null);

    final trailing =
        trailingWidget ??
        (trailingIcon.isNotEmpty
            ? _buildAsset(
                trailingIcon,
                trailingIconWidth,
                trailingIconHeight,
                useTrailingColor,
                iconColor,
              )
            : null);

    final textColumn = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: center ? TextAlign.center : TextAlign.start,
          style: theme.textTheme.titleSmall?.copyWith(
            color: textColor,
            fontSize: fontSize.sp,
            fontWeight: fontWeight,
            fontFamily: fontFamily,
            shadows: [
              Shadow(
                offset: const Offset(0, 0),
                blurRadius: 5,
                color: AppColors.blackColor.withAlpha(232),
              ),
            ],
          ),
        ),
        if (subtitle.isNotEmpty)
          Text(
            subtitle,
            textAlign: center ? TextAlign.center : TextAlign.start,
            style: theme.textTheme.bodySmall?.copyWith(
              color: subtextColor,
              fontSize: subfontSize.sp,
              fontWeight: subfontWeight,
              fontFamily: subfontFamily,
            ),
          ),
      ],
    );

    return Row(
      mainAxisAlignment: center
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      children: [
        if (leading != null) Padding(padding: leadingPadding, child: leading),
        if (center) textColumn else Expanded(child: textColumn),
        if (trailing != null)
          Padding(padding: trailingPadding, child: trailing),
      ],
    );
  }

  Widget _buildAsset(
    String path,
    double width,
    double height,
    bool useColor,
    Color color,
  ) {
    if (path.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(
        path,
        width: width.w,
        height: height.h,
        colorFilter: useColor ? ColorFilter.mode(color, BlendMode.srcIn) : null,
      );
    }
    return Image.asset(
      path,
      width: width.w,
      height: height.h,
      color: useColor ? color : null,
      fit: BoxFit.contain,
    );
  }
}
""");

  File('${corePath.path}/widgets/custom_dialog.dart')
    ..createSync(recursive: true)
    ..writeAsStringSync(r"""import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';
import '../constants/app_assets.dart';
import 'custom_button.dart';

/// A premium, theme-consistent custom dialog for the Stronger By Two app.
class CustomDialog extends StatelessWidget {
  final String title;
  final String description;
  final String primaryText;
  final VoidCallback onPrimaryTap;
  final String? secondaryText;
  final VoidCallback? onSecondaryTap;
  final Widget? topWidget;
  final bool showLogo;

  const CustomDialog({
    super.key,
    required this.title,
    required this.description,
    required this.primaryText,
    required this.onPrimaryTap,
    this.secondaryText,
    this.onSecondaryTap,
    this.topWidget,
    this.showLogo = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dialogTheme = theme.dialogTheme;

    return Dialog(
      backgroundColor: dialogTheme.backgroundColor,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      shape: dialogTheme.shape,
      surfaceTintColor: dialogTheme.surfaceTintColor,
      child: Container(
        padding: EdgeInsets.all(24.r),
        decoration: BoxDecoration(
          color: dialogTheme.backgroundColor,
          borderRadius:
              (dialogTheme.shape as RoundedRectangleBorder).borderRadius,
          boxShadow: [
            BoxShadow(
              color: AppColors.blackColor.withAlpha(102),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header Image/Logo
            if (topWidget != null)
              topWidget!
            else if (showLogo)
              Image.asset(AppAssets.sb1Logo, height: 65.h),

            SizedBox(height: 20.h),

            /// TITLE
            Text(
              title,
              textAlign: TextAlign.center,
              style: dialogTheme.titleTextStyle,
            ),

            SizedBox(height: 12.h),

            /// DESCRIPTION
            Text(
              description,
              textAlign: TextAlign.center,
              style: dialogTheme.contentTextStyle,
            ),

            SizedBox(height: 32.h),

            /// PRIMARY BUTTON
            CustomButton(
              onPress: () async {
                Navigator.pop(context); // Close dialog
                onPrimaryTap();
              },
              title: primaryText,
              linearGradient: true,
              height: 52,
              fontSize: 16,
            ),

            if (secondaryText != null) ...[
              SizedBox(height: 14.h),

              /// SECONDARY BUTTON
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  onSecondaryTap?.call();
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColors.iconColor.withAlpha(102),
                      width: 1.2,
                    ),
                  ),
                  child: Text(
                    secondaryText!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: dialogTheme.contentTextStyle?.color?.withAlpha(
                        230,
                      ),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Utility function to show the CustomDialog
void showAppCustomDialog(
  BuildContext context, {
  required String title,
  required String description,
  required String primaryText,
  required VoidCallback onPrimaryTap,
  String? secondaryText,
  VoidCallback? onSecondaryTap,
  Widget? topWidget,
  bool showLogo = true,
  bool barrierDismissible = true,
}) {
  showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: AppColors.blackColor.withAlpha(166),
    builder: (context) => CustomDialog(
      title: title,
      description: description,
      primaryText: primaryText,
      onPrimaryTap: onPrimaryTap,
      secondaryText: secondaryText,
      onSecondaryTap: onSecondaryTap,
      topWidget: topWidget,
      showLogo: showLogo,
    ),
  );
}
""");

  File('${corePath.path}/widgets/custom_dropdown.dart')
    ..createSync(recursive: true)
    ..writeAsStringSync(r"""import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/app_colors.dart';

class CustomDropdown extends StatelessWidget {
  // controller must be ValueNotifier<String> (single) or ValueNotifier<List<String>> (multi)
  final ValueNotifier<dynamic> controller;
  final List<String> items;
  final String title;
  final void Function(dynamic value)? onChanged;
  final bool enabled;

  // Title Text
  final bool showTitle;
  final double titlePaddingBottom;
  final TextStyle? titleStyle;
  final Color titleColor;
  final double titleFontSize;
  final FontWeight titleFontWeight;
  final String titleFontFamily;
  final double? titleLetterSpacing;
  final EdgeInsets? titlePadding;

  // Container
  final double? height;
  final double width;
  final double containerPaddingHorizontal;
  final double containerPaddingVertical;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final bool shadow;
  final Color? shadowColor;
  final double shadowBlur;
  final Offset shadowOffset;
  final Gradient? gradient;

  // Leading & Trailing Assets (Support SVG/Image/Widget)
  final String leadingIcon;
  final Widget? leadingWidget;
  final double leadingIconHeight;
  final double leadingIconWidth;
  final EdgeInsetsGeometry leadingPadding;
  final bool useLeadingColor;
  final Color? leadingColor;

  final String trailingIcon;
  final Widget? trailingWidget;
  final double trailingIconHeight;
  final double trailingIconWidth;
  final EdgeInsetsGeometry trailingPadding;
  final bool useTrailingColor;
  final Color? trailingColor;

  // Hint
  final String hintText;
  final TextStyle? hintStyle;
  final Color hintColor;
  final double hintFontSize;
  final FontWeight hintFontWeight;
  final String hintFontFamily;

  // Selected text
  final TextStyle? selectedTextStyle;
  final Color selectedTextColor;
  final double selectedTextFontSize;
  final FontWeight selectedTextFontWeight;
  final String selectedTextFontFamily;

  // Menu popup (Single Select)
  final Color menuBackgroundColor;
  final double menuElevation;
  final double? menuMaxHeight;

  // Menu item text
  final TextStyle? menuItemStyle;
  final Color menuItemColor;
  final double menuItemFontSize;
  final FontWeight menuItemFontWeight;
  final String menuItemFontFamily;

  // Multi-select specific
  final bool multiSelect;
  final Color? dialogBackgroundColor;
  final String dialogTitle;
  final TextStyle? dialogTitleStyle;
  final Color dialogTitleColor;
  final double dialogTitleFontSize;
  final FontWeight dialogTitleFontWeight;
  final String dialogTitleFontFamily;
  final TextStyle? dialogItemStyle;
  final Color dialogItemColor;
  final double dialogItemFontSize;
  final FontWeight dialogItemFontWeight;
  final String dialogItemFontFamily;
  final Color checkboxActiveColor;
  final double dialogRadius;

  // Initial values
  final String? initialSingleValue;
  final List<String>? initialMultiValues;

  const CustomDropdown({
    super.key,
    required this.controller,
    required this.items,
    this.title = '',
    this.onChanged,
    this.enabled = true,

    // Title
    this.showTitle = true,
    this.titlePaddingBottom = 6,
    this.titleStyle,
    this.titleColor = AppColors.textColor,
    this.titleFontSize = 14,
    this.titleFontWeight = FontWeight.w600,
    this.titleFontFamily = 'Proxima Nova',
    this.titleLetterSpacing,
    this.titlePadding,

    // Container
    this.height,
    this.width = double.infinity,
    this.containerPaddingHorizontal = 12,
    this.containerPaddingVertical = 0,
    this.backgroundColor = AppColors.whiteColor,
    this.borderColor = AppColors.borderColor,
    this.borderWidth = 1,
    this.borderRadius = 12,
    this.shadow = false,
    this.shadowColor,
    this.shadowBlur = 4,
    this.shadowOffset = const Offset(0, 2),
    this.gradient,

    // Leading
    this.leadingIcon = '',
    this.leadingWidget,
    this.leadingIconHeight = 20,
    this.leadingIconWidth = 20,
    this.leadingPadding = const EdgeInsets.only(right: 10),
    this.useLeadingColor = true,
    this.leadingColor,

    // Trailing
    this.trailingIcon = '',
    this.trailingWidget,
    this.trailingIconHeight = 20,
    this.trailingIconWidth = 20,
    this.trailingPadding = const EdgeInsets.only(left: 10),
    this.useTrailingColor = true,
    this.trailingColor,

    // Hint
    this.hintText = 'Select Option',
    this.hintStyle,
    this.hintColor = AppColors.hintTextColor,
    this.hintFontSize = 14,
    this.hintFontWeight = FontWeight.w400,
    this.hintFontFamily = 'Proxima Nova',

    // Selected
    this.selectedTextStyle,
    this.selectedTextColor = AppColors.textColor,
    this.selectedTextFontSize = 14,
    this.selectedTextFontWeight = FontWeight.w500,
    this.selectedTextFontFamily = 'Proxima Nova',

    // Menu
    this.menuBackgroundColor = AppColors.whiteColor,
    this.menuElevation = 8,
    this.menuMaxHeight,
    this.menuItemStyle,
    this.menuItemColor = AppColors.textColor,
    this.menuItemFontSize = 14,
    this.menuItemFontWeight = FontWeight.w400,
    this.menuItemFontFamily = 'Proxima Nova',

    // Multi
    this.multiSelect = false,
    this.dialogTitle = 'Select Items',
    this.dialogBackgroundColor,
    this.dialogTitleStyle,
    this.dialogTitleColor = AppColors.textColor,
    this.dialogTitleFontSize = 18,
    this.dialogTitleFontWeight = FontWeight.bold,
    this.dialogTitleFontFamily = 'Proxima Nova',
    this.dialogItemStyle,
    this.dialogItemColor = AppColors.textColor,
    this.dialogItemFontSize = 15,
    this.dialogItemFontWeight = FontWeight.w400,
    this.dialogItemFontFamily = 'Proxima Nova',
    this.checkboxActiveColor = AppColors.primaryColor,
    this.dialogRadius = 16,

    // Initial
    this.initialSingleValue,
    this.initialMultiValues,
  });

  @override
  Widget build(BuildContext context) {
    if (!multiSelect && initialSingleValue != null) {
      if (controller.value == null || controller.value.toString().isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (controller.value == null || controller.value.toString().isEmpty) {
            controller.value = initialSingleValue;
          }
        });
      }
    }
    if (multiSelect && initialMultiValues != null) {
      if (controller.value == null || (controller.value as List).isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (controller.value == null || (controller.value as List).isEmpty) {
            controller.value = List<String>.from(initialMultiValues!);
          }
        });
      }
    }

    return Opacity(
      opacity: enabled ? 1.0 : 0.6,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showTitle && title.isNotEmpty) _buildTitle(context),
          ValueListenableBuilder(
            valueListenable: controller,
            builder: (context, value, child) {
              return _buildContainer(context, value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: titlePadding ?? EdgeInsets.only(bottom: titlePaddingBottom.h),
      child: Text(
        title,
        style:
            titleStyle ??
            Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: titleColor,
              fontSize: titleFontSize.sp,
              fontWeight: titleFontWeight,
              fontFamily: titleFontFamily,
              letterSpacing: titleLetterSpacing,
            ),
      ),
    );
  }

  Widget _buildContainer(BuildContext context, dynamic currentValue) {
    return Container(
      width: width.w,
      height: height?.h ?? 50.h,
      padding: EdgeInsets.symmetric(
        horizontal: containerPaddingHorizontal.w,
        vertical: containerPaddingVertical.h,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius.r),
        border: Border.all(color: borderColor, width: borderWidth.w),
        boxShadow: shadow
            ? [
                BoxShadow(
                  color: shadowColor ?? AppColors.boxShadowColor,
                  blurRadius: shadowBlur,
                  offset: shadowOffset,
                ),
              ]
            : null,
      ),
      child: multiSelect
          ? _buildMultiSelectTrigger(context, currentValue)
          : _buildSingleSelect(context, currentValue),
    );
  }

  Widget _buildSingleSelect(BuildContext context, dynamic currentValue) {
    final effectiveLeading = _getLeading(selectedTextColor);

    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        isExpanded: true,
        value: (currentValue == null || currentValue.toString().isEmpty)
            ? null
            : currentValue.toString(),
        icon: _getTrailing(selectedTextColor),
        dropdownColor: menuBackgroundColor,
        elevation: menuElevation.toInt(),
        menuMaxHeight: menuMaxHeight?.h,
        borderRadius: BorderRadius.circular(borderRadius.r),
        style:
            selectedTextStyle ??
            Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: selectedTextFontSize.sp,
              color: selectedTextColor,
              fontWeight: selectedTextFontWeight,
              fontFamily: selectedTextFontFamily,
            ),
        hint: Row(
          children: [
            if (effectiveLeading != null)
              Padding(padding: leadingPadding, child: effectiveLeading),
            Expanded(
              child: Text(
                hintText,
                style:
                    hintStyle ??
                    Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: hintFontSize.sp,
                      color: hintColor,
                      fontWeight: hintFontWeight,
                      fontFamily: hintFontFamily,
                    ),
              ),
            ),
          ],
        ),
        selectedItemBuilder: (context) {
          return items.map((String item) {
            return Row(
              children: [
                if (effectiveLeading != null)
                  Padding(padding: leadingPadding, child: effectiveLeading),
                Expanded(
                  child: Text(
                    item,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        selectedTextStyle ??
                        Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: selectedTextFontSize.sp,
                          color: selectedTextColor,
                          fontWeight: selectedTextFontWeight,
                          fontFamily: selectedTextFontFamily,
                        ),
                  ),
                ),
              ],
            );
          }).toList();
        },
        onChanged: enabled
            ? (value) {
                controller.value = value;
                if (onChanged != null) onChanged!(value);
              }
            : null,
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style:
                  menuItemStyle ??
                  Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: menuItemFontSize.sp,
                    color: menuItemColor,
                    fontWeight: menuItemFontWeight,
                    fontFamily: menuItemFontFamily,
                  ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMultiSelectTrigger(BuildContext context, dynamic currentValue) {
    final List<String> selected = List<String>.from(currentValue ?? []);
    final effectiveLeading = _getLeading(selectedTextColor);

    return InkWell(
      onTap: enabled ? () => _showMultiSelectDialog(context) : null,
      child: Row(
        children: [
          if (effectiveLeading != null)
            Padding(padding: leadingPadding, child: effectiveLeading),
          Expanded(
            child: Text(
              selected.isEmpty ? hintText : selected.join(', '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: selected.isEmpty
                  ? (hintStyle ??
                        Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: hintFontSize.sp,
                          color: hintColor,
                          fontWeight: hintFontWeight,
                          fontFamily: hintFontFamily,
                        ))
                  : (selectedTextStyle ??
                        Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: selectedTextFontSize.sp,
                          color: selectedTextColor,
                          fontWeight: selectedTextFontWeight,
                          fontFamily: selectedTextFontFamily,
                        )),
            ),
          ),
          Padding(
            padding: trailingPadding,
            child: _getTrailing(
              selected.isEmpty ? hintColor : selectedTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showMultiSelectDialog(BuildContext context) async {
    final List<String> current = List<String>.from(controller.value ?? []);
    final temp = ValueNotifier<List<String>>(List.from(current));

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: dialogBackgroundColor ?? backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(dialogRadius.r),
        ),
        title: Text(
          dialogTitle,
          style:
              dialogTitleStyle ??
              Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: dialogTitleColor,
                fontSize: dialogTitleFontSize.sp,
                fontWeight: dialogTitleFontWeight,
                fontFamily: dialogTitleFontFamily,
              ),
        ),
        content: ValueListenableBuilder<List<String>>(
          valueListenable: temp,
          builder: (_, selected, __) => SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = selected.contains(item);
                return CheckboxListTile(
                  value: isSelected,
                  activeColor: checkboxActiveColor,
                  checkColor: AppColors.whiteColor,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(
                    item,
                    style:
                        dialogItemStyle ??
                        Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: dialogItemFontSize.sp,
                          color: dialogItemColor,
                          fontWeight: dialogItemFontWeight,
                          fontFamily: dialogItemFontFamily,
                        ),
                  ),
                  onChanged: (checked) {
                    final updated = List<String>.from(temp.value);
                    if (checked == true) {
                      updated.add(item);
                    } else {
                      updated.remove(item);
                    }
                    temp.value = updated;
                  },
                );
              },
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textColor3,
                fontSize: 14.sp,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: checkboxActiveColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            onPressed: () {
              controller.value = List<String>.from(temp.value);
              if (onChanged != null) {
                onChanged!(controller.value);
              }
              Navigator.pop(context);
            },
            child: Text(
              'OK',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.whiteColor,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget? _getLeading(Color color) {
    return leadingWidget ??
        (leadingIcon.isNotEmpty
            ? _buildAsset(
                leadingIcon,
                leadingIconWidth,
                leadingIconHeight,
                useLeadingColor,
                leadingColor ?? color,
              )
            : null);
  }

  Widget _getTrailing(Color color) {
    return trailingWidget ??
        (trailingIcon.isNotEmpty
            ? _buildAsset(
                trailingIcon,
                trailingIconWidth,
                trailingIconHeight,
                useTrailingColor,
                trailingColor ?? color,
              )
            : Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 24.sp,
                color: color,
              ));
  }

  Widget _buildAsset(
    String path,
    double width,
    double height,
    bool useColor,
    Color color,
  ) {
    if (path.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(
        path,
        width: width.w,
        height: height.h,
        colorFilter: useColor ? ColorFilter.mode(color, BlendMode.srcIn) : null,
      );
    }
    return Image.asset(
      path,
      width: width.w,
      height: height.h,
      color: useColor ? color : null,
      fit: BoxFit.contain,
    );
  }
}
""");

  File('${corePath.path}/widgets/custom_input.dart')
    ..createSync(recursive: true)
    ..writeAsStringSync(r"""import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../constants/app_colors.dart';

import '../theme/design_system.dart';

class _InputState {
  bool isObscured;
  bool isFocused;
  String? errorText;

  _InputState({required this.isObscured, required this.isFocused});
}

class CustomInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? title;
  final bool obscureText;
  final bool showObscureToggle;
  final bool readOnly;
  final bool enabled;
  final bool autofocus;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextAlign textAlign;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final AutovalidateMode? autovalidateMode;

  // Title Style
  final bool showTitle;
  final TextStyle? titleStyle;
  final Color? titleColor;
  final double? titleFontSize;
  final FontWeight? titleFontWeight;
  final String? titleFontFamily;
  final double titlePaddingBottom;

  // Container & Decoration
  final double? height;
  final double width;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final Color? disabledBorderColor;
  final double? borderWidth;
  final double? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final bool shadow;
  final Color? shadowColor;
  final Gradient? gradient;

  // Text Styles
  final TextStyle? textStyle;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily;

  final TextStyle? hintStyle;
  final Color? hintColor;
  final double? hintFontSize;
  final FontWeight? hintFontWeight;
  final String? hintFontFamily;

  // Leading (Prefix)
  final String leadingIcon;
  final Widget? leadingWidget;
  final double leadingIconHeight;
  final double leadingIconWidth;
  final EdgeInsetsGeometry leadingPadding;
  final bool useLeadingColor;
  final Color? leadingColor;

  // Trailing (Suffix)
  final String trailingIcon;
  final Widget? trailingWidget;
  final double trailingIconHeight;
  final double trailingIconWidth;
  final EdgeInsetsGeometry trailingPadding;
  final bool useTrailingColor;
  final Color? trailingColor;

  // Obscure Toggle Icons
  final String? visibleIcon;
  final String? hiddenIcon;
  final double obscureIconSize;

  const CustomInput({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.title,
    this.obscureText = false,
    this.showObscureToggle = false,
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.textAlign = TextAlign.start,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.focusNode,
    this.onChanged,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.onTap,
    this.validator,
    this.onSaved,
    this.autovalidateMode,

    // Title
    this.showTitle = false,
    this.titleStyle,
    this.titleColor,
    this.titleFontSize,
    this.titleFontWeight,
    this.titleFontFamily,
    this.titlePaddingBottom = 6,

    // Container
    this.height,
    this.width = double.infinity,
    this.backgroundColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.disabledBorderColor,
    this.borderWidth,
    this.borderRadius,
    this.contentPadding,
    this.shadow = false,
    this.shadowColor,
    this.gradient,

    // Text
    this.textStyle,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.fontFamily,

    // Hint
    this.hintStyle,
    this.hintColor,
    this.hintFontSize,
    this.hintFontWeight,
    this.hintFontFamily,

    // Leading
    this.leadingIcon = '',
    this.leadingWidget,
    this.leadingIconHeight = 20,
    this.leadingIconWidth = 20,
    this.leadingPadding = const EdgeInsets.only(right: 12),
    this.useLeadingColor = true,
    this.leadingColor,

    // Trailing
    this.trailingIcon = '',
    this.trailingWidget,
    this.trailingIconHeight = 20,
    this.trailingIconWidth = 20,
    this.trailingPadding = const EdgeInsets.only(left: 12),
    this.useTrailingColor = true,
    this.trailingColor,

    // Obscure
    this.visibleIcon,
    this.hiddenIcon,
    this.obscureIconSize = 22,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<AppDesignSystem>();

    return FormField<_InputState>(
      initialValue: _InputState(isObscured: obscureText, isFocused: false),
      builder: (FormFieldState<_InputState> fieldState) {
        final state = fieldState.value!;
        final hasError = state.errorText != null;

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showTitle && title != null) _buildTitle(theme),
            _buildInputField(context, theme, design, fieldState, state),
            if (hasError) _buildErrorText(theme, state.errorText!),
          ],
        );
      },
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.only(bottom: titlePaddingBottom.h),
      child: Text(
        title!,
        style:
            titleStyle ??
            theme.textTheme.labelLarge?.copyWith(
              color: titleColor ?? theme.textTheme.labelLarge?.color,
              fontSize: (titleFontSize ?? 14).sp,
              fontWeight: titleFontWeight ?? FontWeight.w600,
              fontFamily: titleFontFamily,
            ),
      ),
    );
  }

  Widget _buildErrorText(ThemeData theme, String error) {
    return Padding(
      padding: EdgeInsets.only(top: 4.h, left: 4.w),
      child: Text(
        error,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.error,
          fontSize: 11.sp,
        ),
      ),
    );
  }

  Widget _buildInputField(
    BuildContext context,
    ThemeData theme,
    AppDesignSystem? design,
    FormFieldState<_InputState> fieldState,
    _InputState state,
  ) {
    final hasError = state.errorText != null;
    final isEnabled = enabled;

    final effectiveRadius = borderRadius != null
        ? BorderRadius.circular(borderRadius!.r)
        : BorderRadius.circular(24.r);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width.w,
      height: height?.h,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color:
            backgroundColor ??
            design?.inputFillColor ??
            AppColors.colorFF21321E,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: (borderWidth ?? 0.50).w,
            color: hasError
                ? (errorBorderColor ?? theme.colorScheme.error)
                : (borderColor ??
                      design?.inputBorderColor ??
                      AppColors.colorFF334B2F),
          ),
          borderRadius: effectiveRadius,
        ),
        shadows: shadow
            ? [
                BoxShadow(
                  color:
                      shadowColor ??
                      design?.inputShadowColor ??
                      AppColors.colorFF2E4429,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      child: Center(
        child: Focus(
          onFocusChange: (hasFocus) {
            state.isFocused = hasFocus;
            fieldState.didChange(state);
          },
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            obscureText: state.isObscured,
            readOnly: readOnly,
            enabled: isEnabled,
            autofocus: autofocus,
            maxLines: maxLines,
            minLines: minLines,
            maxLength: maxLength,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            textAlign: textAlign,
            textCapitalization: textCapitalization,
            inputFormatters: inputFormatters,
            onSaved: onSaved,
            onFieldSubmitted: onFieldSubmitted,
            onEditingComplete: onEditingComplete,
            autovalidateMode: autovalidateMode,
            onChanged: (val) {
              if (hasError) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  state.errorText = null;
                  fieldState.didChange(state);
                });
              }
              onChanged?.call(val);
            },
            onTap: onTap,
            validator: (val) {
              if (validator != null) {
                final result = validator!(val);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  state.errorText = result;
                  fieldState.didChange(state);
                });
                return null; // Use custom error UI
              }
              return null;
            },
            style:
                textStyle ??
                theme.textTheme.bodyMedium?.copyWith(
                  color: isEnabled
                      ? (textColor ?? AppColors.whiteColor)
                      : theme.disabledColor,
                  fontSize: (fontSize ?? 14).sp,
                  fontWeight: fontWeight ?? FontWeight.w400,
                  fontFamily: fontFamily,
                ),
            decoration: InputDecoration(
              hintText: hintText,
              labelText: labelText,
              hintStyle:
                  hintStyle ??
                  Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color:
                        hintColor ??
                        design?.inputHintColor ??
                        AppColors.greyColor,
                    fontSize: fontSize?.sp ?? 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
              labelStyle: hintStyle ?? theme.inputDecorationTheme.labelStyle,
              isDense: true,
              contentPadding:
                  contentPadding ??
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              prefixIcon: _buildLeading(theme, hasError),
              suffixIcon: _buildTrailing(theme, hasError, fieldState, state),
              errorStyle: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(height: 0, fontSize: 0),
              counterText: '',
              fillColor: backgroundColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget? _buildLeading(ThemeData theme, bool hasError) {
    if (leadingWidget == null && leadingIcon.isEmpty) return null;
    final color = hasError
        ? theme.colorScheme.error
        : (leadingColor ?? theme.hintColor);
    final leading =
        leadingWidget ??
        Padding(
          padding: leadingPadding,
          child: _buildAsset(
            leadingIcon,
            leadingIconWidth,
            leadingIconHeight,
            useLeadingColor,
            color,
          ),
        );
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [leading],
    );
  }

  Widget? _buildTrailing(
    ThemeData theme,
    bool hasError,
    FormFieldState<_InputState> fieldState,
    _InputState state,
  ) {
    final List<Widget> children = [];
    final color = hasError
        ? theme.colorScheme.error
        : (trailingColor ?? theme.hintColor);
    if (showObscureToggle || obscureText) {
      children.add(
        GestureDetector(
          onTap: () {
            state.isObscured = !state.isObscured;
            fieldState.didChange(state);
          },
          child: _buildObscureIcon(theme, hasError, state),
        ),
      );
    }
    if (trailingWidget != null || trailingIcon.isNotEmpty) {
      final trailing =
          trailingWidget ??
          Padding(
            padding: trailingPadding,
            child: _buildAsset(
              trailingIcon,
              trailingIconWidth,
              trailingIconHeight,
              useTrailingColor,
              color,
            ),
          );
      children.add(trailing);
    }
    if (children.isEmpty) return null;
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  Widget _buildObscureIcon(ThemeData theme, bool hasError, _InputState state) {
    final color = hasError
        ? theme.colorScheme.error
        : (trailingColor ?? theme.hintColor);
    if (state.isObscured) {
      if (hiddenIcon != null) {
        return _buildAsset(
          hiddenIcon!,
          obscureIconSize,
          obscureIconSize,
          true,
          color,
        );
      }
      return Icon(
        Icons.visibility_off_outlined,
        size: obscureIconSize.sp,
        color: color,
      );
    } else {
      if (visibleIcon != null) {
        return _buildAsset(
          visibleIcon!,
          obscureIconSize,
          obscureIconSize,
          true,
          color,
        );
      }
      return Icon(
        Icons.visibility_outlined,
        size: obscureIconSize.sp,
        color: color,
      );
    }
  }

  Widget _buildAsset(
    String path,
    double width,
    double height,
    bool useColor,
    Color color,
  ) {
    if (path.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(
        path,
        width: width.w,
        height: height.h,
        colorFilter: useColor ? ColorFilter.mode(color, BlendMode.srcIn) : null,
      );
    }
    return Image.asset(
      path,
      width: width.w,
      height: height.h,
      color: useColor ? color : null,
      fit: BoxFit.contain,
    );
  }
}
""");

  File('${corePath.path}/widgets/custom_loader.dart')
    ..createSync(recursive: true)
    ..writeAsStringSync(r"""import 'dart:math';
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';

class _LoaderState {
  final ValueNotifier<double> rotateTarget;
  final ValueNotifier<double> pendulumTarget;
  _LoaderState()
      : rotateTarget = ValueNotifier<double>(1.0),
        pendulumTarget = ValueNotifier<double>(1.0);
}

class CustomLoader extends StatelessWidget {
  final double size;
  final Color? color;
  final Duration rotateDuration;
  final Duration pendulumDuration;

  const CustomLoader({
    super.key,
    this.size = 80.0,
    this.color,
    this.rotateDuration = const Duration(milliseconds: 1400),
    this.pendulumDuration = const Duration(milliseconds: 900),
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).primaryColor;

    return FormField<_LoaderState>(
      initialValue: _LoaderState(),
      builder: (fieldState) {
        final state = fieldState.value!;

        return ValueListenableBuilder<double>(
          valueListenable: state.rotateTarget,
          builder: (context, rotateTarget, _) {
            return TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: rotateTarget - 1.0, end: rotateTarget),
              duration: rotateDuration,
              onEnd: () {
                state.rotateTarget.value = rotateTarget + 1.0;
              },
              builder: (context, rotateVal, _) {
                return ValueListenableBuilder<double>(
                  valueListenable: state.pendulumTarget,
                  builder: (context, pendulumTarget, _) {
                    return TweenAnimationBuilder<double>(
                      tween: Tween<double>(
                        begin: pendulumTarget == 1.0 ? 0.0 : 1.0,
                        end: pendulumTarget,
                      ),
                      duration: pendulumDuration,
                      curve: Curves.easeInOutSine,
                      onEnd: () {
                        state.pendulumTarget.value = pendulumTarget == 1.0 ? 0.0 : 1.0;
                      },
                      builder: (context, pendulumVal, _) {
                        final double rotAngle = rotateVal * 2 * pi;
                        final double morph = pendulumVal; // 0=circle, 1=drop
                        final double maxOrbit = size * 0.26;
                        final double orbitRadius = maxOrbit * morph;
                        final double dotRadius = size * 0.14;
                        final double center = size / 2;
                        final double paintArea = dotRadius * 5.0;

                        const List<double> opacities = [1.0, 0.72, 0.48, 0.26];

                        return SizedBox(
                          width: size,
                          height: size,
                          child: Stack(
                            children: List.generate(4, (i) {
                              final double angle = rotAngle + i * pi / 2;
                              final double dx = center + orbitRadius * cos(angle);
                              final double dy = center + orbitRadius * sin(angle);

                              return Positioned(
                                left: dx - paintArea / 2,
                                top: dy - paintArea / 2,
                                child: CustomPaint(
                                  size: Size(paintArea, paintArea),
                                  painter: _WaterDropPainter(
                                    morph: morph,
                                    outwardAngle: angle,
                                    color: effectiveColor,
                                    opacity: opacities[i],
                                    dotRadius: dotRadius,
                                  ),
                                ),
                              );
                            }),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}

class _WaterDropPainter extends CustomPainter {
  final double morph;
  final double outwardAngle;
  final Color color;
  final double opacity;
  final double dotRadius;

  const _WaterDropPainter({
    required this.morph,
    required this.outwardAngle,
    required this.color,
    required this.opacity,
    required this.dotRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double r = dotRadius;
    final path = _buildMorphPath(r, morph);

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(outwardAngle - pi / 2);

    // Glow
    final glowPaint = Paint()
      ..color = color.withAlpha((opacity * 89).round())
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, glowPaint);

    // Main fill
    final fillPaint = Paint()
      ..color = color.withAlpha((opacity * 255).round())
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    // Highlight
    if (morph > 0.05) {
      final double tipR = lerpDouble(r, r * 1.30, morph)!;
      final highlightPaint = Paint()
        ..color = AppColors.whiteColor.withAlpha((opacity * morph * 140).round())
        ..style = PaintingStyle.fill;
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(r * 0.20, -(tipR * 0.58)),
          width: r * 0.28 * morph,
          height: r * 0.44 * morph,
        ),
        highlightPaint,
      );
    }

    canvas.restore();
  }

  Path _buildMorphPath(double r, double m) {
    final double tipR = lerpDouble(r, r * 1.30, m)!;

    final double c1x = lerpDouble(r * 1.333, r * 0.70, m)!;
    final double c1y = lerpDouble(-r, -tipR * 0.25, m)!;
    final double c2x = lerpDouble(r * 1.333, r * 1.20, m)!;
    final double c2y = lerpDouble(r, r * 0.70, m)!;

    final path = Path();
    path.moveTo(0, -tipR);
    path.cubicTo(c1x, c1y, c2x, c2y, 0, r);
    path.cubicTo(-c2x, c2y, -c1x, c1y, 0, -tipR);
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(_WaterDropPainter old) =>
      old.morph != morph ||
      old.outwardAngle != outwardAngle ||
      old.color != color ||
      old.opacity != opacity;
}

class FullScreenLoader extends StatelessWidget {
  final String? message;

  const FullScreenLoader({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.withValues(alpha: 0.8),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CustomLoader(size: 60),
            if (message != null) ...[
              SizedBox(height: 16.h),
              Text(
                message!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textColor, fontSize: 14.sp),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ShimmerState {
  final ValueNotifier<double> target;
  _ShimmerState() : target = ValueNotifier<double>(1.0);
}

class ShimmerLoader extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerLoader({
    super.key,
    this.width = double.infinity,
    this.height = 100,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<_ShimmerState>(
      initialValue: _ShimmerState(),
      builder: (fieldState) {
        final state = fieldState.value!;
        return ValueListenableBuilder<double>(
          valueListenable: state.target,
          builder: (context, target, _) {
            return TweenAnimationBuilder<double>(
              key: ValueKey(target),
              tween: Tween<double>(begin: -2.0, end: 2.0),
              duration: const Duration(milliseconds: 1500),
              onEnd: () {
                state.target.value = target + 1.0;
              },
              builder: (context, value, _) {
                return Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: const [0.1, 0.5, 0.9],
                      colors: [
                        AppColors.whiteColor.withValues(alpha: 0.05),
                        AppColors.whiteColor.withValues(alpha: 0.15),
                        AppColors.whiteColor.withValues(alpha: 0.05),
                      ],
                      transform: _SlidingGradientTransform(
                        slidePercent: value,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({required this.slidePercent});

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}
""");

  File('${corePath.path}/widgets/custom_text_field.dart')
    ..createSync(recursive: true)
    ..writeAsStringSync(r"""import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class _InputState {
  bool isObscured;
  bool isFocused;
  String? errorText;

  _InputState({
    required this.isObscured,
    required this.isFocused,
  });
}

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? title;
  final bool isPassword;
  final bool showObscureToggle;
  final bool readOnly;
  final bool enabled;
  final bool autofocus;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextAlign textAlign;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final AutovalidateMode? autovalidateMode;

  // Title Style
  final bool showTitle;
  final TextStyle? titleStyle;
  final Color? titleColor;
  final double? titleFontSize;
  final FontWeight? titleFontWeight;
  final String? titleFontFamily;
  final double titlePaddingBottom;

  // Container & Decoration
  final double? height;
  final double width;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final Color? disabledBorderColor;
  final double borderWidth;
  final double borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final bool shadow;
  final Color? shadowColor;
  final Gradient? gradient;

  // Text Styles
  final TextStyle? textStyle;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily;

  final TextStyle? hintStyle;
  final Color? hintColor;
  final double? hintFontSize;
  final FontWeight? hintFontWeight;
  final String? hintFontFamily;

  // Leading (Prefix) - Supports Widget OR Asset Path
  final dynamic prefix; // Widget or String (path)
  final double prefixSize;
  final EdgeInsetsGeometry prefixPadding;
  final bool usePrefixColor;
  final Color? prefixColor;

  // Trailing (Suffix) - Supports Widget OR Asset Path
  final dynamic suffix; // Widget or String (path)
  final double suffixSize;
  final EdgeInsetsGeometry suffixPadding;
  final bool useSuffixColor;
  final Color? suffixColor;

  // Obscure Toggle Icons
  final dynamic visibleIcon; // Widget or String (path)
  final dynamic hiddenIcon; // Widget or String (path)
  final double obscureIconSize;

  const CustomTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.title,
    this.isPassword = false,
    this.showObscureToggle = true,
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.textAlign = TextAlign.start,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.focusNode,
    this.onChanged,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.onTap,
    this.validator,
    this.onSaved,
    this.autovalidateMode,

    // Title
    this.showTitle = false,
    this.titleStyle,
    this.titleColor,
    this.titleFontSize,
    this.titleFontWeight,
    this.titleFontFamily,
    this.titlePaddingBottom = 8,

    // Container
    this.height,
    this.width = double.infinity,
    this.backgroundColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.disabledBorderColor,
    this.borderWidth = 1,
    this.borderRadius = 12,
    this.contentPadding,
    this.shadow = false,
    this.shadowColor,
    this.gradient,

    // Text
    this.textStyle,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.fontFamily,

    // Hint
    this.hintStyle,
    this.hintColor,
    this.hintFontSize,
    this.hintFontWeight,
    this.hintFontFamily,

    // Prefix
    this.prefix,
    this.prefixSize = 20,
    this.prefixPadding = const EdgeInsets.only(right: 12),
    this.usePrefixColor = true,
    this.prefixColor,

    // Suffix
    this.suffix,
    this.suffixSize = 20,
    this.suffixPadding = const EdgeInsets.only(left: 12),
    this.useSuffixColor = true,
    this.suffixColor,

    // Obscure
    this.visibleIcon,
    this.hiddenIcon,
    this.obscureIconSize = 22,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FormField<_InputState>(
      initialValue: _InputState(
        isObscured: isPassword,
        isFocused: false,
      ),
      builder: (FormFieldState<_InputState> fieldState) {
        final state = fieldState.value!;
        final hasError = state.errorText != null;

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showTitle && title != null) _buildTitle(theme),
            _buildInputField(theme, fieldState, state),
            if (hasError) _buildErrorText(theme, state.errorText!),
          ],
        );
      },
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.only(bottom: titlePaddingBottom.h),
      child: Text(
        title!,
        style: titleStyle ??
            theme.textTheme.labelLarge?.copyWith(
              color: titleColor ?? theme.textTheme.labelLarge?.color,
              fontSize: (titleFontSize ?? 14).sp,
              fontWeight: titleFontWeight ?? FontWeight.w600,
              fontFamily: titleFontFamily,
            ),
      ),
    );
  }

  Widget _buildErrorText(ThemeData theme, String error) {
    return Padding(
      padding: EdgeInsets.only(top: 6.h, left: 4.w),
      child: Text(
        error,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.error,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildInputField(ThemeData theme, FormFieldState<_InputState> fieldState, _InputState state) {
    final hasError = state.errorText != null;
    final isEnabled = enabled;
    
    final inputTheme = theme.inputDecorationTheme;
    final colorScheme = theme.colorScheme;

    final bg = backgroundColor ?? 
               (isEnabled ? (inputTheme.fillColor ?? theme.cardColor) 
                          : (theme.disabledColor.withValues(alpha: 0.05)));
    
    final borderCol = hasError 
        ? (errorBorderColor ?? colorScheme.error)
        : (!isEnabled 
            ? (disabledBorderColor ?? theme.disabledColor.withValues(alpha: 0.2))
            : (state.isFocused 
                ? (focusedBorderColor ?? colorScheme.primary) 
                : (borderColor ?? theme.dividerColor)));

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width.w,
      height: height?.h,
      decoration: BoxDecoration(
        color: bg,
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius.r),
        border: Border.all(
          color: borderCol,
          width: (hasError || state.isFocused) ? (borderWidth + 0.5).w : borderWidth.w,
        ),
        boxShadow: shadow
            ? [
                BoxShadow(
                  color: shadowColor ?? theme.shadowColor.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Focus(
        onFocusChange: (hasFocus) {
          state.isFocused = hasFocus;
          fieldState.didChange(state);
        },
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          obscureText: state.isObscured,
          readOnly: readOnly,
          enabled: isEnabled,
          autofocus: autofocus,
          maxLines: isPassword ? 1 : maxLines,
          minLines: minLines,
          maxLength: maxLength,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textAlign: textAlign,
          textCapitalization: textCapitalization,
          inputFormatters: inputFormatters,
          onSaved: onSaved,
          onFieldSubmitted: onFieldSubmitted,
          onEditingComplete: onEditingComplete,
          autovalidateMode: autovalidateMode,
          onChanged: (val) {
            if (hasError) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                state.errorText = null;
                fieldState.didChange(state);
              });
            }
            onChanged?.call(val);
          },
          onTap: onTap,
          validator: (val) {
            if (validator != null) {
              final result = validator!(val);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                state.errorText = result;
                fieldState.didChange(state);
              });
              return null; // Handle error UI externally
            }
            return null;
          },
          style: textStyle ??
              theme.textTheme.bodyMedium?.copyWith(
                color: isEnabled 
                    ? (textColor ?? theme.textTheme.bodyMedium?.color)
                    : theme.disabledColor,
                fontSize: (fontSize ?? 14).sp,
                fontWeight: fontWeight ?? FontWeight.w400,
                fontFamily: fontFamily,
              ),
          decoration: InputDecoration(
            hintText: hintText,
            labelText: labelText,
            hintStyle: hintStyle ??
                inputTheme.hintStyle ??
                theme.textTheme.bodyMedium?.copyWith(
                  color: hintColor ?? theme.hintColor.withValues(alpha: 0.5),
                  fontSize: (hintFontSize ?? 14).sp,
                  fontWeight: hintFontWeight ?? FontWeight.w400,
                  fontFamily: hintFontFamily,
                ),
            labelStyle: hintStyle ?? inputTheme.labelStyle,
            isDense: true,
            contentPadding: contentPadding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            prefixIcon: _buildPrefix(theme, hasError),
            suffixIcon: _buildSuffix(theme, hasError, fieldState, state),
            counterText: '',
          ),
        ),
      ),
    );
  }

  Widget? _buildPrefix(ThemeData theme, bool hasError) {
    if (prefix == null) return null;
    final color = hasError ? theme.colorScheme.error : (prefixColor ?? theme.hintColor);
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: prefixPadding,
          child: _resolveAssetOrWidget(prefix, prefixSize, usePrefixColor, color),
        ),
      ],
    );
  }

  Widget? _buildSuffix(ThemeData theme, bool hasError, FormFieldState<_InputState> fieldState, _InputState state) {
    final List<Widget> children = [];
    final color = hasError ? theme.colorScheme.error : (suffixColor ?? theme.hintColor);

    if (isPassword && showObscureToggle) {
      children.add(
        GestureDetector(
          onTap: () {
            state.isObscured = !state.isObscured;
            fieldState.didChange(state);
          }, 
          child: _buildObscureIcon(theme, hasError, state)
        ),
      );
    }

    if (suffix != null) {
      children.add(
        Padding(
          padding: suffixPadding,
          child: _resolveAssetOrWidget(suffix, suffixSize, useSuffixColor, color),
        ),
      );
    }

    if (children.isEmpty) return null;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  Widget _buildObscureIcon(ThemeData theme, bool hasError, _InputState state) {
    final color = hasError ? theme.colorScheme.error : theme.hintColor;
    final icon = state.isObscured ? (hiddenIcon ?? Icons.visibility_off_outlined) 
                             : (visibleIcon ?? Icons.visibility_outlined);
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: _resolveAssetOrWidget(icon, obscureIconSize, true, color),
    );
  }

  Widget _resolveAssetOrWidget(dynamic input, double size, bool useColor, Color color) {
    if (input is String) {
      if (input.toLowerCase().endsWith('.svg')) {
        return SvgPicture.asset(
          input,
          width: size.w,
          height: size.h,
          colorFilter: useColor ? ColorFilter.mode(color, BlendMode.srcIn) : null,
        );
      }
      return Image.asset(
        input,
        width: size.w,
        height: size.h,
        color: useColor ? color : null,
        fit: BoxFit.contain,
      );
    } else if (input is IconData) {
      return Icon(input, size: size.sp, color: color);
    } else if (input is Widget) {
      return SizedBox(width: size.w, height: size.h, child: input);
    }
    return const SizedBox.shrink();
  }
}
""");

  File('${corePath.path}/widgets/error_widget.dart')
    ..createSync(recursive: true)
    ..writeAsStringSync(r"""import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';
import '../exceptions/app_exceptions.dart';

/// Widget to display app exceptions
class ErrorDisplayWidget extends StatelessWidget {
  final AppException exception;
  final VoidCallback? onRetry;
  final bool isFullScreen;

  const ErrorDisplayWidget({
    super.key,
    required this.exception,
    this.onRetry,
    this.isFullScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return isFullScreen
        ? _buildFullScreenError(context)
        : _buildInlineError(context);
  }

  Widget _buildFullScreenError(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getErrorIcon(),
                size: 80.w,
                color: _getErrorColor(),
              ),
              SizedBox(height: 24.h),
              Text(
                exception.title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color ?? AppColors.textColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),
              Text(
                exception.message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14.sp,
                  color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textColor2,
                ),
                textAlign: TextAlign.center,
              ),
              if (onRetry != null) ...[
                SizedBox(height: 32.h),
                ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: Text(
                    'Retry',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.whiteColor,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInlineError(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: _getErrorColor().withValues(alpha: 0.1),
        border: Border.all(color: _getErrorColor(), width: 1.5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Icon(
              _getErrorIcon(),
              color: _getErrorColor(),
              size: 24.w,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    exception.title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: _getErrorColor(),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    exception.message,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 12.sp,
                      color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textColor2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (onRetry != null) ...[
              SizedBox(width: 12.w),
              GestureDetector(
                onTap: onRetry,
                child: Icon(
                  Icons.refresh,
                  color: _getErrorColor(),
                  size: 20.w,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getErrorIcon() {
    if (exception is InternetException) return Icons.cloud_off;
    if (exception is TimeoutException) return Icons.schedule;
    if (exception is UnauthorizedException) return Icons.lock;
    if (exception is NotFoundException) return Icons.search_off;
    if (exception is ValidationException) return Icons.warning_amber_rounded;
    return Icons.error_outline;
  }

  Color _getErrorColor() {
    if (exception is InternetException) return AppColors.orangeColor;
    if (exception is TimeoutException) return AppColors.amberColor;
    if (exception is UnauthorizedException) return AppColors.redColor;
    if (exception is ValidationException) return AppColors.orangeAccentColor;
    return AppColors.redColor;
  }
}
""");

  File('${corePath.path}/widgets/full_screen_image_viewer.dart')
    ..createSync(recursive: true)
    ..writeAsStringSync(r"""import 'dart:io';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'custom_loader.dart';

class FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;
  final bool isLocalFile;

  const FullScreenImageViewer({
    super.key,
    required this.imageUrl,
    this.isLocalFile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.whiteColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Back",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.whiteColor, fontSize: 16.sp),
        ),
      ),
      body: Center(
        child: FutureBuilder(
          future: Future.delayed(const Duration(milliseconds: 1000)),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const CustomLoader(size: 80);
            }
            return InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: isLocalFile
                  ? Image.file(
                      File(imageUrl),
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: double.infinity,
                    )
                  : Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CustomLoader(size: 150.r),
                        );
                      },
                    ),
            );
          },
        ),
      ),
    );
  }
}
""");

  File('${corePath.path}/widgets/general_exception.dart')
    ..createSync(recursive: true)
    ..writeAsStringSync(r"""import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class GeneralExceptionWidget extends StatelessWidget {
  final VoidCallback onPress;
  const GeneralExceptionWidget({super.key, required this.onPress});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(height: height * .15),
          Icon(Icons.cloud_off, color: AppColors.deepred, size: 50),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Center(
              child: Text(
                'general_exception',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.deepred, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: height * .15),
          InkWell(
            onTap: onPress,
            child: Container(
              height: 44,
              width: 160,
              decoration: BoxDecoration(
                color: AppColors.defaultColor,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Center(
                child: Text(
                  'Retry',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium!.copyWith(color: AppColors.whiteColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
""");

  File('${corePath.path}/widgets/glass_widget.dart')
    ..createSync(recursive: true)
    ..writeAsStringSync(r"""import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../theme/design_system.dart';

class GlassWidget extends StatelessWidget {
  final Widget child;
  final double? height;
  final double? width;
  final double? borderRadius;
  final double? blur;
  final double? opacity;
  final double? borderOpacity;
  final Color? color;

  const GlassWidget({
    super.key,
    required this.child,
    this.height = 44,
    this.width = double.infinity,
    this.borderRadius,
    this.blur,
    this.opacity,
    this.borderOpacity,
    this.color = AppColors.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final designSystem = theme.extension<AppDesignSystem>();

    // These variables safely hold your fallbacks
    final effectiveRadius = borderRadius ?? 12.0;
    final effectiveBlur = blur ?? designSystem?.glassBlur ?? 15.0;
    // Note: You can optionally utilize effectiveOpacity and effectiveBorderOpacity
    // down in your gradients/decorations if you want them to be dynamic too!

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          transform: const GradientRotation(360 * 3),
          end: Alignment.bottomLeft,
          colors: [
            AppColors.backgroundColor,
            AppColors.whiteLiteColor,
            AppColors.backgroundColor,
          ],
        ),
        borderRadius: BorderRadius.circular(
          12.r,
        ), // Added .r here for consistency
      ),
      child: Container(
        margin: EdgeInsets.all(0.7.r),
        height: height
            ?.h, // Changed from height! to height? to safely allow null double.infinity handling
        width: width == double.infinity ? double.infinity : width?.w,
        padding: EdgeInsets.all(.5.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.center,
            end: Alignment.center,
            colors: [
              AppColors.backgroundColor,
              AppColors.whiteLiteColor,
              AppColors.blackColor,
              AppColors.whiteLiteColor,
            ],
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.r),
            bottomRight: Radius.circular(12.r),
            bottomLeft: Radius.circular(4.r + .5.w),
            topRight: Radius.circular(4.r + .5.w),
          ),
        ),
        child: ClipRRect(
          // FIX: Swapped out 'borderRadius!.r' for your safe 'effectiveRadius' variable
          borderRadius: BorderRadius.circular(effectiveRadius.r),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(
              sigmaX: effectiveBlur,
              sigmaY: effectiveBlur,
            ), // Used effectiveBlur here
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  effectiveRadius.r,
                ), // Fixed here too
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
""");

  File('${corePath.path}/widgets/input_text_widget.dart')
    ..createSync(recursive: true)
    ..writeAsStringSync(r"""import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/app_colors.dart';

class _InputState {
  bool isObscured;
  bool isFocused;
  String? errorText;

  _InputState({
    required this.isObscured,
    required this.isFocused,
  });
}

class InputTextWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? title;
  final bool obscureText;
  final bool showObscureToggle;
  final bool readOnly;
  final bool enabled;
  final bool autofocus;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextAlign textAlign;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final AutovalidateMode? autovalidateMode;

  // Title Style
  final bool showTitle;
  final TextStyle? titleStyle;
  final Color? titleColor;
  final double? titleFontSize;
  final FontWeight? titleFontWeight;
  final String? titleFontFamily;
  final double titlePaddingBottom;

  // Container & Decoration
  final double? height;
  final double width;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final Color? disabledBorderColor;
  final double? borderWidth;
  final double? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final bool shadow;
  final Color? shadowColor;
  final Gradient? gradient;

  // Text Styles
  final TextStyle? textStyle;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily;

  final TextStyle? hintStyle;
  final Color? hintColor;
  final double? hintFontSize;
  final FontWeight? hintFontWeight;
  final String? hintFontFamily;

  // Leading (Prefix)
  final String leadingIcon;
  final Widget? leadingWidget;
  final double leadingIconHeight;
  final double leadingIconWidth;
  final EdgeInsetsGeometry leadingPadding;
  final bool useLeadingColor;
  final Color? leadingColor;

  // Trailing (Suffix)
  final String trailingIcon;
  final Widget? trailingWidget;
  final double trailingIconHeight;
  final double trailingIconWidth;
  final EdgeInsetsGeometry trailingPadding;
  final bool useTrailingColor;
  final Color? trailingColor;

  // Obscure Toggle Icons
  final String? visibleIcon;
  final String? hiddenIcon;
  final double obscureIconSize;

  const InputTextWidget({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.title,
    this.obscureText = false,
    this.showObscureToggle = false,
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.textAlign = TextAlign.start,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.focusNode,
    this.onChanged,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.onTap,
    this.validator,
    this.onSaved,
    this.autovalidateMode,

    // Title
    this.showTitle = false,
    this.titleStyle,
    this.titleColor,
    this.titleFontSize,
    this.titleFontWeight,
    this.titleFontFamily,
    this.titlePaddingBottom = 6,

    // Container
    this.height,
    this.width = double.infinity,
    this.backgroundColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.disabledBorderColor,
    this.borderWidth,
    this.borderRadius,
    this.contentPadding,
    this.shadow = false,
    this.shadowColor,
    this.gradient,

    // Text
    this.textStyle,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.fontFamily,

    // Hint
    this.hintStyle,
    this.hintColor,
    this.hintFontSize,
    this.hintFontWeight,
    this.hintFontFamily,

    // Leading
    this.leadingIcon = '',
    this.leadingWidget,
    this.leadingIconHeight = 20,
    this.leadingIconWidth = 20,
    this.leadingPadding = const EdgeInsets.only(right: 12),
    this.useLeadingColor = true,
    this.leadingColor,

    // Trailing
    this.trailingIcon = '',
    this.trailingWidget,
    this.trailingIconHeight = 20,
    this.trailingIconWidth = 20,
    this.trailingPadding = const EdgeInsets.only(left: 12),
    this.useTrailingColor = true,
    this.trailingColor,

    // Obscure
    this.visibleIcon,
    this.hiddenIcon,
    this.obscureIconSize = 22,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FormField<_InputState>(
      initialValue: _InputState(
        isObscured: obscureText,
        isFocused: false,
      ),
      builder: (FormFieldState<_InputState> fieldState) {
        final state = fieldState.value!;
        final hasError = state.errorText != null;

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showTitle && title != null) _buildTitle(theme),
            _buildInputField(theme, fieldState, state),
            if (hasError) _buildErrorText(theme, state.errorText!),
          ],
        );
      },
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.only(bottom: titlePaddingBottom.h),
      child: Text(
        title!,
        style: titleStyle ??
            theme.textTheme.labelLarge?.copyWith(
              color: titleColor ?? theme.textTheme.labelLarge?.color,
              fontSize: (titleFontSize ?? 14).sp,
              fontWeight: titleFontWeight ?? FontWeight.w600,
              fontFamily: titleFontFamily,
            ),
      ),
    );
  }

  Widget _buildErrorText(ThemeData theme, String error) {
    return Padding(
      padding: EdgeInsets.only(top: 4.h, left: 4.w),
      child: Text(
        error,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.error,
          fontSize: 11.sp,
        ),
      ),
    );
  }

  Widget _buildInputField(ThemeData theme, FormFieldState<_InputState> fieldState, _InputState state) {
    final hasError = state.errorText != null;
    final isEnabled = enabled;
    
    // Theme-based resolution
    final inputTheme = theme.inputDecorationTheme;
    final colorScheme = theme.colorScheme;

    // Helper to get properties from theme's InputBorder
    Color getBorderColor(InputBorder? border, Color fallback) {
      if (border is OutlineInputBorder) return border.borderSide.color;
      return fallback;
    }

    double getBorderWidth(InputBorder? border, double fallback) {
      if (border is OutlineInputBorder) return border.borderSide.width;
      return fallback;
    }

    BorderRadius getBorderRadius(InputBorder? border) {
      if (border is OutlineInputBorder) return border.borderRadius;
      return BorderRadius.circular(12.r);
    }

    final bg = backgroundColor ?? 
               (isEnabled ? (inputTheme.fillColor ?? theme.cardColor) 
                          : (theme.disabledColor.withAlpha(25)));
    
    final borderCol = hasError 
        ? (errorBorderColor ?? getBorderColor(inputTheme.errorBorder, colorScheme.error))
        : (!isEnabled 
            ? (disabledBorderColor ?? getBorderColor(inputTheme.disabledBorder, theme.disabledColor.withAlpha(75)))
            : (state.isFocused 
                ? (focusedBorderColor ?? getBorderColor(inputTheme.focusedBorder, colorScheme.primary)) 
                : (borderColor ?? getBorderColor(inputTheme.enabledBorder, AppColors.inputBorderColor))));

    final effectiveWidth = hasError || state.isFocused 
        ? getBorderWidth(hasError ? inputTheme.errorBorder : inputTheme.focusedBorder, 1.5) 
        : getBorderWidth(inputTheme.enabledBorder, 1.0);

    final effectiveRadius = borderRadius != null 
        ? BorderRadius.circular(borderRadius!.r) 
        : getBorderRadius(inputTheme.enabledBorder);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width.w,
      height: height?.h,
      decoration: BoxDecoration(
        color: bg,
        gradient: gradient,
        borderRadius: effectiveRadius,
        border: Border.all(
          color: borderCol,
          width: (borderWidth ?? effectiveWidth).w,
        ),
        boxShadow: shadow
            ? [
                BoxShadow(
                  color: shadowColor ?? theme.shadowColor.withAlpha(20),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Focus(
        onFocusChange: (hasFocus) {
          state.isFocused = hasFocus;
          fieldState.didChange(state);
        },
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          obscureText: state.isObscured,
          readOnly: readOnly,
          enabled: isEnabled,
          autofocus: autofocus,
          maxLines: maxLines,
          minLines: minLines,
          maxLength: maxLength,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textAlign: textAlign,
          textCapitalization: textCapitalization,
          inputFormatters: inputFormatters,
          onSaved: onSaved,
          onFieldSubmitted: onFieldSubmitted,
          onEditingComplete: onEditingComplete,
          autovalidateMode: autovalidateMode,
          onChanged: (val) {
            if (hasError) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                state.errorText = null;
                fieldState.didChange(state);
              });
            }
            onChanged?.call(val);
          },
          onTap: onTap,
          validator: (val) {
            if (validator != null) {
              final result = validator!(val);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                state.errorText = result;
                fieldState.didChange(state);
              });
              return null; // Use custom error UI
            }
            return null;
          },
          style: textStyle ??
              theme.textTheme.bodyMedium?.copyWith(
                color: isEnabled 
                    ? (textColor ?? theme.textTheme.bodyMedium?.color)
                    : theme.disabledColor,
                fontSize: (fontSize ?? 14).sp,
                fontWeight: fontWeight ?? FontWeight.w400,
                fontFamily: fontFamily,
              ),
          decoration: InputDecoration(
            hintText: hintText,
            labelText: labelText,
            hintStyle: hintStyle ?? inputTheme.hintStyle,
            labelStyle: hintStyle ?? inputTheme.labelStyle,
            isDense: true,
            contentPadding: contentPadding ?? inputTheme.contentPadding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            prefixIcon: _buildLeading(theme, hasError),
            suffixIcon: _buildTrailing(theme, hasError, fieldState, state),
            counterText: '',
              fillColor: backgroundColor
          ),
        ),
      ),
    );
  }

  Widget? _buildLeading(ThemeData theme, bool hasError) {
    if (leadingWidget == null && leadingIcon.isEmpty) return null;
    final color = hasError ? theme.colorScheme.error : (leadingColor ?? theme.hintColor);
    final leading = leadingWidget ??
        Padding(
          padding: leadingPadding,
          child: _buildAsset(leadingIcon, leadingIconWidth, leadingIconHeight, useLeadingColor, color),
        );
    return Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [leading]);
  }

  Widget? _buildTrailing(ThemeData theme, bool hasError, FormFieldState<_InputState> fieldState, _InputState state) {
    final List<Widget> children = [];
    final color = hasError ? theme.colorScheme.error : (trailingColor ?? theme.hintColor);
    if (showObscureToggle || obscureText) {
      children.add(GestureDetector(
        onTap: () {
          state.isObscured = !state.isObscured;
          fieldState.didChange(state);
        }, 
        child: _buildObscureIcon(theme, hasError, state)
      ));
    }
    if (trailingWidget != null || trailingIcon.isNotEmpty) {
      final trailing = trailingWidget ??
          Padding(
            padding: trailingPadding,
            child: _buildAsset(trailingIcon, trailingIconWidth, trailingIconHeight, useTrailingColor, color),
          );
      children.add(trailing);
    }
    if (children.isEmpty) return null;
    return Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: children);
  }

  Widget _buildObscureIcon(ThemeData theme, bool hasError, _InputState state) {
    final color = hasError ? theme.colorScheme.error : (trailingColor ?? theme.hintColor);
    if (state.isObscured) {
      if (hiddenIcon != null) return _buildAsset(hiddenIcon!, obscureIconSize, obscureIconSize, true, color);
      return Icon(Icons.visibility_off_outlined, size: obscureIconSize.sp, color: color);
    } else {
      if (visibleIcon != null) return _buildAsset(visibleIcon!, obscureIconSize, obscureIconSize, true, color);
      return Icon(Icons.visibility_outlined, size: obscureIconSize.sp, color: color);
    }
  }

  Widget _buildAsset(String path, double width, double height, bool useColor, Color color) {
    if (path.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(path, width: width.w, height: height.h, colorFilter: useColor ? ColorFilter.mode(color, BlendMode.srcIn) : null);
    }
    return Image.asset(path, width: width.w, height: height.h, color: useColor ? color : null, fit: BoxFit.contain);
  }
}
""");

  File('${corePath.path}/widgets/internet_exceptions_widget.dart')
    ..createSync(recursive: true)
    ..writeAsStringSync(r"""import 'package:flutter/material.dart';

import '../../features/shared/localization/localization_extension.dart';
import '../constants/app_colors.dart';

class InternetExceptionsWidget extends StatelessWidget {
  final VoidCallback onPress;
  const InternetExceptionsWidget({super.key, required this.onPress});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(height: height * .15),
          Icon(Icons.cloud_off, color: AppColors.textColor, size: 50),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Center(
              child: Text(
                context.watchTr('internet_exception'),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textColor,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: height * .15),
          InkWell(
            onTap: onPress,
            child: Container(
              height: 44,
              width: 160,
              decoration: BoxDecoration(
                color: AppColors.defaultColor,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Center(
                child: Text(
                  'Retry',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium!.copyWith(color: AppColors.whiteColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
""");

  print("🛣️ Creating app_router.dart...");
  final routesPath = Directory('${libPath.path}/routes');
  routesPath.createSync(recursive: true);

  File('${routesPath.path}/app_router.dart').writeAsStringSync('''

import 'package:go_router/go_router.dart';

abstract class AppRoutes {
  static const splash = '/splash';
}

class AppRouter {
  static CustomTransitionPage _buildPageWithTransition({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  static GoRouter create() {
    return GoRouter(
      initialLocation: AppRoutes.splash,
      routes: [
        GoRoute(
          path: AppRoutes.splash,
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const Scaffold(body: Center(child: Text("Splash Screen"))),
          ),
        ),
      ],
    );
  }
}
''');

  print("⚙️ Setting up main.dart...");
  File('${libPath.path}/main.dart').writeAsStringSync('''

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'routes/app_router.dart';
import 'core/constants/app_colors.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => "DummyProvider"), 
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Boilerplate App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: AppColors.primary,
            scaffoldBackgroundColor: AppColors.background,
          ),
          routerConfig: AppRouter.create(),
        );
      },
    );
  }
}
''');

  print("✅ Boilerplate initialized successfully!");
  print(
    "Use `dart scripts/config.dart generate <role> <feature>` to add features.",
  );
}

// ==========================================
// 2. SCAFFOLD / GENERATE COMMAND
// ==========================================
String toCamelCase(String snakeStr) {
  final components = snakeStr.split('_');
  if (components.isEmpty) return '';
  String result = components[0];
  for (int i = 1; i < components.length; i++) {
    final word = components[i];
    if (word.isNotEmpty) {
      result += word[0].toUpperCase() + word.substring(1);
    }
  }
  return result;
}

String toPascalCase(String snakeStr) {
  final components = snakeStr.split('_');
  String result = '';
  for (final word in components) {
    if (word.isNotEmpty) {
      result += word[0].toUpperCase() + word.substring(1);
    }
  }
  return result;
}

void scaffoldFeature(String role, String featureName) {
  final libPath = Directory('${Directory.current.path}/lib');
  final featurePath = Directory('${libPath.path}/features/$role/$featureName');

  final controllersPath = Directory('${featurePath.path}/controllers');
  final modelsPath = Directory('${featurePath.path}/models');
  final viewsPath = Directory('${featurePath.path}/views');

  controllersPath.createSync(recursive: true);
  modelsPath.createSync(recursive: true);
  viewsPath.createSync(recursive: true);

  // Controller
  final controllerName = '${featureName}_controller';
  final pascalController = toPascalCase(controllerName);
  File('${controllersPath.path}/$controllerName.dart').writeAsStringSync('''

class $pascalController extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }
}
''');

  // View
  final viewName = '${featureName}_view';
  final pascalView = toPascalCase(viewName);
  File('${viewsPath.path}/$viewName.dart').writeAsStringSync('''
import 'package:provider/provider.dart';
import '../controllers/$controllerName.dart';

class $pascalView extends StatelessWidget {
  const $pascalView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('$pascalView')),
      body: const Center(
        child: Text('New Feature: $featureName'),
      ),
    );
  }
}
''');

  // Model
  final modelName = '${featureName}_model';
  final pascalModel = toPascalCase(modelName);
  File('${modelsPath.path}/$modelName.dart').writeAsStringSync(
    '''class $pascalModel {
  final String id;
  
  $pascalModel({required this.id});
  
  factory $pascalModel.fromJson(Map<String, dynamic> json) {
    return $pascalModel(
      id: json['id'] ?? '',
    );
  }
}
''',
  );

  print("[SUCCESS] Generated $featureName inside $role");
  injectRoute(role, featureName, pascalView);
}

void injectRoute(String role, String featureName, String pascalView) {
  final routerFile = File(
    '${Directory.current.path}/lib/routes/app_router.dart',
  );

  if (!routerFile.existsSync()) {
    print(
      "[ERROR] app_router.dart not found at ${routerFile.path}. Skipping route injection.",
    );
    return;
  }

  String content = routerFile.readAsStringSync();

  // 1. Inject Import
  final importStatement =
      "import '../features/$role/$featureName/views/${featureName}_view.dart';";
  if (!content.contains(importStatement)) {
    final importRegex = RegExp(
      "^import\\s+['\\\"].*['\\\"];\\\$",
      multiLine: true,
    );
    final matches = importRegex.allMatches(content);
    if (matches.isNotEmpty) {
      final lastMatch = matches.last;
      final pos = lastMatch.end;
      content =
          "${content.substring(0, pos)}\\n$importStatement${content.substring(pos)}";
    }
  }

  // 2. Inject Route Name in AppRoutes
  final camelRoute = toCamelCase(featureName);
  final routePath = featureName.replaceAll('_', '-');
  final routeVar = "  static const $camelRoute = '/$routePath';";

  if (!content.contains(routeVar)) {
    final classRegex = RegExp(r"abstract class AppRoutes \\{");
    final match = classRegex.firstMatch(content);
    if (match != null) {
      final pos = match.end;
      content =
          "${content.substring(0, pos)}\\n$routeVar${content.substring(pos)}";
    }
  }

  // 3. Inject GoRoute
  final goRouteBlock =
      '''        GoRoute(
          path: AppRoutes.$camelRoute,
          pageBuilder: (context, state) => _buildPageWithTransition(
            context: context,
            state: state,
            child: const $pascalView(),
          ),
        ),
''';

  if (!content.contains("path: AppRoutes.$camelRoute")) {
    final injectPos = content.lastIndexOf("GoRoute(");
    if (injectPos != -1) {
      content =
          content.substring(0, injectPos) +
          goRouteBlock +
          content.substring(injectPos);
    }
  }

  routerFile.writeAsStringSync(content);
  print("[SUCCESS] Injected $pascalView into app_router.dart");
}
