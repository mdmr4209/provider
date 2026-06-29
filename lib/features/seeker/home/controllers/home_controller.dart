import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/services/navigation_service.dart';
import '../../../../core/widgets/show_breathing_dialog.dart';
import '../models/dashboard_model.dart';

/// Controller for the Home Dashboard and Guides.
class HomeController extends ChangeNotifier {
  DashboardModel? _dashboardModel;
  List<Map<String, dynamic>> _guideData = [];
  bool _isLoading = false;
  bool _isRefreshing = false;
  Timer? _ticker;

  // Added Journal Controller
  final TextEditingController journalController = TextEditingController();

  DashboardModel? get dashboardModel => _dashboardModel;
  List<Map<String, dynamic>> get guideData => _guideData;
  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;

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

  Future<void> fetchDashboardData({bool isRefresh = false}) async {
    if (isRefresh) {
      _isRefreshing = true;
    } else {
      _isLoading = true;
    }
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 1500));
      final String jsonString = await rootBundle.loadString(
        'assets/json/home.json',
      );
      final Map<String, dynamic> rawData = jsonDecode(jsonString);

      _dashboardModel = DashboardModel.fromJson(rawData);
    } catch (e) {
      debugPrint("Error loading home dashboard data: $e");
    } finally {
      _isLoading = false;
      _isRefreshing = false;
      notifyListeners();
    }
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
        "\"Stop. Don't press send. You are feeling a temporary wave of emotion. Before you do anything, let's take a quick 30 seconds, and breathe. DO it with me 4 seconds breath in, 4 seconds hold, 4 seconds breathe out. DO it 3 times, and a timer appears on screen counting down 4-3-2-1, and then beeps to signal the transition, and on top it directs them. It will say either Breath in, Hold or Breathe out. It should last a total of 30 seconds,\"",
    primaryButtonText: "\"Start Breathing\"",
    onPrimaryTap: () {
      NavigationService.goToBreathing(
        title: "\"Stop. Don't press send. 🔴\"",
        subtitle: "\"You are feeling a temporary wave of emotion.\"",
      );
    },
  );

  void handleRelapsePrevention(BuildContext context) => showBreathingDialog(
    context,
    title:
        "How do you feel now ${dashboardModel?.data?.user?.name ?? '[Name]'}?",
    description:
        "\"Take a breath, ${dashboardModel?.data?.user?.name ?? '[Name]'}. This happens. Breaking No Contact doesn't mean you've failed; it just means you're human. The important thing is what you do next. We are going to reset your tracker together, but first: Do you want to talk to a Coach about what happened? They can help you figure out your next move.\"",
    primaryButtonText: "\"I need to speak to someone. 📞\"",
    onPrimaryTap: () {
      // Logic for contacting someone
    },
  );

  List<Map<String, dynamic>> _notifications = [];
  List<Map<String, dynamic>> get notifications => _notifications;

  Future<void> fetchNotifications({bool isRefresh = false}) async {
    if (isRefresh) {
      _isRefreshing = true;
    } else {
      _isLoading = true;
    }
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 600));
      _notifications = [
        {
          "type": "invitation",
          "message": "You got a new a pod invitation from \"Sajib\"",
        },
        {
          "type": "invitation",
          "message": "A pod invitation has been accepted from \"Sajib\"",
        },
        {
          "type": "push",
          "title": "Title Of The Push Notification",
          "message":
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
          "image":
              "https://image.api.playstation.com/vulcan/ap/rnd/202102/1012/L0P0B1P6f1Q5v5S0Z1o1m3B6.png",
        },
      ];
    } catch (e) {
      // ignore
    } finally {
      _isLoading = false;
      _isRefreshing = false;
      notifyListeners();
    }
  }

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
