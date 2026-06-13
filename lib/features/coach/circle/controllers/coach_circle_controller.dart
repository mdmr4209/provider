import 'package:flutter/material.dart';
import '../../../../core/utils/helpers/snack_bar_helper.dart';

class CoachCircleController extends ChangeNotifier {
  bool _isPremium = false;
  final List<String> _joinedGroups = ['1']; // Mock: user joined one group

  bool get isPremium => _isPremium;

  void joinGroup(BuildContext context, String groupId) {
    if (!_isPremium && _joinedGroups.length >= 1) {
      _showUpgradeSheet(context);
    } else {
      if (!_joinedGroups.contains(groupId)) {
        _joinedGroups.add(groupId);
        showSuccessSnackBar(message: "Joined group successfully!");
        notifyListeners();
      }
    }
  }

  void _showUpgradeSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Color(0xFF1B2B1B),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFC19E5F), width: 1.5),
              ),
              child: const Icon(Icons.lock_outline, color: Color(0xFFC19E5F), size: 40),
            ),
            const SizedBox(height: 24),
            const Text(
              'Unlock More Groups',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'You can only one free circle at a time, to join more upgrade now.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  _isPremium = true;
                  Navigator.pop(context);
                  showSuccessSnackBar(message: "Premium unlocked! (Mock)");
                  notifyListeners();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC19E5F),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Upgrade Now', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Later', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
