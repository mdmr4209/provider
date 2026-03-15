import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../res/assets/image_assets.dart';
import '../../../../res/colors/app_color.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/input_text_widget.dart';
import '../../../routes/app_router.dart';

class AddNewCardView extends StatelessWidget {
  const AddNewCardView({super.key});

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
              mainAxisAlignment: MainAxisAlignment.center,
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
                      'Edit profile',
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
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      width: 335.w,
                      height: 677.h,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(ImageAssets.background),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 40.h),
                          SvgPicture.asset(
                            ImageAssets.card3,
                            width: 279.w,
                            height: 170.h,
                          ),
                          SizedBox(height: 30.h),
                          _inputCard('Enter your full name'),
                          SizedBox(height: 10.h),
                          _inputCard('xxxx xxxx xxxx xxxx',keyboardType: TextInputType.number),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              Expanded(child: _inputCard('MM/YY',keyboardType: TextInputType.datetime)),
                              SizedBox(width: 10.w),
                              Expanded(child: _inputCard('CVV',keyboardType: TextInputType.number)),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          CustomButton(
                            onPress: () async {},
                            title: 'SAVE CARD',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
