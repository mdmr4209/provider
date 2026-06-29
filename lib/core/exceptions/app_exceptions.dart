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
    super.message = 'No internet connection',
    super.code,
    super.originalException,
  }) : super(title: 'Connectivity Issue', isCritical: true);
}

/// Request timeout exception
class TimeoutException extends AppException {
  TimeoutException({
    super.message = 'Request timeout',
    super.code,
    super.originalException,
  }) : super(title: 'Timeout', isCritical: true);
}

/// Bad request exception (400)
class BadRequestException extends AppException {
  BadRequestException({
    required super.message,
    String? code,
    super.originalException,
  }) : super(title: 'Invalid Request', isCritical: false, code: code ?? '400');
}

/// Unauthorized exception (401)
class UnauthorizedException extends AppException {
  UnauthorizedException({
    super.message = 'Unauthorized access',
    String? code,
    super.originalException,
  }) : super(title: 'Unauthorized', isCritical: false, code: code ?? '401');
}

/// Forbidden exception (403)
class ForbiddenException extends AppException {
  ForbiddenException({
    super.message = 'Access forbidden',
    String? code,
    super.originalException,
  }) : super(title: 'Forbidden', isCritical: false, code: code ?? '403');
}

/// Not found exception (404)
class NotFoundException extends AppException {
  NotFoundException({
    required super.message,
    String? code,
    super.originalException,
  }) : super(title: 'Not Found', isCritical: false, code: code ?? '404');
}

/// Server exception (500, 502, 503, 504)
class ServerException extends AppException {
  ServerException({
    super.message = 'Server error',
    String? code,
    super.originalException,
  }) : super(title: 'Server Error', isCritical: true, code: code ?? '500');
}

/// Validation exception (422)
class ValidationException extends AppException {
  final Map<String, dynamic>? errors;

  ValidationException({
    super.message = 'Validation error',
    String? code,
    super.originalException,
    this.errors,
  }) : super(
         title: 'Validation Failed',
         isCritical: false,
         code: code ?? '422',
       );
}

/// Generic network exception
class NetworkException extends AppException {
  NetworkException({
    required super.message,
    super.code,
    super.originalException,
  }) : super(title: 'Network Error', isCritical: false);
}

// ── App-Level Exceptions ───────────────────────────────────────────────

/// Generic app exception
class GenericException extends AppException {
  GenericException({
    super.message = 'Something went wrong',
    super.code,
    super.originalException,
  }) : super(title: 'Error', isCritical: false);
}

/// Authentication exception
class AuthException extends AppException {
  AuthException({required super.message, super.code, super.originalException})
    : super(title: 'Authentication Error', isCritical: false);
}

/// Data parsing exception
class DataParsingException extends AppException {
  DataParsingException({
    super.message = 'Failed to parse data',
    super.code,
    super.originalException,
  }) : super(title: 'Parsing Error', isCritical: true);
}

/// Cache exception
class CacheException extends AppException {
  CacheException({
    super.message = 'Cache error',
    super.code,
    super.originalException,
  }) : super(title: 'Cache Error', isCritical: false);
}
