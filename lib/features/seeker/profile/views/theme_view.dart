import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../shared/localization/controllers/localization_controller.dart';
import '../../../shared/theme/controllers/theme_controller.dart';
import '../../../shared/localization/localization_extension.dart';

class ThemeView extends StatelessWidget {
  const ThemeView({super.key});

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
              builder: (context, themeCtrl, _) {
                final isDark = themeCtrl.isDarkMode(context);
                final isSystem = themeCtrl.themeMode == ThemeMode.system;

                return Column(
                  children: [
                    _settingsTile(
                      context,
                      title: context.watchTr('dark_mode'),
                      subtitle: isDark
                          ? context.watchTr('on')
                          : context.watchTr('off'),
                      trailing: Switch.adaptive(
                        value: isDark,
                        onChanged: isSystem
                            ? null // Disable manual toggle if following system
                            : (value) => themeCtrl.toggleTheme(context),
                        activeThumbColor: Theme.of(context).colorScheme.primary,
                      ),
                      onTap: isSystem
                          ? null
                          : () => themeCtrl.toggleTheme(context),
                    ),
                    SizedBox(height: 12.h),
                    _settingsTile(
                      context,
                      title: 'Use Device Theme',
                      subtitle: 'Automatically switch based on device settings',
                      trailing: Checkbox(
                        value: isSystem,
                        onChanged: (value) {
                          if (value == true) {
                            themeCtrl.setThemeMode(ThemeMode.system);
                          } else {
                            // If turning off system, set to current effective brightness
                            themeCtrl.setThemeMode(
                              isDark ? ThemeMode.dark : ThemeMode.light,
                            );
                          }
                        },
                        activeColor: Theme.of(context).colorScheme.primary,
                      ),
                      onTap: () {
                        if (isSystem) {
                          themeCtrl.setThemeMode(
                            isDark ? ThemeMode.dark : ThemeMode.light,
                          );
                        } else {
                          themeCtrl.setThemeMode(ThemeMode.system);
                        }
                      },
                    ),
                  ],
                );
              },
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
    required VoidCallback? onTap,
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
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(
              context,
            ).textTheme.bodySmall?.color?.withAlpha(153),
          ),
        ),
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
            ? Theme.of(context).colorScheme.primary.withAlpha(26)
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
