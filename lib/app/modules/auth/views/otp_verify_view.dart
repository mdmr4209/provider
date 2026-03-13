import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../../../res/assets/image_assets.dart';
import '../../../../res/colors/app_color.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/snack_bar_helper.dart';
import '../../../routes/app_router.dart';
import '../providers/auth_provider.dart';

class OtpVerifyView extends StatefulWidget {
  final String? origin;
  const OtpVerifyView({super.key, this.origin});

  @override
  State<OtpVerifyView> createState() => _OtpVerifyViewState();
}

class _OtpVerifyViewState extends State<OtpVerifyView> {
  int _secondsRemaining = 60;
  String _formattedTime = '01:00';
  Timer? _timer;

  final FocusNode _pinFocusNode = FocusNode();
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
      _formattedTime = '01:00';
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColor.whiteColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back_ios_new),
                    ),
                    Spacer(),
                    Text(
                      'Forgot password',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.tenorSans(
                        color: AppColor.textColor,
                        fontSize: 18.w,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Spacer(),
                    SizedBox(width: 20.w),
                  ],
                ),
                SizedBox(height: 10.h),
                Container(
                  width: 335.w,
                  height: 331.h,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(ImageAssets.background2),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Consumer<AuthProvider>(
                        builder: (context, auth, _) => ListView(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          children: [
                            SizedBox(height: 30.h),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Enter your OTP code here.',
                                  style: GoogleFonts.lato(
                                    color: AppColor.textColor2,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                    height: 1.70,
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  'An SMS has been sent to ${widget.origin == 'forget' ? auth.forgetEmailController.text : auth.signupEmail} containing a code to activate your account',
                                  style: GoogleFonts.lato(
                                    color: AppColor.textColor2,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.60,
                                  ),
                                ),
                                SizedBox(height: 15.h),
                              ],
                            ),
                            SizedBox(
                              height: 53.h,
                              width: double.infinity,
                              child: PinCodeTextField(
                                appContext: context,
                                length: 5,
                                textStyle: TextStyle(fontSize: 18.sp),
                                animationType: AnimationType.fade,
                                cursorColor: AppColor.textColor,
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  fieldHeight: 50.h,
                                  fieldWidth: 50.w,
                                  activeColor: Colors.transparent,
                                  activeFillColor: Colors.transparent,
                                  selectedColor: AppColor.defaultColor,
                                  selectedFillColor: AppColor.whiteColor,
                                  inactiveColor: AppColor.whiteColor,
                                  inactiveFillColor: AppColor.whiteColor,
                                ),
                                animationDuration: const Duration(
                                  milliseconds: 300,
                                ),
                                enableActiveFill: true,
                                keyboardType: TextInputType.number,
                                controller: _otpController,
                                focusNode: _pinFocusNode,
                                onChanged: (v) {
                                  auth.otpController.text = v;
                                  auth.updateOtp(v);
                                },
                                onCompleted: auth.updateOtp,
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
                                        onTap: _secondsRemaining == 0
                                            ? _startTimer
                                            : null,
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
                                  SizedBox(height: 20.h),
                                  CustomButton(
                                    title: 'VERIFY',
                                    buttonColor: auth.isOtpVerified
                                        ? AppColor.buttonColor
                                        : AppColor.subTitleColor,
                                    borderColor: auth.isOtpVerified
                                        ? AppColor.buttonColor
                                        : AppColor.subTitleColor,
                                    textColor: AppColor.whiteColor,
                                    onPress: () async {
                                      if (auth.isOtpVerified) {
                                        auth.otpController.text =
                                            _otpController.text;
                                        // await auth.verifyOtp(
                                        //   origin: widget.origin,
                                        // );
                                        context.push(
                                          AppRoutes.changePass,
                                          extra: widget.origin,
                                        );
                                      } else {
                                        showWarningSnackBar(
                                          message:
                                              'Please enter a valid 6-digit OTP',
                                        );
                                      }
                                    },
                                  ),
                                  SizedBox(height: 10.h),
                                ],
                              ),
                            ),
                          ],
                        ),
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
