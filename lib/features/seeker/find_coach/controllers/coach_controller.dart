import 'package:flutter/material.dart';
import '../models/coach_model.dart';
import '../../../../core/utils/helpers/snack_bar_helper.dart';

class CoachController extends ChangeNotifier {
  CoachModel? _heroCoach;
  List<CoachModel> _featuredCoaches = [];
  List<CoachModel> _topRatedCoaches = [];
  List<CoachSlotModel> _slots = [];
  List<String> _availableSlots = [];
  List<CoachReviewModel> _reviews = [];

  bool _isLoading = false;
  bool _isRefreshing = false;

  CoachModel? get heroCoach => _heroCoach;
  List<CoachModel> get featuredCoaches => _featuredCoaches;
  List<CoachModel> get topRatedCoaches => _topRatedCoaches;
  List<CoachSlotModel> get slots => _slots;
  List<String> get availableSlots => _availableSlots;
  List<CoachReviewModel> get reviews => _reviews;

  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;

  Future<void> fetchCoachesDiscover({bool isRefresh = false}) async {
    if (isRefresh) {
      _isRefreshing = true;
    } else {
      _isLoading = true;
    }
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 1000));

      // Mock dynamic JSON based on 12.1 Discover Coaches
      final Map<String, dynamic> rawDiscover = {
        "heroCoach": {
          "id": "c1",
          "name": "Coach Pearl",
          "title": "Relationship Specialist",
          "rating": 5.0,
          "reviews": 310,
          "avatar": "https://i.pravatar.cc/300?u=coach_pearl",
          "experience": "5 Year Experience",
          "bio": "Amazon Alexa Shopping is seeking a talented, experienced, and self-directed UX Designer to define and drive the future of shopping at Amazon."
        },
        "featured": [
          {
            "id": "c2",
            "name": "Coach Sarah",
            "title": "Mindset Coach",
            "rating": 4.9,
            "reviews": 187,
            "avatar": "https://i.pravatar.cc/150?u=coach_sarah"
          },
          {
            "id": "c4",
            "name": "Coach Michael",
            "title": "Cognitive Therapist",
            "rating": 4.8,
            "reviews": 125,
            "avatar": "https://i.pravatar.cc/150?u=coach_mike"
          }
        ],
        "topRated": [
          {
            "id": "c3",
            "name": "Coach Emma",
            "title": "Life Coach & Counselor",
            "rating": 4.9,
            "reviews": 240,
            "avatar": "https://i.pravatar.cc/150?u=coach_emma"
          },
          {
            "id": "c2",
            "name": "Coach Sarah",
            "title": "Mindset Coach",
            "rating": 4.9,
            "reviews": 187,
            "avatar": "https://i.pravatar.cc/150?u=coach_sarah"
          }
        ]
      };

      _heroCoach = CoachModel.fromJson(rawDiscover['heroCoach']);
      _featuredCoaches = (rawDiscover['featured'] as List).map((x) => CoachModel.fromJson(x)).toList();
      _topRatedCoaches = (rawDiscover['topRated'] as List).map((x) => CoachModel.fromJson(x)).toList();
    } catch (e) {
      showErrorSnackBar(message: "Failed to fetch coaches list: $e");
    } finally {
      _isLoading = false;
      _isRefreshing = false;
      notifyListeners();
    }
  }

  Future<void> fetchCoachSlots(String coachId, {bool isRefresh = false}) async {
    if (isRefresh) {
      _isRefreshing = true;
    } else {
      _isLoading = true;
    }
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 600));

      // Mock dynamic JSON based on 12.2
      final Map<String, dynamic> rawSlots = {
        "sessions": [
          { "duration": "30 Min", "price": 75 },
          { "duration": "60 Minutes", "price": 150 }
        ],
        "availableSlots": [
          "09:00 AM - 09:30 AM",
          "10:00 AM - 10:30 AM",
          "11:30 AM - 12:00 PM"
        ]
      };

      _slots = (rawSlots['sessions'] as List).map((x) => CoachSlotModel.fromJson(x)).toList();
      _availableSlots = List<String>.from(rawSlots['availableSlots']);
    } catch (e) {
      showErrorSnackBar(message: "Failed to fetch slots: $e");
    } finally {
      _isLoading = false;
      _isRefreshing = false;
      notifyListeners();
    }
  }

  Future<void> fetchCoachReviews(String coachId, {bool isRefresh = false}) async {
    if (isRefresh) {
      _isRefreshing = true;
    } else {
      _isLoading = true;
    }
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final List<Map<String, dynamic>> rawReviews = [
        {
          "reviewerName": "Monalisa gong",
          "reviewerAvatar": "https://i.pravatar.cc/150?u=reviewer1",
          "date": "25 July, 25",
          "rating": 4.0,
          "content": "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s."
        },
        {
          "reviewerName": "David Miller",
          "reviewerAvatar": "https://i.pravatar.cc/150?u=reviewer2",
          "date": "20 July, 25",
          "rating": 5.0,
          "content": "Great counseling session, helped me stay calm and stay strong during my breakup. Highly recommended."
        }
      ];

      _reviews = rawReviews.map((x) => CoachReviewModel.fromJson(x)).toList();
    } catch (e) {
      showErrorSnackBar(message: "Failed to load reviews: $e");
    } finally {
      _isLoading = false;
      _isRefreshing = false;
      notifyListeners();
    }
  }

  Future<bool> bookSession(String slot) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 1000));
      showSuccessSnackBar(message: "Successfully scheduled session!");
      return true;
    } catch (e) {
      showErrorSnackBar(message: "Booking failed: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
