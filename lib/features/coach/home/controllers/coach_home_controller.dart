import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      final String jsonString = await rootBundle.loadString('assets/json/coach_home.json');
      final Map<String, dynamic> data = jsonDecode(jsonString);

      _stats = CoachStatsModel.fromJson(data['stats']);
      _sessions = (data['upcomingSessions'] as List).map((x) => CoachSessionModel.fromJson(x)).toList();
      _messages = (data['newMessages'] as List).map((x) => CoachMessageModel.fromJson(x)).toList();
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
        backgroundColor: const Color(0xFF1B2B1B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFF2D3D2D),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.priority_high, color: Color(0xFFE57373), size: 30),
            ),
            const SizedBox(height: 16),
            const Text(
              'Hold On!!',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'You cant disable account before taking decision about arranged Sessions',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC19E5F),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Got it', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
        backgroundColor: const Color(0xFF1B2B1B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white54, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const Text(
              'Are you sure about Cancelling Session?',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A5D4A),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('No', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Perform cancel logic
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC19E5F),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Yes', style: TextStyle(color: Colors.white)),
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
