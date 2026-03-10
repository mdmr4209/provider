//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../controllers/auth_controller.dart';
// import 'sign_up_view.dart';
//
// class LoginPage extends GetView<AuthController> {
//   LoginPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;
//
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//         resizeToAvoidBottomInset: true,
//         body: Stack(
//           children: [
//
//             Positioned(
//               top: 0,
//               left: 0,
//               right: 0,
//               child: Image.asset(
//                 'assets/images/logo2.png',
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//               ),
//             ),
//
//             AnimatedPositioned(
//               duration: Duration(milliseconds: 200),
//               curve: Curves.ease,
//               top: isKeyboardOpen ? 50 : 325,
//               left: 0,
//               right: 0,
//               child: Stack(
//                 children: [
//                   Image.asset(
//                     'assets/images/img_2.png',
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                   Positioned(
//                     top: 50,
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                       child: SizedBox(
//                         height: 500,
//                         width: 400,
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                           child: Column(
//                             children: [
//                               SizedBox(height: 20),
//                               Text(
//                                 'Login',
//                                 style: TextStyle(
//                                   fontSize: 40,
//                                   fontWeight: FontWeight.bold,
//                                   letterSpacing: 2,
//                                 ),
//                               ),
//                               SizedBox(height: 10),
//                               Text(
//                                 'Login to your account',
//                                 style: TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               SizedBox(height: 20),
//                               // CustomTextFieldForSetting(
//                               //   textInputType: TextInputType.text,
//                               //   hintText: 'user@gmail.com',
//                               //   prefixicon: Icons.email,
//                               // ),
//                               // Obx(
//                               //       () => CustomTextFieldForSetting(
//                               //     textInputType: TextInputType.number,
//                               //     hintText: 'Password',
//                               //     isPassword: authcontroller.ispasswordvisible.value,
//                               //     suffixicon: authcontroller.ispasswordvisible.value
//                               //         ? Icons.visibility_off
//                               //         : Icons.visibility,
//                               //     prefixicon: Icons.lock,
//                               //     onSuffixTap: () {
//                               //       authcontroller.ispasswordvisible.toggle();
//                               //     },
//                               //   ),
//                               // ),
//                               SizedBox(height: 20),
//                               // Row(
//                               //   children: [
//                               //     GestureDetector(
//                               //       onTap: () {
//                               //         authcontroller.isremembered.toggle();
//                               //       },
//                               //       child: Obx(
//                               //             () => Container(
//                               //           width: 20,
//                               //           height: 20,
//                               //           decoration: BoxDecoration(
//                               //             color: authcontroller.isremembered.value
//                               //                 ? AppColors.darkOlive
//                               //                 : AppColors.transparent,
//                               //             border: Border.all(
//                               //               color: authcontroller.isremembered.value
//                               //                   ? AppColors.transparent
//                               //                   : AppColors.mediumGray,
//                               //             ),
//                               //           ),
//                               //           child: Center(
//                               //             child: Icon(
//                               //               Icons.check,
//                               //               color: authcontroller.isremembered.value
//                               //                   ? AppColors.pureWhite
//                               //                   : AppColors.transparent,
//                               //               size: 18,
//                               //             ),
//                               //           ),
//                               //         ),
//                               //       ),
//                               //     ),
//                               //     SizedBox(width: 10),
//                               //     Text(
//                               //       'Remember Me',
//                               //       style: TextStyle(
//                               //         color: AppColors.veryDarkGray,
//                               //         fontSize: 14,
//                               //       ),
//                               //     ),
//                               //     Spacer(),
//                               //     InkWell(
//                               //       onTap: (){
//                               //         Get.to(Passchange(),transition: Transition.rightToLeft);
//                               //       },
//                               //       child: Text(
//                               //         'Forgot password?',
//                               //         style: TextStyle(
//                               //           fontSize: 15,
//                               //           color: AppColors.darkOlive,
//                               //           fontWeight: FontWeight.bold,
//                               //         ),
//                               //         textAlign: TextAlign.center,
//                               //       ),
//                               //     ),
//                               //   ],
//                               // ),
//                               SizedBox(height: 30),
//                               // CustomActionButton(
//                               //   text: 'Login',
//                               //   onPressed: () {Get.to(Navigation(),transition: Transition.rightToLeft);},
//                               //   backgroundColor: AppColors.darkOlive,
//                               //   borderColor: AppColors.transparent,
//                               // ),
//                               SizedBox(height: 20),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     'Don’t have account?',
//                                     style: TextStyle(
//                                       fontSize: 15,
//                                     ),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                   InkWell(
//                                     onTap: () {
//                                       Get.to(SignUpView(), transition: Transition.rightToLeft);
//                                     },
//                                     child: Text(
//                                       ' Register',
//                                       style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
