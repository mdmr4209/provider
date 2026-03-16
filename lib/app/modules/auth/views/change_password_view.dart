import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../res/assets/image_assets.dart';
import '../../../../res/colors/app_color.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/input_text_widget.dart';
import '../../../routes/app_router.dart';
import '../providers/auth_provider.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key,});

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
    if (password != confirm) return 'Passwords do not match.';
    if (password.length < 8) return 'Password must be at least 8 characters.';
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Must contain an uppercase letter.';
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return 'Must contain a lowercase letter.';
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) return 'Must contain a digit.';
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return 'Must contain a special character.';
    }
    return null;
  }

  Future<void> _onSave(AuthProvider auth) async {
    final error = _validate(
      auth.setPasswordController.text,
      _confirmController.text,
    );
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
      return;
    }
    await auth.setPassword();
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
                    Text( 'Reset Password',
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
                            SizedBox(
                              width: 295.w,
                              child: Text(
                                'Enter new password and confirm.',
                                style: GoogleFonts.lato(
                                  color: AppColor.textColor2,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  height: 1.70,
                                ),
                              ),
                            ),
                            SizedBox(height: 30.h),
                            InputTextWidget(
                              hintText: 'Enter your password',
                              obscureText: true,
                              onChanged: (_) {},
                              textEditingController: auth.setPasswordController,
                              leadingHeight: 18,
                              leadingWidth: 14,
                            ),
                            SizedBox(height: 20.h),
                            InputTextWidget(
                              hintText: 'Confirm your password',
                              obscureText: true,
                              onChanged: (_) {},
                              leadingHeight: 18,
                              leadingWidth: 14,
                              textEditingController: _confirmController,
                            ),
                            SizedBox(height: 20.h),
                            CustomButton(
                              height: 60,
                              title: 'CHANGE PASSWORD',
                              fontWeight: FontWeight.w900,
                              onPress: auth.isLoading
                                  ? null
                                  : ()async {
                                      context.push(
                                        AppRoutes.goToHome,
                                      );
                                      // _onSave(auth)
                                    },
                              loading: auth.isLoading,
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
