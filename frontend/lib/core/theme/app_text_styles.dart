import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const String _fontFamily = 'Inter';

  // Headings
  static TextStyle h1 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static TextStyle h2 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
  );

  static TextStyle h3 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle h4 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Body
  static TextStyle bodyLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle bodySmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // Button
  static TextStyle buttonLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnPrimary,
  );

  static TextStyle buttonMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnPrimary,
  );

  // Caption
  static TextStyle caption = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle overline = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textHint,
    letterSpacing: 1.2,
  );
}
