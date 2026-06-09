import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'custom_loader.dart';

class FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;
  final bool isLocalFile;

  const FullScreenImageViewer({
    super.key,
    required this.imageUrl,
    this.isLocalFile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Back",
          style: TextStyle(color: Colors.white, fontSize: 16.sp),
        ),
      ),
      body: Center(
        child: FutureBuilder(
          future: Future.delayed(const Duration(milliseconds: 1000)),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const CustomLoader(size: 80);
            }
            return InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: isLocalFile
                  ? Image.file(
                      File(imageUrl),
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: double.infinity,
                    )
                  : Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CustomLoader(size: 150.r),
                        );
                      },
                    ),
            );
          },
        ),
      ),
    );
  }
}
