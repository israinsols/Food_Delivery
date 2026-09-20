import 'package:foodos/core/errors/result.dart';
import '../models/user.dart';
import '../models/auth_request.dart';

abstract class AuthRepository {
  Future<Result<AuthResponse>> login(LoginRequest request);
  Future<Result<AuthResponse>> signup(SignupRequest request);
  Future<Result<void>> logout();
  Future<Result<void>> verifyEmail(String token);
  Future<Result<void>> forgotPassword(String email);
  Future<Result<void>> resetPassword(ResetPasswordRequest request);
  Future<Result<void>> changePassword(ChangePasswordRequest request);
  Future<Result<User>> getCurrentUser();
}
