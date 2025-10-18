import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/entities/pet.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../bloc/pet_cubit.dart';
import '../widgets/custom_button.dart';

/// Details screen - Shows pet details
class DetailsScreen extends StatelessWidget {
  final Pet pet;

  const DetailsScreen({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back and favorite buttons
            _buildHeader(context),
            // Pet Image
            Expanded(
              flex: 3,
              child: _buildImage(),
            ),
            // Pet Info Card
            Expanded(
              flex: 4,
              child: _buildInfoCard(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 20.sp,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              context.read<PetCubit>().toggleFavoriteStatus(pet);
            },
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                pet.isFavorite ? Icons.favorite : Icons.favorite_border,
                size: 24.sp,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    final imageUrl = pet.imageUrl != null
        ? '${AppConstants.baseImageUrl}${pet.imageUrl}.jpg'
        : null;

    if (imageUrl == null) {
      return Center(
        child: Icon(Icons.pets, size: 120.sp, color: AppColors.primary),
      );
    }

    return Center(
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.contain,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        errorWidget: (context, url, error) => Icon(
          Icons.pets,
          size: 120.sp,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
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
            // Name and Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    pet.name,
                    style: AppTextStyles.heading2,
                  ),
                ),
                Text(
                  '\$${pet.price?.toStringAsFixed(0) ?? '0'}',
                  style: AppTextStyles.heading3.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            // Distance
            Row(
              children: [
                Icon(Icons.location_on, color: AppColors.error, size: 16.sp),
                SizedBox(width: 4.w),
                Text(
                  '${pet.distance} km away',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
            SizedBox(height: 20.h),
            // Info Chips
            Row(
              children: [
                _buildInfoChip('Gender', pet.gender ?? 'Unknown'),
                SizedBox(width: 12.w),
                _buildInfoChip('Age', pet.age ?? 'Unknown'),
                SizedBox(width: 12.w),
                _buildInfoChip('Weight', pet.weight ?? 'N/A'),
              ],
            ),
            SizedBox(height: 24.h),
            // About Section
            Text('About:', style: AppTextStyles.heading3),
            SizedBox(height: 12.h),
            Text(
              pet.description ?? 'No description available.',
              style: AppTextStyles.bodyMedium.copyWith(height: 1.6),
            ),
            if (pet.temperament != null) ...[
              SizedBox(height: 16.h),
              Text('Temperament:', style: AppTextStyles.heading3),
              SizedBox(height: 8.h),
              Text(
                pet.temperament!,
                style: AppTextStyles.bodyMedium,
              ),
            ],
            SizedBox(height: 24.h),
            // Adopt Button
            CustomButton(
              text: 'Adopt me',
              onPressed: () {
                _showAdoptDialog(context);
              },
            ),
          ],
        ),
      ),
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
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAdoptDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Adopt ${pet.name}?', style: AppTextStyles.heading3),
        content: Text(
          'Are you sure you want to adopt ${pet.name}?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Congratulations! ${pet.name} is yours!'),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
            child: Text('Adopt', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}
