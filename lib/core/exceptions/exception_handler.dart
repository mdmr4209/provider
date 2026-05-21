import 'dart:io';
import 'package:dio/dio.dart';
import 'app_exceptions.dart';

/// Handles exceptions and converts them to AppException
class ExceptionHandler {
  static AppException handleException(dynamic exception) {
    if (exception is AppException) {
      return exception;
    }

    if (exception is DioException) {
      return _handleDioException(exception);
    }

    if (exception is FormatException) {
      return DataParsingException(
        message: exception.message,
        originalException: exception,
      );
    }

    return GenericException(
      message: exception.toString(),
      originalException: exception,
    );
  }

  static AppException _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(
          originalException: error,
        );

      case DioExceptionType.connectionError:
        return InternetException(
          originalException: error,
        );

      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return InternetException(
            message: 'Failed to connect to server',
            originalException: error,
          );
        }
        return NetworkException(
          message: error.message ?? 'Network error occurred',
          originalException: error,
        );

      case DioExceptionType.badResponse:
        return _handleStatusCode(error);

      case DioExceptionType.cancel:
        return NetworkException(
          message: 'Request cancelled',
          originalException: error,
        );

      case DioExceptionType.badCertificate:
        return NetworkException(
          message: 'Certificate validation failed',
          originalException: error,
        );
    }
  }

  static AppException _handleStatusCode(DioException error) {
    final statusCode = error.response?.statusCode ?? 0;
    final data = error.response?.data;
    final message = _extractErrorMessage(data);

    switch (statusCode) {
      case 400:
        return BadRequestException(
          message: message,
          originalException: error,
        );
      case 401:
        return UnauthorizedException(
          message: message,
          originalException: error,
        );
      case 403:
        return ForbiddenException(
          message: message,
          originalException: error,
        );
      case 404:
        return NotFoundException(
          message: message,
          originalException: error,
        );
      case 422:
        return ValidationException(
          message: message,
          originalException: error,
          errors: data is Map ? data['errors'] : null,
        );
      case 500:
      case 502:
      case 503:
      case 504:
        return ServerException(
          message: message,
          code: '$statusCode',
          originalException: error,
        );
      default:
        return NetworkException(
          message: message,
          code: '$statusCode',
          originalException: error,
        );
    }
  }

  static String _extractErrorMessage(dynamic data) {
    if (data is Map) {
      return data['message']?.toString() ??
          data['error']?.toString() ??
          data['detail']?.toString() ??
          'An error occurred';
    }
    return 'An error occurred';
  }
}

