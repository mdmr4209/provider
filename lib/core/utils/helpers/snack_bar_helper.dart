import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_colors.dart';

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
          backgroundColor: AppColors.greenColor,
          accentColor: AppColors.greenColor.withValues(alpha: 0.4),
          textColor: AppColors.textWhiteColor,
          icon: Icons.check_circle_outline,
          duration: const Duration(seconds: 3),
        );
      case SnackBarType.error:
        return _SnackBarConfig(
          backgroundColor: AppColors.redColor,
          accentColor: AppColors.redColor.withValues(alpha: 0.4),
          textColor: AppColors.textWhiteColor,
          icon: Icons.error_outline,
          duration: const Duration(seconds: 4),
        );
      case SnackBarType.warning:
        return _SnackBarConfig(
          backgroundColor: AppColors.warningColor,
          accentColor: AppColors.warningColor.withValues(alpha: 0.4),
          textColor: AppColors.textWhiteColor,
          icon: Icons.warning_amber_rounded,
          duration: const Duration(seconds: 3),
        );
      case SnackBarType.info:
        return _SnackBarConfig(
          backgroundColor: AppColors.seeAllColor,
          accentColor: AppColors.seeAllColor.withValues(alpha: 0.4),
          textColor: AppColors.textWhiteColor,
          icon: Icons.info_outline,
          duration: const Duration(seconds: 3),
        );
    }
  }
}

// ── Queue Management ─────────────────────────────────────────────────────────
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
      // Wait for duration + buffer for entrance and exit animations
      await Future.delayed(const Duration(milliseconds: 5000));
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
Color? accentColor,
  Color? textColor,
  Duration? duration,
}) {
  final context = SnackBarHelper._context;
  if (context == null) return;

  final base = _SnackBarConfig.fromType(type);
  final cfg = _SnackBarConfig(
    backgroundColor: backgroundColor ?? base.backgroundColor,
    accentColor: accentColor ?? base.accentColor,
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
        onDismiss: () {
          if (entry.mounted) entry.remove();
        },
      ),
    );
    overlay.insert(entry);
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
    with TickerProviderStateMixin {
  late final AnimationController _slideCtrl;
  late final AnimationController _progressCtrl;
  late final AnimationController _iconPulseCtrl;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _iconScaleAnim;
  bool _isExiting = false;

  @override
  void initState() {
    super.initState();
    
    // Entrance/Exit Animation (Right to Left)
    _slideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(1.5, 0), // Start off-screen right
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutBack));

    // Progress Bar Animation (Timer)
    _progressCtrl = AnimationController(
      vsync: this,
      duration: widget.config.duration,
    );

    // Icon Pulse Animation (Size Increase/Decrease)
    _iconPulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _iconScaleAnim = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _iconPulseCtrl, curve: Curves.easeInOut),
    );

    _slideCtrl.forward().then((_) {
      if (mounted) {
        _progressCtrl.forward().then((_) => _handleExit());
      }
    });
  }

  void _handleExit() {
    if (_isExiting) return;
    _isExiting = true;
    _slideCtrl.reverse().then((_) => widget.onDismiss());
  }

  @override
  void dispose() {
    _slideCtrl.dispose();
    _progressCtrl.dispose();
    _iconPulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 60.h,
      right: 16.w,
      left: 16.w,
      child: SlideTransition(
        position: _slideAnim,
        child: Align(
          alignment: Alignment.topRight,
          child: Material(
            color: Colors.transparent,
            child: Container(
              constraints: BoxConstraints(maxWidth: 0.9.sw),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [widget.config.backgroundColor, widget.config.accentColor],
                ),
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: [widget.config.backgroundColor, widget.config.accentColor].first.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 14.h, 8.w, 14.h),
                      child: Row(
                        children: [
                          // Pulse Icon Animation
                          ScaleTransition(
                            scale: _iconScaleAnim,
                            child: Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withValues(alpha: 0.1),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Icon(
                                widget.config.icon,
                                color: widget.config.textColor,
                                size: 24.w,
                              ),
                            ),
                          ),
                          SizedBox(width: 14.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.title,
                                  style: TextStyle(
                                    color: widget.config.textColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                    letterSpacing: 0.5,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  widget.message,
                                  style: TextStyle(
                                    color: widget.config.textColor.withValues(alpha: 0.9),
                                    fontSize: 12.sp,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: _handleExit,
                            icon: Icon(Icons.close_rounded,
                                color: widget.config.textColor.withValues(alpha: 0.8),
                                size: 22.w),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ),
                    // Futuristic Progress Bar
                    AnimatedBuilder(
                      animation: _progressCtrl,
                      builder: (context, child) {
                        return LinearProgressIndicator(
                          value: 1.0 - _progressCtrl.value, // Shrinks as time passes
                          minHeight: 5.h,
                          backgroundColor: Colors.black.withValues(alpha: 0.1),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            widget.config.textColor.withValues(alpha: 0.5),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
