/// Base exception class for the application
abstract class AppException implements Exception {
  final String message;
  final String title;
  final String? code;
  final bool isCritical;
  final dynamic originalException;

  AppException({
    required this.message,
    required this.title,
    this.isCritical = false,
    this.code,
    this.originalException,
  });

  @override
  String toString() => '$title: $message';

  /// Helper to check if the error is network related
  bool get isNetworkError => 
    this is InternetException || 
    this is TimeoutException || 
    this is NetworkException;

  /// Helper to check if the error is auth related
  bool get isAuthError => 
    this is UnauthorizedException || 
    this is ForbiddenException || 
    this is AuthException;
}

// ── Network Exceptions ─────────────────────────────────────────────────

/// Internet connection exception
class InternetException extends AppException {
  InternetException({
    String message = 'No internet connection',
    String? code,
    dynamic originalException,
  }) : super(
          message: message,
          title: 'Connectivity Issue',
          isCritical: true,
          code: code,
          originalException: originalException,
        );
}

/// Request timeout exception
class TimeoutException extends AppException {
  TimeoutException({
    String message = 'Request timeout',
    String? code,
    dynamic originalException,
  }) : super(
          message: message,
          title: 'Timeout',
          isCritical: true,
          code: code,
          originalException: originalException,
        );
}

/// Bad request exception (400)
class BadRequestException extends AppException {
  BadRequestException({
    required String message,
    String? code,
    dynamic originalException,
  }) : super(
          message: message,
          title: 'Invalid Request',
          isCritical: false,
          code: code ?? '400',
          originalException: originalException,
        );
}

/// Unauthorized exception (401)
class UnauthorizedException extends AppException {
  UnauthorizedException({
    String message = 'Unauthorized access',
    String? code,
    dynamic originalException,
  }) : super(
          message: message,
          title: 'Unauthorized',
          isCritical: false,
          code: code ?? '401',
          originalException: originalException,
        );
}

/// Forbidden exception (403)
class ForbiddenException extends AppException {
  ForbiddenException({
    String message = 'Access forbidden',
    String? code,
    dynamic originalException,
  }) : super(
          message: message,
          title: 'Forbidden',
          isCritical: false,
          code: code ?? '403',
          originalException: originalException,
        );
}

/// Not found exception (404)
class NotFoundException extends AppException {
  NotFoundException({
    required String message,
    String? code,
    dynamic originalException,
  }) : super(
          message: message,
          title: 'Not Found',
          isCritical: false,
          code: code ?? '404',
          originalException: originalException,
        );
}

/// Server exception (500, 502, 503, 504)
class ServerException extends AppException {
  ServerException({
    String message = 'Server error',
    String? code,
    dynamic originalException,
  }) : super(
          message: message,
          title: 'Server Error',
          isCritical: true,
          code: code ?? '500',
          originalException: originalException,
        );
}

/// Validation exception (422)
class ValidationException extends AppException {
  final Map<String, dynamic>? errors;

  ValidationException({
    String message = 'Validation error',
    String? code,
    dynamic originalException,
    this.errors,
  }) : super(
          message: message,
          title: 'Validation Failed',
          isCritical: false,
          code: code ?? '422',
          originalException: originalException,
        );
}

/// Generic network exception
class NetworkException extends AppException {
  NetworkException({
    required String message,
    String? code,
    dynamic originalException,
  }) : super(
          message: message,
          title: 'Network Error',
          isCritical: false,
          code: code,
          originalException: originalException,
        );
}

// ── App-Level Exceptions ───────────────────────────────────────────────

/// Generic app exception
class GenericException extends AppException {
  GenericException({
    String message = 'Something went wrong',
    String? code,
    dynamic originalException,
  }) : super(
          message: message,
          title: 'Error',
          isCritical: false,
          code: code,
          originalException: originalException,
        );
}

/// Authentication exception
class AuthException extends AppException {
  AuthException({
    required String message,
    String? code,
    dynamic originalException,
  }) : super(
          message: message,
          title: 'Authentication Error',
          isCritical: false,
          code: code,
          originalException: originalException,
        );
}

/// Data parsing exception
class DataParsingException extends AppException {
  DataParsingException({
    String message = 'Failed to parse data',
    String? code,
    dynamic originalException,
  }) : super(
          message: message,
          title: 'Parsing Error',
          isCritical: true,
          code: code,
          originalException: originalException,
        );
}

/// Cache exception
class CacheException extends AppException {
  CacheException({
    String message = 'Cache error',
    String? code,
    dynamic originalException,
  }) : super(
          message: message,
          title: 'Cache Error',
          isCritical: false,
          code: code,
          originalException: originalException,
        );
}
