import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';

class AuthInterceptor extends Interceptor {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;
  bool _isRefreshing = false;

  AuthInterceptor(this._dio, this._secureStorage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.path.contains('/auth/login') ||
        options.path.contains('/auth/signup') ||
        options.path.contains('/auth/refresh')) {
      return handler.next(options);
    }

    final token = await _secureStorage.read(key: AppConstants.accessTokenKey);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;
      try {
        final refreshToken = await _secureStorage.read(key: AppConstants.refreshTokenKey);
        if (refreshToken != null) {
          final response = await Dio().post(
            '${AppConstants.baseUrl}/auth/refresh',
            data: {'refresh_token': refreshToken},
          );

          final newAccessToken = response.data['access_token'];
          final newRefreshToken = response.data['refresh_token'];

          await _secureStorage.write(key: AppConstants.accessTokenKey, value: newAccessToken);
          await _secureStorage.write(key: AppConstants.refreshTokenKey, value: newRefreshToken);

          err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
          final retryResponse = await _dio.fetch(err.requestOptions);
          return handler.resolve(retryResponse);
        }
      } catch (e) {
        await _secureStorage.delete(key: AppConstants.accessTokenKey);
        await _secureStorage.delete(key: AppConstants.refreshTokenKey);
      } finally {
        _isRefreshing = false;
      }
    }
    return handler.next(err);
  }
}

class TenantInterceptor extends Interceptor {
  final FlutterSecureStorage _secureStorage;

  TenantInterceptor(this._secureStorage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.path.contains('/auth/')) {
      return handler.next(options);
    }

    final businessId = await _secureStorage.read(key: AppConstants.businessIdKey);
    final branchId = await _secureStorage.read(key: AppConstants.branchIdKey);

    if (businessId != null) {
      options.headers['X-Business-Id'] = businessId;
    }
    if (branchId != null) {
      options.headers['X-Branch-Id'] = branchId;
    }

    return handler.next(options);
  }
}

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    return handler.next(err);
  }
}
