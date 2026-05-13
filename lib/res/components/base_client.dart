import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../widgets/snack_bar_helper.dart';
import '../app_url/app_url.dart';

/// Robust HTTP client built on Dio with automatic token refresh and centralized error handling.
/// Supports GET, POST, PUT, PATCH, DELETE and Multipart for all methods.
class BaseClient {
  static const _storage = FlutterSecureStorage();

  /// Set in main.dart — called when 401 refresh fails to redirect the user to login.
  static VoidCallback? onUnauthorized;

  // ── Dio singleton ──────────────────────────────────────────────────────────
  static final Dio _dio = _buildDio();

  static Dio _buildDio() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(minutes: 10),
        sendTimeout: const Duration(seconds: 30),
        // By default, Dio throws for status codes >= 400.
        // We'll catch them in onError interceptor for global handling.
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
          logPrint: (o) => debugPrint('🌐 [API]: ${o.toString()}'),
        ),
      );
    }

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (options.extra['auth'] == true) {
            final token = await getAccessToken();
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          handler.next(options);
        },
        onError: (DioException error, handler) async {
          final statusCode = error.response?.statusCode;
          final isAuthReq = error.requestOptions.extra['auth'] == true;

          // 1. Automatic 401 handling: Attempt to refresh token if authorized request fails
          if (statusCode == 401 && isAuthReq) {
            final refreshed = await _silentRefresh();
            if (refreshed) {
              final token = await getAccessToken();
              final opts = error.requestOptions;
              opts.headers['Authorization'] = 'Bearer $token';
              
              try {
                // Retry the original request with a fresh Dio instance to avoid looping
                final retryRes = await Dio(_dio.options).fetch(opts);
                return handler.resolve(retryRes);
              } catch (e) {
                return handler.next(error);
              }
            } else {
              showErrorSnackBar(message: 'Session expired. Please log in again.');
              onUnauthorized?.call();
              return handler.next(error);
            }
          }

          // 2. Centralized Error Handling for all other status codes
          _handleDioError(error);
          handler.next(error);
        },
      ),
    );

    return dio;
  }

  // ── Storage Helpers ────────────────────────────────────────────────────────
  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> storeTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
    debugPrint('🔐 Tokens saved');
  }

  static Future<String?> getAccessToken() => _storage.read(key: 'access_token');
  static Future<String?> getRefreshToken() => _storage.read(key: 'refresh_token');

  static Future<void> store({required String key, required String value}) async =>
      await _storage.write(key: key, value: value);

  static Future<String?> getStored({required String key}) => _storage.read(key: key);

  static Future<void> storeRole({required String role}) async => await _storage.write(key: 'user_role', value: role);
  static Future<String?> getStoredRole() => _storage.read(key: 'user_role');

  static Future<void> storeUserId({required String id}) async => await _storage.write(key: 'user_id', value: id);
  static Future<int?> getStoredId() async {
    final v = await _storage.read(key: 'user_id');
    return v == null ? null : int.tryParse(v);
  }

  static Future<void> clearTokens() async {
    await _storage.deleteAll();
    debugPrint('🗑️ All auth data cleared');
  }

  // ── Unified Request Core ───────────────────────────────────────────────────
  /// Main entry point for all network calls.
  /// Handles GET, POST, PUT, PATCH, DELETE and Multipart automatically.
  static Future<Response?> safeRequest({
    required String api,
    required String method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool authenticated = false,
    bool isMultipart = false,
  }) async {
    try {
      dynamic finalData = data;
      
      // Auto-convert to FormData if Multipart is specified and data is a Map
      if (isMultipart && data is Map<String, dynamic>) {
        finalData = await _convertToFormData(data);
      }

      return await _dio.request(
        api,
        data: finalData,
        queryParameters: queryParameters,
        options: Options(
          method: method,
          extra: {'auth': authenticated},
          contentType: isMultipart ? 'multipart/form-data' : Headers.jsonContentType,
        ),
      );
    } on DioException {
      // Handled globally in Interceptor
      return null;
    } catch (e) {
      debugPrint('❌ Unexpected Error: $e');
      return null;
    }
  }

  // ── API Methods ────────────────────────────────────────────────────────────
  
  static Future<Response?> get({
    required String api,
    Map<String, dynamic>? params,
    bool auth = false,
  }) => safeRequest(api: api, method: 'GET', queryParameters: params, authenticated: auth);

  static Future<Response?> post({
    required String api,
    dynamic data,
    bool auth = false,
    bool multipart = false,
  }) => safeRequest(api: api, method: 'POST', data: data, authenticated: auth, isMultipart: multipart);

  static Future<Response?> put({
    required String api,
    dynamic data,
    bool auth = false,
    bool multipart = false,
  }) => safeRequest(api: api, method: 'PUT', data: data, authenticated: auth, isMultipart: multipart);

  static Future<Response?> patch({
    required String api,
    dynamic data,
    bool auth = false,
    bool multipart = false,
  }) => safeRequest(api: api, method: 'PATCH', data: data, authenticated: auth, isMultipart: multipart);

  static Future<Response?> delete({
    required String api,
    dynamic data,
    bool auth = false,
  }) => safeRequest(api: api, method: 'DELETE', data: data, authenticated: auth);

  // ── Error & Response Handling ──────────────────────────────────────────────
  
  static void _handleDioError(DioException e) {
    String message = 'Unexpected error occurred';
    
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      message = 'Request timed out. Check your connection.';
    } else if (e.type == DioExceptionType.connectionError) {
      message = 'Internet connection lost.';
    } else if (e.error is SocketException) {
      message = 'Could not reach the server.';
    } else if (e.response != null) {
      final status = e.response!.statusCode;
      final data = e.response!.data;

      switch (status) {
        case 400:
          message = _extractErrorMessage(data, 'Bad Request (400)');
          break;
        case 401:
          // 401 is handled for auth:true requests in interceptor.
          // This case catches guest 401s or failed refreshes.
          message = 'Unauthorized access (401).';
          break;
        case 402:
          message = 'Payment Required (402).';
          break;
        case 403:
          message = 'Forbidden: Access denied (403).';
          break;
        case 404:
          message = 'Resource not found (404).';
          break;
        case 405:
          message = 'Method not allowed (405).';
          break;
        case 408:
          message = 'Request Timeout (408).';
          break;
        case 422:
          message = _extractErrorMessage(data, 'Validation Error (422)');
          break;
        case 429:
          message = 'Too many requests. Please slow down.';
          break;
        case 500:
          message = 'Internal Server Error (500).';
          break;
        case 502:
          message = 'Bad Gateway (502). Server might be down.';
          break;
        case 503:
          message = 'Service Unavailable (503).';
          break;
        case 504:
          message = 'Gateway Timeout (504).';
          break;
        default:
          message = _extractErrorMessage(data, 'Error code: $status');
      }
    }

    showErrorSnackBar(message: message);
  }

  static String _extractErrorMessage(dynamic data, String defaultMsg) {
    if (data is Map) {
      return data['message']?.toString() ??
          data['error']?.toString() ??
          data['errors']?.toString() ??
          data['detail']?.toString() ??
          data['details']?.toString() ??
          data['msg']?.toString() ??
          (data['errors'] is Map ? (data['errors'] as Map).values.first.toString() : null) ??
          (data['errors'] is List ? (data['errors'] as List).first.toString() : null) ??
          defaultMsg;
    }
    return defaultMsg;
  }

  // ── Silent Token Refresh ───────────────────────────────────────────────────
  static Future<bool> _silentRefresh() async {
    try {
      final refresh = await getRefreshToken();
      if (refresh == null) return false;

      // Use a pure Dio instance to avoid infinite interceptor loops
      final response = await Dio().post(
        Api.refreshTokenUrl,
        data: {'refresh': refresh},
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200) {
        final newAccess = response.data['access'] as String? ?? response.data['access_token'] as String?;
        if (newAccess != null) {
          await _storage.write(key: 'access_token', value: newAccess);
          final newRefresh = response.data['refresh'] as String? ?? response.data['refresh_token'] as String?;
          if (newRefresh != null) {
            await _storage.write(key: 'refresh_token', value: newRefresh);
          }
          debugPrint('🔐 Access token successfully refreshed');
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint('❌ Silent refresh failed: $e');
      return false;
    }
  }

  /// Extracts data if response is successful.
  static dynamic handleResponse(Response? response) {
    if (response == null) return null;
    final status = response.statusCode ?? 0;
    if (status >= 200 && status < 300) {
      return response.data;
    }
    return null;
  }

  // ── Internal Multipart Utility ─────────────────────────────────────────────
  static Future<FormData> _convertToFormData(Map<String, dynamic> data) async {
    final Map<String, dynamic> formDataMap = {};
    for (var entry in data.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value is File) {
        formDataMap[key] = await MultipartFile.fromFile(value.path, filename: value.path.split('/').last);
      } else if (value is List<File>) {
        formDataMap[key] = await Future.wait(value.map((f) => MultipartFile.fromFile(f.path, filename: f.path.split('/').last)));
      } else {
        formDataMap[key] = value;
      }
    }
    return FormData.fromMap(formDataMap);
  }
}
