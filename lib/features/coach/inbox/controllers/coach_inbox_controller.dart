import 'package:flutter/material.dart';

class CoachInboxController extends ChangeNotifier {
  int _credits = 15;
  int get credits => _credits;

  void addCredits(int amount) {
    _credits += amount;
    notifyListeners();
  }

  // Future: Add logic for filtering clients vs friends, tabs, etc.
}
