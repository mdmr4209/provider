import 'package:newproject/core/theme/design_system.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newproject/core/constants/app_assets.dart';
import 'package:newproject/core/widgets/custom_button.dart';
import '../../../../core/utils/helpers/snack_bar_helper.dart';
import '../../../seeker/circle/models/group_model.dart';
import '../../../../core/constants/app_colors.dart'; // Reuse GroupModel

class CoachCircleController extends ChangeNotifier {
  bool _isLoading = false;
  bool _isRefreshing = false;
  bool _isPremium = false;
  bool _hasFetched = false;

  List<GroupModel> _circles = [];

  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;
  bool get isPremium => _isPremium;
  bool get hasFetched => _hasFetched;
  List<GroupModel> get circles => _circles;

  Future<void> fetchCircles({bool isRefresh = false}) async {
    _hasFetched = true;
    if (isRefresh) {
      _isRefreshing = true;
    } else {
      _isLoading = true;
    }
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 1000));
      final String jsonString = await rootBundle.loadString(
        'assets/json/coach_circle.json',
      );
      final Map<String, dynamic> data = jsonDecode(jsonString);

      _circles = (data['circles'] as List)
          .map((x) => GroupModel.fromJson(x))
          .toList();
    } catch (e) {
      showErrorSnackBar(message: "Failed to load coach circles: $e");
    } finally {
      _isLoading = false;
      _isRefreshing = false;
      notifyListeners();
    }
  }

  void joinGroup(BuildContext context, String groupId) {
    // Check if joined circles count > 0 (mock limit for non-premium)
    int joinedCount = _circles.where((c) => c.isJoined).length;

    if (!_isPremium && joinedCount >= 1) {
      _showUpgradeSheet(context);
    } else {
      final index = _circles.indexWhere(
        (c) => c.id == groupId || c.name == groupId,
      );
      if (index != -1 && !_circles[index].isJoined) {
        // Mock update
        final current = _circles[index];
        _circles[index] = GroupModel(
          id: current.id,
          name: current.name,
          icon: current.icon,
          memberCount: current.memberCount + 1,
          description: current.description,
          isJoined: true,
          status: current.status,
        );
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
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).extension<AppDesignSystem>()!.accentPanelColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.white24Color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 32),
            SvgPicture.asset(AppAssets.lock),
            const SizedBox(height: 12),
            Text(
              'Unlock More Groups',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.whiteColor,
                fontSize: 20,
                fontFamily: 'Segoe UI',
                fontWeight: FontWeight.w600,
                height: 1.50,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'You can only one free circle at a time, to join more upgrade now.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.coachColorFF838383,
                fontSize: 14,
                fontFamily: 'Segoe UI',
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              linearGradient: true,
              height: 48,
              onPress: () async {
                _isPremium = true;
                Navigator.pop(context);
                showSuccessSnackBar(message: "Premium unlocked! (Mock)");
                notifyListeners();
              },
              title: "Upgrade Now",
            ),
            const SizedBox(height: 12),
            CustomButton(
              height: 44,
              onPress: () async => Navigator.pop(context),
              title: "Later",
              buttonColor: AppColors.coachColor33434928,
              borderColor: AppColors.coachColorF2C9A84C,
              borderWidth: .5,
              radius: 8,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
