import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/routing/app_routes.dart';
import '../../bloc/pet_cubit.dart';
import '../../bloc/pet_state.dart';
import '../../widgets/pet_card_grid.dart';

class FavoritesGridView extends StatelessWidget {
  const FavoritesGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PetCubit, PetState>(
      builder: (context, state) {
        if (state is PetLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        } else if (state is PetError) {
          return _buildError(state.message);
        } else if (state is PetLoaded) {
          final favorites = state.pets.where((pet) => pet.isFavorite).toList();

          if (favorites.isEmpty) {
            return _buildEmptyState();
          }

          return GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.h,
              childAspectRatio: 0.75,
            ),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final pet = favorites[index];
              return PetCardGrid(
                pet: pet,
                onTap: () => context.push(AppRoutes.details, extra: pet),
                onFavoriteTap: () {
                  context.read<PetCubit>().toggleFavoriteStatus(pet);
                },
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64.sp, color: AppColors.error),
          SizedBox(height: 16.h),
          Text(message, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80.sp,
            color: AppColors.textLight,
          ),
          SizedBox(height: 16.h),
          Text('No Favorites Yet', style: AppTextStyles.heading3),
          SizedBox(height: 8.h),
          Text(
            'Start adding pets to your favorites!',
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}