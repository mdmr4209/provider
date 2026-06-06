import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'custom_loader.dart';

class FullScreenImageViewer extends StatefulWidget {
  final String imageUrl;
  final bool isLocalFile;

  const FullScreenImageViewer({
    super.key,
    required this.imageUrl,
    this.isLocalFile = false,
  });

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  bool _isPreloading = true;

  @override
  void initState() {
    super.initState();
    // Pre-loading delay
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _isPreloading = false;
        });
      }
    });
  }

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
        child: _isPreloading
            ? const CustomLoader(size: 80)
            : InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: widget.isLocalFile
                    ? Image.file(
                        File(widget.imageUrl),
                        fit: BoxFit.contain,
                        width: double.infinity,
                        height: double.infinity,
                      )
                    : Image.network(
                        widget.imageUrl,
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
              ),
      ),
    );
  }
}
