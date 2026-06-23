import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      final String jsonString = await rootBundle.loadString('assets/json/coach.json');
      final Map<String, dynamic> rawDiscover = jsonDecode(jsonString);

      _heroCoach = CoachModel.fromJson(rawDiscover['heroCoach']);
      _featuredCoaches = (rawDiscover['featured'] as List).map((x) => CoachModel.fromJson(x)).toList();
      _topRatedCoaches = (rawDiscover['topRated'] as List).map((x) => CoachModel.fromJson(x)).toList();
    } catch (e) {
      debugPrint("Error loading coaches: $e");
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

      final String slotsJsonString = await rootBundle.loadString('assets/json/coach_slots.json');
      final Map<String, dynamic> rawSlots = jsonDecode(slotsJsonString);

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

      final String reviewsJsonString = await rootBundle.loadString('assets/json/coach_reviews.json');
      final List<dynamic> rawReviewsList = jsonDecode(reviewsJsonString);
      final List<Map<String, dynamic>> rawReviews = List<Map<String, dynamic>>.from(rawReviewsList);

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
