import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:newproject/core/constants/app_colors.dart';
import 'package:provider/provider.dart';
import '../../../../routes/app_router.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/input_text_widget.dart';
import '../controllers/auth_controller.dart';
import '../../localization/localization_extension.dart';
import 'setup/setup_base_view.dart';

class NameInputView extends StatelessWidget {
  final String role;
  const NameInputView({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthController>();

    return SetupBaseView(
      currentStep: 2, // 2/15
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Text(
                "Hi There!👋",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 8.h),
              Text(
                "You selected: $role",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              SizedBox(height: 40.h),
              InputTextWidget(
                hintText: context.watchTr('enter_your_name'),
                controller: auth.nameController,
                keyboardType: TextInputType.name,
                onChanged: (_) {
                  // This triggers rebuild of this widget to re-evaluate the button state
                  (context as Element).markNeedsBuild();
                },
              ),
              const Spacer(),
              ListenableBuilder(
                listenable: auth.nameController,
                builder: (context, _) {
                  final bool isNameEntered = auth.nameController.text.trim().isNotEmpty;

                  return CustomButton(
                    title: "Continue",
                    linearGradient:isNameEntered? true:false,
                    onPress: isNameEntered
                        ? () async {
                            context.push(AppRoutes.setup1);
                          }
                        : null,
                  );
                },
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
