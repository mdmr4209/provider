import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../../../res/colors/app_color.dart';
import '../../../../widgets/custom_button.dart';
import '../../../routes/app_router.dart';
import '../providers/auth_provider.dart';

class OtpVerifyView extends StatefulWidget {
  final String? origin;
  const OtpVerifyView({super.key, this.origin});

  @override
  State<OtpVerifyView> createState() => _OtpVerifyViewState();
}

class _OtpVerifyViewState extends State<OtpVerifyView> {
  int    _secondsRemaining = 60;
  String _formattedTime    = '01:00';
  Timer? _timer;

  final FocusNode            _pinFocusNode  = FocusNode();
  final TextEditingController _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _pinFocusNode.unfocus();
    Future.microtask(() {
      _timer?.cancel();
      _pinFocusNode.dispose();
      _otpController.dispose();
    });
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _secondsRemaining = 60;
      _formattedTime    = '01:00';
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
          final m = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
          final s = (_secondsRemaining % 60).toString().padLeft(2, '0');
          _formattedTime = '$m:$s';
        });
      } else {
        t.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back, color: AppColor.textColor),
        ),
        title: Text(
          'Verification',
          style: TextStyle(
            color: AppColor.textColor,
            fontSize: 20.sp,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, auth, _) => SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Column(
                  children: [
                    SizedBox(height: 50.h),
                    Text(
                      'We have sent you an activation code.',
                      style: TextStyle(
                        color: AppColor.textColor,
                        fontSize: 16.sp,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.80,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'An SMS has been sent to ${auth.signupEmail} containing a code to activate your account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF666666),
                        fontSize: 12.sp,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.60,
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Text(
                      'Enter verification code',
                      style: TextStyle(
                        color: AppColor.textColor,
                        fontSize: 14.sp,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.70,
                      ),
                    ),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: SizedBox(
                  height: 53.h,
                  width: double.infinity,
                  child: PinCodeTextField(
                    appContext: context,
                    length: 6,
                    textStyle: TextStyle(fontSize: 18.sp),
                    animationType: AnimationType.fade,
                    cursorColor: AppColor.textColor,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.circle,
                      fieldHeight: 48.5.h,
                      fieldWidth: 48.5.w,
                      activeColor: AppColor.defaultColor,
                      selectedColor: AppColor.textColor,
                      inactiveColor: AppColor.inactiveTrack,
                    ),
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: false,
                    keyboardType: TextInputType.number,
                    controller: _otpController,
                    focusNode: _pinFocusNode,
                    onChanged: (v) { auth.otpController.text = v; },
                    onCompleted: auth.updateOtp,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Column(
                  children: [
                    SizedBox(height: 15.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn't receive a code? ",
                          style: TextStyle(
                            color: AppColor.textColor,
                            fontSize: 15.sp,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.60,
                          ),
                        ),
                        InkWell(
                          onTap: _secondsRemaining == 0 ? _startTimer : null,
                          child: Text(
                            'Resend',
                            style: TextStyle(
                              color: _secondsRemaining == 0
                                  ? AppColor.defaultColor
                                  : AppColor.textColor,
                              fontWeight: _secondsRemaining == 0
                                  ? FontWeight.bold
                                  : FontWeight.w600,
                              fontSize: 14.sp,
                              fontFamily: 'DM Sans',
                              letterSpacing: 0.60,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      'Resend available in $_formattedTime',
                      style: TextStyle(
                        color: AppColor.defaultColor,
                        fontSize: 15.sp,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.60,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 50.h),
                    CustomButton(
                      title: 'Continue',
                      buttonColor: auth.isOtpVerified
                          ? AppColor.defaultColor
                          : AppColor.subTitleColor,
                      borderColor: AppColor.borderareaColor,
                      textColor: AppColor.textWhiteColor,
                      onPress: () async {
                        if (auth.isOtpVerified) {
                          auth.otpController.text = _otpController.text;
                          await auth.verifyOtp(origin: widget.origin);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter a valid 6-digit OTP'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account?',
                            style: TextStyle(
                                fontSize: 18.sp, color: AppColor.textColor)),
                        InkWell(
                          onTap: () => context.go(AppRoutes.login),
                          child: Text(
                            ' Login',
                            style: TextStyle(
                              fontSize: 19.sp,
                              color: AppColor.defaultColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
