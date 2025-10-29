import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/entities/pet.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';

/// Pet card widget for grid display (Favorites screen)
class PetCardGrid extends StatelessWidget {
  final Pet pet;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  const PetCardGrid({
    super.key,
    required this.pet,
    required this.onTap,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pet Image
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                  child: _buildImage(context),
                ),
              ),
              // Pet Info
              Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            pet.name,
                            style: AppTextStyles.petName(context),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: onFavoriteTap,
                          child: Icon(
                            pet.isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: AppColors.primary,
                            size: 24.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
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
                          style: AppTextStyles.distance(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    final imageUrl = pet.imageUrl != null
        ? '${AppConstants.baseImageUrl}${pet.imageUrl}.jpg'
        : null;

    if (imageUrl == null) {
      return Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Center(
          child: Icon(
            Icons.pets,
            color: Theme.of(context).iconTheme.color?.withAlpha((255 * 0.5).toInt()),
          ),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      placeholder: (context, url) => Container(
        color: Theme.of(context).cardColor,
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      errorWidget: (context, url, error) => Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Center(
          child: Icon(
            Icons.pets,
            color: Theme.of(context).iconTheme.color?.withAlpha((255 * 0.5).toInt()),
          ),
        ),
      ),
    );
  }
}
