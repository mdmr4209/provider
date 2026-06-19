import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:newproject/core/constants/app_assets.dart';
import 'package:newproject/core/widgets/background_widget.dart';
import 'package:newproject/core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_loader.dart';
import '../../../../core/utils/helpers/snack_bar_helper.dart';
import '../../../seeker/profile/views/logout.dart';
import 'edit_coach_profile_wizard.dart';
import 'manage_availability_view.dart';
import 'follow_up_setup_view.dart';
import 'total_earnings_view.dart';
import '../../../../routes/app_router.dart';

class CoachSettingsView extends StatelessWidget {
  const CoachSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String referralLink = "thisisyourlink/au/invite/asjib00";
    bool notificationsEnabled = true;

    return BackgroundWidget(
      imagePath: AppAssets.bgMain,
      child: Scaffold(
        backgroundColor:
            Colors.transparent, // Background handled by parent wrapper

        body: FutureBuilder(
          future: Future.delayed(const Duration(milliseconds: 1500)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildSkeletonLoader();
            }
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  _buildSectionHeader("Account"),
                  _buildSettingsTile(
                    Icons.person_outline,
                    "Personal Information",
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EditCoachProfileWizard(),
                        ),
                      );
                    },
                  ),
                  _buildSettingsTile(
                    Icons.account_balance_wallet_outlined,
                    "Payment Method",
                    () => context.push(AppRoutes.paymentMethod),
                  ),
                  _buildSettingsTile(
                    Icons.lock_outline,
                    "Change Password",
                    () => context.push(AppRoutes.resetPassword),
                  ),
                  _buildSettingsTile(
                    Icons.workspace_premium_outlined,
                    "Subscription Plan",
                    () => context.push(AppRoutes.subscriptionPlan),
                  ),
                  _buildSettingsTile(Icons.access_time, "Set availability", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ManageAvailabilityView(),
                      ),
                    );
                  }),
                  _buildSettingsTile(
                    Icons.balance_outlined,
                    "Credits Balance",
                    () => context.push(AppRoutes.points),
                  ),
                  _buildSettingsTile(
                    Icons.connect_without_contact_outlined,
                    "Follow Up Set up",
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const FollowUpSetupView(),
                        ),
                      );
                    },
                  ),
                  _buildSettingsTile(
                    Icons.block_outlined,
                    "Block List",
                    () => context.push(AppRoutes.blockList),
                  ),
                  _buildSettingsTile(
                    Icons.history_outlined,
                    "Total Earnings",
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TotalEarningsView(),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 24.h),
                  _buildSectionHeader("Preferences"),
                  _buildSettingsTile(
                    Icons.palette_outlined,
                    "Theme & Appearance",
                    () => context.push(AppRoutes.theme),
                  ),
                  _buildNotificationTile(notificationsEnabled),

                  SizedBox(height: 24.h),
                  _buildSectionHeader("Support"),
                  _buildSettingsTile(
                    Icons.help_outline,
                    "Help & Support",
                    () => context.push(AppRoutes.helpSupport),
                  ),
                  _buildSettingsTile(Icons.logout, "Sign Out", () {
                    showDialog(
                      context: context,
                      builder: (context) => const Logout(),
                    );
                  }),

                  SizedBox(height: 24.h),
                  _buildSectionHeader("Referral Link"),
                  _buildReferralCard(referralLink),

                  SizedBox(height: 100.h),
                ],
              ),
            );
          },
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
      height: 49.h,
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: ShapeDecoration(
        color: const Color(0xFF273B24),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 0.50.r, color: const Color(0xFF354D31)),
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: Colors.white70, size: 22.r),
        title: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 14.sp),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.white24,
          size: 16.r,
        ),
      ),
    );
  }

  Widget _buildNotificationTile(bool notificationsEnabled) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          decoration: BoxDecoration(
            color: const Color(0xFF2D3D2D),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: ListTile(
            leading: const Icon(
              Icons.notifications_none_outlined,
              color: Colors.white70,
              size: 22,
            ),
            title: const Text(
              "Notifications",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            trailing: Switch(
              value: notificationsEnabled,
              onChanged: (val) => setState(() => notificationsEnabled = val),
              activeThumbColor: const Color(0xFFC19E5F),
              activeTrackColor: const Color(0xFFC19E5F).withAlpha(100),
            ),
          ),
        );
      },
    );
  }

  Widget _buildReferralCard(String referralLink) {
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
            referralLink,
            style: TextStyle(color: Colors.white38, fontSize: 13.sp),
          ),
          SizedBox(height: 16.h),
          CustomButton(onPress: ()async {
            await Clipboard.setData(ClipboardData(text: referralLink));
            showSuccessSnackBar(message: "Link copied to clipboard!");
          }, title: "Copy your referral link",linearGradient: true,leadingIcon: AppAssets.copy,)
        ],
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          ShimmerLoader(width: 100.w, height: 20.h),
          SizedBox(height: 12.h),
          ...List.generate(
            8,
            (_) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: ShimmerLoader(
                width: double.infinity,
                height: 56.h,
                borderRadius: 12.r,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          ShimmerLoader(width: 120.w, height: 20.h),
          SizedBox(height: 12.h),
          ...List.generate(
            2,
            (_) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: ShimmerLoader(
                width: double.infinity,
                height: 56.h,
                borderRadius: 12.r,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          ShimmerLoader(width: 80.w, height: 20.h),
          SizedBox(height: 12.h),
          ...List.generate(
            2,
            (_) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: ShimmerLoader(
                width: double.infinity,
                height: 56.h,
                borderRadius: 12.r,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          ShimmerLoader(width: 140.w, height: 20.h),
          SizedBox(height: 12.h),
          ShimmerLoader(
            width: double.infinity,
            height: 160.h,
            borderRadius: 16.r,
          ),
        ],
      ),
    );
  }
}
