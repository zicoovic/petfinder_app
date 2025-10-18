import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/entities/pet.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';

/// Pet card widget for list display (Home screen)
class PetCardList extends StatelessWidget {
  final Pet pet;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  const PetCardList({
    super.key,
    required this.pet,
    required this.onTap,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            // Pet Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: _buildImage(),
            ),
            SizedBox(width: 12.w),
            // Pet Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pet.name,
                    style: AppTextStyles.petName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    pet.gender ?? 'Unknown',
                    style: AppTextStyles.bodySmall,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    pet.age ?? 'Unknown',
                    style: AppTextStyles.bodySmall,
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: AppColors.error,
                        size: 14.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${pet.distance} km away',
                        style: AppTextStyles.distance,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Favorite Button
            GestureDetector(
              onTap: onFavoriteTap,
              child: Container(
                padding: EdgeInsets.all(8.w),
                child: Icon(
                  pet.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: AppColors.primary,
                  size: 28.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    final imageUrl = pet.imageUrl != null
        ? '${AppConstants.baseImageUrl}${pet.imageUrl}.jpg'
        : null;

    if (imageUrl == null) {
      return Container(
        width: 100.w,
        height: 100.h,
        color: AppColors.cardBackground,
        child: const Center(child: Icon(Icons.pets)),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: 100.w,
      height: 100.h,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        width: 100.w,
        height: 100.h,
        color: AppColors.cardBackground,
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: 100.w,
        height: 100.h,
        color: AppColors.cardBackground,
        child: const Center(child: Icon(Icons.pets)),
      ),
    );
  }
}
