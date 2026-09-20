import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:foodos/core/constants/app_constants.dart';

class AuthApi {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  AuthApi({Dio? dio, FlutterSecureStorage? storage})
      : _dio = dio ?? Dio(BaseOptions(baseUrl: '${AppConstants.baseUrl}/auth')),
        _storage = storage ?? const FlutterSecureStorage();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await _dio.post('/login', data: {'email': email, 'password': password});
    final token = res.data['token'] as String?;
    if (token != null) {
      await _storage.write(key: AppConstants.accessTokenKey, value: token);
    }
    return res.data;
  }

  Future<Map<String, dynamic>> signup(String fullName, String email, String password, {String accountType = 'customer'}) async {
    final res = await _dio.post('/register', data: {
      'fullName': fullName,
      'email': email,
      'password': password,
      'accountType': accountType,
    });
    final token = res.data['token'] as String?;
    if (token != null) {
      await _storage.write(key: AppConstants.accessTokenKey, value: token);
    }
    return res.data;
  }

  Future<Map<String, dynamic>> getProfile() async {
    final token = await _storage.read(key: AppConstants.accessTokenKey);
    final res = await _dio.get('/profile', options: Options(headers: {'Authorization': 'Bearer $token'}));
    return res.data;
  }

  Future<void> logout() async {
    await _storage.delete(key: AppConstants.accessTokenKey);
    await _storage.delete(key: AppConstants.refreshTokenKey);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: AppConstants.accessTokenKey);
  }
}
