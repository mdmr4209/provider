import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../res/assets/image_assets.dart';
import '../../../../res/colors/app_color.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/input_text_widget.dart';
import '../providers/auth_provider.dart';

class ForgetPasswordView extends StatelessWidget {
  const ForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Forget Password', style: TextStyle(fontSize: 25)),
        centerTitle: true,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, auth, _) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              SvgPicture.asset(ImageAssets.mail, width: 80, height: 80),
              const SizedBox(height: 10),
              const Text(
                'Enter your email address to reset your password',
                style: TextStyle(
                  fontSize: 18,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              InputTextWidget(
                hintText: 'user@mail.com',
                leading: true,
                leadingIcon: ImageAssets.mail,
                textEditingController: auth.forgetEmailController,
                onChanged: (v) => auth.forgetEmailController.text = v,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'We will send an email to verify.....',
                  style: TextStyle(
                    color: AppColor.textColor,
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.60,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              auth.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : CustomButton(
                      onPress: () async {
                        if (auth.forgetEmailController.text.isNotEmpty) {
                          await auth.forget();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter an email'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      title: 'Continue',
                      fontWeight: FontWeight.w700,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
