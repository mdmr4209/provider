import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/input_text_widget.dart';
import '../controllers/profile_controller.dart';

class AddNewAddress extends StatelessWidget {
  const AddNewAddress({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: Stack(
          children: [
            Image.asset(AppAssets.addressBg, fit: BoxFit.cover),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.arrow_back_ios_new),
                          ),
                          Spacer(),
                          Text(
                            'Add A New Address',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.tenorSans(
                              color: AppColors.textColor,
                              fontSize: 18.w,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Spacer(),
                          SizedBox(width: 20.w),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Expanded(
                      child: ListView(
                        children: [
                          Image.asset('assets/image/img_4.png'),
                          SizedBox(height: 20.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Column(
                              children: [
                                _inputCard('Enter your address title'),
                                SizedBox(height: 20.h),
                                _inputCard('Enter your address'),
                                SizedBox(height: 20.h),
                                Consumer<ProfileController>(
                                  builder: (context, profile, _) => Row(
                                    children: [
                                      GestureDetector(
                                        onTap: profile.toggleCurrent,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 18.r,
                                              height: 18.r,
                                              decoration: BoxDecoration(
                                                color: profile.isCurrent
                                                    ? AppColors.defaultColor
                                                    : AppColors.whiteColor,
                                                border: Border.all(
                                                  color: profile.isCurrent
                                                      ? Colors.transparent
                                                      : AppColors.whiteColor,
                                                ),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.check,
                                                  color: profile.isCurrent
                                                      ? AppColors.textWhiteColor
                                                      : Colors.transparent,
                                                  size: 14,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10.w),
                                            Text(
                                              'Use current location',
                                              textAlign: TextAlign.right,
                                              style: GoogleFonts.lato(
                                                color: AppColors.textColor2,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w400,
                                                height: 1.70,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: CustomButton(
                        onPress: () async {},
                        title: 'SAVE ADDRESS',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputCard(
    String title, {
    TextInputType? keyboardType = TextInputType.text,
  }) {
    return InputTextWidget(
      onChanged: (onChanged) {},
      hintText: title,
      keyboardType: keyboardType ?? TextInputType.text,
    );
  }
}
