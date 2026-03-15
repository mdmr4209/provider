import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../res/assets/image_assets.dart';
import '../../../../res/colors/app_color.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/input_text_widget.dart';
import '../../../routes/app_router.dart';

class EditView extends StatelessWidget {
  const EditView({super.key});

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;

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
                          Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.all(10.w),
                                width: 120.w,
                                height: 120.h,
                                clipBehavior: Clip.antiAlias,
                                decoration: ShapeDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/image/img_3.png"),
                                    fit: BoxFit.cover,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      width: 1.5.w,
                                      strokeAlign: BorderSide.strokeAlignOutside,
                                      color: AppColor.defaultColor,
                                    ),
                                    borderRadius: BorderRadius.circular(70.r),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 15.h,
                                right: 0,
                                child: InkWell(
                                  onTap: () =>
                                      context.push(AppRoutes.editProfile),
                                  child: Container(
                                    width: 40.w,
                                    height: 40.h,
                                    padding: EdgeInsets.all(10.w),
                                    decoration: ShapeDecoration(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50.r),
                                      ),
                                      shadows: [
                                        BoxShadow(
                                          color: Color(0x26222222),
                                          blurRadius: 10,
                                          offset: Offset(0, 4),
                                          spreadRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child: SvgPicture.asset(
                                      ImageAssets.camera,
                                      colorFilter: ColorFilter.mode(
                                        AppColor.blackColor,
                                        BlendMode.srcIn,
                                      ),
                                      width: 20.w,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30.h),
                          _inputCard('Enter your full name'),
                          SizedBox(height: 10.h),
                          _inputCard('Enter your email'),
                          SizedBox(height: 10.h),
                          _inputCard('Enter your phone number'),
                          SizedBox(height: 10.h),
                          _inputCard('Enter your address'),
                          SizedBox(height: 20.h),
                          CustomButton(
                            onPress: () async {},
                            title: 'SAVE CHANGE',
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

  Widget _inputCard(String title) {
    return InputTextWidget(onChanged: (onChanged) {}, hintText: title);
  }
}
