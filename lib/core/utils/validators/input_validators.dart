/// Validators for form inputs
/// All methods return null if valid, error message if invalid
class InputValidators {
  // ── Email Validation ─────────────────────────────────────────────
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    const emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
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

    if (year < currentYear || (year == currentYear && month < currentMonth)) {
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
