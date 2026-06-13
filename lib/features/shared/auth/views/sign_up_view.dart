import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/utils/validators/input_validators.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_loader.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/input_text_widget.dart';
import '../../../../core/widgets/background_widget.dart';
import '../../../../routes/app_router.dart';
import '../../localization/localization_extension.dart';
import '../controllers/auth_controller.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    final auth = context.read<AuthController>();

    return ChangeNotifierProvider<SignUpFormNotifier>(
      create: (_) => SignUpFormNotifier(
        emailController: auth.signupEmailController,
        passwordController: auth.setPasswordController,
      ),
      child: Consumer2<AuthController, SignUpFormNotifier>(
        builder: (context, auth, form, _) {
          if (auth.isLoading && auth.error == null) {
            return const FullScreenLoader();
          }

          if (auth.error != null && auth.error!.isCritical) {
            return ErrorDisplayWidget(
              exception: auth.error!,
              isFullScreen: true,
              onRetry: () => auth.signup(),
            );
          }

          return BackgroundWidget(
            imagePath: 'assets/images/bg1.png',
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Scaffold(
                body: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
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
                                top: isKeyboardOpen ? -80.h : 170.h,
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: ListView(
                                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                                  children: [
                                    SizedBox(height: 20.h),
                                    Text(
                                      context.watchTr('welcome'),
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayLarge
                                          ?.copyWith(fontFamily: 'LobsterTwo'),
                                    ),
                                    SizedBox(
                                      width: 291.w,
                                      child: Text(
                                        context.watchTr('auth_subtitle'),
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
                                    SizedBox(height: 20.h),

                                    if (auth.error != null) ...[
                                      ErrorDisplayWidget(
                                        exception: auth.error!,
                                        onRetry: () => auth.clearError(),
                                      ),
                                      SizedBox(height: 16.h),
                                    ],

                                    // Email Section
                                    Text(
                                      context.watchTr('email'),
                                      textAlign: TextAlign.left,
                                      style: Theme.of(context).textTheme.bodyLarge
                                          ?.copyWith(fontFamily: 'Segoe UI'),
                                    ),
                                    SizedBox(height: 8.h),
                                    InputTextWidget(
                                      hintText: context.watchTr(
                                        'enter_your_email',
                                      ),
                                      controller: form.emailController,
                                      onChanged: (val) {
                                        auth.clearError();
                                        form.setEmailError(InputValidators.validateEmail(val));
                                      },
                                      keyboardType: TextInputType.emailAddress,
                                      leadingIcon: AppAssets.email,
                                      leadingColor: AppColors.iconColor,
                                      leadingPadding: EdgeInsets.only(
                                        left: 10.w,
                                        right: 5.w,
                                      ),
                                    ),
                                    if (form.emailError != null) ...[
                                      SizedBox(height: 4.h),
                                      Text(
                                        form.emailError!,
                                        style: TextStyle(
                                          color: AppColors.redColor,
                                          fontSize: 11.sp,
                                        ),
                                      ),
                                    ],
                                    SizedBox(height: 15.h),

                                    // Password Section
                                    Text(
                                      context.watchTr('password'),
                                      textAlign: TextAlign.left,
                                      style: Theme.of(context).textTheme.bodyLarge
                                          ?.copyWith(fontFamily: 'Segoe UI'),
                                    ),
                                    SizedBox(height: 8.h),
                                    InputTextWidget(
                                      hintText: context.watchTr(
                                        'enter_your_password',
                                      ),
                                      obscureText: true,
                                      showObscureToggle: true,
                                      controller: form.passwordController,
                                      onChanged: (val) {
                                        auth.clearError();
                                        form.setPasswordError(InputValidators.validatePassword(val));
                                      },
                                      leadingIcon: AppAssets.pass,
                                      leadingColor: AppColors.iconColor,
                                      leadingPadding: EdgeInsets.only(
                                        left: 10.w,
                                        right: 5.w,
                                      ),
                                    ),
                                    if (form.passwordError != null) ...[
                                      SizedBox(height: 4.h),
                                      Text(
                                        form.passwordError!,
                                        style: TextStyle(
                                          color: AppColors.redColor,
                                          fontSize: 11.sp,
                                        ),
                                      ),
                                    ],
                                    SizedBox(height: 15.h),

                                    // Confirm Password Section
                                    Text(
                                      context.watchTr('confirm_password'),
                                      textAlign: TextAlign.left,
                                      style: Theme.of(context).textTheme.bodyLarge
                                          ?.copyWith(fontFamily: 'Segoe UI'),
                                    ),
                                    SizedBox(height: 8.h),
                                    InputTextWidget(
                                      hintText: context.watchTr(
                                        'confirm_your_password',
                                      ),
                                      obscureText: true,
                                      showObscureToggle: true,
                                      controller: form.confirmPasswordController,
                                      onChanged: (val) {
                                        auth.clearError();
                                        form.setConfirmPasswordError(
                                          InputValidators.validatePasswordMatch(
                                            form.passwordController.text,
                                            val,
                                          ),
                                        );
                                      },
                                      leadingIcon: AppAssets.pass,
                                      leadingColor: AppColors.iconColor,
                                      leadingPadding: EdgeInsets.only(
                                        left: 10.w,
                                        right: 5.w,
                                      ),
                                    ),
                                    if (form.confirmPasswordError != null) ...[
                                      SizedBox(height: 4.h),
                                      Text(
                                        form.confirmPasswordError!,
                                        style: TextStyle(
                                          color: AppColors.redColor,
                                          fontSize: 11.sp,
                                        ),
                                      ),
                                    ],
                                    SizedBox(height: 20.h),

                                    Row(
                                      children: [
                                        SizedBox(
                                          height: 24.w,
                                          width: 24.w,
                                          child: Checkbox(
                                            value: form.agreeToTerms,
                                            onChanged: (val) {
                                              form.setAgreeToTerms(val ?? false);
                                            },
                                            activeColor: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          "Agree to Legal Terms",
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20.h),

                                    CustomButton(
                                      linearGradient: true,
                                      height: 48,
                                      title: context.watchTr('sign_up_caps'),
                                      onPress: auth.isLoading || !form.isFormValid
                                          ? null
                                          : () async {
                                              form.validateFields();
                                              if (form.isFormValid) {
                                                auth.signup();
                                              }
                                            },
                                      loading: auth.isLoading,
                                    ),
                                    SizedBox(height: 20.h),

                                    // Divider
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Divider(
                                            color: AppColors.defaultColorLight,
                                            thickness: 1.h,
                                          ),
                                        ),
                                        Container(
                                          width: 50.w,
                                          height: 22.h,
                                          alignment: Alignment.center,
                                          decoration: ShapeDecoration(
                                            color: AppColors.defaultColorLight,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                44.r,
                                              ),
                                            ),
                                          ),
                                          child: Text(
                                            'or',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodyLarge,
                                          ),
                                        ),
                                        Expanded(
                                          child: Divider(
                                            color: AppColors.defaultColorLight,
                                            thickness: 1.h,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20.h),

                                    // Google Signup Button
                                    Container(
                                      width: 319.w,
                                      height: 48.h,
                                      decoration: ShapeDecoration(
                                        color: AppColors.defaultColorAlpha,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            AppAssets.google,
                                            width: 20.r,
                                            height: 20.r,
                                          ),
                                          SizedBox(width: 14.w),
                                          Text(
                                            'Sign Up with Google',
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.copyWith(
                                                  color: AppColors.whiteColor,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 20.h),

                                    // Footer
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${context.watchTr('already_have_account')} ",
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium,
                                        ),
                                        GestureDetector(
                                          onTap: () =>
                                              context.push(AppRoutes.login),
                                          child: Text(
                                            context.watchTr('sign_in_dot'),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 40.h),
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

class SignUpFormNotifier extends ChangeNotifier {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController = TextEditingController();

  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  bool _agreeToTerms = false;

  String? get emailError => _emailError;
  String? get passwordError => _passwordError;
  String? get confirmPasswordError => _confirmPasswordError;
  bool get agreeToTerms => _agreeToTerms;

  SignUpFormNotifier({required this.emailController, required this.passwordController});

  void setEmailError(String? val) {
    _emailError = val;
    notifyListeners();
  }

  void setPasswordError(String? val) {
    _passwordError = val;
    notifyListeners();
  }

  void setConfirmPasswordError(String? val) {
    _confirmPasswordError = val;
    notifyListeners();
  }

  void setAgreeToTerms(bool val) {
    _agreeToTerms = val;
    notifyListeners();
  }

  void validateFields() {
    _emailError = InputValidators.validateEmail(emailController.text);
    _passwordError = InputValidators.validatePassword(passwordController.text);
    _confirmPasswordError = InputValidators.validatePasswordMatch(
      passwordController.text,
      confirmPasswordController.text,
    );
    notifyListeners();
  }

  bool get isFormValid =>
      _emailError == null &&
      _passwordError == null &&
      _confirmPasswordError == null &&
      emailController.text.isNotEmpty &&
      passwordController.text.isNotEmpty &&
      confirmPasswordController.text.isNotEmpty &&
      _agreeToTerms;

  @override
  void dispose() {
    confirmPasswordController.dispose();
    super.dispose();
  }
}
