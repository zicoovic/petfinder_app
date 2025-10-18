import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Find Your Forever Pet',
            style: AppTextStyles.heading2,
          ),
          Icon(
            Icons.notifications_outlined,
            size: 28.sp,
            color: AppColors.textPrimary,
          ),
        ],
      ),
    );
  }
}
