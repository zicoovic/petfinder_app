import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

/// App text styles following design system
/// All styles are now context-aware to support dark/light themes
class AppTextStyles {
  // Headings
  static TextStyle heading1(BuildContext context) => TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).textTheme.bodyLarge?.color,
    height: 1.2,
  );

  static TextStyle heading2(BuildContext context) => TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).textTheme.bodyLarge?.color,
    height: 1.3,
  );

  static TextStyle heading3(BuildContext context) => TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).textTheme.bodyLarge?.color,
    height: 1.4,
  );

  // Body Text
  static TextStyle bodyLarge(BuildContext context) => TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w400,
    color: Theme.of(context).textTheme.bodyLarge?.color,
    height: 1.5,
  );

  static TextStyle bodyMedium(BuildContext context) => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: Theme.of(context).textTheme.bodyMedium?.color,
    height: 1.5,
  );

  static TextStyle bodySmall(BuildContext context) => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: Theme.of(context).textTheme.bodySmall?.color,
    height: 1.5,
  );

  // Button Text
  static TextStyle button(BuildContext context) => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  // Caption
  static TextStyle caption(BuildContext context) => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: Theme.of(context).textTheme.bodySmall?.color,
    height: 1.4,
  );

  // Pet Name
  static TextStyle petName(BuildContext context) => TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).textTheme.bodyLarge?.color,
  );

  // Distance
  static TextStyle distance(BuildContext context) => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: Theme.of(context).textTheme.bodyMedium?.color,
  );
}
