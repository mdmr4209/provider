import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newproject/core/widgets/custom_button.dart';
import '../models/coach_home_model.dart';
import '../../../../core/utils/helpers/snack_bar_helper.dart';

class CoachHomeController extends ChangeNotifier {
  bool _isActive = true;
  bool _isLoading = false;
  bool _isRefreshing = false;

  CoachStatsModel? _stats;
  List<CoachSessionModel> _sessions = [];
  List<CoachMessageModel> _messages = [];

  bool get isActive => _isActive;
  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;

  CoachStatsModel? get stats => _stats;
  List<CoachSessionModel> get sessions => _sessions;
  List<CoachMessageModel> get messages => _messages;

  Future<void> fetchHomeData({bool isRefresh = false}) async {
    if (isRefresh) {
      _isRefreshing = true;
    } else {
      _isLoading = true;
    }
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 1000));
      final String jsonString = await rootBundle.loadString(
        'assets/json/coach_home.json',
      );
      final Map<String, dynamic> data = jsonDecode(jsonString);

      _stats = CoachStatsModel.fromJson(data['stats']);
      _sessions = (data['upcomingSessions'] as List)
          .map((x) => CoachSessionModel.fromJson(x))
          .toList();
      _messages = (data['newMessages'] as List)
          .map((x) => CoachMessageModel.fromJson(x))
          .toList();
    } catch (e) {
      showErrorSnackBar(message: "Failed to load dashboard: $e");
    } finally {
      _isLoading = false;
      _isRefreshing = false;
      notifyListeners();
    }
  }

  void toggleActive(BuildContext context) {
    if (_isActive) {
      // Logic for disabling: check for pending sessions
      _showHoldOnDialog(context);
    } else {
      _isActive = true;
      notifyListeners();
    }
  }

  void _showHoldOnDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C3F28),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFF132312),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                color: const Color(0xFFFB6262),
                size: 30,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Hold On!!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: 251,
              child: Text(
                'You cant disable account before taking decision about arranged Sessions',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                onPress: () async => Navigator.pop(context),
                title: 'Got it',
                linearGradient: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void cancelSession(BuildContext context, String sessionId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C3E28),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                child: const Icon(Icons.close, color: Colors.white54, size: 20),
                onTap: () => Navigator.pop(context),
              ),
            ),
            Text(
              'Are you sure about Cancelling Session?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    width: 125.64,
                    height: 32,
                    onPress: () async => Navigator.pop(context),
                    title: 'No',
                    buttonColor: Color(0xFF4C6D45),
                    borderColor: Color(0xFF4C6D45),
                    radius: 4,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    width: 125.64,
                    height: 32,
                    onPress: () async => Navigator.pop(context),
                    title: 'Yes',
                    linearGradient: true,
                    radius: 4,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
