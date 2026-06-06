import 'package:flutter/material.dart';
import '../models/circle_post_model.dart';

class CircleController extends ChangeNotifier {
  List<CirclePostModel> _posts = [];
  List<SuggestionModel> _members = [];
  bool _isLoading = false;
  bool _isRefreshing = false;

  List<CirclePostModel> get posts => _posts;
  List<SuggestionModel> get members => _members;
  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;

  Future<void> fetchCircleData({bool isRefresh = false}) async {
    if (isRefresh) {
      _isRefreshing = true;
    } else {
      _isLoading = true;
    }
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1500));
    // Simulating API call with dummy data
    _posts = CirclePostModel.dummyPosts;
    _members = SuggestionModel.dummySuggestions;
    
    _isLoading = false;
    _isRefreshing = false;
    notifyListeners();
  }
}
