import 'package:flutter/material.dart';
import 'dart:async';

import '../../../core/services/navigation_service.dart';
import '../../../core/widgets/showBreathingDialog.dart';
import '../models/dashboard_model.dart';

/// Controller for the Home Dashboard and Guides.
class HomeController extends ChangeNotifier {
  DashboardModel? _dashboardModel;
  List<Map<String, dynamic>> _guideData = [];
  bool _isLoading = false;
  Timer? _ticker;

  // Added Journal Controller
  final TextEditingController journalController = TextEditingController();

  DashboardModel? get dashboardModel => _dashboardModel;
  List<Map<String, dynamic>> get guideData => _guideData;
  bool get isLoading => _isLoading;

  HomeController() {
    fetchDashboardData().then((_) => _startTicker());
    fetchGuideData();
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_dashboardModel != null) {
        notifyListeners();
      }
    });
  }

  Future<void> fetchDashboardData() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1500));

    final Map<String, dynamic> rawData = {
      "status": "success",
      "data": {
        "user": {"name": "Jhonathan", "status": "YOU ARE\nSTRONG ✨"},
        "timer": {
          "days": 32,
          "hours": 0,
          "mins": 11,
          "secs": 45,
          "progress": 0.8,
          "startDate": "2026-04-22T08:30:00Z",
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
          timer: TimerData(
            days: 0,
            hours: 0,
            mins: 0,
            secs: 0,
            progressValue: 0.0,
            startDate: DateTime.now().toIso8601String(),
          ),
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
    "Stop. Don't press send. You are feeling a temporary wave of emotion. Before you do anything, let's take a quick 30 seconds, and breathe. Do it with me 4 seconds breath in, 4 seconds hold, 4 seconds breathe out. Do it 3 times.",
    primaryButtonText: "Start Breathing",
    onPrimaryTap: () { 
      NavigationService.goToBreathing(
        title: "Stop. Don't press send. 🔴",
        subtitle: "You are feeling a temporary wave of emotion.",
      );
    },
  );

  void handleRelapsePrevention(BuildContext context) => showBreathingDialog(
    context,
    title: "How do you feel, ${dashboardModel?.data?.user?.name ?? '[Name]'}?",
    description:
    "Take a breath. This happens. Breaking No Contact doesn't mean you've failed; it just means you're human.",
    primaryButtonText: "I need to speak to someone 📞",
    onPrimaryTap: () {
      // Logic for contacting someone
    },
  );

  void postJournal() {
    if (journalController.text.isNotEmpty) {
      // Handle post logic
      journalController.clear();
      NavigationService.pop();
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    journalController.dispose();
    super.dispose();
  }
}
