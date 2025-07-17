import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'theme_colors.dart';

//sample
mixin ThemeTexts {
  //Display
  static TextStyle displayLarge = TextStyle(
    fontWeight: FontWeight.w400,
    color: ThemeColors.onSurface,
    fontSize: 57.sp,
  );
  static TextStyle displayMedium = TextStyle(
    fontWeight: FontWeight.w400,
    color: ThemeColors.onSurface,
    fontSize: 45.sp,
  );
  static TextStyle displaySmall = TextStyle(
    fontWeight: FontWeight.w400,
    color: ThemeColors.onSurface,
    fontSize: 36.sp,
  );

  //Headline
  static TextStyle headlineLarge = TextStyle(
    fontWeight: FontWeight.w400,
    color: ThemeColors.onSurface,
    fontSize: 32.sp,
  );
  static TextStyle headlineMedium = TextStyle(
    fontWeight: FontWeight.w400,
    color: ThemeColors.onSurface,
    fontSize: 28.sp,
  );
  static TextStyle headlineSmall = TextStyle(
    fontWeight: FontWeight.w400,
    color: ThemeColors.onSurface,
    fontSize: 24.sp,
  );

  //Title
  static TextStyle titleLarge = TextStyle(
    fontWeight: FontWeight.w400,
    color: ThemeColors.onSurface,
  );
  static TextStyle titleMedium = TextStyle(
    fontWeight: FontWeight.w500,
    color: ThemeColors.onSurface,
    fontSize: 16.sp,
  );
  static TextStyle titleEntity = TextStyle(
    fontWeight: FontWeight.w700,
    color: ThemeColors.onSurface,
    fontSize: 16.sp,
  );
  static TextStyle titleSmall = TextStyle(
    fontWeight: FontWeight.w500,
    color: ThemeColors.onSurface,
    fontSize: 14.sp,
  );

  //Body
  static TextStyle bodyLarge = TextStyle(
    fontWeight: FontWeight.w400,
    color: ThemeColors.onSurface,
    fontSize: 16.sp,
  );
  static TextStyle bodyMedium = TextStyle(
    fontWeight: FontWeight.w400,
    color: ThemeColors.onSurface,
    fontSize: 14.sp,
  );
  static TextStyle bodySmall = TextStyle(
    fontWeight: FontWeight.w400,
    color: ThemeColors.onSurface,
    fontSize: 12.sp,
  );
}
