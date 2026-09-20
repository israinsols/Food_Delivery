class AppDimensions {
  AppDimensions._();

  // Border Radius
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 20;
  static const double radiusFull = 999;

  // Padding
  static const double paddingXs = 4;
  static const double paddingSm = 8;
  static const double paddingMd = 16;
  static const double paddingLg = 24;
  static const double paddingXl = 32;

  // Icon Size
  static const double iconSm = 16;
  static const double iconMd = 24;
  static const double iconLg = 32;
  static const double iconXl = 48;

  // Elevation
  static const double elevationSm = 1;
  static const double elevationMd = 4;
  static const double elevationLg = 8;
}

class AppDuration {
  AppDuration._();

  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
}
