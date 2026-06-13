import 'package:flutter/material.dart';

class CoachProfileController extends ChangeNotifier {
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
  
  final List<CoachServiceOption> services = [
    CoachServiceOption(duration: '', price: '', isActive: true),
  ];

  // --- NEW: Manage Availability ---
  String? selectedDay;
  String? selectedStartTime;
  String? selectedEndTime;

  final List<CoachAvailability> currentAvailability = [
    CoachAvailability(day: "Monday", timeRange: "09:00 AM - 12:00 PM"),
    CoachAvailability(day: "Wednesday", timeRange: "02:00 PM - 05:00 PM"),
  ];

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

  // --- NEW: Follow Up Set up ---
  final TextEditingController followUpTextController = TextEditingController();
  String selectedFollowUpInterval = "30 Days";

  void setFollowUpInterval(String interval) {
    selectedFollowUpInterval = interval;
    notifyListeners();
  }

  // --- NEW: Total Earnings & Withdrawal ---
  final double balance = 20.0;
  final TextEditingController withdrawalAmountController = TextEditingController();
  final TextEditingController cardHolderNameController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvcController = TextEditingController();

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
}

class CoachAvailability {
  String day;
  String timeRange;

  CoachAvailability({required this.day, required this.timeRange});
}
