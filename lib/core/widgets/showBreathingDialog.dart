import 'package:flutter/material.dart';
import 'custom_dialog.dart';

/// Shows a beautiful breathing dialog using the unified CustomDialog.
void showBreathingDialog(
  BuildContext context, {
  bool isBreathing = false,
  required String title,
  required String? description,
  required String primaryButtonText,
  required VoidCallback onPrimaryTap,
}) {
  showAppCustomDialog(
    context,
    title: title,
    description: description ?? '',
    primaryText: primaryButtonText,
    onPrimaryTap: onPrimaryTap,
    secondaryText: '"No, I\'m okay for now."',
    showLogo: isBreathing,
  );
}
