import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../res/colors/app_color.dart';
import '../../../../res/components/api_service.dart';

class FullScreenImageView extends StatelessWidget {
  final String imageUrl;
  final String fileName;

  FullScreenImageView({
    super.key,
    required this.imageUrl,
    required this.fileName,
  });

  final ApiService apiService = ApiService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.blackColor,
      appBar: AppBar(
        backgroundColor: AppColor.blackColor,
        title: Text(fileName, style: TextStyle(color: AppColor.hintTextColor)),
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColor.hintTextColor),
        actionsIconTheme: const IconThemeData(color: AppColor.hintTextColor),
        actions: [
          PopupMenuButton<String>(
            color: AppColor.whiteTextColor,
            onSelected: (value) async {
              if (value == 'download') {
                await apiService.downloadFile(imageUrl, fileName);
                Get.snackbar(
                  "Download",
                  "Downloading $fileName...",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColor.whiteTextColor,
                  colorText: AppColor.whiteTextColor,
                );
              }
            },
            itemBuilder:
                (context) => [
              const PopupMenuItem(
                value: 'download',
                child: Row(
                  children: [
                    Icon(Icons.download, color: AppColor.blackColor),
                    SizedBox(width: 8),
                    Text("Download"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 0.5,
          maxScale: 4,
          child: Image.network(imageUrl, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
