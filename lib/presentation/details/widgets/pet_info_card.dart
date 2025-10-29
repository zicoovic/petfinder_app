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
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNameAndPrice(context),
            SizedBox(height: 8.h),
            _buildDistance(context),
            SizedBox(height: 20.h),
            _buildInfoChips(context),
            SizedBox(height: 24.h),
            _buildAboutSection(context),
            if (pet.temperament != null) _buildTemperamentSection(context),
            SizedBox(height: 24.h),
            CustomButton(
              text: pet.isAdopted ? 'Unadopt' : 'Adopt me',
              onPressed: onAdoptTap,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNameAndPrice(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(pet.name, style: AppTextStyles.heading2(context)),
        ),
        Text(
          '\$${pet.price?.toStringAsFixed(0) ?? '0'}',
          style: AppTextStyles.heading3(context).copyWith(color: AppColors.primary),
        ),
      ],
    );
  }

  Widget _buildDistance(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.location_on, color: AppColors.error, size: 16.sp),
        SizedBox(width: 4.w),
        Text('${pet.distance} km away', style: AppTextStyles.bodySmall(context)),
      ],
    );
  }

  Widget _buildInfoChips(BuildContext context) {
    return Row(
      children: [
        _buildInfoChip(context, 'Gender', pet.gender ?? 'Unknown'),
        SizedBox(width: 12.w),
        _buildInfoChip(context, 'Age', pet.age ?? 'Unknown'),
        SizedBox(width: 12.w),
        _buildInfoChip(context, 'Weight', pet.weight ?? 'N/A'),
      ],
    );
  }

  Widget _buildInfoChip(BuildContext context, String label, String value) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: AppTextStyles.caption(context).copyWith(
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              value,
              style: AppTextStyles.bodySmall(context).copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('About:', style: AppTextStyles.heading3(context)),
        SizedBox(height: 12.h),
        Text(
          pet.description ?? 'No description available.',
          style: AppTextStyles.bodyMedium(context).copyWith(height: 1.6),
        ),
      ],
    );
  }

  Widget _buildTemperamentSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        Text('Temperament:', style: AppTextStyles.heading3(context)),
        SizedBox(height: 8.h),
        Text(pet.temperament!, style: AppTextStyles.bodyMedium(context)),
      ],
    );
  }
}