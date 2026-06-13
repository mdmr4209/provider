import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/utils/helpers/snack_bar_helper.dart';

class CoachProfileController extends ChangeNotifier {
  bool _isLoading = false;
  bool _isRefreshing = false;

  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;

  // Step 1: Basic Info
  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  String? profilePhotoUrl;

  // Step 2: Experience & Specialties
  String? yearsOfExperience;
  final TextEditingController certificationController = TextEditingController();
  final List<String> selectedSpecialties = [];
  final List<String> selectedCoachingStyles = [];

  // Step 3: Pitch & Bio
  final TextEditingController pitchController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  // Step 4: Rates & Policies
  final TextEditingController perMinuteRateController = TextEditingController();
  final TextEditingController perTextRateController = TextEditingController();
  final TextEditingController cancellationPolicyController = TextEditingController();
  final TextEditingController cancellationPriorController = TextEditingController();
  
  List<CoachServiceOption> services = [
    CoachServiceOption(duration: '', price: '', isActive: true),
  ];

  // --- NEW: Manage Availability ---
  String? selectedDay;
  String? selectedStartTime;
  String? selectedEndTime;

  List<CoachAvailability> currentAvailability = [];

  // --- NEW: Follow Up Set up ---
  final TextEditingController followUpTextController = TextEditingController();
  String selectedFollowUpInterval = "30 Days";

  // --- NEW: Total Earnings & Withdrawal ---
  double balance = 0.0;
  final TextEditingController withdrawalAmountController = TextEditingController();
  final TextEditingController cardHolderNameController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvcController = TextEditingController();

  Future<void> fetchProfileData({bool isRefresh = false}) async {
    if (isRefresh) {
      _isRefreshing = true;
    } else {
      _isLoading = true;
    }
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 1000));
      final String jsonString = await rootBundle.loadString('assets/json/coach_profile.json');
      final Map<String, dynamic> data = jsonDecode(jsonString);

      balance = data['balance'] ?? 0.0;
      
      currentAvailability = (data['availability'] as List).map((x) => CoachAvailability.fromJson(x)).toList();
      services = (data['services'] as List).map((x) => CoachServiceOption.fromJson(x)).toList();
    } catch (e) {
      showErrorSnackBar(message: "Failed to load profile data: $e");
    } finally {
      _isLoading = false;
      _isRefreshing = false;
      notifyListeners();
    }
  }

  void setAvailabilityDay(String day) {
    selectedDay = day;
    notifyListeners();
  }

  void setStartTime(String time) {
    selectedStartTime = time;
    notifyListeners();
  }

  void setEndTime(String time) {
    selectedEndTime = time;
    notifyListeners();
  }

  void saveAvailability() {
    if (selectedDay != null && selectedStartTime != null && selectedEndTime != null) {
      currentAvailability.add(CoachAvailability(
        day: selectedDay!,
        timeRange: "$selectedStartTime - $selectedEndTime",
      ));
      // Reset selections
      selectedDay = null;
      selectedStartTime = null;
      selectedEndTime = null;
      notifyListeners();
    }
  }

  void removeAvailability(int index) {
    currentAvailability.removeAt(index);
    notifyListeners();
  }

  void setFollowUpInterval(String interval) {
    selectedFollowUpInterval = interval;
    notifyListeners();
  }

  void addServiceOption() {
    services.add(CoachServiceOption(duration: '', price: '', isActive: true));
    notifyListeners();
  }

  void removeServiceOption(int index) {
    if (services.length > 1) {
      services.removeAt(index);
      notifyListeners();
    }
  }

  void toggleSpecialty(String specialty) {
    if (selectedSpecialties.contains(specialty)) {
      selectedSpecialties.remove(specialty);
    } else {
      selectedSpecialties.add(specialty);
    }
    notifyListeners();
  }

  void toggleCoachingStyle(String style) {
    if (selectedCoachingStyles.contains(style)) {
      selectedCoachingStyles.remove(style);
    } else {
      selectedCoachingStyles.add(style);
    }
    notifyListeners();
  }

  void setYearsOfExperience(String? value) {
    yearsOfExperience = value;
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    locationController.dispose();
    certificationController.dispose();
    pitchController.dispose();
    bioController.dispose();
    perMinuteRateController.dispose();
    perTextRateController.dispose();
    cancellationPolicyController.dispose();
    cancellationPriorController.dispose();
    super.dispose();
  }
}

class CoachServiceOption {
  String duration;
  String price;
  bool isActive;

  CoachServiceOption({
    required this.duration,
    required this.price,
    required this.isActive,
  });

  factory CoachServiceOption.fromJson(Map<String, dynamic> json) {
    return CoachServiceOption(
      duration: json['duration'] ?? '',
      price: json['price'] ?? '',
      isActive: json['isActive'] ?? true,
    );
  }
}

class CoachAvailability {
  String day;
  String timeRange;

  CoachAvailability({required this.day, required this.timeRange});

  factory CoachAvailability.fromJson(Map<String, dynamic> json) {
    return CoachAvailability(
      day: json['day'] ?? '',
      timeRange: json['timeRange'] ?? '',
    );
  }
}
