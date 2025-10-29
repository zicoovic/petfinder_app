import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/routing/app_routes.dart';
import '../../presentation/bloc/pet_cubit.dart';

/// Bottom navigation bar widget
class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
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
              _buildNavItem(
                context: context,
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                index: 0,
              ),
              _buildNavItem(
                context: context,
                icon: Icons.favorite_border,
                activeIcon: Icons.favorite,
                index: 1,
              ),
              _buildNavItem(
                context: context,
                icon: Icons.volunteer_activism_outlined,
                activeIcon: Icons.volunteer_activism,
                index: 2,
              ),
              _buildNavItem(
                context: context,
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                index: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required IconData activeIcon,
    required int index,
  }) {
    final isActive = currentIndex == index;
    return GestureDetector(
      onTap: () async {
        if (index == 0 && currentIndex != 0) {
          // Pop all routes until we reach home and reload pets
          final cubit = context.read<PetCubit>();
          Navigator.of(context).popUntil((route) => route.isFirst);
          cubit.loadPets();
        } else if (index == 1 && currentIndex != 1) {
          await context.push(AppRoutes.favorites);
        } else if (index == 2 && currentIndex != 2) {
          await context.push(AppRoutes.adopted);
        }
      },
      child: Container(
        padding: EdgeInsets.all(8.w),
        child: Icon(
          isActive ? activeIcon : icon,
          color: isActive
              ? AppColors.primary
              : Theme.of(context).iconTheme.color,
          size: 28.sp,
        ),
      ),
    );
  }
}
