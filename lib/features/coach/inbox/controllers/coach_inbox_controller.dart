import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/coach_inbox_model.dart';
import '../../../../core/utils/helpers/snack_bar_helper.dart';
import '../../../seeker/inbox/models/inbox_model.dart'; // Reuse StoryModel and ChatSummaryModel

class CoachInboxController extends ChangeNotifier {
  bool _isLoading = false;
  bool _isRefreshing = false;
  bool _hasFetched = false;
  int _credits = 15;

  List<StoryModel> _stories = [];
  List<ChatSummaryModel> _messages = [];
  List<CoachClientModel> _clients = [];
  List<CoachMissedCallModel> _missedCalls = [];
  List<CoachCallbackModel> _callbacks = [];

  int _selectedTabIndex = 0;
  int _selectedContext = 0;

  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;
  bool get hasFetched => _hasFetched;
  int get credits => _credits;

  List<StoryModel> get stories => _stories;
  List<ChatSummaryModel> get messages => _messages;
  List<CoachClientModel> get clients => _clients;
  List<CoachMissedCallModel> get missedCalls => _missedCalls;
  List<CoachCallbackModel> get callbacks => _callbacks;

  int get selectedTabIndex => _selectedTabIndex;
  int get selectedContext => _selectedContext;

  void setSelectedTab(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

  void setSelectedContext(int index) {
    _selectedContext = index;
    notifyListeners();
  }

  Future<void> fetchInboxData({bool isRefresh = false}) async {
    _hasFetched = true;
    if (isRefresh) {
      _isRefreshing = true;
    } else {
      _isLoading = true;
    }
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 1000));
      final String jsonString = await rootBundle.loadString(
        'assets/json/coach_inbox.json',
      );
      final Map<String, dynamic> data = jsonDecode(jsonString);

      _credits = data['credits'] ?? 15;
      _stories = (data['stories'] as List)
          .map((x) => StoryModel.fromJson(x))
          .toList();
      _messages = (data['messages'] as List)
          .map((x) => ChatSummaryModel.fromJson(x))
          .toList();
      _clients = (data['clients'] as List)
          .map((x) => CoachClientModel.fromJson(x))
          .toList();
      _missedCalls = (data['missedCalls'] as List)
          .map((x) => CoachMissedCallModel.fromJson(x))
          .toList();
      _callbacks = (data['callBacks'] as List)
          .map((x) => CoachCallbackModel.fromJson(x))
          .toList();
    } catch (e) {
      showErrorSnackBar(message: "Failed to load coach inbox: $e");
    } finally {
      _isLoading = false;
      _isRefreshing = false;
      notifyListeners();
    }
  }

  void addCredits(int amount) {
    _credits += amount;
    notifyListeners();
  }
}
