import 'package:flutter/material.dart';
import 'dart:async';

import '../../../core/widgets/showBreathingDialog.dart';
import '../models/dashboard_model.dart';

/// Controller for the Home Dashboard and Guides.
class HomeController extends ChangeNotifier {
  DashboardModel? _dashboardModel;
  List<Map<String, dynamic>> _guideData = [];
  bool _isLoading = false;

  DashboardModel? get dashboardModel => _dashboardModel;
  List<Map<String, dynamic>> get guideData => _guideData;
  bool get isLoading => _isLoading;

  HomeController() {
    fetchDashboardData();
    fetchGuideData();
  }

  Future<void> fetchDashboardData() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1500));

    final Map<String, dynamic> rawData = {
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

    _dashboardModel = DashboardModel.fromJson(rawData);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchGuideData() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _guideData = [
      {"index": 0, "title": "Home", "message": "Explore your dashboard."},
      {"index": 1, "title": "The Circle", "message": "Connect with others."},
      {"index": 2, "title": "Find Coaches", "message": "Get expert help."},
      {"index": 3, "title": "Inbox", "message": "Stay updated."},
      {"index": 4, "title": "Profile", "message": "Track your growth."},
    ];
    notifyListeners();
  }

  void resetTimer() {
    if (_dashboardModel?.data?.timer != null) {
      final currentData = _dashboardModel!.data!;
      _dashboardModel = DashboardModel(
        status: _dashboardModel!.status,
        data: DashboardData(
          user: currentData.user,
          timer: TimerData(days: 0, hours: 0, mins: 0, startDate: currentData.timer?.startDate),
          dailyWisdom: currentData.dailyWisdom,
          journal: currentData.journal,
          notifications: currentData.notifications,
        ),
      );
      notifyListeners();
    }
  }

  void handleBreakNoContact(BuildContext context) => showBreathingDialog(
    context,
    title: "Take A Breath, ${dashboardModel?.data?.user?.name ?? '[Name]'}",
    description:
        "\"Stop. Don't press send. Before you do anything, let's take a quick 30 seconds and breathe.\"",
    primaryButtonText: "Start Breathing",
    onPrimaryTap: () {
      // Add navigation or specific logic here if needed
      debugPrint("Started breathing session for No Contact break.");
    },
  );

  void handleRelapsePrevention(BuildContext context) => showBreathingDialog(
    context,
    title: "How do you feel, ${dashboardModel?.data?.user?.name ?? '[Name]'}?",
    description:
        "\"Take a breath. This happens. Breaking No Contact doesn't mean you've failed; it just means you're human.\"",
    primaryButtonText: "I need to speak to someone 📞",
    onPrimaryTap: () {
      // Logic for contacting someone
      debugPrint("User requested to speak to someone.");
    },
  );
}
