import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/helpers/snack_bar_helper.dart';
import '../../../seeker/profile/views/logout.dart';
import 'edit_coach_profile_wizard.dart';
import 'manage_availability_view.dart';
import 'follow_up_setup_view.dart';
import 'total_earnings_view.dart';
import '../../../../routes/app_router.dart';
import '../../../shared/auth/controllers/auth_controller.dart';


class CoachSettingsView extends StatefulWidget {
  const CoachSettingsView({super.key});

  @override
  State<CoachSettingsView> createState() => _CoachSettingsViewState();
}

class _CoachSettingsViewState extends State<CoachSettingsView> {
  bool _notificationsEnabled = true;
  final String _referralLink = "thisisyourlink/au/invite/asjib00";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent, // Background handled by parent wrapper
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Settings",
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            _buildSectionHeader("Account"),
            _buildSettingsTile(Icons.person_outline, "Personal Information", () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const EditCoachProfileWizard()));
            }),
            _buildSettingsTile(Icons.account_balance_wallet_outlined, "Payment Method", () => context.push(AppRoutes.paymentMethod)),
            _buildSettingsTile(Icons.lock_outline, "Change Password", () => context.push(AppRoutes.resetPassword)),
            _buildSettingsTile(Icons.workspace_premium_outlined, "Subscription Plan", () => context.push(AppRoutes.subscriptionPlan)),
            _buildSettingsTile(Icons.access_time, "Set availability", () {
               Navigator.push(context, MaterialPageRoute(builder: (_) => const ManageAvailabilityView()));
            }),
            _buildSettingsTile(Icons.balance_outlined, "Credits Balance", () => context.push(AppRoutes.points)),
            _buildSettingsTile(Icons.connect_without_contact_outlined, "Follow Up Set up", () {
               Navigator.push(context, MaterialPageRoute(builder: (_) => const FollowUpSetupView()));
            }),
            _buildSettingsTile(Icons.block_outlined, "Block List", () => context.push(AppRoutes.blockList)),
            _buildSettingsTile(Icons.history_outlined, "Total Earnings", () {
               Navigator.push(context, MaterialPageRoute(builder: (_) => const TotalEarningsView()));
            }),

            SizedBox(height: 24.h),
            _buildSectionHeader("Preferences"),
            _buildSettingsTile(Icons.palette_outlined, "Theme & Appearance", () => context.push(AppRoutes.theme)),
            _buildNotificationTile(),

            SizedBox(height: 24.h),
            _buildSectionHeader("Support"),
            _buildSettingsTile(Icons.help_outline, "Help & Support", () => context.push(AppRoutes.helpSupport)),
            _buildSettingsTile(Icons.logout, "Sign Out", () {
              showDialog(
                context: context,
                builder: (context) => const Logout(),
              );
            }),

            SizedBox(height: 24.h),
            _buildSectionHeader("Referral Link"),
            _buildReferralCard(),

            SizedBox(height: 100.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h, left: 4.w),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3D2D),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: Colors.white70, size: 22.r),
        title: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 14.sp),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16.r),
      ),
    );
  }

  Widget _buildNotificationTile() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3D2D),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListTile(
        leading: const Icon(Icons.notifications_none_outlined, color: Colors.white70, size: 22),
        title: const Text("Notifications", style: TextStyle(color: Colors.white, fontSize: 14)),
        trailing: Switch(
          value: _notificationsEnabled,
          onChanged: (val) => setState(() => _notificationsEnabled = val),
          activeColor: const Color(0xFFC19E5F),
          activeTrackColor: const Color(0xFFC19E5F).withAlpha(100),
        ),
      ),
    );
  }

  Widget _buildReferralCard() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3D2D),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.help_outline, color: Colors.white38, size: 18),
              SizedBox(width: 12.w),
              const Expanded(
                child: Text(
                  "Personalized Profile Link",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              const Icon(Icons.keyboard_arrow_down, color: Colors.white38),
            ],
          ),
          SizedBox(height: 24.h),
          Text(
            _referralLink,
            style: TextStyle(color: Colors.white38, fontSize: 13.sp),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFAC823A), Color(0xFFF3D194)],
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _referralLink));
                  showSuccessSnackBar(message: "Link copied to clipboard!");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                icon: const Icon(Icons.copy, color: Colors.white),
                label: const Text(
                  "Copy your referral link",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
