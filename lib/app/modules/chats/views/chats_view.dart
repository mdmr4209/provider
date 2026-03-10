
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../res/assets/image_assets.dart';
import '../../../../res/colors/app_color.dart';
import '../../../../widgets/custom_input_widget.dart';
import '../controllers/chats_controller.dart';
import 'personal_chat.dart';

class ChatsView extends GetView<ChatsController> {
  const ChatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            automaticallyImplyLeading: false,
            snap: true,
            backgroundColor: AppColor.chatColor,
            title: Text(
              'requests'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColor.textColor,
                fontSize: 20.sp,
                fontFamily: Get.locale?.languageCode == 'ar' ? 'ArabicFont' : 'Proxima Nova',
                fontWeight: FontWeight.w600,
              ),
            )
          ),
          // Search Bar stays always visible after AppBar
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                SizedBox(
                  height: 85.sp,
                  child: ListView.builder(
                    itemCount: controller.images.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 25.r,
                              backgroundColor: Colors.grey[300],
                              child: ClipOval(
                                child: Image.asset(
                                  controller.images[index],
                                  fit: BoxFit.cover,
                                  width: 80.r,
                                  height: 80.r,
                                ),
                              ),
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              controller.names[index],
                              style: TextStyle(
                                color: AppColor.textGreyColor,
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: CustomInputWidget(
                    onTap: () {},
                    onChanged: (e) {},
                    hintText: 'search_bar'.tr,
                    readOnly: true,
                    leadingIcon: ImageAssets.search,
                    leading: true,
                    height: 45,
                    shadow: true,
                    borderShadowColor: AppColor.boxShadowColor,
                    borderColor: AppColor.otpColor,
                    backgroundColor: AppColor.otpColor,
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 5.h),
                  child: Row(
                    spacing: 8.w,
                    children: [
                      SvgPicture.asset(ImageAssets.request),
                      Text(
                        'request_count'.tr,
                        style: TextStyle(
                          color: AppColor.greyColor,
                          fontSize: 14.sp,
                          fontFamily: Get.locale?.languageCode == 'ar' ? 'ArabicFont' : 'Proxima Nova',
                          fontWeight: FontWeight.w400,
                          height: 1.20,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Chat List
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 5.h),
                child: GestureDetector(
                  onTap: () {
                    Get.to(PersonalChat(name: controller.names[index], image: controller.images[index],),transition: Transition.rightToLeft);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: AppColor.backgroundColor,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: AppColor.backgroundColor),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 25.r,
                          child: ClipOval(
                            child: Image.asset(
                              controller.images[index],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.names[index],
                                style: TextStyle(
                                  color: AppColor.textColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.sp,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              SizedBox(
                                width: 233.w,
                                child: Text(
                                  'sample_message'.tr,
                                  style: TextStyle(
                                    color: AppColor.greyColor,
                                    fontSize: 12.sp,
                                    fontFamily: Get.locale?.languageCode == 'ar' ? 'ArabicFont' : 'Proxima Nova',
                                    fontWeight: FontWeight.w400,
                                    height: 1.20,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                          'sample_time'.tr,
                              style: TextStyle(
                                color: AppColor.greyColor,
                                fontSize: 12.sp,
                                fontFamily: Get.locale?.languageCode == 'ar' ? 'ArabicFont' : 'Proxima Nova',
                                fontWeight: FontWeight.w400,
                                height: 1.20,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Container(
                              width: 25.sp,
                              height: 25.sp,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.r),
                                color: AppColor.defaultColor,
                              ),
                              child: Center(
                                child: Text(
                                  'unread_count'.tr,
                                  style: TextStyle(
                                    color: AppColor.textWhiteColor,
                                    fontSize: 8.sp,
                                    fontFamily: Get.locale?.languageCode == 'ar' ? 'ArabicFont' : 'Proxima Nova',
                                    fontWeight: FontWeight.w600,
                                    height: 1.20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }, childCount: controller.names.length),
          ),
        ],
      ),
    );
  }
}
