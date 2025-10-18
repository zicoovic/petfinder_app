import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/routing/app_routes.dart';
import '../widgets/custom_button.dart';

/// Onboarding screen - First screen users see
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Pet Image
              _buildImage(),
              const Spacer(flex: 1),
              // Title
              Text(
                'Find Your Best\nCompanion With Us',
                style: AppTextStyles.heading1,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              // Subtitle
              Text(
                'Join & discover the best suitable pets as\nper your preferences in your location',
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 2),
              // Get Started Button
              CustomButton(
                text: 'Get started',
                onPressed: () => context.go(AppRoutes.home),
                icon: Icon(Icons.pets, color: AppColors.white, size: 20.sp),
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      width: 280.w,
      height: 280.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Center(
        child: Icon(
          Icons.pets,
          size: 120.sp,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
