import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class FavoriteHeader extends StatelessWidget {
  const FavoriteHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Icon(
              Icons.arrow_back_ios_new,
              size: 24.sp,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            'Your Favorite Pets',
            style: AppTextStyles.heading2,
          ),
        ],
      ),
    );
  }
}