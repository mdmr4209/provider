import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../routes/app_router.dart';
import '../controllers/profile_controller.dart';
import 'logout.dart';
import '../../localization/localization_extension.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text(
          context.watchTr('settings'),
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontFamily: 'Georgia',
            fontSize: 20.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<ProfileController>(
        builder: (context, profile, _) => SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                _buildSectionHeader("Account"),
                _buildSettingsTile(
                  icon: Icons.person_outline,
                  title: "Personal Information",
                  onTap: () => context.push(AppRoutes.editProfile),
                ),
                _buildSettingsTile(
                  icon: Icons.payment_outlined,
                  title: "Payment Method",
                  onTap: () => context.push(AppRoutes.paymentMethod),
                ),
                _buildSettingsTile(
                  icon: Icons.lock_outline,
                  title: "Change Password",
                  onTap: () {}, // Implement logic or route
                ),
                _buildSettingsTile(
                  icon: Icons.workspace_premium_outlined,
                  title: "Subscription Plan",
                  onTap: () {},
                ),
                _buildSettingsTile(
                  icon: Icons.balance_outlined,
                  title: "Credits Balance",
                  onTap: () => context.push(AppRoutes.points),
                ),
                _buildSettingsTile(
                  icon: Icons.block_outlined,
                  title: "Block List",
                  onTap: () {},
                ),
                SizedBox(height: 24.h),
                _buildSectionHeader("Preferences"),
                _buildNotificationTile(),
                SizedBox(height: 24.h),
                _buildSectionHeader("Support"),
                _buildSettingsTile(
                  icon: Icons.help_outline,
                  title: "Help & Support",
                  onTap: () {},
                ),
                _buildSettingsTile(
                  icon: Icons.logout,
                  title: context.watchTr('sign_out'),
                  isLogout: true,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => const Logout(),
                    );
                  },
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
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

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(13),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          color: isLogout ? Colors.redAccent : Colors.white.withAlpha(179),
          size: 22.r,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isLogout ? Colors.redAccent : Colors.white.withAlpha(204),
            fontSize: 14.sp,
          ),
        ),
        trailing: isLogout
            ? null
            : Icon(
                Icons.arrow_forward_ios,
                color: Colors.white.withAlpha(128),
                size: 16.r,
              ),
      ),
    );
  }

  Widget _buildNotificationTile() {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(13),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListTile(
        leading: Icon(
          Icons.notifications_none_outlined,
          color: Colors.white.withAlpha(179),
          size: 22.r,
        ),
        title: Text(
          "Notifications",
          style: TextStyle(
            color: Colors.white.withAlpha(204),
            fontSize: 14.sp,
          ),
        ),
        trailing: Transform.scale(
          scale: 0.8,
          child: Switch(
            value: _notificationsEnabled,
            onChanged: (val) => setState(() => _notificationsEnabled = val),
            activeColor: const Color(0xFFC19E5F),
            activeTrackColor: const Color(0xFFC19E5F).withAlpha(102),
            inactiveThumbColor: Colors.white.withAlpha(128),
            inactiveTrackColor: Colors.white.withAlpha(26),
          ),
        ),
      ),
    );
  }
}
