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
void showSuccessSnackBar({
  String? title,
  required String message,
  Duration? duration,
}) => showAppSnackBar(
  title: title ?? 'Success',
  message: message,
  type: SnackBarType.success,
  duration: duration,
);

void showErrorSnackBar({
  String? title,
  required String message,
  Duration? duration,
}) => showAppSnackBar(
  title: title ?? 'Error',
  message: message,
  type: SnackBarType.error,
  duration: duration,
);

void showWarningSnackBar({
  String? title,
  required String message,
  Duration? duration,
}) => showAppSnackBar(
  title: title ?? 'Warning',
  message: message,
  type: SnackBarType.warning,
  duration: duration,
);

void showInfoSnackBar({
  required String title,
  required String message,
  Duration? duration,
}) => showAppSnackBar(
  title: title,
  message: message,
  type: SnackBarType.info,
  duration: duration,
);

// ── Overlay widget ────────────────────────────────────────────────────────────
class _SnackBarState {
  final ValueNotifier<double> slideTarget;
  final ValueNotifier<double> pulseTarget;
  bool isExiting;
  bool isDelayStarted;

  _SnackBarState()
      : slideTarget = ValueNotifier<double>(1.5),
        pulseTarget = ValueNotifier<double>(1.25),
        isExiting = false,
        isDelayStarted = false;
}

class _SnackBarOverlay extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return FormField<_SnackBarState>(
      initialValue: _SnackBarState(),
      builder: (fieldState) {
        final state = fieldState.value!;

        // Trigger the slide entrance animation post-frame
        if (state.slideTarget.value == 1.5 && !state.isExiting && !state.isDelayStarted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            state.slideTarget.value = 0.0;
          });
        }

        // Start the duration delay timer to exit
        if (!state.isDelayStarted) {
          state.isDelayStarted = true;
          Future.delayed(config.duration + const Duration(milliseconds: 600), () {
            state.isExiting = true;
            state.slideTarget.value = 1.5;
          });
        }

        return Positioned(
          top: 60.h,
          right: 16.w,
          left: 16.w,
          child: ValueListenableBuilder<double>(
            valueListenable: state.slideTarget,
            builder: (context, slideVal, _) {
              return TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: state.isExiting ? 0.0 : 1.5, end: slideVal),
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutBack,
                onEnd: () {
                  if (state.isExiting && slideVal == 1.5) {
                    onDismiss();
                  }
                },
                builder: (context, val, child) {
                  return Transform.translate(
                    offset: Offset(val * MediaQuery.of(context).size.width, 0),
                    child: child,
                  );
                },
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
                          colors: [
                            config.backgroundColor,
                            config.accentColor,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: [
                              config.backgroundColor,
                              config.accentColor,
                            ].first.withValues(alpha: 0.3),
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
                                  ValueListenableBuilder<double>(
                                    valueListenable: state.pulseTarget,
                                    builder: (context, pulseVal, child) {
                                      return TweenAnimationBuilder<double>(
                                        tween: Tween<double>(begin: pulseVal == 1.25 ? 1.0 : 1.25, end: pulseVal),
                                        duration: const Duration(milliseconds: 800),
                                        onEnd: () {
                                          state.pulseTarget.value = pulseVal == 1.25 ? 1.0 : 1.25;
                                        },
                                        builder: (context, scale, child) {
                                          return Transform.scale(
                                            scale: scale,
                                            child: child,
                                          );
                                        },
                                        child: child,
                                      );
                                    },
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
                                        config.icon,
                                        color: config.textColor,
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
                                          title,
                                          style: TextStyle(
                                            color: config.textColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.sp,
                                            letterSpacing: 0.5,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          message,
                                          style: TextStyle(
                                            color: config.textColor.withValues(
                                              alpha: 0.9,
                                            ),
                                            fontSize: 12.sp,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      if (!state.isExiting) {
                                        state.isExiting = true;
                                        state.slideTarget.value = 1.5;
                                      }
                                    },
                                    icon: Icon(
                                      Icons.close_rounded,
                                      color: config.textColor.withValues(
                                        alpha: 0.8,
                                      ),
                                      size: 22.w,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ),
                            ),
                            // Futuristic Progress Bar
                            if (!state.isExiting)
                              TweenAnimationBuilder<double>(
                                tween: Tween<double>(begin: 1.0, end: 0.0),
                                duration: config.duration,
                                builder: (context, progressVal, _) {
                                  return LinearProgressIndicator(
                                    value: progressVal, // Shrinks as time passes
                                    minHeight: 5.h,
                                    backgroundColor: Colors.black.withValues(alpha: 0.1),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      config.textColor.withValues(alpha: 0.5),
                                    ),
                                  );
                                },
                              )
                            else
                              SizedBox(height: 5.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
