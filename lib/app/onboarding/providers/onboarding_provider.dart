import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingProvider extends ChangeNotifier {
  bool _hasCompletedOnboarding = false;
  bool _isLoading = true;

  bool get hasCompletedOnboarding => _hasCompletedOnboarding;
  bool get isLoading => _isLoading;

  OnboardingProvider() {
    _loadOnboardingStatus();
  }

  Future<void> _loadOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _hasCompletedOnboarding = prefs.getBool('completed_onboarding') ?? false;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('completed_onboarding', true);
    _hasCompletedOnboarding = true;
    notifyListeners();
  }
}