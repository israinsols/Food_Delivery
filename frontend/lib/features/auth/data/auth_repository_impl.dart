import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:foodos/core/constants/app_constants.dart';
import 'package:foodos/core/errors/result.dart';
import '../domain/models/user.dart';
import '../domain/models/auth_request.dart';
import '../domain/repositories/auth_repository.dart';
import 'auth_api_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _apiService;
  final FlutterSecureStorage _secureStorage;

  AuthRepositoryImpl(this._apiService, this._secureStorage);

  @override
  Future<Result<AuthResponse>> login(LoginRequest request) async {
    final result = await _apiService.login(request);
    if (result.isSuccess && result.data != null) {
      await _saveTokens(result.data!.tokens);
    }
    return result;
  }

  @override
  Future<Result<AuthResponse>> signup(SignupRequest request) async {
    final result = await _apiService.signup(request);
    if (result.isSuccess && result.data != null) {
      await _saveTokens(result.data!.tokens);
    }
    return result;
  }

  @override
  Future<Result<void>> logout() async {
    final result = await _apiService.logout();
    await _clearTokens();
    return result;
  }

  @override
  Future<Result<void>> verifyEmail(String token) {
    return _apiService.verifyEmail(token);
  }

  @override
  Future<Result<void>> forgotPassword(String email) {
    return _apiService.forgotPassword(email);
  }

  @override
  Future<Result<void>> resetPassword(ResetPasswordRequest request) {
    return _apiService.resetPassword(request);
  }

  @override
  Future<Result<void>> changePassword(ChangePasswordRequest request) {
    return _apiService.changePassword(request);
  }

  @override
  Future<Result<User>> getCurrentUser() {
    return _apiService.getCurrentUser();
  }

  Future<void> _saveTokens(AuthTokens tokens) async {
    await _secureStorage.write(key: AppConstants.accessTokenKey, value: tokens.accessToken);
    await _secureStorage.write(key: AppConstants.refreshTokenKey, value: tokens.refreshToken);
  }

  Future<void> _clearTokens() async {
    await _secureStorage.delete(key: AppConstants.accessTokenKey);
    await _secureStorage.delete(key: AppConstants.refreshTokenKey);
    await _secureStorage.delete(key: AppConstants.businessIdKey);
    await _secureStorage.delete(key: AppConstants.branchIdKey);
  }
}
