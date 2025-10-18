import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/entities/pet.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';

class PetImage extends StatelessWidget {
  final Pet pet;

  const PetImage({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
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
}