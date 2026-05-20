import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Languages/languages.dart';

class LocalizationController with ChangeNotifier {
  static const String _localeKey = "app_locale";
  Locale _locale = const Locale('en', 'US');

  Locale get locale => _locale;

  LocalizationController() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_localeKey);
    if (languageCode != null) {
      // Simple parsing: 'en_US' -> 'en', 'US'
      if (languageCode.contains('_')) {
        final parts = languageCode.split('_');
        _locale = Locale(parts[0], parts[1]);
      } else {
        _locale = Locale(languageCode);
      }
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.toString());
  }

  String translate(String key) {
    final String localeKey = _locale.toString(); // e.g. 'en_US'
    
    // Try exact match (e.g. 'en_US')
    if (Languages.keys.containsKey(localeKey) && 
        Languages.keys[localeKey]!.containsKey(key)) {
      return Languages.keys[localeKey]![key]!;
    }
    
    // Try language code only (e.g. 'en')
    final String langCode = _locale.languageCode;
    if (Languages.keys.containsKey(langCode) && 
        Languages.keys[langCode]!.containsKey(key)) {
      return Languages.keys[langCode]![key]!;
    }

    // Default to 'en_US' if not found
    if (Languages.keys.containsKey('en_US') && 
        Languages.keys['en_US']!.containsKey(key)) {
      return Languages.keys['en_US']![key]!;
    }

    return key; // Return key if no translation found
  }
}
