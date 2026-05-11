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
import '../controllers/auth_controller.dart';
import '../../localization/localization_extension.dart';
import '../../../routes/app_router.dart';

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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                      child: Icon(Icons.arrow_back_ios_new, color: Theme.of(context).iconTheme.color),
                    ),
                    Spacer(),
                    Text(
                      context.watchTr('otp_verification'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
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
                      Consumer<AuthController>(
                        builder: (context, auth, _) => ListView(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          children: [
                            SizedBox(height: 30.h),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.watchTr('enter_otp_msg'),
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  '${context.watchTr('sms_sent_msg')} ${widget.origin == 'forget' ? auth.forgetEmailController.text : auth.signupEmail} ${context.watchTr('containing_code_msg')}',
                                  style: Theme.of(context).textTheme.bodySmall,
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
                                cursorColor: Theme.of(context).colorScheme.primary,
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  fieldHeight: 50.h,
                                  fieldWidth: 50.w,
                                  activeColor: Theme.of(context).dividerColor,
                                  activeFillColor: Theme.of(context).cardTheme.color,
                                  selectedColor: Theme.of(context).colorScheme.primary,
                                  selectedFillColor: Theme.of(context).cardTheme.color,
                                  inactiveColor: Theme.of(context).dividerColor,
                                  inactiveFillColor: Theme.of(context).cardTheme.color,
                                  borderRadius: BorderRadius.circular(8.r),
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
                                        context.watchTr('did_not_receive_code'),
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                      InkWell(
                                        onTap: _secondsRemaining == 0
                                            ? _startTimer
                                            : null,
                                        child: Text(
                                          context.watchTr('resend'),
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: _secondsRemaining == 0
                                                ? Theme.of(context).colorScheme.primary
                                                : Theme.of(context).textTheme.bodySmall?.color,
                                            fontWeight: _secondsRemaining == 0
                                                ? FontWeight.bold
                                                : FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5.h),
                                  Text(
                                    '${context.watchTr('resend_available_in')} $_formattedTime',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 20.h),
                                  CustomButton(
                                    title: context.watchTr('verify_caps'),
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
                                              context.watchTr('enter_valid_otp'),
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
