import 'package:dio/dio.dart';
import 'package:foodos/core/errors/result.dart';
import 'package:foodos/core/network/api_exception.dart';
import '../domain/models/user.dart';
import '../domain/models/auth_request.dart';

class AuthApiService {
  final Dio _dio;

  AuthApiService(this._dio);

  Future<Result<AuthResponse>> login(LoginRequest request) async {
    try {
      final response = await _dio.post('/auth/login', data: request.toJson());
      return Success(AuthResponse.fromJson(response.data['data']));
    } on DioException catch (e) {
      return ApiException.handle(e);
    }
  }

  Future<Result<AuthResponse>> signup(SignupRequest request) async {
    try {
      final response = await _dio.post('/auth/signup', data: request.toJson());
      return Success(AuthResponse.fromJson(response.data['data']));
    } on DioException catch (e) {
      return ApiException.handle(e);
    }
  }

  Future<Result<void>> logout() async {
    try {
      await _dio.post('/auth/logout');
      return const Success(null);
    } on DioException catch (e) {
      return ApiException.handle(e);
    }
  }

  Future<Result<void>> verifyEmail(String token) async {
    try {
      await _dio.post('/auth/verify-email', data: {'token': token});
      return const Success(null);
    } on DioException catch (e) {
      return ApiException.handle(e);
    }
  }

  Future<Result<void>> forgotPassword(String email) async {
    try {
      await _dio.post('/auth/forgot-password', data: {'email': email});
      return const Success(null);
    } on DioException catch (e) {
      return ApiException.handle(e);
    }
  }

  Future<Result<void>> resetPassword(ResetPasswordRequest request) async {
    try {
      await _dio.post('/auth/reset-password', data: request.toJson());
      return const Success(null);
    } on DioException catch (e) {
      return ApiException.handle(e);
    }
  }

  Future<Result<void>> changePassword(ChangePasswordRequest request) async {
    try {
      await _dio.patch('/auth/change-password', data: request.toJson());
      return const Success(null);
    } on DioException catch (e) {
      return ApiException.handle(e);
    }
  }

  Future<Result<User>> getCurrentUser() async {
    try {
      final response = await _dio.get('/auth/me');
      return Success(User.fromJson(response.data['data']));
    } on DioException catch (e) {
      return ApiException.handle(e);
    }
  }
}
