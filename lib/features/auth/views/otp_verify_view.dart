import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/helpers/snack_bar_helper.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/background_widget.dart';
import '../../localization/localization_extension.dart';
import '../controllers/auth_controller.dart';

class OtpVerifyView extends StatelessWidget {
  final String? origin;
  const OtpVerifyView({super.key, this.origin});

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    return ChangeNotifierProvider<OtpVerifyController>(
      create: (_) => OtpVerifyController(),
      child: Consumer2<AuthController, OtpVerifyController>(
        builder: (context, auth, otpVal, _) {
          return BackgroundWidget(
            imagePath: 'assets/images/bg.png',
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Scaffold(
                body: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Spacer(),
                            const Spacer(),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Expanded(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              AnimatedPositioned(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeIn,
                                top: isKeyboardOpen ? -50.h : 170.h,
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: ListView(
                                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                                  children: [
                                    SizedBox(height: 20.h),
                                    Text(
                                      context.watchTr('otp_verification'),
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayLarge
                                          ?.copyWith(fontFamily: 'LobsterTwo'),
                                    ),
                                    SizedBox(height: 8.h),
                                    SizedBox(
                                      width: 291.w,
                                      child: Text(
                                        '${context.watchTr('sms_sent_msg')} ${origin == 'forget' ? auth.forgetEmailController.text : auth.signupEmail} ${context.watchTr('containing_code_msg')}',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              fontFamily: 'Segoe UI',
                                              color: AppColors.textColor2,
                                            ),
                                      ),
                                    ),
                                    SizedBox(height: 30.h),
                                    PinCodeTextField(
                                      appContext: context,
                                      length: 4, // Set to 4 digits
                                      textStyle: TextStyle(
                                        fontSize: 18.sp,
                                        color: AppColors.whiteColor,
                                      ),
                                      animationType: AnimationType.fade,
                                      cursorColor: Theme.of(context).colorScheme.primary,
                                      pinTheme: PinTheme(
                                        shape: PinCodeFieldShape.box,
                                        fieldHeight: 60.h,
                                        fieldWidth: 60.w,
                                        activeColor: AppColors.primaryColor,
                                        activeFillColor: AppColors.defaultColorAlpha,
                                        selectedColor: AppColors.primaryColor,
                                        selectedFillColor: AppColors.defaultColorAlpha,
                                        inactiveColor: AppColors.inputBorderColor,
                                        inactiveFillColor: AppColors.defaultColorAlpha,
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                      animationDuration: const Duration(milliseconds: 300),
                                      enableActiveFill: true,
                                      keyboardType: TextInputType.number,
                                      controller: otpVal.otpController,
                                      focusNode: otpVal.pinFocusNode,
                                      onChanged: (v) {
                                        auth.otpController.text = v;
                                        auth.updateOtp(v);
                                      },
                                      onCompleted: auth.updateOtp,
                                    ),
                                    SizedBox(height: 20.h),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          context.watchTr('did_not_receive_code'),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(fontFamily: 'Segoe UI'),
                                        ),
                                        SizedBox(width: 5.w),
                                        InkWell(
                                          onTap: otpVal.secondsRemaining == 0
                                              ? otpVal.startTimer
                                              : null,
                                          child: Text(
                                            context.watchTr('resend'),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: otpVal.secondsRemaining == 0
                                                      ? AppColors.primaryColor
                                                      : AppColors.textColor2,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Segoe UI',
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5.h),
                                    Text(
                                      '${context.watchTr('resend_available_in')} ${otpVal.formattedTime}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: AppColors.primaryColor,
                                            fontFamily: 'Segoe UI',
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 40.h),
                                    CustomButton(
                                      linearGradient: true,
                                      height: 48,
                                      title: context.watchTr('verify_caps'),
                                      loading: auth.isLoading,
                                      onPress: () async {
                                        if (auth.isOtpVerified) {
                                          auth.otpController.text = otpVal.otpController.text;
                                          await auth.verifyOtp(origin: origin);
                                        } else {
                                          showWarningSnackBar(
                                            message: context.watchTr('enter_valid_otp'),
                                          );
                                        }
                                      },
                                    ),
                                    SizedBox(height: 20.h),
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
            ),
          );
        },
      ),
    );
  }
}

class OtpVerifyController extends ChangeNotifier {
  int _secondsRemaining = 60;
  String _formattedTime = '01:00';
  Timer? _timer;

  final FocusNode pinFocusNode = FocusNode();
  final TextEditingController otpController = TextEditingController();

  int get secondsRemaining => _secondsRemaining;
  String get formattedTime => _formattedTime;

  OtpVerifyController() {
    startTimer();
  }

  void startTimer() {
    _timer?.cancel();
    _secondsRemaining = 60;
    _formattedTime = '01:00';
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsRemaining > 0) {
        _secondsRemaining--;
        final m = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
        final s = (_secondsRemaining % 60).toString().padLeft(2, '0');
        _formattedTime = '$m:$s';
      } else {
        t.cancel();
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    pinFocusNode.dispose();
    otpController.dispose();
    super.dispose();
  }
}
