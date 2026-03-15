import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../res/assets/image_assets.dart';
import '../../../../res/colors/app_color.dart';
import '../../../../widgets/custom_button.dart';

class Logout extends StatelessWidget {
  const Logout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Container(
        width: 375,
        height: 2088,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(color: Colors.white),
        child: Stack(
          children: [
            Positioned(
              left: 20,
              top: 111,
              child: Container(
                width: 335,
                height: 33,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 33,
                      child: Container(
                        width: 167,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 2,
                              strokeAlign: BorderSide.strokeAlignCenter,
                              color: const Color(0xFF222222),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 168,
                      top: 33,
                      child: Opacity(
                        opacity: 0.50,
                        child: Container(
                          width: 167,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 2,
                                strokeAlign: BorderSide.strokeAlignCenter,
                                color: const Color(0xFF222222),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Text(
                        'Current',
                        style: TextStyle(
                          color: const Color(0xFF222222),
                          fontSize: 18,
                          fontFamily: 'Tenor Sans',
                          fontWeight: FontWeight.w400,
                          height: 1.20,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 167,
                      top: 0,
                      child: Opacity(
                        opacity: 0.50,
                        child: Text(
                          'Used',
                          style: TextStyle(
                            color: const Color(0xFF222222),
                            fontSize: 18,
                            fontFamily: 'Tenor Sans',
                            fontWeight: FontWeight.w400,
                            height: 1.20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 44,
              child: Container(
                width: 375,
                height: 47,
                decoration: BoxDecoration(color: const Color(0xFFFCEDEA)),
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: 375,
                height: 44,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(color: const Color(0xFFFCEDEA)),
                child: Stack(
                  children: [
                    Positioned(
                      left: 20,
                      top: 17,
                      child: Container(
                        width: 29,
                        height: 12,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                        child: Stack(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 20,
              top: 56,
              child: Container(
                width: 340,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 78,
                  children: [
                    Container(
                      width: 211,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 115,
                        children: [
                          Container(
                            width: 8,
                            height: 14,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(),
                            child: Stack(),
                          ),
                          Text(
                            'My Points',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF222222),
                              fontSize: 18,
                              fontFamily: 'Tenor Sans',
                              fontWeight: FontWeight.w400,
                              height: 1.20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Opacity(
                      opacity: 0,
                      child: Container(
                        height: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 7),
                        decoration: ShapeDecoration(
                          color: const Color(0xFFFBEEF2),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              color: const Color(0xFFFFC5D7),
                            ),
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 4,
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(),
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 2.82,
                                    top: 1.41,
                                    child: Text(
                                      'e',
                                      style: TextStyle(
                                        color: const Color(0xFFD05278),
                                        fontSize: 10.50,
                                        fontFamily: 'Tenor Sans',
                                        fontWeight: FontWeight.w400,
                                        height: 1.20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '2500',
                              style: TextStyle(
                                color: const Color(0xFFD05278),
                                fontSize: 12,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w900,
                                height: 1.70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: -221,
              top: 144,
              child: Container(
                width: 816,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 42,
                  children: [
                    Container(
                      width: 375,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 42,
                        children: [
                          Container(
                            width: double.infinity,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 572,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        width: 1,
                                        color: const Color(0xFFFCEDEA),
                                      ),
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 24,
                                        top: 24,
                                        child: Container(
                                          width: 327,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            spacing: 144.92,
                                            children: [
                                              SizedBox(
                                                width: 99.11,
                                                height: 32,
                                                child: Text(
                                                  'Member',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 24,
                                                    fontFamily: 'Tenor Sans',
                                                    fontWeight: FontWeight.w400,
                                                    height: 1.33,
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: double.infinity,
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Text(
                                                          'Billie Groves',
                                                          textAlign:
                                                              TextAlign.right,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                            fontFamily:
                                                                'Tenor Sans',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            height: 1.43,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: double.infinity,
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        SizedBox(
                                                          width: 97.97,
                                                          height: 17,
                                                          child: Text(
                                                            'Joined 09/02/2017',
                                                            textAlign:
                                                                TextAlign.right,
                                                            style: TextStyle(
                                                              color:
                                                                  const Color(
                                                                    0xFF6B7280,
                                                                  ),
                                                              fontSize: 11,
                                                              fontFamily:
                                                                  'Tenor Sans',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              height: 1.50,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 24,
                                        top: 92.50,
                                        child: Container(
                                          width: 327,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 192,
                                                height: 192,
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      transform:
                                                          Matrix4.identity()
                                                            ..translate(
                                                              0.0,
                                                              0.0,
                                                            )
                                                            ..rotateZ(-1.57),
                                                      height: 192,
                                                      clipBehavior:
                                                          Clip.antiAlias,
                                                      decoration:
                                                          BoxDecoration(),
                                                      child: Stack(),
                                                    ),
                                                    Positioned(
                                                      left: 63.50,
                                                      top: 72.50,
                                                      child: Text(
                                                        '0%',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 48,
                                                          fontFamily:
                                                              'Tenor Sans',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          height: 1,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(
                                                  top: 16,
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 118.92,
                                                      height: 20,
                                                      child: Text(
                                                        'Towards Platinum',
                                                        style: TextStyle(
                                                          color: const Color(
                                                            0xFF4B5563,
                                                          ),
                                                          fontSize: 14,
                                                          fontFamily:
                                                              'Tenor Sans',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          height: 1.43,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 24,
                                        top: 344.50,
                                        child: Container(
                                          width: 327,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            spacing: 12,
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                height: 28.50,
                                                decoration: ShapeDecoration(
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                      width: 1,
                                                      color: const Color(
                                                        0xFFE5E7EB,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                child: Stack(
                                                  children: [
                                                    Positioned(
                                                      left: 0,
                                                      top: -1,
                                                      child: Container(
                                                        height: 20.50,
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(
                                                              width: 111.39,
                                                              height: 20,
                                                              child: Text(
                                                                'To reach Platinum',
                                                                style: TextStyle(
                                                                  color: const Color(
                                                                    0xFF1F2937,
                                                                  ),
                                                                  fontSize: 13,
                                                                  fontFamily:
                                                                      'Tenor Sans',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  height: 1.50,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      left: 293,
                                                      top: -0.50,
                                                      child: SizedBox(
                                                        width: 34.14,
                                                        height: 20,
                                                        child: Text(
                                                          '\$500',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontFamily:
                                                                'Tenor Sans',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            height: 1.50,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                height: 28.50,
                                                decoration: ShapeDecoration(
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                      width: 1,
                                                      color: const Color(
                                                        0xFFE5E7EB,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                child: Stack(
                                                  children: [
                                                    Positioned(
                                                      left: 0,
                                                      top: -1,
                                                      child: Container(
                                                        height: 20.50,
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Amount to go',
                                                              style: TextStyle(
                                                                color:
                                                                    const Color(
                                                                      0xFF1F2937,
                                                                    ),
                                                                fontSize: 13,
                                                                fontFamily:
                                                                    'Tenor Sans',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                height: 1.50,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      left: 293,
                                                      top: -1,
                                                      child: SizedBox(
                                                        width: 34.14,
                                                        height: 20,
                                                        child: Text(
                                                          '\$500',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontFamily:
                                                                'Tenor Sans',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            height: 1.50,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                height: 28.50,
                                                decoration: ShapeDecoration(
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                      width: 1,
                                                      color: const Color(
                                                        0xFFE5E7EB,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                child: Stack(
                                                  children: [
                                                    Positioned(
                                                      left: 0,
                                                      top: -1,
                                                      child: Container(
                                                        height: 20.50,
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(
                                                              width: 90.84,
                                                              height: 20,
                                                              child: Text(
                                                                'You\'re earning',
                                                                style: TextStyle(
                                                                  color: const Color(
                                                                    0xFF1F2937,
                                                                  ),
                                                                  fontSize: 13,
                                                                  fontFamily:
                                                                      'Tenor Sans',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  height: 1.50,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      left: 264,
                                                      top: 0.50,
                                                      child: SizedBox(
                                                        width: 63.16,
                                                        height: 20,
                                                        child: Text(
                                                          '1 pt per \$1',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontFamily:
                                                                'Tenor Sans',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            height: 1.50,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 24,
                                        top: 486,
                                        child: Container(
                                          width: 327,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          decoration: ShapeDecoration(
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                width: 1,
                                                color: const Color(0xFFE5E7EB),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 20,
                                                height: 20,
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(),
                                                child: Stack(),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(
                                                  left: 8,
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'MEMBER ID',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                            fontFamily:
                                                                'Tenor Sans',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            height: 1.43,
                                                            letterSpacing: 1.40,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.only(
                                    top: 24,
                                    left: 24,
                                    right: 24,
                                    bottom: 32,
                                  ),
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        width: 1,
                                        color: const Color(0xFFFCEDEA),
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    spacing: 8,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 327,
                                              child: Text(
                                                'POINTS ACTIVITY',
                                                style: TextStyle(
                                                  color: const Color(
                                                    0xFF6B7280,
                                                  ),
                                                  fontSize: 12,
                                                  fontFamily: 'Tenor Sans',
                                                  fontWeight: FontWeight.w400,
                                                  height: 1.50,
                                                  letterSpacing: 0.30,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 45.63,
                                                  height: 36,
                                                  child: Text(
                                                    '112',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 30,
                                                      fontFamily: 'Tenor Sans',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height: 1.20,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: double.infinity,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Points',
                                                        style: TextStyle(
                                                          color: const Color(
                                                            0xFF6B7280,
                                                          ),
                                                          fontSize: 11,
                                                          fontFamily:
                                                              'Tenor Sans',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          height: 1.50,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                left: 16,
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        width: 90.08,
                                                        height: 36,
                                                        child: Text(
                                                          '\$3.00',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 30,
                                                            fontFamily:
                                                                'Tenor Sans',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            height: 1.20,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: double.infinity,
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Value',
                                                              style: TextStyle(
                                                                color:
                                                                    const Color(
                                                                      0xFF6B7280,
                                                                    ),
                                                                fontSize: 11,
                                                                fontFamily:
                                                                    'Tenor Sans',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                height: 1.50,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 96,
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              left: 0,
                                              top: 63,
                                              child: Container(
                                                width: 327,
                                                height: 2,
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xFFE5E7EB,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              left: 0,
                                              top: 62,
                                              child: Container(
                                                width: 109,
                                                height: 4,
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xFFD05278,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              left: 0,
                                              top: 58,
                                              child: Container(
                                                width: 327,
                                                height: 12,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  spacing: 153,
                                                  children: [
                                                    Container(
                                                      height: double.infinity,
                                                      child: Stack(
                                                        children: [
                                                          Container(
                                                            width: 12,
                                                            height: 12,
                                                            decoration: ShapeDecoration(
                                                              color:
                                                                  const Color(
                                                                    0xFFD05278,
                                                                  ),
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      9999,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                          Positioned(
                                                            left: -34,
                                                            top: 24,
                                                            child: Container(
                                                              width: 80,
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    width: double
                                                                        .infinity,
                                                                    child: Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        SizedBox(
                                                                          width:
                                                                              12.60,
                                                                          height:
                                                                              15,
                                                                          child: Text(
                                                                            '\$3',
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style: TextStyle(
                                                                              color: const Color(
                                                                                0xFF6B7280,
                                                                              ),
                                                                              fontSize: 10,
                                                                              fontFamily: 'Tenor Sans',
                                                                              fontWeight: FontWeight.w400,
                                                                              height: 1.50,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    width: double
                                                                        .infinity,
                                                                    child: Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        SizedBox(
                                                                          width:
                                                                              34.08,
                                                                          height:
                                                                              15,
                                                                          child: Text(
                                                                            '100 pts',
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style: TextStyle(
                                                                              color: const Color(
                                                                                0xFF6B7280,
                                                                              ),
                                                                              fontSize: 10,
                                                                              fontFamily: 'Tenor Sans',
                                                                              fontWeight: FontWeight.w400,
                                                                              height: 1.50,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      height: double.infinity,
                                                      child: Stack(
                                                        children: [
                                                          Container(
                                                            width: 12,
                                                            height: 12,
                                                            decoration: ShapeDecoration(
                                                              color:
                                                                  Colors.white,
                                                              shape: RoundedRectangleBorder(
                                                                side: BorderSide(
                                                                  width: 2,
                                                                  color: const Color(
                                                                    0xFFE5E7EB,
                                                                  ),
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      9999,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                          Positioned(
                                                            left: -34,
                                                            top: 24,
                                                            child: Container(
                                                              width: 80,
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    width: double
                                                                        .infinity,
                                                                    child: Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        SizedBox(
                                                                          width:
                                                                              12.62,
                                                                          height:
                                                                              15,
                                                                          child: Text(
                                                                            '\$6',
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style: TextStyle(
                                                                              color: const Color(
                                                                                0xFF6B7280,
                                                                              ),
                                                                              fontSize: 10,
                                                                              fontFamily: 'Tenor Sans',
                                                                              fontWeight: FontWeight.w400,
                                                                              height: 1.50,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    width: double
                                                                        .infinity,
                                                                    child: Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        SizedBox(
                                                                          width:
                                                                              36.11,
                                                                          height:
                                                                              15,
                                                                          child: Text(
                                                                            '200 pts',
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style: TextStyle(
                                                                              color: const Color(
                                                                                0xFF6B7280,
                                                                              ),
                                                                              fontSize: 10,
                                                                              fontFamily: 'Tenor Sans',
                                                                              fontWeight: FontWeight.w400,
                                                                              height: 1.50,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      height: double.infinity,
                                                      child: Stack(
                                                        children: [
                                                          Container(
                                                            width: 12,
                                                            height: 12,
                                                            decoration: ShapeDecoration(
                                                              color:
                                                                  Colors.white,
                                                              shape: RoundedRectangleBorder(
                                                                side: BorderSide(
                                                                  width: 2,
                                                                  color: const Color(
                                                                    0xFFE5E7EB,
                                                                  ),
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      9999,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                          Positioned(
                                                            left: -34,
                                                            top: 24,
                                                            child: Container(
                                                              width: 80,
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    width: double
                                                                        .infinity,
                                                                    child: Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        SizedBox(
                                                                          width:
                                                                              12.61,
                                                                          height:
                                                                              15,
                                                                          child: Text(
                                                                            '\$8',
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style: TextStyle(
                                                                              color: const Color(
                                                                                0xFF6B7280,
                                                                              ),
                                                                              fontSize: 10,
                                                                              fontFamily: 'Tenor Sans',
                                                                              fontWeight: FontWeight.w400,
                                                                              height: 1.50,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    width: double
                                                                        .infinity,
                                                                    child: Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        SizedBox(
                                                                          width:
                                                                              35.73,
                                                                          height:
                                                                              15,
                                                                          child: Text(
                                                                            '250 pts',
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style: TextStyle(
                                                                              color: const Color(
                                                                                0xFF6B7280,
                                                                              ),
                                                                              fontSize: 10,
                                                                              fontFamily: 'Tenor Sans',
                                                                              fontWeight: FontWeight.w400,
                                                                              height: 1.50,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
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
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 32,
                              children: [
                                Container(
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    spacing: 32,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        spacing: 9,
                                        children: [
                                          Text(
                                            'Rewards Love',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontFamily: 'Tenor Sans',
                                              fontWeight: FontWeight.w400,
                                              height: 1.20,
                                            ),
                                          ),
                                          Text(
                                            'THE PERKS GET ELIXIER-369 AT EVERY MEMBER LEVEL',
                                            style: TextStyle(
                                              color: const Color(0xFF6B7280),
                                              fontSize: 10,
                                              fontFamily: 'Tenor Sans',
                                              fontWeight: FontWeight.w400,
                                              height: 1.20,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width: double.infinity,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          spacing: 20,
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'SPEND PER YEAR',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 10,
                                                            fontFamily:
                                                                'Tenor Sans',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            height: 1.50,
                                                            letterSpacing: 0.50,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 60,
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                'MEMBER',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 10,
                                                                  fontFamily:
                                                                      'Tenor Sans',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  height: 1.25,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                'FREE',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 10,
                                                                  fontFamily:
                                                                      'Tenor Sans',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  height: 1.50,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 60,
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                'PLATINUM',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 10,
                                                                  fontFamily:
                                                                      'Tenor Sans',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  height: 1.25,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              SizedBox(
                                                                width: 26.78,
                                                                height: 15,
                                                                child: Text(
                                                                  '\$500',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        10,
                                                                    fontFamily:
                                                                        'Tenor Sans',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    height:
                                                                        1.50,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 60,
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                'DIAMOND',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 10,
                                                                  fontFamily:
                                                                      'Tenor Sans',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  height: 1.25,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              SizedBox(
                                                                width: 31.23,
                                                                height: 15,
                                                                child: Text(
                                                                  '\$1200',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        10,
                                                                    fontFamily:
                                                                        'Tenor Sans',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    height:
                                                                        1.50,
                                                                  ),
                                                                ),
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
                                            Container(
                                              width: double.infinity,
                                              height: 222.50,
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    left: 0,
                                                    top: 0,
                                                    child: Container(
                                                      width: 327,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'POINTS',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 11,
                                                              fontFamily:
                                                                  'Tenor Sans',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              height: 1.50,
                                                              letterSpacing:
                                                                  1.10,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    left: 0,
                                                    top: 24.50,
                                                    child: Container(
                                                      width: 327,
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 8,
                                                          ),
                                                      decoration: ShapeDecoration(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                              side: BorderSide(
                                                                width: 1,
                                                                color:
                                                                    const Color(
                                                                      0xFFFCEDEA,
                                                                    ),
                                                              ),
                                                            ),
                                                      ),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  'Points per \$1',
                                                                  style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        12,
                                                                    fontFamily:
                                                                        'Tenor Sans',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    height:
                                                                        1.33,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 60,
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SizedBox(
                                                                  width: 4.08,
                                                                  height: 15,
                                                                  child: Text(
                                                                    '1',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          10,
                                                                      fontFamily:
                                                                          'Tenor Sans',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      height:
                                                                          1.50,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 60,
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SizedBox(
                                                                  width: 18.98,
                                                                  height: 15,
                                                                  child: Text(
                                                                    '1.25',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          10,
                                                                      fontFamily:
                                                                          'Tenor Sans',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      height:
                                                                          1.50,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 60,
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SizedBox(
                                                                  width: 12.75,
                                                                  height: 15,
                                                                  child: Text(
                                                                    '1.5',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          10,
                                                                      fontFamily:
                                                                          'Tenor Sans',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      height:
                                                                          1.50,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    left: 0,
                                                    top: 57.50,
                                                    child: Container(
                                                      width: 327,
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 12,
                                                          ),
                                                      decoration: ShapeDecoration(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                              side: BorderSide(
                                                                width: 1,
                                                                color:
                                                                    const Color(
                                                                      0xFFFCEDEA,
                                                                    ),
                                                              ),
                                                            ),
                                                      ),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  'Bonus points &\nsavings',
                                                                  style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        12,
                                                                    fontFamily:
                                                                        'Tenor Sans',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    height:
                                                                        1.25,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 60,
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  height: double
                                                                      .infinity,
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            9.50,
                                                                        height:
                                                                            24,
                                                                        child: Text(
                                                                          '♥',
                                                                          style: TextStyle(
                                                                            color: const Color(
                                                                              0xFFD05278,
                                                                            ),
                                                                            fontSize:
                                                                                16,
                                                                            fontFamily:
                                                                                'Liberation Sans',
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            height:
                                                                                1.50,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 60,
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  height: double
                                                                      .infinity,
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            9.50,
                                                                        height:
                                                                            24,
                                                                        child: Text(
                                                                          '♥',
                                                                          style: TextStyle(
                                                                            color: const Color(
                                                                              0xFFD05278,
                                                                            ),
                                                                            fontSize:
                                                                                16,
                                                                            fontFamily:
                                                                                'Liberation Sans',
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            height:
                                                                                1.50,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 60,
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  height: double
                                                                      .infinity,
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            9.50,
                                                                        height:
                                                                            24,
                                                                        child: Text(
                                                                          '♥',
                                                                          style: TextStyle(
                                                                            color: const Color(
                                                                              0xFFD05278,
                                                                            ),
                                                                            fontSize:
                                                                                16,
                                                                            fontFamily:
                                                                                'Liberation Sans',
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            height:
                                                                                1.50,
                                                                          ),
                                                                        ),
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
                                                  Positioned(
                                                    left: 0,
                                                    top: 112.50,
                                                    child: Container(
                                                      width: 327,
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 12,
                                                          ),
                                                      decoration: ShapeDecoration(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                              side: BorderSide(
                                                                width: 1,
                                                                color:
                                                                    const Color(
                                                                      0xFFFCEDEA,
                                                                    ),
                                                              ),
                                                            ),
                                                      ),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  'Redeem for\ndiscounts',
                                                                  style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        12,
                                                                    fontFamily:
                                                                        'Tenor Sans',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    height:
                                                                        1.25,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 60,
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  height: double
                                                                      .infinity,
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            9.50,
                                                                        height:
                                                                            24,
                                                                        child: Text(
                                                                          '♥',
                                                                          style: TextStyle(
                                                                            color: const Color(
                                                                              0xFFD05278,
                                                                            ),
                                                                            fontSize:
                                                                                16,
                                                                            fontFamily:
                                                                                'Liberation Sans',
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            height:
                                                                                1.50,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 60,
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  height: double
                                                                      .infinity,
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            9.50,
                                                                        height:
                                                                            24,
                                                                        child: Text(
                                                                          '♥',
                                                                          style: TextStyle(
                                                                            color: const Color(
                                                                              0xFFD05278,
                                                                            ),
                                                                            fontSize:
                                                                                16,
                                                                            fontFamily:
                                                                                'Liberation Sans',
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            height:
                                                                                1.50,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 60,
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  height: double
                                                                      .infinity,
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            9.50,
                                                                        height:
                                                                            24,
                                                                        child: Text(
                                                                          '♥',
                                                                          style: TextStyle(
                                                                            color: const Color(
                                                                              0xFFD05278,
                                                                            ),
                                                                            fontSize:
                                                                                16,
                                                                            fontFamily:
                                                                                'Liberation Sans',
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            height:
                                                                                1.50,
                                                                          ),
                                                                        ),
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
                                                  Positioned(
                                                    left: 0,
                                                    top: 167.50,
                                                    child: Container(
                                                      width: 327,
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 12,
                                                          ),
                                                      decoration: ShapeDecoration(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                              side: BorderSide(
                                                                width: 1,
                                                                color:
                                                                    const Color(
                                                                      0xFFFCEDEA,
                                                                    ),
                                                              ),
                                                            ),
                                                      ),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        spacing: 60,
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  'Points never\nexpire',
                                                                  style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        12,
                                                                    fontFamily:
                                                                        'Tenor Sans',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    height:
                                                                        1.25,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 60,
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  height: double
                                                                      .infinity,
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            9.50,
                                                                        height:
                                                                            24,
                                                                        child: Text(
                                                                          '♥',
                                                                          style: TextStyle(
                                                                            color: const Color(
                                                                              0xFFD05278,
                                                                            ),
                                                                            fontSize:
                                                                                16,
                                                                            fontFamily:
                                                                                'Liberation Sans',
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            height:
                                                                                1.50,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets.only(
                                                                  right: 60,
                                                                ),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  height: double
                                                                      .infinity,
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            9.50,
                                                                        height:
                                                                            24,
                                                                        child: Text(
                                                                          '♥',
                                                                          style: TextStyle(
                                                                            color: const Color(
                                                                              0xFFD05278,
                                                                            ),
                                                                            fontSize:
                                                                                16,
                                                                            fontFamily:
                                                                                'Liberation Sans',
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            height:
                                                                                1.50,
                                                                          ),
                                                                        ),
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
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 183.50,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 0,
                                        top: 0,
                                        child: Container(
                                          width: 327,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'BIRTHDAY',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 11,
                                                  fontFamily: 'Tenor Sans',
                                                  fontWeight: FontWeight.w400,
                                                  height: 1.50,
                                                  letterSpacing: 1.10,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 0,
                                        top: 24.50,
                                        child: Container(
                                          width: 327,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          decoration: ShapeDecoration(
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                width: 1,
                                                color: const Color(0xFFFCEDEA),
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '2X points\nmonth**',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        fontFamily:
                                                            'Tenor Sans',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        height: 1.25,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: 60,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: double.infinity,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            width: 9.50,
                                                            height: 24,
                                                            child: Text(
                                                              '♥',
                                                              style: TextStyle(
                                                                color:
                                                                    const Color(
                                                                      0xFFD05278,
                                                                    ),
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    'Tenor Sans',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                height: 1.50,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: 60,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: double.infinity,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            width: 9.50,
                                                            height: 24,
                                                            child: Text(
                                                              '♥',
                                                              style: TextStyle(
                                                                color:
                                                                    const Color(
                                                                      0xFFD05278,
                                                                    ),
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    'Tenor Sans',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                height: 1.50,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: 60,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: double.infinity,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            width: 9.50,
                                                            height: 24,
                                                            child: Text(
                                                              '♥',
                                                              style: TextStyle(
                                                                color:
                                                                    const Color(
                                                                      0xFFD05278,
                                                                    ),
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    'Tenor Sans',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                height: 1.50,
                                                              ),
                                                            ),
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
                                      Positioned(
                                        left: 0,
                                        top: 79.50,
                                        child: Container(
                                          width: 327,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          decoration: ShapeDecoration(
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                width: 1,
                                                color: const Color(0xFFFCEDEA),
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Choice of\nBirthday Gift**',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        fontFamily:
                                                            'Tenor Sans',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        height: 1.25,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: 60,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: double.infinity,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            width: 9.50,
                                                            height: 24,
                                                            child: Text(
                                                              '♥',
                                                              style: TextStyle(
                                                                color:
                                                                    const Color(
                                                                      0xFFD05278,
                                                                    ),
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    'Tenor Sans',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                height: 1.50,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: 60,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: double.infinity,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            width: 9.50,
                                                            height: 24,
                                                            child: Text(
                                                              '♥',
                                                              style: TextStyle(
                                                                color:
                                                                    const Color(
                                                                      0xFFD05278,
                                                                    ),
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    'Tenor Sans',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                height: 1.50,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: 60,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: double.infinity,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            width: 9.50,
                                                            height: 24,
                                                            child: Text(
                                                              '♥',
                                                              style: TextStyle(
                                                                color:
                                                                    const Color(
                                                                      0xFFD05278,
                                                                    ),
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    'Tenor Sans',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                height: 1.50,
                                                              ),
                                                            ),
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
                                      Positioned(
                                        left: 0,
                                        top: 134.50,
                                        child: Container(
                                          width: 327,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          decoration: ShapeDecoration(
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                width: 1,
                                                color: const Color(0xFFFCEDEA),
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            spacing: 60,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 78.33,
                                                      height: 16,
                                                      child: Text(
                                                        '\$10 coupon**',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12,
                                                          fontFamily:
                                                              'Tenor Sans',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          height: 1.33,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: 60,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: double.infinity,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            width: 9.50,
                                                            height: 24,
                                                            child: Text(
                                                              '♥',
                                                              style: TextStyle(
                                                                color:
                                                                    const Color(
                                                                      0xFFD05278,
                                                                    ),
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    'Tenor Sans',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                height: 1.50,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(
                                                  right: 60,
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: double.infinity,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            width: 9.50,
                                                            height: 24,
                                                            child: Text(
                                                              '♥',
                                                              style: TextStyle(
                                                                color:
                                                                    const Color(
                                                                      0xFFD05278,
                                                                    ),
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    'Tenor Sans',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                height: 1.50,
                                                              ),
                                                            ),
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
                                    ],
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 149.50,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 0,
                                        top: 0,
                                        child: Container(
                                          width: 327,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 51.47,
                                                height: 17,
                                                child: Text(
                                                  'EXTRAS',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 11,
                                                    fontFamily: 'Tenor Sans',
                                                    fontWeight: FontWeight.w400,
                                                    height: 1.50,
                                                    letterSpacing: 1.10,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 0,
                                        top: 24.50,
                                        child: Container(
                                          width: 327,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          decoration: ShapeDecoration(
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                width: 1,
                                                color: const Color(0xFFFCEDEA),
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            spacing: 60,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 90.38,
                                                      height: 45,
                                                      child: Text(
                                                        'Exclusive deals,\ngifts & early\naccess',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12,
                                                          fontFamily:
                                                              'Tenor Sans',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          height: 1.25,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: 60,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: double.infinity,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            width: 9.50,
                                                            height: 24,
                                                            child: Text(
                                                              '♥',
                                                              style: TextStyle(
                                                                color:
                                                                    const Color(
                                                                      0xFFD05278,
                                                                    ),
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    'Tenor Sans',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                height: 1.50,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(
                                                  right: 60,
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: double.infinity,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            width: 9.50,
                                                            height: 24,
                                                            child: Text(
                                                              '♥',
                                                              style: TextStyle(
                                                                color:
                                                                    const Color(
                                                                      0xFFD05278,
                                                                    ),
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    'Tenor Sans',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                height: 1.50,
                                                              ),
                                                            ),
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
                                      Positioned(
                                        left: 0,
                                        top: 94.50,
                                        child: Container(
                                          width: 327,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          decoration: ShapeDecoration(
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                width: 1,
                                                color: const Color(0xFFFCEDEA),
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            spacing: 120,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Choice of full size\nDiamond Gift',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        fontFamily:
                                                            'Tenor Sans',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        height: 1.25,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: 60,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: double.infinity,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            width: 9.50,
                                                            height: 24,
                                                            child: Text(
                                                              '♥',
                                                              style: TextStyle(
                                                                color:
                                                                    const Color(
                                                                      0xFFD05278,
                                                                    ),
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    'Tenor Sans',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                height: 1.50,
                                                              ),
                                                            ),
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
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 23),
                      decoration: BoxDecoration(color: const Color(0xFFFCEDEA)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 32,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 9,
                            children: [
                              Text(
                                'Points Redeemed',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: 'Tenor Sans',
                                  fontWeight: FontWeight.w400,
                                  height: 1.20,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: double.infinity,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              spacing: 18,
                              children: [
                                ConstrainedBox(
                                  constraints: BoxConstraints(minWidth: 260),
                                  child: Container(
                                    height: 132,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 44,
                                    ),
                                    decoration: ShapeDecoration(
                                      color: const Color(0xFFD05278),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          left: 0,
                                          top: 0,
                                          child: Opacity(
                                            opacity: 0.30,
                                            child: Container(
                                              width: 260,
                                              height: 132,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      height: double.infinity,
                                                      clipBehavior:
                                                          Clip.antiAlias,
                                                      decoration:
                                                          BoxDecoration(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          spacing: 6,
                                          children: [
                                            SizedBox(
                                              width: 65.48,
                                              height: 16,
                                              child: Text(
                                                '1000 PTS',
                                                style: TextStyle(
                                                  color: const Color(
                                                    0xFFFFD7E3,
                                                  ),
                                                  fontSize: 12,
                                                  fontFamily: 'Tenor Sans',
                                                  fontWeight: FontWeight.w400,
                                                  height: 1.33,
                                                  letterSpacing: 1.20,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 128,
                                              height: 40,
                                              child: Text(
                                                '\$50 off',
                                                style: TextStyle(
                                                  color: const Color(
                                                    0xFFFCEDEA,
                                                  ),
                                                  fontSize: 36,
                                                  fontFamily: 'Tenor Sans',
                                                  fontWeight: FontWeight.w400,
                                                  height: 1.11,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 42,
                                            vertical: 1,
                                          ),
                                          decoration: ShapeDecoration(
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                width: 0.50,
                                                color: const Color(0xFFFF84A9),
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            spacing: 10,
                                            children: [
                                              Text(
                                                'Claim',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontFamily: 'Lato',
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                ConstrainedBox(
                                  constraints: BoxConstraints(minWidth: 260),
                                  child: Container(
                                    height: 132,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 44,
                                    ),
                                    decoration: ShapeDecoration(
                                      color: const Color(0xFFD05278),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          left: 0,
                                          top: 0,
                                          child: Opacity(
                                            opacity: 0.30,
                                            child: Container(
                                              width: 260,
                                              height: 132,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      height: double.infinity,
                                                      clipBehavior:
                                                          Clip.antiAlias,
                                                      decoration:
                                                          BoxDecoration(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          spacing: 6,
                                          children: [
                                            SizedBox(
                                              width: 65.48,
                                              height: 16,
                                              child: Text(
                                                '2000 PTS',
                                                style: TextStyle(
                                                  color: const Color(
                                                    0xFFFFD7E3,
                                                  ),
                                                  fontSize: 12,
                                                  fontFamily: 'Tenor Sans',
                                                  fontWeight: FontWeight.w400,
                                                  height: 1.33,
                                                  letterSpacing: 1.20,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 128,
                                              height: 40,
                                              child: Text(
                                                '\$75 off',
                                                style: TextStyle(
                                                  color: const Color(
                                                    0xFFFCEDEA,
                                                  ),
                                                  fontSize: 36,
                                                  fontFamily: 'Tenor Sans',
                                                  fontWeight: FontWeight.w400,
                                                  height: 1.11,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 42,
                                            vertical: 1,
                                          ),
                                          decoration: ShapeDecoration(
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                width: 0.50,
                                                color: const Color(0xFFFF84A9),
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            spacing: 10,
                                            children: [
                                              Text(
                                                'Claim',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontFamily: 'Lato',
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                ConstrainedBox(
                                  constraints: BoxConstraints(minWidth: 260),
                                  child: Container(
                                    height: 132,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 44,
                                    ),
                                    decoration: ShapeDecoration(
                                      color: const Color(0xFFD05278),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          left: 0,
                                          top: 0,
                                          child: Opacity(
                                            opacity: 0.30,
                                            child: Container(
                                              width: 260,
                                              height: 132,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      height: double.infinity,
                                                      clipBehavior:
                                                          Clip.antiAlias,
                                                      decoration:
                                                          BoxDecoration(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          spacing: 6,
                                          children: [
                                            SizedBox(
                                              width: 65.48,
                                              height: 16,
                                              child: Text(
                                                '3000 PTS',
                                                style: TextStyle(
                                                  color: const Color(
                                                    0xFFFFD7E3,
                                                  ),
                                                  fontSize: 12,
                                                  fontFamily: 'Tenor Sans',
                                                  fontWeight: FontWeight.w400,
                                                  height: 1.33,
                                                  letterSpacing: 1.20,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '\$100 off',
                                              style: TextStyle(
                                                color: const Color(0xFFFCEDEA),
                                                fontSize: 36,
                                                fontFamily: 'Tenor Sans',
                                                fontWeight: FontWeight.w400,
                                                height: 1.11,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 42,
                                            vertical: 1,
                                          ),
                                          decoration: ShapeDecoration(
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                width: 0.50,
                                                color: const Color(0xFFFF84A9),
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            spacing: 10,
                                            children: [
                                              Text(
                                                'Claim',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontFamily: 'Lato',
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
            Positioned(
              left: 0,
              top: 2054,
              child: Container(
                width: 375,
                height: 34,
                child: Stack(
                  children: [
                    Positioned(
                      left: 121,
                      top: 21,
                      child: Container(
                        width: 134,
                        height: 5,
                        decoration: ShapeDecoration(
                          color: const Color(0xFF222222),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
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
}
