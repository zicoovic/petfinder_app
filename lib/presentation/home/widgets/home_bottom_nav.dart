import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routing/app_routes.dart';

class HomeBottomNav extends StatelessWidget {
  final int currentIndex;
  final VoidCallback onHomeReturn;

  const HomeBottomNav({
    super.key,
    required this.currentIndex,
    required this.onHomeReturn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, Icons.home_outlined, 0, context),
              _buildNavItem(Icons.favorite, Icons.favorite_border, 1, context),
              _buildNavItem(Icons.chat_bubble, Icons.chat_bubble_outline, 2, context),
              _buildNavItem(Icons.person, Icons.person_outline, 3, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData activeIcon, IconData icon, int index, BuildContext context) {
    final isActive = currentIndex == index;
    return GestureDetector(
      onTap: () async {
        if (index == 1) {
          await context.push(AppRoutes.favorites);
          onHomeReturn();
        }
      },
      child: Icon(
        isActive ? activeIcon : icon,
        color: isActive ? AppColors.primary : AppColors.iconGray,
        size: 28.sp,
      ),
    );
  }
}