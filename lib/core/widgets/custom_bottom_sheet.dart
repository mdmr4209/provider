import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';

class CustomBottomSheet extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final bool showHandle;

  const CustomBottomSheet({
    super.key,
    required this.title,
    required this.children,
    this.showHandle = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bsTheme = theme.bottomSheetTheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 32.h),
      decoration: BoxDecoration(
        color: bsTheme.backgroundColor,
        borderRadius: (bsTheme.shape as RoundedRectangleBorder).borderRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showHandle) ...[
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: theme.dividerColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 24.h),
          ],
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontFamily: 'Georgia',
            ),
          ),
          SizedBox(height: 24.h),
          ...children,
        ],
      ),
    );
  }
}

class BottomSheetAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? color;

  const BottomSheetAction({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      leading: Icon(icon, color: color ?? theme.iconTheme.color),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: color,
        ),
      ),
      contentPadding: EdgeInsets.zero,
    );
  }
}

void showAppBottomSheet(
  BuildContext context, {
  required String title,
  required List<Widget> children,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => CustomBottomSheet(
      title: title,
      children: children,
    ),
  );
}
