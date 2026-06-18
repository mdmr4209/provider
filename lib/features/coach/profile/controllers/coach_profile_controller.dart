import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/utils/helpers/snack_bar_helper.dart';

class CoachProfileController extends ChangeNotifier {
  bool _isLoading = false;
  bool _isRefreshing = false;
  bool _hasFetched = false;

  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;
  bool get hasFetched => _hasFetched;

  // Step 1: Basic Info
  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  String? profilePhotoUrl;

  int wizardCurrentPage = 0;
  final PageController wizardPageController = PageController();

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
    CoachServiceOption(title: 'Option 1', duration: 'Enter here', price: 'Enter here', isActive: true),
  ];

  // --- NEW: Setup Flow Specifics ---
  String selectedExperience = "Select Experience";
  List<String> uploadedFiles = [];
  bool isUploading = false;

  void setSelectedExperience(String experience) {
    selectedExperience = experience;
    notifyListeners();
  }

  Future<void> simulateUpload(Function onDone) async {
    isUploading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 1200));
    isUploading = false;
    uploadedFiles.add("RYT 200 Yoga Certification");
    notifyListeners();
    onDone();
  }

  void removeUploadedFile(String file) {
    uploadedFiles.remove(file);
    notifyListeners();
  }

  // --- NEW: Setup Availability specifics ---
  bool isOnDays = true;
  void toggleIsOnDays(bool val) {
    isOnDays = val;
    notifyListeners();
  }

  String setupSelectedDay = "Enter here";
  String onStartTime = "Enter here";
  String onEndTime = "Enter here";
  List<Map<String, String>> onDaysList = [
    {"day": "Monday", "time": "09:00 AM - 12:00 PM"},
    {"day": "Monday", "time": "09:00 AM - 12:00 PM"},
    {"day": "Tuesday", "time": "09:00 AM - 12:00 PM"},
    {"day": "Tuesday", "time": "09:00 AM - 12:00 PM"},
    {"day": "Tuesday", "time": "09:00 AM - 12:00 PM"},
  ];

  String selectedFromDate = "Select one";
  String selectedToDate = "Select one";
  String offStartTime = "Enter here";
  String offEndTime = "Enter here";
  List<Map<String, String>> offDaysList = [
    {"start": "31/08/2026; 12:00PM", "end": "31/08/2026; 12:00PM"},
    {"start": "31/08/2026; 12:00PM", "end": "31/08/2026; 12:00PM"},
    {"start": "31/08/2026; 12:00PM", "end": "31/08/2026; 12:00PM"},
    {"start": "31/08/2026; 12:00PM", "end": "31/08/2026; 12:00PM"},
  ];

  void updateAvailabilityField({
    String? day, String? onStart, String? onEnd,
    String? fromDate, String? toDate, String? offStart, String? offEnd
  }) {
    if (day != null) setupSelectedDay = day;
    if (onStart != null) onStartTime = onStart;
    if (onEnd != null) onEndTime = onEnd;
    if (fromDate != null) selectedFromDate = fromDate;
    if (toDate != null) selectedToDate = toDate;
    if (offStart != null) offStartTime = offStart;
    if (offEnd != null) offEndTime = offEnd;
    notifyListeners();
  }

  void saveSetupOnDay() {
    onDaysList.add({
      "day": setupSelectedDay,
      "time": "$onStartTime - $onEndTime"
    });
    setupSelectedDay = "Enter here";
    onStartTime = "Enter here";
    onEndTime = "Enter here";
    notifyListeners();
  }

  void saveSetupOffDay() {
    offDaysList.add({
      "start": "$selectedFromDate; $offStartTime",
      "end": "$selectedToDate; $offEndTime"
    });
    selectedFromDate = "Select one";
    selectedToDate = "Select one";
    offStartTime = "Enter here";
    offEndTime = "Enter here";
    notifyListeners();
  }
  
  void removeSetupOnDay(Map<String, String> item) {
    onDaysList.remove(item);
    notifyListeners();
  }

  void removeSetupOffDay(Map<String, String> item) {
    offDaysList.remove(item);
    notifyListeners();
  }

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
    _hasFetched = true;
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
    services.add(CoachServiceOption(title: 'Option ${services.length + 1}', duration: 'Enter here', price: 'Enter here', isActive: true));
    notifyListeners();
  }

  void removeServiceOption(int index) {
    if (services.length > 1) {
      services.removeAt(index);
      notifyListeners();
    }
  }

  void updateServiceOption(CoachServiceOption option, {String? duration, String? price, bool? isActive}) {
    if (duration != null) option.duration = duration;
    if (price != null) option.price = price;
    if (isActive != null) option.isActive = isActive;
    notifyListeners();
  }

  void removeServiceOptionByObject(CoachServiceOption option) {
    services.remove(option);
    notifyListeners();
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

  void setWizardCurrentPage(int page) {
    wizardCurrentPage = page;
    notifyListeners();
  }

  @override
  void dispose() {
    wizardPageController.dispose();
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
  String title;
  String duration;
  String price;
  bool isActive;

  CoachServiceOption({
    this.title = '',
    required this.duration,
    required this.price,
    required this.isActive,
  });

  factory CoachServiceOption.fromJson(Map<String, dynamic> json) {
    return CoachServiceOption(
      title: json['title'] ?? '',
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
