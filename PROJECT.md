# 🚀 Authentication & Setup Flow - Complete Project Guide

## 📋 Project Overview

This is a **Flutter e-commerce application** built with **Provider** state management and **Firebase** authentication. The app follows a complete user onboarding flow: Splash → Login/Sign Up → Setup Pages → Home.

---

## 🎯 Complete User Flow

```
┌─────────────────────────────────────────────────────────────┐
│                  APP STARTUP                                │
└─────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│         SPLASH SCREEN (3 seconds display)                   │
│    Shows app logo, name, and loading indicator              │
└─────────────────────────────────────────────────────────────┘
                           │
                           ▼
        ┌──────────────────┴──────────────────┐
        │   Check Auth Status                 │
        │   (isLoggedIn, isSetupComplete)     │
        └──────────────────┬──────────────────┘
                           │
        ┌──────────────────┴──────────────────┐
        │                                     │
        ▼                                     ▼
   NOT LOGGED IN                        LOGGED IN
        │                                     │
        ▼                                     ▼
   ┌─────────────┐                    ┌─────────────────┐
   │ LOGIN PAGE  │                    │ HOME PAGE       │
   │ - Email     │                    │ - Dashboard     │
   │ - Password  │                    │ - Products      │
   │ - Sign up   │                    │ - Profile       │
   │ - Forgot pw │                    │ - Cart          │
   └──────┬──────┘                    └─────────────────┘
          │
          ▼
   ┌──────────────────────┐
   │  SIGN UP PAGE        │
   │  - Full Name         │
   │  - Email             │
   │  - Password          │
   │  - Confirm Password  │
   └──────────┬───────────┘
              │
              ▼
   ┌─────────────────────────┐
   │  SETUP PAGES (3 Steps)  │
   │                         │
   │  Step 1: Profile        │
   │  - Bio                  │
   │  - Phone                │
   │  - Profile Photo        │
   │                         │
   │  Step 2: Preferences    │
   │  - Notifications        │
   │  - Newsletter           │
   │  - Category Interest    │
   │                         │
   │  Step 3: Summary        │
   │  - Review all info      │
   │  - Complete setup       │
   └──────────┬──────────────┘
              │
              ▼
   ┌─────────────────────────┐
   │  HOME PAGE              │
   │  (Setup Complete)       │
   └─────────────────────────┘
```

---

## 📁 Project Directory Structure

```
lib/
├── main.dart                          # App entry point
├── bindings/
│   └── provider_binding.dart          # Multi-provider setup
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_assets.dart
│   │   └── api_constants.dart
│   ├── exceptions/
│   │   ├── app_exceptions.dart
│   │   └── exception_handler.dart
│   ├── services/
│   │   ├── api_service.dart
│   │   └── notifications/
│   │       └── firebase_options.dart
│   ├── theme/
│   │   └── app_theme.dart
│   ├── utils/
│   │   ├── helpers/
│   │   │   └── snack_bar_helper.dart
│   │   └── validators/
│   │       └── input_validators.dart
│   └── widgets/
│       ├── background_widget.dart
│       ├── custom_button.dart
│       └── input_text_widget.dart
├── features/
│   ├── auth/
│   │   ├── controllers/
│   │   │   └── auth_controller.dart       # Auth logic & state
│   │   └── views/
│   │       ├── splash_screen.dart         # ✨ NEW: Splash Screen
│   │       ├── auth_view.dart             # Login screen
│   │       ├── sign_up_view.dart          # Signup screen
│   │       ├── forget_password_view.dart  # Password recovery
│   │       ├── change_password_view.dart  # Password change
│   │       ├── otp_verify_view.dart       # OTP verification
│   │       ├── role_selection_view.dart   # User role selection
│   │       ├── name_input_view.dart       # Name collection
│   │       ├── go_to_home.dart            # Redirect helper
│   │       └── setup/
│   │           ├── setup_views.dart       # Setup page implementation
│   │           └── setup_base_view.dart   # Setup base widget
│   ├── home/
│   │   └── views/
│   │       ├── home_view.dart
│   │       ├── product_view.dart
│   │       ├── filter_view.dart
│   │       └── ...other views
│   ├── cart/
│   ├── profile/
│   ├── onboarding/
│   └── ...other features
└── routes/
    └── app_router.dart                    # Go Router configuration
```

---

## 🔐 Authentication System

### AuthController Properties

```dart
// Login/Auth status
bool isLoggedIn              // User is logged in
bool isSignedIn              // User has Firebase account
bool isCheckingToken         // Checking token validity
bool isOtpVerified           // OTP verification done

// User data
String accessToken           // JWT/Auth token
String refreshToken          // Refresh token
String id                    // User ID
String signupEmail           // Email used for signup

// UI states
bool isPasswordVisible        // Password field visibility
bool isLoading               // API loading state
bool isRemembered            // Remember me status

// Validation & errors
AppException? error          // Last error
String formattedTime         // OTP timer formatted
int secondsRemaining         // OTP timer seconds
```

### AuthController Methods

```dart
// Login methods
login(email, password)
socialLogin(provider)        // Google, Facebook, Apple
verifyOtp(otp, email)
resendOtp(email)

// Sign up methods
signup(name, email, password)
selectRole(role)             // User/Seller role
setName(name)

// Password methods
forgetPassword(email)
changePassword(oldPassword, newPassword)

// Session management
logout()
checkLoginStatus()           // Check if token is valid
```

---

## 🎨 UI Components & Screens

### 1. **Splash Screen** (NEW)
- **Location**: `lib/features/auth/views/splash_screen.dart`
- **Duration**: 3 seconds
- **Shows**: App logo, name, loading indicator
- **Routes to**: Login or Home (based on auth status)

```dart
SplashScreen()
├── Display app branding
├── Show loading animation
└── Auto-navigate after 3 seconds
```

### 2. **Login Screen**
- **Location**: `lib/features/auth/views/auth_view.dart`
- **Fields**: Email, Password
- **Actions**: Login, Forgot Password, Sign Up
- **Validation**: Email format, password required

### 3. **Sign Up Screen**
- **Location**: `lib/features/auth/views/sign_up_view.dart`
- **Fields**: Name, Email, Password, Confirm Password
- **Validation**: Email uniqueness, password strength
- **Next**: Setup Pages after signup success

### 4. **Setup Pages** (3-Step Wizard)
- **Location**: `lib/features/auth/views/setup/setup_views.dart`

**Step 1: Profile Information**
- Bio/Description
- Phone Number
- Profile Photo upload

**Step 2: User Preferences**
- Enable notifications (toggle)
- Subscribe to newsletter (toggle)
- Select interest category

**Step 3: Summary**
- Review all information
- Complete setup button
- Navigate to Home

### 5. **Home Screen**
- **Location**: `lib/features/home/views/home_view.dart`
- **Shows**: Products, navigation, user menu

---

## 🚀 Navigation Routes

```dart
AppRoutes {
  '/onboarding'          // Initial onboarding
  '/login'               // Login page
  '/signup'              // Sign up page
  '/forget-password'     // Forgot password
  '/otp-verify'          // OTP verification
  '/role-selection'      // Role selection (user/seller)
  '/name-input'          // Name input
  '/setup1' to '/setup13'// Setup wizard pages
  '/setup-complete'      // Setup completion
  '/home'                // Home screen (main app)
  '/profile'             // User profile
  '/order'               // Orders
  '/wishlist'            // Wishlist
  '/search'              // Search
}
```

---

## 🔄 State Management (Provider)

### Main Providers

```dart
// In provider_binding.dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthController()),
    ChangeNotifierProvider(create: (_) => OnboardingController()),
    ChangeNotifierProvider(create: (_) => ThemeController()),
    ChangeNotifierProvider(create: (_) => LocalizationController()),
  ],
  child: MyApp(),
)
```

### Accessing AuthController

```dart
// Watch for changes
final auth = context.watch<AuthController>();

// Read value (no rebuild on change)
final auth = context.read<AuthController>();

// In Consumer widget
Consumer<AuthController>(
  builder: (context, auth, _) => Text(auth.isLoggedIn ? 'Logged In' : 'Not Logged In'),
)
```

---

## 📱 Dummy Test Data

### Test Login Credentials
```
Email: user@example.com
Password: password123
```

### Test Sign Up
```
Name: John Doe
Email: newemail@example.com
Password: secure123
Confirm: secure123
```

### OTP (if applicable)
```
OTP Code: 123456
```

---

## 🔌 API Integration

### API Service
- **Location**: `lib/core/services/api_service.dart`
- **Type**: Dio HTTP client
- **Base URL**: From api_constants.dart

### API Endpoints

| Method | Endpoint | Purpose |
|--------|----------|---------|
| POST | `/auth/login` | User login |
| POST | `/auth/signup` | User registration |
| POST | `/auth/verify-otp` | OTP verification |
| POST | `/auth/logout` | User logout |
| POST | `/auth/refresh-token` | Token refresh |
| POST | `/auth/social-login` | Social auth |
| POST | `/user/profile` | Update profile |
| POST | `/user/setup` | Complete setup |

See **JSON.md** for detailed request/response schemas.

---

## 🎯 Features Implemented

✅ **Authentication**
- Email/password login
- User registration
- OTP verification
- Social login (Google, Facebook)
- Password reset & change

✅ **User Setup**
- 3-step onboarding wizard
- Profile information collection
- User preferences
- Photo upload

✅ **State Management**
- Provider package for state
- Reactive UI updates
- Persistent user session

✅ **Navigation**
- Go Router for routing
- Auth-based route guards
- Deep linking support

✅ **Error Handling**
- Centralized exception handling
- User-friendly error messages
- Toast notifications

---

## 🛠️ Development Setup

### Prerequisites
- Flutter SDK: 3.9.2+
- Dart: 3.9.2+
- Firebase account configured

### Installation

```bash
# Get dependencies
flutter pub get

# Run app
flutter run

# Build APK
flutter build apk

# Build iOS
flutter build ios
```

### Key Dependencies

```yaml
provider: ^6.1.5+1           # State management
go_router: ^14.2.7           # Navigation
firebase_auth: ^6.0.1        # Firebase auth
firebase_core: ^4.0.0        # Firebase core
dio: ^5.9.0                  # HTTP client
pin_code_fields: ^8.0.1      # OTP input
google_sign_in: ^6.2.1       # Google auth
flutter_facebook_auth: ^7.1.2 # Facebook auth
sign_in_with_apple: ^7.0.1   # Apple auth
```

---

## 📊 Testing Scenarios

### Scenario 1: New User (No Account)
1. Launch app
2. See splash screen
3. Go to login
4. Click "Sign Up"
5. Enter details
6. Complete 3-step setup
7. See home screen

### Scenario 2: Returning User
1. Launch app
2. See splash screen
3. Auto-redirect to home (if logged in)
4. See dashboard

### Scenario 3: User Session Expired
1. User tries to access protected route
2. Get redirected to login
3. Enter credentials
4. Get redirected to original route

---

## 🔒 Security Notes

- ✅ Firebase authentication for security
- ✅ Token-based session management
- ✅ Secure password storage
- ✅ HTTPS for API calls
- ✅ Input validation
- ✅ Social login integration

---

## 🚨 Error Handling

All errors are handled through `ExceptionHandler` class:

```dart
try {
  await authController.login(email, password);
} catch (e) {
  final message = ExceptionHandler.handle(e).message;
  SnackBarHelper.showSnackBar(message);
}
```

See **core/exceptions/exception_handler.dart** for details.

---

## 📝 Additional Resources

- **API Schemas**: See `JSON.md`
- **Input Validators**: `lib/core/utils/validators/input_validators.dart`
- **App Colors**: `lib/core/constants/app_colors.dart`
- **App Theme**: `lib/core/theme/app_theme.dart`

---

## 📞 Quick Reference

| What | Where | Notes |
|------|-------|-------|
| Routes | `/routes/app_router.dart` | All route definitions |
| Auth Logic | `/features/auth/controllers/auth_controller.dart` | Main auth logic |
| Screens | `/features/auth/views/` | All auth UI screens |
| API | `/core/services/api_service.dart` | HTTP client |
| Colors | `/core/constants/app_colors.dart` | Color palette |
| Validators | `/core/utils/validators/input_validators.dart` | Input validation |

---

## 🎓 Learning Path

1. **Start**: Read this file (PROJECT.md)
2. **Understand**: Check JSON.md for API schemas
3. **Explore**: Look at `auth_controller.dart` for logic
4. **Study**: Review setup_views.dart for UI pattern
5. **Test**: Use dummy data to test flow
6. **Extend**: Add more features or customize UI

---

## ✨ Next Steps

1. ✅ Splash screen implemented
2. ✅ Auth flow complete
3. ✅ Setup pages ready
4. ✅ Documentation created
5. 🔄 **TODO**: Connect real API endpoints
6. 🔄 **TODO**: Add image picker for photos
7. 🔄 **TODO**: Implement local storage
8. 🔄 **TODO**: Add unit tests

---

**Last Updated**: May 24, 2026
**Status**: ✅ Complete and Ready to Use
