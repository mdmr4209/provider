import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/localization_controller.dart';

extension LocalizationExtension on BuildContext {
  String tr(String key) {
    return read<LocalizationController>().translate(key);
  }

  // If we want it to react to changes, we can use watch, but usually
  // we use a Consumer or Provider.of(context) in the build method.
  // For convenience in some places, we might want a 'watch' version.
  String watchTr(String key) {
    return watch<LocalizationController>().translate(key);
  }
}

// Global function if preferred
String tr(BuildContext context, String key) {
  return context.read<LocalizationController>().translate(key);
}
