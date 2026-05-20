class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }

    final emailRegex =
    RegExp(r'^[^@]+@[^@]+\.[^@]+');

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