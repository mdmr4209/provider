import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../res/colors/app_color.dart';


// ─────────────────────────────────────────────────────────────────────────────
// Public API — same function signatures as before so all call-sites compile.
// GetX (Get.rawSnackbar) replaced with a Flutter OverlayEntry approach so the
// snack-bar works without GetMaterialApp.
// ─────────────────────────────────────────────────────────────────────────────

enum SnackBarType { success, error, warning, info }

class SnackBarConfig {
  final Color backgroundColor;
  final Color textColor;
  final Color accentColor;
  final IconData icon;
  final Duration duration;

  const SnackBarConfig({
    required this.backgroundColor,
    required this.textColor,
    required this.accentColor,
    required this.icon,
    required this.duration,
  });

  factory SnackBarConfig.fromType(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return SnackBarConfig(
          backgroundColor: AppColor.defaultColor,
          textColor: AppColor.textWhiteColor,
          accentColor: AppColor.defaultColor.withValues(alpha: 0.8),
          icon: Icons.check_circle_outline,
          duration: const Duration(seconds: 2),
        );
      case SnackBarType.error:
        return SnackBarConfig(
          backgroundColor: AppColor.redColor,
          textColor: AppColor.textWhiteColor,
          accentColor: AppColor.redAlphaColor,
          icon: Icons.error_outline,
          duration: const Duration(seconds: 3),
        );
      case SnackBarType.warning:
        return SnackBarConfig(
          backgroundColor: AppColor.warningColor,
          textColor: AppColor.textWhiteColor,
          accentColor: AppColor.warningColor.withValues(alpha: 0.8),
          icon: Icons.warning,
          duration: const Duration(seconds: 2),
        );
      case SnackBarType.info:
        return SnackBarConfig(
          backgroundColor: AppColor.defaultColor,
          textColor: AppColor.textWhiteColor,
          accentColor: AppColor.defaultColor.withValues(alpha: 0.8),
          icon: Icons.info_outline,
          duration: const Duration(seconds: 2),
        );
    }
  }
}

// ── Internal constants ─────────────────────────────────────────────────────
class _C {
  static const double hPad = 16;
  static const double vPad = 12;
  static const double iconRightPad = 12;
  static const double iconSize = 20;
  static const double titleFontSize = 16;
  static const double msgFontSize = 14;
  static const double borderRadius = 12;
  static const double shadowBlur = 8;
  static const double shadowOffsetY = 4;
  static const double margin = 16;
  static const double msgAlpha = 0.9;
  static const Duration animIn = Duration(milliseconds: 300);
}

// ── Queue — same singleton behaviour as before ─────────────────────────────
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

// ── Navigator key — set this in your MaterialApp ──────────────────────────
//
//   final navigatorKey = GlobalKey<NavigatorState>();
//   AppSnackBar.navigatorKey = navigatorKey;   // once, in main()
//   MaterialApp(navigatorKey: navigatorKey, ...)
//
class AppSnackBar {
  static GlobalKey<NavigatorState>? navigatorKey;

  static OverlayState? get _overlay =>
      navigatorKey?.currentState?.overlay ??
      // fallback: walk the widget tree (works when navigatorKey is not set)
      WidgetsBinding.instance.rootElement
          ?.findAncestorStateOfType<NavigatorState>()
          ?.overlay;
}

// ── Core show function ─────────────────────────────────────────────────────
// ignore: non_constant_identifier_names
void CustomSnackBar({
  required String title,
  required String message,
  SnackBarType type = SnackBarType.success,
  Color? backgroundColor,
  Color? textColor,
  Duration? duration,
}) {
  final config = (backgroundColor != null || textColor != null)
      ? _createCustomConfig(type, backgroundColor, textColor, duration)
      : SnackBarConfig.fromType(type);

  _SnackBarQueue().enqueue(() => _showOverlay(title, message, config));
}

void _showOverlay(String title, String message, SnackBarConfig config) {
  final overlay = AppSnackBar._overlay;
  if (overlay == null) {
    debugPrint('[CustomSnackBar] No overlay found — set AppSnackBar.navigatorKey');
    return;
  }

  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => _SnackBarOverlay(
      title: title,
      message: message,
      config: config,
      onDismiss: () => entry.remove(),
    ),
  );
  overlay.insert(entry);
}

SnackBarConfig _createCustomConfig(
  SnackBarType type,
  Color? customBackground,
  Color? customText,
  Duration? customDuration,
) {
  final base = SnackBarConfig.fromType(type);
  return SnackBarConfig(
    backgroundColor: customBackground ?? base.backgroundColor,
    textColor: customText ?? base.textColor,
    accentColor:
        customBackground?.withValues(alpha: 0.8) ?? base.accentColor,
    icon: base.icon,
    duration: customDuration ?? base.duration,
  );
}

// ── Animated overlay widget ────────────────────────────────────────────────
class _SnackBarOverlay extends StatefulWidget {
  final String title;
  final String message;
  final SnackBarConfig config;
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
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: _C.animIn);
    _slide = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);

    _ctrl.forward();

    Future.delayed(widget.config.duration, () async {
      if (mounted) {
        await _ctrl.reverse();
        widget.onDismiss();
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
      top: MediaQuery.of(context).padding.top + _C.margin,
      left: _C.margin,
      right: _C.margin,
      child: SlideTransition(
        position: _slide,
        child: FadeTransition(
          opacity: _fade,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () async {
                if (mounted) {
                  await _ctrl.reverse();
                  widget.onDismiss();
                }
              },
              child: _buildContent(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final cfg = widget.config;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _C.hPad.w,
        vertical: _C.vPad.h,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cfg.backgroundColor, cfg.accentColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(_C.borderRadius.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.black20Color,
            blurRadius: _C.shadowBlur.r,
            offset: Offset(0, _C.shadowOffsetY.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: _C.iconRightPad.w),
            child: Icon(cfg.icon, color: cfg.textColor, size: _C.iconSize.w),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    color: cfg.textColor,
                    fontSize: _C.titleFontSize.sp,
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
                    color: cfg.textColor.withValues(alpha: _C.msgAlpha),
                    fontSize: _C.msgFontSize.sp,
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
    );
  }
}

// ── Convenience helpers (unchanged signatures) ─────────────────────────────
void showSuccessSnackBar({
  String? title,
  required String message,
  Duration? duration,
}) =>
    CustomSnackBar(
      title: title ?? 'Success',
      message: message,
      type: SnackBarType.success,
      duration: duration,
    );

void showErrorSnackBar({
  String? title,
  required String message,
  Duration? duration,
}) =>
    CustomSnackBar(
      title: title ?? 'Error',
      message: message,
      type: SnackBarType.error,
      duration: duration,
    );

void showWarningSnackBar({
  String? title,
  required String message,
  Duration? duration,
}) =>
    CustomSnackBar(
      title: title ?? 'Warning',
      message: message,
      type: SnackBarType.warning,
      duration: duration,
    );

void showInfoSnackBar({
  required String title,
  required String message,
  Duration? duration,
}) =>
    CustomSnackBar(
      title: title,
      message: message,
      type: SnackBarType.info,
      duration: duration,
    );
