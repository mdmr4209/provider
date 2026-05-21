import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/input_text_widget.dart';
import '../controllers/profile_controller.dart';

class EditView extends StatefulWidget {
  const EditView({super.key});

  @override
  State<EditView> createState() => _EditViewState();
}

class _EditViewState extends State<EditView> {
  @override
  void initState() {
    super.initState();
    // Initialize controllers with current profile data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileController>().initEditFields();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileController = context.watch<ProfileController>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back_ios_new),
                    ),
                    const Spacer(),
                    Text(
                      'Edit profile',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.tenorSans(
                        color: AppColors.textColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(width: 20.w),
                  ],
                ),
                SizedBox(height: 10.h),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      width: 335.w,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(AppAssets.background),
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
                                  image: const DecorationImage(
                                    image: AssetImage("assets/image/img_3.png"),
                                    fit: BoxFit.cover,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      width: 1.5.w,
                                      strokeAlign:
                                          BorderSide.strokeAlignOutside,
                                      color: AppColors.defaultColor,
                                    ),
                                    borderRadius: BorderRadius.circular(70.r),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 15.h,
                                right: 0,
                                child: InkWell(
                                  onTap: () {
                                    // Handle camera tap (e.g., pick image)
                                  },
                                  child: Container(
                                    width: 40.w,
                                    height: 40.h,
                                    padding: EdgeInsets.all(10.w),
                                    decoration: ShapeDecoration(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          50.r,
                                        ),
                                      ),
                                      shadows: const [
                                        BoxShadow(
                                          color: Color(0x26222222),
                                          blurRadius: 10,
                                          offset: Offset(0, 4),
                                          spreadRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child: SvgPicture.asset(
                                      AppAssets.camera,
                                      colorFilter: const ColorFilter.mode(
                                        AppColors.blackColor,
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
                          _inputCard('Full Name', profileController.nameCtrl),
                          SizedBox(height: 10.h),
                          _inputCard('Email', profileController.emailCtrl),
                          SizedBox(height: 10.h),
                          _inputCard(
                            'Phone Number',
                            profileController.phoneCtrl,
                          ),
                          SizedBox(height: 10.h),
                          _inputCard('Address', profileController.addressCtrl),
                          SizedBox(height: 40.h),
                          CustomButton(
                            onPress: () async {
                              await profileController.updateProfile();
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            },
                            title: profileController.isLoading
                                ? 'SAVING...'
                                : 'SAVE CHANGE',
                          ),
                          SizedBox(height: 20.h),
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

  Widget _inputCard(String hint, TextEditingController controller) {
    return InputTextWidget(
      controller: controller,
      hintText: hint,
      onChanged: (val) {},
    );
  }
}
