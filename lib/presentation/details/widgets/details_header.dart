import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/entities/pet.dart';
import '../../../core/theme/app_colors.dart';
import '../../bloc/pet_cubit.dart';

class DetailsHeader extends StatelessWidget {
  final Pet pet;

  const DetailsHeader({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
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
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 20.sp,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => context.read<PetCubit>().toggleFavoriteStatus(pet),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                pet.isFavorite ? Icons.favorite : Icons.favorite_border,
                size: 24.sp,
                color: Theme.of(context).cardColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}