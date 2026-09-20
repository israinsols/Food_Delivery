import 'package:dio/dio.dart';
import 'package:foodos/core/errors/failures.dart';
import 'package:foodos/core/errors/result.dart';

class ApiException {
  static Result<T> handle<T>(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Result.failure(const NetworkFailure(
          message: 'Connection timed out. Please check your internet connection.',
        ));
      case DioExceptionType.connectionError:
        return Result.failure(const NetworkFailure(
          message: 'No internet connection. Please try again.',
        ));
      case DioExceptionType.badResponse:
        return _handleBadResponse<T>(e.response!);
      default:
        return Result.failure(const ServerFailure(
          message: 'An unexpected error occurred.',
        ));
    }
  }

  static Result<T> _handleBadResponse<T>(Response response) {
    final statusCode = response.statusCode;
    final data = response.data;

    switch (statusCode) {
      case 400:
        final errors = data['error']?['details'];
        return Result.failure(ValidationFailure(
          message: data['error']?['message'] ?? 'Validation error',
          errors: errors != null ? Map<String, String>.from(errors) : null,
        ));
      case 401:
        return Result.failure(const AuthFailure(
          message: 'Please login again.',
        ));
      case 403:
        return Result.failure(const AuthFailure(
          message: 'You do not have permission to perform this action.',
        ));
      case 404:
        return Result.failure(const ServerFailure(
          message: 'Resource not found.',
          statusCode: 404,
        ));
      case 409:
        return Result.failure(ValidationFailure(
          message: data['error']?['message'] ?? 'Conflict occurred.',
        ));
      case 423:
        return Result.failure(const TenantSuspendedFailure(
          message: 'Your account has been suspended. Please contact support.',
        ));
      case 500:
        return Result.failure(const ServerFailure(
          message: 'Server error. Please try again later.',
          statusCode: 500,
        ));
      default:
        return Result.failure(ServerFailure(
          message: data['error']?['message'] ?? 'An error occurred.',
          statusCode: statusCode,
        ));
    }
  }
}
