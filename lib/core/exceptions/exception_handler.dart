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

  /// Handles manual response checks when Dio validateStatus allows error codes
  static AppException handleResponse(Response response) {
    return _handleStatusCode(response.statusCode ?? 0, response.data, null);
  }

  static AppException _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(originalException: error);

      case DioExceptionType.connectionError:
        return InternetException(originalException: error);

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
        return _handleStatusCode(
          error.response?.statusCode ?? 0,
          error.response?.data,
          error,
        );

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

  static AppException _handleStatusCode(
    int statusCode,
    dynamic data,
    dynamic original,
  ) {
    final message = _extractErrorMessage(data);

    switch (statusCode) {
      case 400:
        return BadRequestException(
          message: message,
          originalException: original,
        );
      case 401:
        return UnauthorizedException(
          message: message,
          originalException: original,
        );
      case 403:
        return ForbiddenException(
          message: message,
          originalException: original,
        );
      case 404:
        return NotFoundException(message: message, originalException: original);
      case 422:
        return ValidationException(
          message: message,
          originalException: original,
          errors: data is Map ? data['errors'] : null,
        );
      case 500:
      case 502:
      case 503:
      case 504:
        return ServerException(
          message: message,
          code: '$statusCode',
          originalException: original,
        );
      default:
        return NetworkException(
          message: message,
          code: '$statusCode',
          originalException: original,
        );
    }
  }

  static String _extractErrorMessage(dynamic data) {
    if (data is Map) {
      return data['message']?.toString() ??
          data['error']?.toString() ??
          data['detail']?.toString() ??
          data['msg']?.toString() ??
          (data['errors'] is Map
              ? (data['errors'] as Map).values.first.toString()
              : null) ??
          'An error occurred';
    }
    return 'An error occurred';
  }
}
