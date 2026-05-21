/// Base exception class
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalException;

  AppException({
    required this.message,
    this.code,
    this.originalException,
  });

  @override
  String toString() => message;
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
    code: code,
    originalException: originalException,
  );
}

