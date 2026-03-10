import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../res/assets/image_assets.dart';
import '../../../../res/colors/app_color.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/input_text_widget.dart';
import '../providers/auth_provider.dart';

class ChangePasswordView extends StatefulWidget {
  final String? origin;
  const ChangePasswordView({super.key, this.origin});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final TextEditingController _confirmController = TextEditingController();

  @override
  void dispose() {
    _confirmController.dispose();
    super.dispose();
  }

  String? _validate(String password, String confirm) {
    if (password != confirm)       return 'Passwords do not match.';
    if (password.length < 8)       return 'Password must be at least 8 characters.';
    if (!RegExp(r'[A-Z]').hasMatch(password)) return 'Must contain an uppercase letter.';
    if (!RegExp(r'[a-z]').hasMatch(password)) return 'Must contain a lowercase letter.';
    if (!RegExp(r'[0-9]').hasMatch(password)) return 'Must contain a digit.';
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return 'Must contain a special character.';
    }
    return null;
  }

  Future<void> _onSave(AuthProvider auth) async {
    final error = _validate(
        auth.setPasswordController.text, _confirmController.text);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(error),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4)),
      );
      return;
    }
    await auth.setPassword(origin: widget.origin);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back, color: AppColor.textColor),
          ),
          title: Text(
            widget.origin == 'Signup' ? 'Set Password' : 'Reset Password',
            style: const TextStyle(color: AppColor.textColor, fontSize: 25),
          ),
          centerTitle: true,
        ),
        body: Consumer<AuthProvider>(
          builder: (context, auth, _) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50.h),
                const Text('New Password *',
                    style: TextStyle(
                        color: AppColor.textColor,
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.65)),
                SizedBox(height: 8.h),
                InputTextWidget(
                  hintText: 'Password',
                  obscureText: true,
                  onChanged: (_) {},
                  leading: true,
                  leadingIcon: ImageAssets.password,
                  textEditingController: auth.setPasswordController,
                  leadingHeight: 18,
                  leadingWidth: 14,
                ),
                SizedBox(height: 14.h),
                const Text('Confirm New Password *',
                    style: TextStyle(
                        color: AppColor.textColor,
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.65)),
                SizedBox(height: 8.h),
                InputTextWidget(
                  hintText: 'Confirm Password',
                  obscureText: true,
                  onChanged: (_) {},
                  leading: true,
                  leadingIcon: ImageAssets.password,
                  leadingHeight: 18,
                  leadingWidth: 14,
                  textEditingController: _confirmController,
                ),
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.only(right: 15.w),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: auth.toggleRemembered,
                        child: Container(
                          width: 17,
                          height: 17,
                          decoration: BoxDecoration(
                            color: auth.isRemembered
                                ? AppColor.defaultColor
                                : Colors.transparent,
                            border: Border.all(
                              color: auth.isRemembered
                                  ? Colors.transparent
                                  : AppColor.textGreyColor,
                            ),
                          ),
                          child: Center(
                            child: Icon(Icons.check,
                                color: auth.isRemembered
                                    ? AppColor.textWhiteColor
                                    : Colors.transparent,
                                size: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text('Remember me',
                          style: TextStyle(
                              color: AppColor.textColor,
                              fontSize: 12,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.50)),
                      const Spacer(),
                    ],
                  ),
                ),
                SizedBox(height: 36.h),
                CustomButton(
                  title: 'Save Password',
                  fontWeight: FontWeight.w700,
                  onPress: auth.isLoading ? null : () => _onSave(auth),
                  loading: auth.isLoading,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
