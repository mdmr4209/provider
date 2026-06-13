import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';

class CallController extends ChangeNotifier {
  final String rate;
  Timer? _timer;
  int _secondsElapsed = 0;
  double _rateValue = 0.0;
  double _totalCharge = 20.0;

  bool _isVideoActive = true;
  bool _isSpeakerOn = false;
  bool _isMuted = false;

  int get secondsElapsed => _secondsElapsed;
  double get totalCharge => _totalCharge;
  bool get isVideoActive => _isVideoActive;
  bool get isSpeakerOn => _isSpeakerOn;
  bool get isMuted => _isMuted;

  CallController({required this.rate}) {
    final rateStr = rate.replaceAll(RegExp(r'[^0-9.]'), '');
    _rateValue = double.tryParse(rateStr) ?? 0.0;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _secondsElapsed++;
      _totalCharge = 20.0 + (_rateValue * (_secondsElapsed / 60.0));
      notifyListeners();
    });
  }

  void toggleVideo() {
    _isVideoActive = !_isVideoActive;
    notifyListeners();
  }

  void toggleSpeaker() {
    _isSpeakerOn = !_isSpeakerOn;
    notifyListeners();
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class CallView extends StatelessWidget {
  final String name;
  final String avatar;
  final String rate;

  const CallView({
    super.key,
    required this.name,
    required this.avatar,
    required this.rate,
  });

  String _formatDuration(int totalSeconds) {
    final int hours = totalSeconds ~/ 3600;
    final int minutes = (totalSeconds % 3600) ~/ 60;
    final int seconds = totalSeconds % 60;

    final String hoursStr = hours.toString().padLeft(2, '0');
    final String minutesStr = minutes.toString().padLeft(2, '0');
    final String secondsStr = seconds.toString().padLeft(2, '0');

    return "$hoursStr:$minutesStr:$secondsStr";
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CallController>(
      create: (_) => CallController(rate: rate),
      child: Consumer<CallController>(
        builder: (context, controller, _) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // Profile Picture with green ring
                  Center(
                    child: SizedBox(
                      width: 311.r,
                      height: 311.r,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            AppAssets.circleBg,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.contain,
                          ),

                          Container(
                            width: 102.r,
                            height: 102.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF438A3F),
                                width: 3.r,
                              ),
                            ),
                            padding: EdgeInsets.all(4.r),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(avatar),
                              backgroundColor: Colors.white.withAlpha(26),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Name
                  Text(
                    name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Status
                  Text(
                    "Calling...",
                    style: TextStyle(
                      color: Colors.white.withAlpha(153),
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Rate
                  Text(
                    rate,
                    style: TextStyle(
                      color: Colors.white.withAlpha(102),
                      fontSize: 14.sp,
                    ),
                  ),

                  const Spacer(flex: 3),

                  // Call Timer & Charges
                  Text(
                    _formatDuration(controller.secondsElapsed),
                    style: TextStyle(
                      color: Colors.white.withAlpha(102),
                      fontSize: 15.sp,
                      fontFamily: 'monospace',
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Total Charge: ${controller.totalCharge.toStringAsFixed(0)}\$",
                    style: TextStyle(
                      color: Colors.white.withAlpha(153),
                      fontSize: 15.sp,
                    ),
                  ),

                  SizedBox(height: 32.h),

                  // Control Actions Row
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Video toggle
                        _buildControlButton(
                          icon: controller.isVideoActive
                              ? Icons.videocam_outlined
                              : Icons.videocam_off_outlined,
                          isActive: controller.isVideoActive,
                          onTap: controller.toggleVideo,
                        ),

                        // Speaker toggle
                        _buildControlButton(
                          icon: controller.isSpeakerOn
                              ? Icons.volume_up_outlined
                              : Icons.volume_down_outlined,
                          isActive: controller.isSpeakerOn,
                          onTap: controller.toggleSpeaker,
                        ),

                        // Mic toggle
                        _buildControlButton(
                          icon: controller.isMuted
                              ? Icons.mic_off_outlined
                              : Icons.mic_none_outlined,
                          isActive: controller.isMuted,
                          onTap: controller.toggleMute,
                        ),

                        // End call button (red circular button)
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 50.r,
                            height: 50.r,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE55656),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.call_end,
                              color: Colors.white,
                              size: 22.r,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 40.h),
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50.r,
        height: 50.r,
        decoration: BoxDecoration(
          color: isActive
              ? Colors.white.withAlpha(51)
              : Colors.white.withAlpha(13),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withAlpha(26), width: 1.r),
        ),
        child: Icon(icon, color: Colors.white, size: 22.r),
      ),
    );
  }
}
