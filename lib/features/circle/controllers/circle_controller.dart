import 'package:flutter/material.dart';
import '../models/circle_post_model.dart';

class CircleController extends ChangeNotifier {
  List<CirclePostModel> _posts = [];
  List<SuggestionModel> _members = [];
  bool _isLoading = false;

  List<CirclePostModel> get posts => _posts;
  List<SuggestionModel> get members => _members;
  bool get isLoading => _isLoading;

  void fetchCircleData() {
    _isLoading = true;
    notifyListeners();

    // Simulating API call with dummy data
    _posts = CirclePostModel.dummyPosts;
    _members = SuggestionModel.dummySuggestions;
    
    _isLoading = false;
    notifyListeners();
  }
}
