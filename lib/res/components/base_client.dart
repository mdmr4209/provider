import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../widgets/custom_snack_bar.dart';
import '../app_url/app_url.dart';


/// Static HTTP client built on Dio.
class BaseClient {
  static const _storage = FlutterSecureStorage();

  /// Set in main.dart — called when 401 refresh fails (GoRouter redirect).
  static VoidCallback? onUnauthorized;

  // ── Dio singleton ──────────────────────────────────────────────────────────
  static final Dio _dio = _buildDio();

  static Dio _buildDio() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(minutes: 10),
        sendTimeout: const Duration(seconds: 30),
        validateStatus: (_) => true, // handle all status codes manually
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (o) => debugPrint(o.toString()),
        ),
      );
    }

    // Auth + token-refresh interceptor
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
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            final refreshed = await _silentRefresh();
            if (refreshed) {
              final token = await getAccessToken();
              final opts = error.requestOptions
                ..headers['Authorization'] = 'Bearer $token';
              try {
                final retryRes = await _dio.fetch(opts);
                return handler.resolve(retryRes);
              } catch (_) {}
            }
            showErrorSnackBar(
              message: 'Your session has expired. Please log in again.',
            );
            onUnauthorized?.call();
          }
          handler.next(error);
        },
      ),
    );

    return dio;
  }

  // ── Token / Role storage ───────────────────────────────────────────────────
  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> storeRole({required String role}) async {
    await _storage.write(key: 'user_role', value: role);
  }

  static Future<void> storeUserId({required String id}) async {
    await _storage.write(key: 'user_id', value: id);
  }

  static Future<void> store({
    required String key,
    required String value,
  }) async {
    await _storage.write(key: key, value: value);
  }

  static Future<String?> getStored({required String key}) async {
    final v = await _storage.read(key: key);
    return v?.toString();
  }

  static Future<String?> getStoredRole() async {
    final v = await _storage.read(key: 'user_role');
    return v?.toString();
  }

  static Future<int?> getStoredId() async {
    final v = await _storage.read(key: 'user_id');
    return v == null ? null : int.tryParse(v);
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

  static Future<String?> getRefreshToken() =>
      _storage.read(key: 'refresh_token');

  static Future<void> clearTokens() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
    await _storage.delete(key: 'user_role');
    debugPrint('🗑️ Tokens cleared');
  }

  // ── HTTP Methods ───────────────────────────────────────────────────────────
  static Future<Response> getRequest({
    required String api,
    Map<String, dynamic>? params,
    bool authenticated = false,
  }) async {
    try {
      return await _dio.get(
        api,
        queryParameters: params,
        options: Options(extra: {'auth': authenticated}),
      );
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  static Future<Response> postRequest({
    required String api,
    dynamic body,
    bool authenticated = false,
  }) async {
    try {
      return await _dio.post(
        api,
        data: body,
        options: Options(
          extra: {'auth': authenticated},
          contentType: Headers.jsonContentType,
        ),
      );
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  static Future<Response> patchRequest({
    required String api,
    required dynamic body,
    bool authenticated = false,
  }) async {
    try {
      return await _dio.patch(
        api,
        data: body,
        options: Options(
          extra: {'auth': authenticated},
          contentType: Headers.jsonContentType,
        ),
      );
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  static Future<Response> putRequest({
    required String api,
    required dynamic body,
    bool authenticated = false,
  }) async {
    try {
      return await _dio.put(
        api,
        data: body,
        options: Options(
          extra: {'auth': authenticated},
          contentType: Headers.jsonContentType,
        ),
      );
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  static Future<Response> deleteRequest({
    required String api,
    dynamic body,
    bool authenticated = false,
  }) async {
    try {
      return await _dio.delete(
        api,
        data: body,
        options: Options(extra: {'auth': authenticated}),
      );
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  static Future<Response> multipartPutRequest({
    required String api,
    required Map<String, String> fields,
    required String fileKey,
    File? image,
    bool authenticated = false,
  }) async {
    try {
      final formData = FormData.fromMap({
        ...fields,
        if (image != null) fileKey: await MultipartFile.fromFile(image.path),
      });
      return await _dio.put(
        api,
        data: formData,
        options: Options(extra: {'auth': authenticated}),
      );
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  static Future<Response> multipartPostRequest({
    required String api,
    required Map<String, String> fields,
    List<File>? images,
    bool authenticated = false,
  }) async {
    try {
      final Map<String, dynamic> data = {...fields};
      if (images != null) {
        for (int i = 0; i < images.length; i++) {
          data['images[$i]image'] = await MultipartFile.fromFile(
            images[i].path,
          );
        }
      }
      return await _dio.post(
        api,
        data: FormData.fromMap(data),
        options: Options(extra: {'auth': authenticated}),
      );
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  // ── Response handler ───────────────────────────────────────────────────────
  static dynamic handleResponse(Response response) {
    final status = response.statusCode ?? 0;
    if (status >= 200 && status <= 210) return response.data;
    if (status == 401) {
      showErrorSnackBar(
        message: 'Your session has expired. Please log in again.',
      );
      onUnauthorized?.call();
      return null;
    }
    if (status == 404) {
      showErrorSnackBar(message: 'The requested resource was not found.');
      throw 'Resource not found';
    }
    if (status == 400) {
      showErrorSnackBar(
        message: _extractErrorMessage(response.data, 'Invalid request data'),
      );
      return null;
    }
    if (status == 403) {
      showErrorSnackBar(
        message: 'You do not have permission to access this resource.',
      );
      throw 'Forbidden';
    }
    if (status == 500) {
      showErrorSnackBar(
        message: 'A server error occurred. Please try again later.',
      );
      throw 'Server Error';
    }
    final msg = _extractErrorMessage(response.data, 'Something went wrong');
    showErrorSnackBar(message: msg);
    throw msg;
  }

  // ── Private helpers ────────────────────────────────────────────────────────
  static void _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      showErrorSnackBar(
        message: 'The request took too long. Please check your connection.',
      );
    } else if (e.type == DioExceptionType.connectionError) {
      showErrorSnackBar(message: 'No internet connection. Please try again.');
    } else {
      showErrorSnackBar(message: 'A network error occurred. Please try again.');
    }
  }

  static String _extractErrorMessage(dynamic data, String defaultMsg) {
    if (data == null) return defaultMsg;
    if (data is Map) {
      return data['errors']?.toString() ??
          data['detail']?.toString() ??
          data['non_field_errors']?.toString() ??
          data['message']?.toString() ??
          data['error']?.toString() ??
          defaultMsg;
    }
    return defaultMsg;
  }

  static Future<bool> _silentRefresh() async {
    try {
      final refresh = await getRefreshToken();
      if (refresh == null) return false;
      final response = await Dio().post(
        Api.createToken,
        data: {'refresh_token': refresh},
        options: Options(contentType: Headers.jsonContentType),
      );
      if ((response.statusCode ?? 0) >= 200 &&
          (response.statusCode ?? 0) <= 210) {
        final newAccess = response.data['access_token'] as String?;
        if (newAccess != null) {
          await _storage.write(key: 'access_token', value: newAccess);
          debugPrint('🔐 Token silently refreshed');
          return true;
        }
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
