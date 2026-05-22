import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';
import '../exceptions/app_exceptions.dart';

/// Widget to display app exceptions
class ErrorDisplayWidget extends StatelessWidget {
  final AppException exception;
  final VoidCallback? onRetry;
  final bool isFullScreen;

  const ErrorDisplayWidget({
    Key? key,
    required this.exception,
    this.onRetry,
    this.isFullScreen = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isFullScreen
        ? _buildFullScreenError(context)
        : _buildInlineError(context);
  }

  Widget _buildFullScreenError(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getErrorIcon(),
                size: 80.w,
                color: _getErrorColor(),
              ),
              SizedBox(height: 24.h),
              Text(
                exception.title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color ?? AppColors.textColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),
              Text(
                exception.message,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textColor2,
                ),
                textAlign: TextAlign.center,
              ),
              if (onRetry != null) ...[
                SizedBox(height: 32.h),
                ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: Text(
                    'Retry',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInlineError(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: _getErrorColor().withValues(alpha: 0.1),
        border: Border.all(color: _getErrorColor(), width: 1.5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Icon(
              _getErrorIcon(),
              color: _getErrorColor(),
              size: 24.w,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    exception.title,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: _getErrorColor(),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    exception.message,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textColor2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (onRetry != null) ...[
              SizedBox(width: 12.w),
              GestureDetector(
                onTap: onRetry,
                child: Icon(
                  Icons.refresh,
                  color: _getErrorColor(),
                  size: 20.w,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getErrorIcon() {
    if (exception is InternetException) return Icons.cloud_off;
    if (exception is TimeoutException) return Icons.schedule;
    if (exception is UnauthorizedException) return Icons.lock;
    if (exception is NotFoundException) return Icons.search_off;
    if (exception is ValidationException) return Icons.warning_amber_rounded;
    return Icons.error_outline;
  }

  Color _getErrorColor() {
    if (exception is InternetException) return Colors.orange;
    if (exception is TimeoutException) return Colors.amber;
    if (exception is UnauthorizedException) return Colors.red;
    if (exception is ValidationException) return Colors.orangeAccent;
    return Colors.red;
  }
}
