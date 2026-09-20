sealed class Failure {
  const Failure();
  String get message;
}

class NetworkFailure extends Failure {
  @override
  final String message;
  const NetworkFailure({this.message = 'Connection error'});
}

class AuthFailure extends Failure {
  @override
  final String message;
  const AuthFailure({this.message = 'Authentication error'});
}

class ValidationFailure extends Failure {
  @override
  final String message;
  final Map<String, String>? errors;
  const ValidationFailure({this.message = 'Validation error', this.errors});
}

class ServerFailure extends Failure {
  @override
  final String message;
  final int? statusCode;
  const ServerFailure({this.message = 'Server error', this.statusCode});
}

class CacheFailure extends Failure {
  @override
  final String message;
  const CacheFailure({this.message = 'Cache error'});
}

class TenantSuspendedFailure extends Failure {
  @override
  final String message;
  const TenantSuspendedFailure({this.message = 'Account suspended'});
}

class SubscriptionExpiredFailure extends Failure {
  @override
  final String message;
  const SubscriptionExpiredFailure({this.message = 'Subscription expired'});
}
