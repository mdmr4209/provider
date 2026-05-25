import 'package:flutter/material.dart';
import 'dart:async';

import '../../../core/widgets/showBreathingDialog.dart';

/// Controller for the Home Dashboard and Guides.
/// Follows the pattern of using dummy data as specified in JSON.md.
class HomeController extends ChangeNotifier {
  // ── State ──────────────────────────────────────────────────────────────────

  Map<String, dynamic> _dashboardData = {};
  List<Map<String, dynamic>> _guideData = [];
  bool _isLoading = false;

  Map<String, dynamic> get dashboardData => _dashboardData;
  List<Map<String, dynamic>> get guideData => _guideData;
  bool get isLoading => _isLoading;

  HomeController() {
    fetchDashboardData();
    fetchGuideData();
  }

  /// Mimics fetching Dashboard data from an API (JSON.md #4.1)
  Future<void> fetchDashboardData() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    _dashboardData = {
      "status": "success",
      "data": {
        "user": {"name": "Jonathan", "status": "YOU ARE\nSTRONG ✨"},
        "timer": {
          "days": 32,
          "hours": 0,
          "mins": 11,
          "startDate": "2024-04-22T08:30:00Z",
        },
        "dailyWisdom": {
          "quote":
              "Progress isn't a straight line. Every small step back is just preparation for a giant leap forward.",
          "author": "Coach Pearl 🍃",
        },
        "journal": {
          "prompt": "Tap to write about your day...",
          "actionText": "Write →",
        },
        "notifications": {"unreadCount": 2},
      },
    };

    _isLoading = false;
    notifyListeners();
  }

  /// Mimics fetching Navigation Guide data from an API (JSON.md #5)
  Future<void> fetchGuideData() async {
    await Future.delayed(const Duration(milliseconds: 300));

    _guideData = [
      {
        "index": 0,
        "title": "Home",
        "message":
            "Lorem ipsum dolor Mauris sit amet consectetur. Vel ligula nunc sed amet erat cursus. Mauris.",
      },
      {
        "index": 1,
        "title": "The Circle",
        "message":
            "Connect with others in our community forum and share your progress.",
      },
      {
        "index": 2,
        "title": "Find Coaches",
        "message":
            "Need expert help? Browse and book specialized coaches for one-on-one support.",
      },
      {
        "index": 3,
        "title": "Inbox",
        "message":
            "Stay updated with your latest messages and community notifications.",
      },
      {
        "index": 4,
        "title": "Profile",
        "message":
            "Customize your experience and track your personal growth metrics here.",
      },
    ];
    notifyListeners();
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  void resetTimer() {
    if (_dashboardData.containsKey('data')) {
      _dashboardData['data']['timer']['days'] = 0;
      _dashboardData['data']['timer']['hours'] = 0;
      _dashboardData['data']['timer']['mins'] = 0;
      notifyListeners();
    }
  }

  void handleBreakNoContact(BuildContext context) => showBreathingDialog(
    context,
    title: "Take A Breath, [Name]",
    description:
        "\"Stop. Don't press send. Before you do anything, let's take a quick 30 seconds and breathe. Do it with me 4 seconds breath in, 4 seconds hold, 4 seconds breathe out.\"",
    primaryButtonText: "\"Start Breathing\"",
    onPrimaryTap: () {
      /// CLOSE FIRST DIALOG
      Navigator.pop(context);
    },
  );
  void handleRelapsePrevention(BuildContext context) => showBreathingDialog(
    context,
    title: "How do you feel now [Name]?",
    description:
        "\"Take a breath, [Name]. This happens. Breaking No Contact doesn't mean you've failed; it just means you're human.\"",
    primaryButtonText: "\"Yes, I need to speak to someone.\" 📞",
    onPrimaryTap: () {
      Navigator.pop(context);
    },
  );
}
