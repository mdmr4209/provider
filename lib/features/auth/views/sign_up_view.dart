import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/exceptions/app_exceptions.dart';
import '../../../core/utils/validators/input_validators.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_loader.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/input_text_widget.dart';
import '../../../routes/app_router.dart';
import '../../localization/localization_extension.dart';
import '../controllers/auth_controller.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthController>();
    _emailController = auth.emailController;
    _passwordController = auth.passwordController;
    _confirmPasswordController = auth.setPasswordController;
  }

  void _validateFields() {
    setState(() {
      _emailError = InputValidators.validateEmail(_emailController.text);
      _passwordError =
          InputValidators.validatePassword(_passwordController.text);
      _confirmPasswordError = InputValidators.validatePasswordMatch(
        _passwordController.text,
        _confirmPasswordController.text,
      );
    });
  }

  bool get _isFormValid =>
      _emailError == null &&
      _passwordError == null &&
      _confirmPasswordError == null &&
      _emailController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty &&
      _confirmPasswordController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Consumer<AuthController>(
              builder: (context, auth, _) {
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

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          context.watchTr('sign_up'),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Spacer(),
                        SizedBox(width: 20.w),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Expanded(
                      child: Container(
                        width: 335.w,
                        height: 677.h,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeIn,
                              top: isKeyboardOpen ? -150.h : 50.h,
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: ListView(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 20.w),
                                children: [
                                  SizedBox(height: 20.h),
                                  Text(
                                    context.watchTr('sign_up_caps'),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall,
                                  ),
                                  SizedBox(height: 20.h),
                                  SizedBox(
                                    width: 266.w,
                                    child: Text(
                                      context.watchTr('auth_subtitle'),
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ),
                                  SizedBox(height: 50.h),
                                  
                                  if (auth.error != null) ...[
                                    ErrorDisplayWidget(
                                      exception: auth.error!,
                                      onRetry: () => auth.clearError(),
                                    ),
                                    SizedBox(height: 16.h),
                                  ],

                                  // Email field
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InputTextWidget(
                                        hintText: context
                                            .watchTr('enter_your_email'),
                                        controller: _emailController,
                                        onChanged: (_) {
                                          auth.clearError();
                                          setState(() {
                                            _emailError = InputValidators
                                                .validateEmail(
                                              _emailController.text,
                                            );
                                          });
                                        },
                                        keyboardType:
                                            TextInputType.emailAddress,
                                      ),
                                      if (_emailError != null) ...[
                                        SizedBox(height: 4.h),
                                        Text(
                                          _emailError!,
                                          style: TextStyle(
                                            color: Theme.of(context).colorScheme.error,
                                            fontSize: 11.sp,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  SizedBox(height: 10.h),
                                  // Password field
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InputTextWidget(
                                        hintText: context.watchTr(
                                          'enter_your_password',
                                        ),
                                        obscureText: true,
                                        showObscureToggle: true,
                                        controller: _passwordController,
                                        onChanged: (_) {
                                          auth.clearError();
                                          setState(() {
                                            _passwordError = InputValidators
                                                .validatePassword(
                                              _passwordController.text,
                                            );
                                          });
                                        },
                                      ),
                                      if (_passwordError != null) ...[
                                        SizedBox(height: 4.h),
                                        Text(
                                          _passwordError!,
                                          style: TextStyle(
                                            color: Theme.of(context).colorScheme.error,
                                            fontSize: 11.sp,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  SizedBox(height: 10.h),
                                  // Confirm Password field
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InputTextWidget(
                                        hintText: context.watchTr(
                                          'confirm_your_password',
                                        ),
                                        obscureText: true,
                                        showObscureToggle: true,
                                        controller: _confirmPasswordController,
                                        onChanged: (_) {
                                          auth.clearError();
                                          setState(() {
                                            _confirmPasswordError =
                                                InputValidators
                                                    .validatePasswordMatch(
                                              _passwordController.text,
                                              _confirmPasswordController.text,
                                            );
                                          });
                                        },
                                      ),
                                      if (_confirmPasswordError != null) ...[
                                        SizedBox(height: 4.h),
                                        Text(
                                          _confirmPasswordError!,
                                          style: TextStyle(
                                            color: Theme.of(context).colorScheme.error,
                                            fontSize: 11.sp,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  SizedBox(height: 30.h),
                                  CustomButton(
                                    height: 60,
                                    title: context.watchTr('sign_up_button'),
                                    onPress: auth.isLoading || !_isFormValid
                                        ? null
                                        : () async{
                                            _validateFields();
                                            if (_isFormValid) {
                                              auth.signup();
                                            }
                                          },
                                    loading: auth.isLoading,
                                  ),
                                  SizedBox(height: 20.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${context.watchTr('already_have_account')} ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
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
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
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
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
