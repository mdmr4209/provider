# Implementation Code Structure - Auth Feature

## Directory Structure

```
lib/
├── core/
│   ├── exceptions/
│   │   ├── app_exceptions.dart         [Already exists - 12 exception types]
│   │   └── exception_handler.dart      [Already exists - converts exceptions]
│   ├── utils/
│   │   └── validators/
│   │       └── input_validators.dart   ✅ [NEW - 14 validators]
│   └── widgets/
│       ├── error_widget.dart           [Already exists - error display]
│       ├── custom_loader.dart          [Already exists - loading states]
│       └── input_text_widget.dart      [Already exists - text input]
├── features/
│   └── auth/
│       ├── controllers/
│       │   └── auth_controller.dart    ✅ [UPDATED - exception handling]
│       └── views/
│           ├── auth_view.dart          ✅ [UPDATED - error display]
│           ├── sign_up_view.dart       ✅ [UPDATED - validation + errors]
│           ├── otp_verify_view.dart    [Existing - to be enhanced]
│           ├── forget_password_view.dart
│           └── change_password_view.dart
└── routes/
    └── app_router.dart                 [Already exists - routing]
```

---

## Class Diagrams

### Exception Hierarchy (Already Implemented)
```
AppException (abstract)
  ├── InternetException
  ├── TimeoutException
  ├── UnauthorizedException
  ├── ForbiddenException
  ├── NotFoundException
  ├── ConflictException
  ├── ValidationException
  ├── ServerException
  ├── DataParsingException
  └── GenericException
```

### Input Validators (New)
```
InputValidators (static class)
  ├── validateEmail()
  ├── validatePassword()
  ├── validatePasswordMatch()
  ├── validateName()
  ├── validatePhone()
  ├── validateOtp()
  ├── validateRequired()
  ├── validateAddress()
  ├── validateCity()
  ├── validatePostalCode()
  ├── validateCardNumber()
  ├── validateCVV()
  ├── validateExpiryDate()
  ├── validatePromoCode()
  ├── validateUrl()
  └── _luhnCheck() [private]
```

### AuthController Updates
```
AuthController extends ChangeNotifier
  
  Properties Added:
  ├── AppException? _error
  
  Getters Added:
  ├── AppException? get error
  
  Methods Added:
  └── void clearError()
  
  Methods Enhanced (6):
  ├── Future<void> login()           [+exception handling]
  ├── Future<void> signup()          [+exception handling]
  ├── Future<void> forget()          [+exception handling]
  ├── Future<void> verifyOtp()       [+exception handling]
  ├── Future<void> resendOtp()       [+exception handling]
  └── Future<void> setPassword()     [+exception handling]
```

---

## Data Flow Diagrams

### Login Error Flow
```
User Taps Login Button
    ↓
auth.login() called
    ↓
Set loading = true, error = null
    ↓
API Request (via ApiService)
    ↓
Exception Thrown (DioException, NetworkException, etc.)
    ↓
Caught in catch block
    ↓
ExceptionHandler.handleException(e)
    ↓
Converted to AppException
    ↓
Store in _error property
    ↓
Call notifyListeners()
    ↓
View Consumer rebuilds
    ↓
Check if (auth.error != null)
    ↓
ErrorDisplayWidget shows error
    ↓
User sees "Retry" button
    ↓
User taps Retry
    ↓
auth.clearError() called
    ↓
_error = null
    ↓
notifyListeners()
    ↓
View shows form again
    ↓
User can retry login
```

### Signup Validation Flow
```
User Types in Email Field
    ↓
onChanged callback triggered
    ↓
setState(() { _emailError = InputValidators.validateEmail(...) })
    ↓
Check if (email matches RFC pattern)
    ↓
Return error message OR null
    ↓
setState rebuilds with new error
    ↓
Column checks: if (_emailError != null) ...
    ↓
Show red error text below field
    ↓
_isFormValid recalculates
    ↓
Button enable/disable updates
    ↓
User sees validation feedback
    ↓
User continues filling other fields
    ↓
All fields valid → Button enabled
    ↓
User taps Sign Up
    ↓
Form validated again
    ↓
auth.signup() called (if valid)
```

---

## Code Examples

### Using Validators in Form
```dart
// In _SignUpViewState
String? _emailError;

@override
Widget build(BuildContext context) {
  return Column(
    children: [
      // Email field with validation
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputTextWidget(
            hintText: 'Enter email',
            controller: _emailController,
            onChanged: (_) {
              setState(() {
                _emailError = InputValidators.validateEmail(
                  _emailController.text,
                );
              });
            },
            keyboardType: TextInputType.emailAddress,
          ),
          if (_emailError != null) ...[
            SizedBox(height: 4.h),
            Text(
              _emailError!,
              style: TextStyle(color: Colors.red, fontSize: 11.sp),
            ),
          ],
        ],
      ),
    ],
  );
}
```

### Using Error Widget in View
```dart
// In auth_view.dart build method
Consumer<AuthController>(
  builder: (context, auth, _) {
    // Show full-screen loader
    if (auth.isLoading && auth.errorMessage.isEmpty) {
      return const FullScreenLoader();
    }

    // Show error widget
    if (auth.error != null) {
      return ErrorDisplayWidget(
        exception: auth.error!,
        isFullScreen: true,
        onRetry: () {
          auth.clearError();
        },
      );
    }

    // Show form
    return Form(
      child: Column(
        children: [
          // Form fields
        ],
      ),
    );
  },
)
```

### Exception Handling in Controller
```dart
// In auth_controller.dart login() method
Future<void> login() async {
  final email = emailController.text.trim();
  final password = passwordController.text;

  try {
    _setLoading(true);
    _error = null;                    // Clear previous errors
    notifyListeners();

    final response = await ApiService.post(
      api: ApiConstants.loginUrl,
      data: {'email': email, 'password': password},
    );

    if (response != null && response.statusCode == 200) {
      // Success handling
      _accessToken = response.data['access_token'];
      _isLoggedIn = true;
      notifyListeners();
      showSuccessSnackBar(message: 'Login successful');
    } else {
      // API error
      _errorMessage = response?.data?['error']?.toString() ?? 'Login failed';
      notifyListeners();
    }
  } catch (e) {
    debugPrint('login error: $e');
    
    // Convert exception to AppException
    _error = ExceptionHandler.handleException(e);
    notifyListeners();
  } finally {
    _setLoading(false);
  }
}
```

---

## Integration Points

### 1. View Integration
```
AuthView (StatelessWidget)
  └── Consumer<AuthController>
      ├── Checks auth.isLoading
      ├── Checks auth.error
      ├── Displays CustomLoader when loading
      ├── Displays ErrorDisplayWidget when error
      └── Displays form otherwise

SignUpView (StatefulWidget)
  ├── Local state for field errors
  ├── Uses InputValidators for real-time validation
  ├── Shows error messages below fields
  ├── Enables/disables signup button
  └── Also uses Consumer<AuthController> for API errors
```

### 2. Controller Integration
```
AuthController (ChangeNotifier)
  ├── Properties
  │   ├── _error: AppException?
  │   └── _errorMessage: String
  ├── Getters
  │   └── error: AppException?
  ├── Methods
  │   └── clearError()
  └── Enhanced Auth Methods
      ├── login()
      ├── signup()
      ├── forget()
      ├── verifyOtp()
      ├── resendOtp()
      └── setPassword()
```

### 3. Validator Integration
```
InputValidators (static utility)
  └── Used by:
      ├── SignUpView (real-time field validation)
      ├── Future ForgetPasswordView
      ├── Future ChangePasswordView
      ├── Future CheckoutView
      └── Future ProfileView
```

### 4. Exception Integration
```
ExceptionHandler (static utility)
  └── handleException(dynamic exception)
      ├── Used in login()
      ├── Used in signup()
      ├── Used in forget()
      ├── Used in verifyOtp()
      ├── Used in resendOtp()
      └── Used in setPassword()
      
Returns: AppException (one of 12 types)
Consumed by: Views (via error widget)
```

---

## State Management Flow

### Global State (Provider)
```
AuthController (Global ChangeNotifier)
  ├── _error: AppException?
  ├── _errorMessage: String
  ├── _isLoading: bool
  └── Listeners:
      ├── AuthView (reacts to error)
      ├── SignUpView (reacts to error)
      └── AppRouter (reacts to isLoggedIn)
```

### Local State (StatefulWidget)
```
SignUpViewState
  ├── _nameError: String?
  ├── _emailError: String?
  ├── _passwordError: String?
  ├── _confirmPasswordError: String?
  └── Listeners: Only this widget rebuilds
```

---

## Error Handling Hierarchy

```
Request Error
    ↓
    ├─→ Network Error (no internet, timeout)
    │   └─→ InternetException / TimeoutException
    │
    ├─→ HTTP Status Code Error
    │   ├─→ 400: ValidationException
    │   ├─→ 401: UnauthorizedException
    │   ├─→ 403: ForbiddenException
    │   ├─→ 404: NotFoundException
    │   ├─→ 409: ConflictException
    │   └─→ 500+: ServerException
    │
    ├─→ Parse Error (JSON parsing)
    │   └─→ DataParsingException
    │
    └─→ Other Error
        └─→ GenericException

ExceptionHandler catches all ↓
        ↓
Returns AppException ↓
        ↓
Stored in controller._error ↓
        ↓
View displays ErrorDisplayWidget
```

---

## Testing Scenarios

### Unit Tests Ready For
```
✓ InputValidators
  - validateEmail with various formats
  - validatePassword with various passwords
  - validatePasswordMatch with matching/non-matching
  - validateName with special characters
  - All 14 validators with valid/invalid inputs

✓ AuthController
  - login() with network error
  - signup() with validation error
  - forget() with timeout error
  - All 6 methods with exception handling

✓ ExceptionHandler
  - DioException conversion
  - HTTP status code mapping
  - Error message extraction
```

### Widget Tests Ready For
```
✓ AuthView
  - Shows loading state correctly
  - Shows error widget correctly
  - Shows form when no error
  - Retry button works

✓ SignUpView
  - Shows validation errors
  - Hides validation errors when corrected
  - Button enables/disables
  - API error shows full-screen error
```

---

## Documentation Files Generated

1. **IMPLEMENTATION_SUMMARY.md** - Comprehensive overview
2. **QUICK_REFERENCE.md** - Quick lookup guide
3. **IMPLEMENTATION_CHECKLIST.md** - Complete checklist
4. **This File** - Code structure and diagrams

All files ready for immediate use! 🚀

