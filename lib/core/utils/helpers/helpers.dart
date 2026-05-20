import 'package:flutter/material.dart';
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

  static void showSnackBar(
      BuildContext context,
      String message,
      ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
// Helpers.hideKeyboard(context);
// Text(Helpers.formatPrice(99.5)) Output:$99.50
// Helpers.showSnackBar(
// context,
// "Login Successful",
// );