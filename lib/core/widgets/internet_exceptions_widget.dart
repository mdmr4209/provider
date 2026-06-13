import 'package:flutter/material.dart';

import '../../features/shared/localization/localization_extension.dart';
import '../constants/app_colors.dart';

class InternetExceptionsWidget extends StatelessWidget {
  final VoidCallback onPress;
  const InternetExceptionsWidget({super.key, required this.onPress});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(height: height * .15),
          Icon(Icons.cloud_off, color: AppColors.textColor, size: 50),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Center(
              child: Text(
                context.watchTr('internet_exception'),
                style: TextStyle(
                  color: const Color.fromARGB(255, 12, 0, 2),
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: height * .15),
          InkWell(
            onTap: onPress,
            child: Container(
              height: 44,
              width: 160,
              decoration: BoxDecoration(
                color: AppColors.defaultColor,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Center(
                child: Text(
                  'Retry',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium!.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
