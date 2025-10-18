import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/entities/pet.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../widgets/custom_button.dart';

class PetInfoCard extends StatelessWidget {
  final Pet pet;
  final VoidCallback onAdoptTap;

  const PetInfoCard({
    super.key,
    required this.pet,
    required this.onAdoptTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNameAndPrice(),
            SizedBox(height: 8.h),
            _buildDistance(),
            SizedBox(height: 20.h),
            _buildInfoChips(),
            SizedBox(height: 24.h),
            _buildAboutSection(),
            if (pet.temperament != null) _buildTemperamentSection(),
            SizedBox(height: 24.h),
            CustomButton(text: 'Adopt me', onPressed: onAdoptTap),
          ],
        ),
      ),
    );
  }

  Widget _buildNameAndPrice() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(pet.name, style: AppTextStyles.heading2),
        ),
        Text(
          '\$${pet.price?.toStringAsFixed(0) ?? '0'}',
          style: AppTextStyles.heading3.copyWith(color: AppColors.primary),
        ),
      ],
    );
  }

  Widget _buildDistance() {
    return Row(
      children: [
        Icon(Icons.location_on, color: AppColors.error, size: 16.sp),
        SizedBox(width: 4.w),
        Text('${pet.distance} km away', style: AppTextStyles.bodySmall),
      ],
    );
  }

  Widget _buildInfoChips() {
    return Row(
      children: [
        _buildInfoChip('Gender', pet.gender ?? 'Unknown'),
        SizedBox(width: 12.w),
        _buildInfoChip('Age', pet.age ?? 'Unknown'),
        SizedBox(width: 12.w),
        _buildInfoChip('Weight', pet.weight ?? 'N/A'),
      ],
    );
  }

  Widget _buildInfoChip(String label, String value) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            Text(label, style: AppTextStyles.caption),
            SizedBox(height: 4.h),
            Text(
              value,
              style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('About:', style: AppTextStyles.heading3),
        SizedBox(height: 12.h),
        Text(
          pet.description ?? 'No description available.',
          style: AppTextStyles.bodyMedium.copyWith(height: 1.6),
        ),
      ],
    );
  }

  Widget _buildTemperamentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        Text('Temperament:', style: AppTextStyles.heading3),
        SizedBox(height: 8.h),
        Text(pet.temperament!, style: AppTextStyles.bodyMedium),
      ],
    );
  }
}