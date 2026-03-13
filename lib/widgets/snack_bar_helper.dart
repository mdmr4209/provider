import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../res/colors/app_color.dart';

// ── Public entry point ────────────────────────────────────────────────────────
/// Set this in main.dart:
///   SnackBarHelper.navigatorKey = navigatorKey;
class SnackBarHelper {
  static GlobalKey<NavigatorState>? navigatorKey;

  static BuildContext? get _context {
    if (navigatorKey == null) {
      debugPrint('SnackBarHelper: navigatorKey is not set yet');
      return null;
    }
    return navigatorKey?.currentState?.overlay?.context;
  }
}

// ── Types ──────────────────────────────────────────────────────────────────────
enum SnackBarType { success, error, warning, info }

class _SnackBarConfig {
  final Color backgroundColor;
  final Color accentColor;
  final Color textColor;
  final IconData icon;
  final Duration duration;

  const _SnackBarConfig({
    required this.backgroundColor,
    required this.accentColor,
    required this.textColor,
    required this.icon,
    required this.duration,
  });

  factory _SnackBarConfig.fromType(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return _SnackBarConfig(
          backgroundColor: AppColor.defaultColor,
          accentColor: AppColor.defaultColor.withValues(alpha: 0.8),
          textColor: AppColor.textWhiteColor,
          icon: Icons.check_circle_outline,
          duration: const Duration(seconds: 2),
        );
      case SnackBarType.error:
        return _SnackBarConfig(
          backgroundColor: AppColor.redColor,
          accentColor: AppColor.redAlphaColor,
          textColor: AppColor.textWhiteColor,
          icon: Icons.error_outline,
          duration: const Duration(seconds: 3),
        );
      case SnackBarType.warning:
        return _SnackBarConfig(
          backgroundColor: AppColor.warningColor,
          accentColor: AppColor.warningColor.withValues(alpha: 0.8),
          textColor: AppColor.textWhiteColor,
          icon: Icons.warning,
          duration: const Duration(seconds: 2),
        );
      case SnackBarType.info:
        return _SnackBarConfig(
          backgroundColor: AppColor.defaultColor,
          accentColor: AppColor.defaultColor.withValues(alpha: 0.8),
          textColor: AppColor.textWhiteColor,
          icon: Icons.info_outline,
          duration: const Duration(seconds: 2),
        );
    }
  }
}

// ── Queue (no GetX) ───────────────────────────────────────────────────────────
class _SnackBarQueue {
  static final _SnackBarQueue _instance = _SnackBarQueue._internal();
  factory _SnackBarQueue() => _instance;
  _SnackBarQueue._internal();

  bool _isShowing = false;
  final List<VoidCallback> _queue = [];

  Future<void> enqueue(VoidCallback show) async {
    _queue.add(show);
    if (!_isShowing) await _processQueue();
  }

  Future<void> _processQueue() async {
    while (_queue.isNotEmpty) {
      _isShowing = true;
      _queue.removeAt(0)();
      await Future.delayed(const Duration(milliseconds: 2500));
    }
    _isShowing = false;
  }
}

// ── Core show function ────────────────────────────────────────────────────────
void showAppSnackBar({
  required String title,
  required String message,
  SnackBarType type = SnackBarType.success,
  Color? backgroundColor,
  Color? textColor,
  Duration? duration,
}) {
  final context = SnackBarHelper._context;
  if (context == null) {
    debugPrint('SnackBarHelper: no context available – $title: $message');
    return;
  }

  final base = _SnackBarConfig.fromType(type);
  final cfg = _SnackBarConfig(
    backgroundColor: backgroundColor ?? base.backgroundColor,
    accentColor: (backgroundColor ?? base.backgroundColor).withValues(alpha: 0.8),
    textColor: textColor ?? base.textColor,
    icon: base.icon,
    duration: duration ?? base.duration,
  );

  _SnackBarQueue().enqueue(() {
    final overlay = SnackBarHelper.navigatorKey?.currentState?.overlay;
    if (overlay == null) return;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _SnackBarOverlay(
        title: title,
        message: message,
        config: cfg,
        onDismiss: () => entry.remove(),
      ),
    );
    overlay.insert(entry);
    Future.delayed(cfg.duration + const Duration(milliseconds: 300),
            () {
          if (entry.mounted) entry.remove();
        });
  });
}

// ── Convenience helpers ───────────────────────────────────────────────────────
void showSuccessSnackBar({String? title, required String message, Duration? duration}) =>
    showAppSnackBar(title: title ?? 'Success', message: message, type: SnackBarType.success, duration: duration);

void showErrorSnackBar({String? title, required String message, Duration? duration}) =>
    showAppSnackBar(title: title ?? 'Error', message: message, type: SnackBarType.error, duration: duration);

void showWarningSnackBar({String? title, required String message, Duration? duration}) =>
    showAppSnackBar(title: title ?? 'Warning', message: message, type: SnackBarType.warning, duration: duration);

void showInfoSnackBar({required String title, required String message, Duration? duration}) =>
    showAppSnackBar(title: title, message: message, type: SnackBarType.info, duration: duration);

// ── Overlay widget ────────────────────────────────────────────────────────────
class _SnackBarOverlay extends StatefulWidget {
  final String title;
  final String message;
  final _SnackBarConfig config;
  final VoidCallback onDismiss;

  const _SnackBarOverlay({
    required this.title,
    required this.message,
    required this.config,
    required this.onDismiss,
  });

  @override
  State<_SnackBarOverlay> createState() => _SnackBarOverlayState();
}

class _SnackBarOverlayState extends State<_SnackBarOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _slide = Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();

    Future.delayed(widget.config.duration, () {
      if (mounted) {
        _ctrl.reverse().then((_) => widget.onDismiss());
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 48.h,
      left: 16.w,
      right: 16.w,
      child: SlideTransition(
        position: _slide,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  widget.config.backgroundColor,
                  widget.config.accentColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 8.r,
                  offset: Offset(0, 4.h),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(widget.config.icon,
                    color: widget.config.textColor, size: 20.w),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          color: widget.config.textColor,
                          fontSize: 16.sp,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        widget.message,
                        style: TextStyle(
                          color: widget.config.textColor
                              .withValues(alpha: 0.9),
                          fontSize: 14.sp,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
