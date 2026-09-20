class AppConstants {
  AppConstants._();

  // API
  static const String baseUrl = 'http://192.168.18.14:3000/api';
  static const String socketUrl = 'http://192.168.18.14:3000';

  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String businessIdKey = 'business_id';
  static const String branchIdKey = 'branch_id';
  static const String onboardingCompleteKey = 'onboarding_complete';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);

  // Pagination
  static const int defaultPageSize = 20;

  // Cache
  static const Duration menuCacheDuration = Duration(hours: 1);
  static const Duration dashboardCacheDuration = Duration(minutes: 5);
}
