import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showBreathingDialog(
    BuildContext context, {
      required String title,
      required String description,
      required String primaryButtonText,
      required VoidCallback onPrimaryTap,
    }) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.65),
    builder: (_) {
      return Dialog(
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 18,
                sigmaY: 18,
              ),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 18.w,
                  vertical: 22.h,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),

                  // GLASS EFFECT
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.08),
                      Colors.white.withOpacity(0.03),
                    ],
                  ),

                  border: Border.all(
                    color: const Color(0xFFD4AF37).withOpacity(0.28),
                    width: 1,
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 30,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),

                child: Stack(
                  children: [

                    /// SOFT GLOW
                    Positioned(
                      top: -40,
                      left: -20,
                      right: -20,
                      child: Container(
                        height: 90.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.10),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),

                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        /// SMALL TOP TEXT
                        Text(
                          "Stop. Don't press send. 🛑",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.18),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SizedBox(height: 10.h),

                        /// TITLE
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.92),
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                          ),
                        ),

                        SizedBox(height: 18.h),

                        /// DESCRIPTION
                        Text(
                          description,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.72),
                            fontSize: 14.sp,
                            height: 1.55,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        SizedBox(height: 26.h),

                        /// PRIMARY BUTTON
                        GestureDetector(
                          onTap: onPrimaryTap,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 15.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),

                              gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color(0xFFB8862F),
                                  Color(0xFFD4AF37),
                                ],
                              ),

                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFD4AF37)
                                      .withOpacity(0.25),
                                  blurRadius: 18,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Text(
                              primaryButtonText,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 14.h),

                        /// SECONDARY BUTTON
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: const Color(0xFFD4AF37)
                                    .withOpacity(0.6),
                              ),
                              color: Colors.transparent,
                            ),
                            child: Text(
                              '"No, I\'m okay for now."',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.92),
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 16.h),

                        /// FOOTER TEXT
                        Text(
                          "4 sec each · 3 rounds · guided breathing",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.18),
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
      );
    },
  );
}