import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../localization/controllers/localization_controller.dart';
import '../../theme/controllers/theme_controller.dart';
import '../../localization/localization_extension.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          context.watchTr('settings'),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(20.w),
          children: [
            _sectionHeader(context, context.watchTr('appearance')),
            Consumer<ThemeController>(
              builder: (context, themeCtrl, _) => _settingsTile(
                context,
                title: context.watchTr('dark_mode'),
                subtitle: themeCtrl.isDarkMode
                    ? context.watchTr('on')
                    : context.watchTr('off'),
                trailing: Switch.adaptive(
                  value: themeCtrl.isDarkMode,
                  onChanged: (value) => themeCtrl.toggleTheme(),
                  activeThumbColor: Theme.of(context).colorScheme.primary,
                ),
                onTap: () => themeCtrl.toggleTheme(),
              ),
            ),
            SizedBox(height: 20.h),
            _sectionHeader(context, context.watchTr('language')),
            Consumer<LocalizationController>(
              builder: (context, locCtrl, _) => Column(
                children: [
                  _languageTile(
                    context,
                    title: 'English',
                    isSelected: locCtrl.locale.languageCode == 'en',
                    onTap: () => locCtrl.setLocale(const Locale('en', 'US')),
                  ),
                  _languageTile(
                    context,
                    title: 'العربية',
                    isSelected: locCtrl.locale.languageCode == 'ar',
                    onTap: () => locCtrl.setLocale(const Locale('ar', 'AE')),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h, left: 4.w),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _settingsTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required Widget trailing,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
        subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
        trailing: trailing,
      ),
    );
  }

  Widget _languageTile(
    BuildContext context, {
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).colorScheme.primary.withAlpha(20)
            : Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).dividerColor,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: isSelected
            ? Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              )
            : null,
      ),
    );
  }
}
